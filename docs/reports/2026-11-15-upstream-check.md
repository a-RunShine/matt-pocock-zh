# 上游更新比对与同步报告（2026-11-15）

## 结论摘要

- **上游前进了**：`mattpocock/skills` 的 `main` 从 `4ae2317`（2026-11-02）前进到 `5863806`，中间 2 个提交。
- **影响译本的只有 2 个文件**，都在 `skills/in-progress/software-factory/` 下；另一个提交是 merge，不引入新变化。
- 2 个文件已由上游原文覆盖 `英文版本/`，并重译到 `中文版本/`；其余 111 个文件未动。
- `verify_zh.py` 全绿；安装位同步后漂移为 0。

## 1. 上游状态

| 项 | 值 |
| --- | --- |
| 仓库 | `https://github.com/mattpocock/skills` |
| 上一基线 | `4ae2317`（2026-11-02） |
| 默认分支 / HEAD | `main` @ `5863806dd4e15c63174bee4e7515a4256792ecfa` |
| 最新发布标签 | `v1.3.1`（指向 `24fe0ef`，未变） |

克隆位置：`C:/Users/Administrator/AppData/Local/Temp/mattpocock-skills-upstream`（纯英文临时路径）。

## 2. 本次上游提交

| commit | 标题 |
| --- | --- |
| `d18183f` | `software-factory: "job" is the CI vendor's word; explore leaves findings` |
| `5863806` | `Merge pull request #1416 from mattpocock/software-factory-task-wording` |

## 3. 逐文件变更清单（`4ae2317` → `5863806`）

### 3.1 影响译本（2 个，已同步并重译）

| 文件 | 变更内容 |
| --- | --- |
| `skills/in-progress/software-factory/SKILL.md` | `Task` 的 `_Avoid_` 行从「job, workflow, action」扩为「…, as names for the task. A CI vendor's workflow file and its jobs are where a task is wired up, not the task.」——防止把 CI 的 workflow/job 概念与工厂的 Task 混淆 |
| `skills/in-progress/software-factory/EXAMPLE-TASKS.md` | Explore task 的「Does」从「检查工单并归类」扩为「核查工单的说法、能复现就复现、归类、把发现留在工单上交给实现者」，并强调「It never pushes」 |

### 3.2 不影响译本

merge 提交 `5863806` 是 `d18183f` 的合并，不引入新变化。`CHANGELOG.md`、`.changeset/` 等仓库自身文件若有变动，不属于译本范围。

## 4. 同步动作与验证

| 步骤 | 结果 |
| --- | --- |
| `英文版本/` 覆盖 2 个文件 | 完成，`git diff --stat` 与上游对应文件一致 |
| `中文版本/` 重译 2 处 | 完成；`_Avoid_` 标记与被避免词保持英文，说明文字译成中文 |
| `python scripts/verify_zh.py` | 全绿 |
| `python scripts/deploy_zh.py --apply` | 同步 2 个文件 |
| 复查漂移 | 0 |

## 5. 相关

- [上游状态 2026-11-15](../wiki/upstream/2026-11-15-state.md)
- [上游更新比对与同步报告（2026-11-02）](2026-11-02-upstream-check.md)
