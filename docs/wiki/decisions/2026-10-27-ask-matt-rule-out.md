# 2026-10-27 ask-matt 的 rule out 裁定

## 背景

上游 `mattpocock/skills@5beb35b`（2026-10-19）的 `ask-matt` 有两处句子：

- `SKILL.md`：`why the primary-source cost makes Continue the one to rule out first`
- `PHASE-BOUNDARIES.md`：`Continue costs nothing and loses nothing, so rule it out before anything else.`

但同一文件的决策树第 1 问是「能否在本会话中继续？」，第一个**是**即胜出，`Continue` 是首选分支。按 `rule out` 的字面义翻译会与决策树直接冲突。

## 决定

2026-10-27：中文译文不按字面「先排除 Continue」，而按决策树语义译为「先把 Continue 定下来」：

- `SKILL.md`：「为什么一手来源的成本使**继续**成为应当最先定下来的选项」
- `PHASE-BOUNDARIES.md`：「因此先把它定下来，再考虑其余选项」

## 理由

- 两处原文与同一文件的决策树矛盾，更像上游笔误（`rule it out` vs `rule it in`）。
- 逐字翻译会把一个明显不可执行的禁令交给智能体；可执行性优先于字面忠实。
- 这是**有意的偏离**，不是漏译；若上游后续修正原句，应重新评估。

## 相关

- [全量保真审计 2026-10-27](../audits/2026-10-27-fidelity-full.md)
- [术语约定 2026-10-27](../rules/2026-10-27-terminology.md)
