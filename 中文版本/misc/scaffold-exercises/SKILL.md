---
name: scaffold-exercises
description: 创建包含章节、题目、答案和讲解的练习目录结构，并确保其通过 lint 检查。当用户希望搭建练习、创建练习桩（stub），或设置新的课程章节时使用。
---

# 搭建练习（Scaffold Exercises）

创建能通过 `pnpm ai-hero-cli internal lint` 检查的练习目录结构，然后用 `git commit` 提交。

## 目录命名

- **章节**：位于 `exercises/` 内的 `XX-section-name/`（例如 `01-retrieval-skill-building`）
- **练习**：位于章节内的 `XX.YY-exercise-name/`（例如 `01.03-retrieval-with-bm25`）
- 章节编号为 `XX`，练习编号为 `XX.YY`
- 名称使用 dash-case（小写，用连字符分隔）

## 练习变体

每个练习至少需要以下子文件夹之一：

- `problem/`：学生的工作区，包含 TODO
- `solution/`：参考实现
- `explainer/`：概念性材料，不含 TODO

搭建练习桩时，默认使用 `explainer/`，除非计划中另有指定。

## 必需文件

每个子文件夹（`problem/`、`solution/`、`explainer/`）都需要一个 `readme.md`，且满足：

- **不为空**（必须有实际内容，哪怕只有一行标题也可以）
- 没有失效链接

搭建桩时，创建一个包含标题和描述的最简 readme：

```md
# 练习标题

这里是描述
```

如果子文件夹包含代码，还需要一个 `main.ts`（超过一行）。但对于桩来说，只有 readme 的练习也是可以的。

## 工作流程

1. **解析计划**：提取章节名称、练习名称和变体类型
2. **创建目录**：对每个路径执行 `mkdir -p`
3. **创建桩 readme**：每个变体文件夹创建一个带标题的 `readme.md`
4. **运行 lint**：执行 `pnpm ai-hero-cli internal lint` 进行验证
5. **修复错误**：反复迭代，直到 lint 通过

## Lint 规则概要

lint 工具（`pnpm ai-hero-cli internal lint`）检查以下内容：

- 每个练习都有子文件夹（`problem/`、`solution/`、`explainer/`）
- 至少存在 `problem/`、`explainer/` 或 `explainer.1/` 之一
- 主子文件夹中存在非空的 `readme.md`
- 没有 `.gitkeep` 文件
- 没有 `speaker-notes.md` 文件
- readme 中没有失效链接
- readme 中没有 `pnpm run exercise` 命令
- 每个子文件夹都需要 `main.ts`，除非它只包含 readme

## 移动或重命名练习

在重新编号或移动练习时：

1. 使用 `git mv`（而不是 `mv`）重命名目录，以保留 git 历史
2. 更新数字前缀，以保持顺序
3. 移动后重新运行 lint

示例：

```bash
git mv exercises/01-retrieval/01.03-embeddings exercises/01-retrieval/01.04-embeddings
```

## 示例：根据计划搭建桩

假设有如下计划：

```
Section 05: Memory Skill Building
- 05.01 Introduction to Memory
- 05.02 Short-term Memory (explainer + problem + solution)
- 05.03 Long-term Memory
```

创建：

```bash
mkdir -p exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer
mkdir -p exercises/05-memory-skill-building/05.02-short-term-memory/{explainer,problem,solution}
mkdir -p exercises/05-memory-skill-building/05.03-long-term-memory/explainer
```

然后创建 readme 桩：

```
exercises/05-memory-skill-building/05.01-introduction-to-memory/explainer/readme.md -> "# Introduction to Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/explainer/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/problem/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.02-short-term-memory/solution/readme.md -> "# Short-term Memory"
exercises/05-memory-skill-building/05.03-long-term-memory/explainer/readme.md -> "# Long-term Memory"
```
