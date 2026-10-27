# 2026-10-27 Wiki 位置

## 决定

2026-10-27，用户选择把长期记忆 wiki 放在仓库内 `wiki/`，与 `engineering/`、`in-progress/`、`misc/`、`productivity/` 及 `中文版本/` 并列。

## 理由与约束

- 不影响四个桶的文件树对齐校验：对齐只比较桶内相对路径，`wiki/` 在桶外。
- wiki 与产出物同仓，便于子智能体用相对路径引用。
- 本仓库不是 git 仓库（见 [基线与环境](../repo/baseline-2026-10-27.md)），wiki 的历史完全依赖每条论断的日期与来源指针，不能依赖提交历史。

## 后续变更

2026-10-27：位置部分已被 [元数据收进 docs/](2026-10-27-docs-consolidation.md) 取代——wiki 现位于 `docs/wiki/`，不再位于仓库根目录。上文的理由与约束仍然成立。

## 相关

- [报告与 wiki 分离](2026-10-27-sources-vs-wiki.md)
- [元数据收进 docs/](2026-10-27-docs-consolidation.md)
