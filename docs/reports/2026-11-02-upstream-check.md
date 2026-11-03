# 上游更新比对与同步报告（2026-11-02）

## 结论摘要

- **上游前进了**：`mattpocock/skills` 的 `main` 从 `59db609` 前进到 `4ae2317`，中间 5 个提交。
- **影响译本的有 15 个 skill 文件**：其中 9 个是已有文件，6 个是新增 skill `software-factory` 的文件。其余变更（`.changeset/`、`CHANGELOG.md`、`CLAUDE.md`、`package.json`、`.claude-plugin/plugin.json`）不在译本范围内。
- 已有 9 个文件已在 `英文版本/` 更新到上游原文，并重译到 `中文版本/`；`software-factory` 6 个文件已新增到两边。
- `verify_zh.py` 全绿；`deploy_zh.py` 同步后漂移为 0。

## 1. 上游状态

| 项 | 值 |
| --- | --- |
| 仓库 | `https://github.com/mattpocock/skills` |
| 上一基线 | `59db609`（2026-10-29） |
| 默认分支 / HEAD | `main` @ `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` |
| 最新发布标签 | `v1.3.1`（指向 `24fe0ef`，未变） |

克隆位置：`C:/Users/Administrator/AppData/Local/Temp/mattpocock-skills-upstream`（纯英文临时路径）。

## 2. 本次上游提交

| commit | 标题 | PR |
| --- | --- | --- |
| `7739eae` | `Start subagents with a fresh context window, not a fork` | #1341 |
| `d1478fc` | `chore: version skills` | #1161 |
| `a496f55` | `implement-spec: a fresh implementer subagent per ticket` | #1342 |
| `5ae4816` | `chief-of-staff: shared wiki first; retro and implement-spec as procedures` | #1363 |
| `4ae2317` | `software-factory: glossary skill for designing a factory` | #1316 |

## 3. 逐文件变更清单（`59db609` → `4ae2317`）

### 3.1 已有文件（9 个，已同步并重译）

| 文件 | 变更内容 |
| --- | --- |
| `engineering/code-review/SKILL.md` | 并行子智能体启动时加"以全新上下文窗口启动" |
| `engineering/codebase-design/DESIGN-IT-TWICE.md` | 设计子智能体加"全新上下文窗口" |
| `engineering/implement-spec/SKILL.md` | 新增"每个子智能体以全新上下文窗口启动"；实现者子智能体改为"每张工单一个全新的实现者子智能体"；修复评审问题的子智能体也改为全新的 |
| `engineering/improve-codebase-architecture/SKILL.md` | 探索子智能体加"全新上下文窗口" |
| `engineering/research/SKILL.md` | 后台研究智能体加"全新上下文窗口" |
| `engineering/wayfinder/SKILL.md` | 研究子智能体加"全新上下文窗口" |
| `in-progress/README.md` | 新增 `software-factory` 条目 |
| `in-progress/chief-of-staff/SKILL.md` | 子智能体加"全新上下文窗口"；wiki 段改为"先找共享 wiki，沿用其约定"；新增"流程"一节，引用 `retro` 与 `to-spec` / `to-tickets` / `implement-spec` |
| `productivity/grilling/SKILL.md` | 事实查找的子智能体加"全新上下文窗口" |

### 3.2 新增 skill（6 个文件）

`in-progress/software-factory/` 下 `SKILL.md`、`EXAMPLE-TASKS.md`、`GIT-HOSTS.md`、`OBSERVABILITY-PLATFORMS.md`、`RUNNERS.md`、`TICKET-TRACKERS.md`。这是一份术语表型 skill，加上 4 份供应商调查文档。`_Avoid_` 标记与协议字符串保持英文。

### 3.3 不在译本范围（未处理）

`.changeset/`（新增与删除）、`CHANGELOG.md`、`CLAUDE.md`、`package.json`、`.claude-plugin/plugin.json`。

## 4. 同步动作与验证

| 步骤 | 结果 |
| --- | --- |
| `英文版本/` 覆盖 9 个已有文件，新增 `software-factory` 6 个文件 | 完成 |
| `中文版本/` 重译 9 个已有文件，新增 `software-factory` 6 个文件 | 完成 |
| `python scripts/verify_zh.py` | 全绿：四桶 61 + 22 + 10 + 20，frontmatter 全部可解析，`name` 与目录同名，`openai.yaml` 键结构，协议字符串计数一致 |
| `python scripts/deploy_zh.py --apply` | 同步 8 个文件，备份至 `~/.qoder-cn/skills-backup-20261102-233105` |
| `software-factory` 安装位 | `deploy_zh.py` 不创建缺失的 skill 目录，由人工复制到 `~/.qoder-cn/skills/software-factory` |
| 复查漂移 | 0，39 个 skill，无缺失、无多余 |

## 5. 过程中的问题与处置

- **比对脚本路径拼接错误**：最初的比对把 `code-review` 误判为"未变"，因为脚本漏掉了 `engineering/` 前缀，导致它被归到 `localOther`。重新用 Python 逐一核对后，确认 `code-review` 确实变化了。
- **PowerShell 字节比较的假差异**：用 `Out-File` 与 `Get-Content` 比较时，行尾与编码造成不一致。改用 Python 按 UTF-8 读取并统一 `\r\n` → `\n` 后比较，结果一致。
- **`deploy_zh.py` 不处理新增 skill**：它只报告 `missing-skill`，不会创建目录。新 skill 需要人工复制，本次已按平铺结构复制。
- **英文版本 9 个文件的同步时机**：第一次校验时，`英文版本/` 仍是 `59db609` 版本，与上游不一致。随即覆盖为 `4ae2317` 版本后再校验。

## 6. 相关

- [上游状态 2026-11-02](../wiki/upstream/2026-11-02-state.md)
- [上游状态 2026-10-29](../wiki/upstream/2026-10-29-state.md)
- [上游更新比对与同步报告（2026-10-29）](2026-10-29-upstream-check.md)
