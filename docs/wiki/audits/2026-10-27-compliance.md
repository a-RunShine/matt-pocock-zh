# 审计：机械合规 2026-10-27

来源：[docs/reports/2026-10-27-compliance-audit.md](../../reports/2026-10-27-compliance-audit.md)。

## 范围与结果

2026-10-27：对 `中文版本/` 全部 38 个 skill、107 个文件做机械检查，8 项中 6 项 PASS、1 项 FAIL、1 项部分 FAIL。

| 检查项 | 结果 |
| --- | --- |
| frontmatter `name` 英文且等于目录名、description 已译 | FAIL：38/38 名称一致，但 1 个文件 YAML 非法 |
| `agents/openai.yaml` 键名/取值原样 | PASS：38/38；23 个 `allow_implicit_invocation: false` 与英文集合一致 |
| 分诊标签 / `wayfinder:*` / triage 声明 / `BLOCKED:` | PASS：计数一致，零误译 |
| `CONTEXT.md` / `CONTEXT-MAP` 残留 | PASS：0 命中 |
| `in-progress/README.md` beta 提示 | PASS：第 3 行 |
| 三个脚本 `bash -n` | PASS：3/3 退出码 0 |
| 代码块内容 | 部分 FAIL：命令/变量/正则/键值未译；模板字段与节名被译 |
| 四桶文件树对齐 | PASS：107 = 107，missing/extra = 0 |

## 问题

2026-10-27：共 6 条。

| 级别 | 位置 | 问题 |
| --- | --- | --- |
| P1 高 | `code-review/SKILL.md:3` | description 内层双引号未转义，YAML 解析失败 |
| P2 中 | `to-tickets/SKILL.md:75,77` | `Status:` / `Blocked by:` 被译，与 `issue-tracker-local.md` 协议行冲突 |
| P3 中 | `wayfinder/SKILL.md:32-50` | 地图节名被译，三份 tracker 文档仍用 `Notes / Decisions-so-far / Fog` |
| P4 低 | 22 个文件、36 个围栏 | 模板正文被译；是否违规取决于对不变量的解释 |
| P5 低 | 两份 `GLOSSARY-FORMAT.md` | 样板术语追加中文注解，`_Avoid_` 被译 |
| P6 信息 | `in-progress/README.md:11` | 比上游多列 `chief-of-staff`，非缺陷，同步时注意重复 |

## 复核

2026-10-27：幕僚长亲自复核 P1、P2、P3 属实；P4、P5 依据报告，尚未逐行复核。P1 与保真审计的 P0 是同一处。

## 系统性含义

2026-10-27：P2、P3、P5 都属于同一类——**把「协议字符串」当普通散文翻译**。现有 `AGENTS.md` 只点名了分诊标签与 `wayfinder:*`，没有覆盖 tracker 的状态行、地图节名、模板字段名、术语表样板。规则需要补，而不是逐条打补丁。

## 相关

- [保真审计 2026-10-27](2026-10-27-fidelity.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
