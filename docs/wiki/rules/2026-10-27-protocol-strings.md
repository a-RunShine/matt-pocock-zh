# 规则：协议字符串与脚手架

## 决定

2026-10-27，用户确认「脚手架英文、说明可译」：

- **保持英文**：分诊标签、`wayfinder:*`、tracker 协议行 `Status:` / `Blocked by:`、wayfinder 地图节名（`Destination` / `Notes` / `Decisions so far` / `Not yet specified` / `Out of scope`）、术语表样板名与 `_Avoid_` 标记、`name:`、`openai.yaml` 键名、triage AI 声明、`BLOCKED:`。
- **可以翻译**：说明性散文、注释、模板里给人看的提示文字。
- **可以做例外**：ADR、学习记录、文章等模板里「给人填写的标题占位符」允许本地化；不承担跨文件指代，不按字面解析。
- **一律不译**：命令、变量名、正则、JSON/YAML 键值、路径、占位符标识。

理由是这些字符串是跨文件的**指代**：一旦翻译，同一概念会出现中英两套名字，子智能体按一套写、另一套读。

## 证据

2026-10-27 的审计发现三处同类问题：

- `to-tickets` 把 `Status:` / `Blocked by:` 译成中文，与 `issue-tracker-local.md` 的协议行冲突。
- `wayfinder` 把地图节名译成中文，而三份 tracker 文档仍用英文名指代。
- 两份 `GLOSSARY-FORMAT.md` 把样板术语名与 `_Avoid_` 译掉，样板会被照抄进真实术语表。

修复提交：`6739f6b`（2026-10-27）。

## 执行

2026-10-27：`scripts/verify_zh.py` 已强制检查上述协议字符串、地图节名、`Status:` / `Blocked by:` 与 `_Avoid_`。规则同时写入 `AGENTS.md` 的「翻译不变量」。

## 相关

- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
- [机械合规审计 2026-10-27](../audits/2026-10-27-compliance.md)
- [保真审计 2026-10-27](../audits/2026-10-27-fidelity.md)
