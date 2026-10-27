# 2026-10-27 报告与 wiki 分离

## 决定

2026-10-27，幕僚长决定：子智能体的原始审计报告、上游 changelog 摘录等「来源」统一写入仓库根目录 `reports/`；`wiki/` 只保存带日期的结论、决策与指向来源的链接。

## 理由

- 遵循 skill 的约束：来源绝不复制进 wiki，也不在 wiki 内编辑。
- 原始报告体量大、时效性强；wiki 需要可读、可链接、可长期维护。
- 报告文件名以日期开头（`YYYY-MM-DD-*.md`），便于按时间回溯。

## 后续变更

2026-10-27：位置已调整——`reports/` 移入 `docs/reports/`，见 [元数据收进 docs/](2026-10-27-docs-consolidation.md)。「来源不进 wiki」的原则不变。

## 相关

- [Wiki 位置](2026-10-27-wiki-location.md)
- [元数据收进 docs/](2026-10-27-docs-consolidation.md)
