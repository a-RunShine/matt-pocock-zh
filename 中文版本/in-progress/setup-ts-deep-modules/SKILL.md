---
name: setup-ts-deep-modules
description: 在 TypeScript 仓库中接入 dependency-cruiser，使每个包都成为深度模块：实现隐藏在子文件夹中，只能通过其入口文件访问。由用户调用。
disable-model-invocation: true
---

# 设置 TS 深度模块

让本仓库中的每个包都成为**深度模块**：在一个小接口背后蕴含大量行为。包的公开表面是其**入口点（entry points）**（位于包根目录的文件），而其子文件夹中的一切都是隐藏的。本 skill 会安装 [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) 以及使入口点成为唯一访问途径的规则，然后验证这些规则确实生效。

关于术语（深度模块、接口、接缝、深度），请调用 Skill 工具并传入 "codebase-design"，并在整个过程中使用它的语言。

## 本设置所强制的结构

```
src/packages/
  <name>/
    index.ts        ← 入口点（公开）。从外部导入此文件。
    client.ts       ← 另一个入口点。包可以暴露多个入口点。
    lib/            ← 实现：对外隐藏，可以相互自由导入。
    tests/          ← 同置的测试与夹具（一个子文件夹，因此是私有的）。
```

包的公开表面是其**根文件**，而不是某个指定的 `index.ts`。按惯例，实现位于 `lib/`，测试位于 `tests/`，使每个包都具有相同的两文件夹结构。不过规则本身是通用的：_任何_子文件夹中的_任何_内容都是私有的，因此你永远不需要为了新增一个文件夹而去修改配置。

共有四条规则，均为 `error` 级别：

1. **入口点边界**：包之外的代码（应用代码或其他包）只能导入该包的入口点（其根文件），绝不能导入其子文件夹中的任何内容。
2. **包内自由**：一个包内部的文件可以相互自由导入。
3. **测试通过入口点**：`<pkg>/tests/` 下的文件可以导入任何包的入口点，以及它们自己的 `tests/` 夹具，但绝不能导入任何包的子文件夹内部（即使是它自己的子文件夹）。跨包的集成测试没有问题；深度导入则不行。
4. **无循环**：不能存在依赖循环。

**入口点，而非桶文件（barrel）。** 由于公开表面是_每一个_根文件，一个包可以暴露多个小型入口点（`index.ts`、`client.ts`、`server.ts`），而不是把所有东西都通过一个庞大的 `index.ts` 汇聚。不鼓励使用重新导出整个子树的桶文件；应保持入口点小巧，并把实现隐藏在子文件夹中。

分层（哪些包可以依赖哪些包）是一个_不同_的问题，在配置中以一个注释桩的形式保留，由本仓库自行填写。

## 步骤

### 1. 检测环境

- **包管理器**：`pnpm-lock.yaml` → pnpm，`yarn.lock` → yarn，`bun.lockb` → bun，否则 npm。下面每条命令都使用它（`pnpm`/`yarn`/`npm run`/`bunx`）。
- **包根目录**：如果存在 `src/`，则使用 `src/packages`，否则使用 `packages`。如果仓库已有其他明显的约定，请与用户确认选择。
- **已有配置**：检查是否存在 `.dependency-cruiser.*` 文件。如果存在，**不要**覆盖它：将四条规则和相关选项合并进去，并告诉用户你添加了什么。

**完成标准：** 包管理器、包根目录以及已有配置的状态均已确定。

### 2. 安装 dependency-cruiser

使用检测到的包管理器，将 `dependency-cruiser` 安装为开发依赖（devDependency）。

**完成标准：** `dependency-cruiser` 已位于 `devDependencies` 中。

### 3. 编写配置

将 [`dependency-cruiser.config.cjs`](./dependency-cruiser.config.cjs) 复制到仓库根目录，命名为 `.dependency-cruiser.cjs`。将 `PACKAGES_ROOT` 设为第 1 步检测到的根目录。这些规则基于路径深度且与文件扩展名无关，因此无需做其他调整。

**完成标准：** `.dependency-cruiser.cjs` 存在，`PACKAGES_ROOT` 正确，且四条禁止规则均已就位。

### 4. 接入检查

- 添加一个 `lint:boundaries` 脚本：`depcruise <packages-root>`（或 `depcruise src`）。
- 将其合并进仓库已有的总检查命令中，即已经运行类型检查的那个命令（例如 `check` / `ci` / `validate` 脚本）。**不要**修改 `tsconfig`，也不要添加路径别名。
- 如果没有总检查脚本，就添加 `lint:boundaries`，并告诉用户将其纳入 CI。

**完成标准：** `lint:boundaries` 已存在，并与类型检查在同一条命令中运行。

### 5. 搭建示例包

创建一个已提交的 `<packages-root>/example/`，作为可复制的模板：

- `index.ts` 是入口点。导出一个函数，并将其委托给一个内部文件（使该包明显是"深"的，而不是一个直通层）。
- `lib/impl.ts`：位于**子文件夹**中的内部文件，由 `index.ts` 导入，外部无法访问。
- `tests/example.test.ts` 只导入 **`../index`**（一个入口点），并针对公开函数进行断言。

告诉用户这是一个入门模板，可以复制或删除。

**完成标准：** 示例包已存在，通过根入口点暴露其行为，并把 `impl` 隐藏在子文件夹中。

### 6. 证明规则确实生效

这是整个 skill 的完成标准：一个对违规行为不报错的配置毫无价值。

1. 运行 `lint:boundaries`。在干净的示例上它必须**通过**。
2. 临时在 `tests/example.test.ts` 中添加一条深度导入（例如 `import { thing } from "../lib/impl"`）。再次运行 `lint:boundaries`，它必须以 `tests-through-entrypoints` **失败**。
3. 还原该深度导入。再运行一次，它必须**通过**。

**完成标准：** 你已观察到先通过、再因深度导入而失败、最后再次通过的全过程。如果第 2 步没有失败，说明规则接线有误，必须先修复再结束。

### 7. 记录约定

在**包文件夹中**（`<packages-root>/README.md`，与它所管理的包并列）编写一份 `README.md`，涵盖：`src/packages/<name>/` 的结构（入口点位于根目录，`lib/` 存放实现，`tests/` 存放测试）、"只能通过包的入口点（其根文件）导入"，以及如何运行 `lint:boundaries`。**明确不鼓励使用桶文件**：应暴露多个小型入口点，而不是通过一个索引文件重新导出整个子树。内容保持在可复制的代码片段加上四条规则（每条一段）即可。

然后从仓库的智能体指令文件（若存在 `CLAUDE.md` 则用它，否则用 `AGENTS.md`，两者都不存在则创建 `AGENTS.md`）中添加一个指向它的**上下文指针**。一行即可，例如：`Packages are deep modules: see [src/packages/README.md](./src/packages/README.md) before adding or importing one.` 正是这一行使智能体能够发现边界规则，而不是误踩它。

**完成标准：** `<packages-root>/README.md` 已存在并不鼓励使用桶文件，且仓库的 `CLAUDE.md`/`AGENTS.md` 链接到它。

## 注意事项

- 配置中的 `$1` 反向引用（dependency-cruiser 的分组匹配）正是让包可以访问自身内部、而外部无法访问的关键。不要把它们展开成每个包一条独立规则。
- 公开还是私有是由**深度**决定的：包的根文件是入口点；子文件夹中的任何内容都是私有的。约定的子文件夹是 `lib/`（实现）和 `tests/`，但规则并不硬编码它们：任何子文件夹都是私有的，因此新增文件夹永远不需要修改配置。添加入口点就是添加一个根文件（而非桶文件）。
- 包是**扁平的**：根目录下只有一层直接子级。包的内部可以任意嵌套；但包不能包含另一个包。
- 使用 `.cjs`（而不是 `.js`），以便配置中的 `module.exports` 即使在 `"type": "module"` 的仓库中也能正常工作。
