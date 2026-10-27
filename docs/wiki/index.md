# Wiki 索引

本 wiki 记录「mattpocock-skills-ch 中文译本长期维护」这一目标的决策、基线与审计结论。它是历史记录：每条论断都带日期；涉及代码时引用当时的提交。

原始来源（子智能体报告、上游 changelog、issue）存放在 `../reports/`（即 `docs/reports/`），本 wiki 只引用、不复制。

## 目标

- [目标宪章 2026-10-27](goals/2026-10-27-charter.md) — 把快照改造成可自证、可增量同步、决策有据的长期基线。

## 决策

- [2026-10-27 ask-matt 的 rule out 裁定](decisions/2026-10-27-ask-matt-rule-out.md) — 上游原句与决策树矛盾，按可执行语义译为「先定下来」。
- [2026-10-27 四个源桶收进 英文版本/](decisions/2026-10-27-source-folder.md) — 英文源不再平行摆在根目录，与 `中文版本/` 对称。
- [2026-10-27 同步到实际安装目录](decisions/2026-10-27-install-sync.md) — 9 个修复文件已同步到 `~/.qoder-cn/skills`，漂移归零。
- [2026-10-27 定时任务](decisions/2026-10-27-scheduled-tasks.md) — 每周一核对上游、每月 1 日巡检 wiki。
- [2026-10-27 元数据收进 docs/](decisions/2026-10-27-docs-consolidation.md) — `docs/wiki/` 存记忆，`docs/reports/` 存来源。
- [2026-10-27 Wiki 位置](decisions/2026-10-27-wiki-location.md) — 最初放在仓库根 `wiki/`；位置部分已被上一条取代。
- [2026-10-27 报告与 wiki 分离](decisions/2026-10-27-sources-vs-wiki.md) — 原始报告与 wiki 职责分离；位置已改为 `docs/reports/`。

## 仓库基线

- [2026-10-27 基线与环境](repo/baseline-2026-10-27.md) — 文件树对齐 107 个文件；仓库无 git；本地英文 = 上游 `main`@`5beb35b`。
- [2026-10-27 AGENTS.md 维护流程更新](repo/2026-10-27-agents-update.md) — 双命令验证、部署步骤、已知有意偏离。

## 上游

- [2026-10-27 上游状态](upstream/2026-10-27-state.md) — 上游未发新版；`v1.3.1` 标签落后本地 18 个文件；本次零重译。

## 规则

- [术语约定 2026-10-27](rules/2026-10-27-terminology.md) — 保留英文与统一中文的跨文件术语表。
- [协议字符串与脚手架 2026-10-27](rules/2026-10-27-protocol-strings.md) — 脚手架英文、说明可译；哪些字符串一律不译。

## 审计

- [译文保真抽检 2026-10-27](audits/2026-10-27-fidelity.md) — 10 个 skill：P0 1、P1 4、P2 24；code-review 的 frontmatter 无法解析。
- [全量保真审计 2026-10-27](audits/2026-10-27-fidelity-full.md) — 剩余 28 个 skill：P1 6、P2 47；已全部修复并部署。
- [机械合规审计 2026-10-27](audits/2026-10-27-compliance.md) — 38 skill / 107 文件：6 项通过；协议字符串与模板脚手架是主要缺口。

## 问题

- [AGENTS.md 基线标注错误](issues/2026-10-27-agents-baseline-label.md) — 把未发布的 `main`@`5beb35b` 标成了 `v1.3.1`，按标签同步会回退。
- [缺少 frontmatter 自动校验](issues/2026-10-27-no-frontmatter-validation.md) — 非法 YAML 能静默通过现有验证流程。

## 进行中

（暂无。审计完成后在此登记结论页。）
