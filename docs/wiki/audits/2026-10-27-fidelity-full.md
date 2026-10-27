# 审计：全量保真 2026-10-27

来源（四份原始报告，均在 `docs/reports/`）：

- `2026-10-27-fidelity-full-engineering-a.md`
- `2026-10-27-fidelity-full-engineering-b.md`
- `2026-10-27-fidelity-full-in-progress-misc.md`
- `2026-10-27-fidelity-full-productivity.md`

## 范围

2026-10-27：对剩余 28 个 skill 做逐段中英对照，补齐全仓 38 个 skill 的保真覆盖。含 `in-progress/README.md`、`misc/README.md`、`productivity/README.md`、`teach/` 四份格式模板、`writing-for-agents/SKILL-MECHANICS.md`，以及 38 份 `openai.yaml` 的键结构。

## 结果

2026-10-27：P1 6 条、P2 47 条。

| 区域 | P1 | P2 |
| --- | --- | --- |
| engineering 前半（ask-matt 等 10 个） | 1 | 7 |
| engineering 后半（wayfinder 等 10 个） | 4 | 16 |
| in-progress + misc（11 个） | 1 | 7 |
| productivity（7 个） | 0 | 17 |

## 最严重的问题

- `wayfinder:69` 把「阻塞它的工单」译成「它所阻塞的工单」，前沿判定方向反转。
- `wayfinder` 正文仍用中文指代英文地图节名；`to-tickets` 正文仍用「阻塞于」指 `Blocked by`。
- `writing-shape` 把 `block` 全篇译成「段落」，把 grounding 约束收窄到段落。
- `ask-matt` 的 `rule it out` 在两处被译成相反意思。
- 模板脚手架仍中英混排：`GLOSSARY-FORMAT`、`teach` 四份 FORMAT、`triage` 评论模板、`to-tickets` / `to-spec` 工单模板。

## 处理

2026-10-27：全部 P1/P2 已修复，提交 `d33e8f7`，43 个文件；40 个文件同步到 `~/.qoder-cn/skills`，备份 `skills-backup-20261027-142929`，复查漂移 0。跨文件术语见 [术语约定](../rules/2026-10-27-terminology.md)。

## 裁定

2026-10-27：`ask-matt` 的上游原文自相矛盾，按决策树语义译为「先把 Continue 定下来」，不按字面「先排除」。见 [ask-matt 的 rule out 裁定](../decisions/2026-10-27-ask-matt-rule-out.md)。

## 相关

- [保真抽检 2026-10-27](2026-10-27-fidelity.md)
- [机械合规审计 2026-10-27](2026-10-27-compliance.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
