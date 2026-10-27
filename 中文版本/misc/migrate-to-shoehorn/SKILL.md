---
name: migrate-to-shoehorn
description: 把测试文件从 `as` 类型断言迁移到 @total-typescript/shoehorn。当用户提到 shoehorn、希望替换测试中的 `as`，或需要部分测试数据时使用。
---

# 迁移到 Shoehorn

## 为什么使用 shoehorn？

`shoehorn` 让你可以在测试中传入部分数据，同时让 TypeScript 保持满意。它用类型安全的替代方案取代 `as` 断言。

**仅用于测试代码。** 绝不要在生产代码中使用 shoehorn。

测试中使用 `as` 的问题：

- 被训练过不要使用它
- 必须手动指定目标类型
- 为了故意构造错误数据，需要双重 as（`as unknown as Type`）

## 安装

```bash
npm i @total-typescript/shoehorn
```

## 迁移模式

### 大对象但只需要少数属性

迁移前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ……另外 20 个属性
};

it("gets user by id", () => {
  // 只关心 body.id，却必须伪造整个 Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ……把 20 个属性全部伪造
  });
});
```

迁移后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("gets user by id", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

迁移前：

```ts
getUser({ body: { id: "123" } } as Request);
```

迁移后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

迁移前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // 故意写错类型
```

迁移后：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 何时使用哪个函数

| 函数            | 使用场景                                          |
| --------------- | ------------------------------------------------- |
| `fromPartial()` | 传入仍能通过类型检查的部分数据                    |
| `fromAny()`     | 故意传入错误的数据（保留自动补全）                |
| `fromExact()`   | 强制要求完整对象（之后可替换为 fromPartial）      |

## 工作流程

1. **收集需求**，询问用户：
   - 哪些测试文件中的 `as` 断言造成了问题？
   - 他们是否在处理只有部分属性有用的大对象？
   - 他们是否需要为错误测试故意传入错误的数据？

2. **安装并迁移**：
   - [ ] 安装：`npm i @total-typescript/shoehorn`
   - [ ] 查找带有 `as` 断言的测试文件：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 将 `as Type` 替换为 `fromPartial()`
   - [ ] 将 `as unknown as Type` 替换为 `fromAny()`
   - [ ] 添加来自 `@total-typescript/shoehorn` 的 import
   - [ ] 运行类型检查以验证
