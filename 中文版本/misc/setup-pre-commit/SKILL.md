---
name: setup-pre-commit
description: 在当前仓库中设置 Husky 预提交钩子，包含 lint-staged（Prettier）、类型检查和测试。当用户希望添加预提交钩子、设置 Husky、配置 lint-staged，或添加提交时的格式化、类型检查或测试时使用。
---

# 设置预提交钩子

## 本设置包含的内容

- **Husky** 预提交钩子
- 对所有暂存文件运行 Prettier 的 **lint-staged**
- **Prettier** 配置（若缺失）
- 预提交钩子中的 **typecheck** 和 **test** 脚本

## 步骤

### 1. 检测包管理器

检查 `package-lock.json`（npm）、`pnpm-lock.yaml`（pnpm）、`yarn.lock`（yarn）、`bun.lockb`（bun）。使用其中存在的那个。若无法判断，默认使用 npm。

### 2. 安装依赖

作为开发依赖安装：

```
husky lint-staged prettier
```

### 3. 初始化 Husky

```bash
npx husky init
```

这会创建 `.husky/` 目录，并在 package.json 中添加 `prepare: "husky"`。

### 4. 创建 `.husky/pre-commit`

编写此文件（Husky v9+ 无需 shebang）：

```
npx lint-staged
npm run typecheck
npm run test
```

**适配**：将 `npm` 替换为检测到的包管理器。如果仓库的 package.json 中没有 `typecheck` 或 `test` 脚本，则省略对应行，并告知用户。

### 5. 创建 `.lintstagedrc`

```json
{
  "*": "prettier --ignore-unknown --write"
}
```

### 6. 创建 `.prettierrc`（若缺失）

仅在不存在任何 Prettier 配置时创建。使用以下默认值：

```json
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": false,
  "trailingComma": "es5",
  "semi": true,
  "arrowParens": "always"
}
```

### 7. 验证

- [ ] `.husky/pre-commit` 存在且可执行
- [ ] `.lintstagedrc` 存在
- [ ] package.json 中的 `prepare` 脚本为 `"husky"`
- [ ] `prettier` 配置存在
- [ ] 运行 `npx lint-staged` 以验证其正常工作

### 8. 提交

暂存所有已更改或新建的文件，并使用如下提交信息提交：`Add pre-commit hooks (husky + lint-staged + prettier)`

这次提交会经过新设置的预提交钩子：这是一次很好的冒烟测试，可以验证一切是否正常。

## 注意事项

- Husky v9+ 的钩子文件无需 shebang
- `prettier --ignore-unknown` 会跳过 Prettier 无法解析的文件（图片等）
- 预提交钩子先运行 lint-staged（快速，只针对暂存文件），然后运行完整的类型检查和测试
