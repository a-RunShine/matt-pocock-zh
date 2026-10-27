# 2026-10-27 AGENTS.md 维护流程更新

## 变更

2026-10-27：`AGENTS.md` 更新，提交 `83ce74c`。

- **入口**：要求先读 `docs/wiki/index.md` 与相关规则页，再动手。
- **目录职责**：写明 `docs/wiki/` 的内容（索引、决策、规则、审计）与 `scripts/` 两个脚本的只读 / `--apply` 语义。
- **验证**：由一条命令改为两条——`verify_zh.py` 管仓库，`deploy_zh.py` 管安装位漂移。
- **改动流程**：新增「改完译文必须 `--apply` 同步安装位，再复查漂移为 0；持久结论写回 wiki」。
- **翻译不变量**：补「ADR / 学习记录 / 文章标题占位符可本地化」，并把跨文件术语指向 `docs/wiki/rules/2026-10-27-terminology.md`。
- **已知有意偏离**：登记 `ask-matt` 的 `rule it out` 裁定、`in-progress/README.md` 多列的 `chief-of-staff`、标题占位符例外。

## 为什么

2026-10-27 之前，`AGENTS.md` 仍停留在「目录 + 单脚本校验」的版本。但仓库当天已经新增了 git、安装位部署、wiki 规则与全量审计；旧说明会让下一个会话：

- 只跑仓库校验，忘记同步 `~/.qoder-cn/skills`；
- 把 `ask-matt` 的有意偏离当成误译改回去；
- 不知道术语与模板规则已经落在 `docs/wiki/rules/`。

## 未写入 AGENTS.md 的内容

47 条 P2 的逐条结论、审计过程、部署备份路径仍只放在 `docs/wiki/` 与 `docs/reports/`。`AGENTS.md` 只承载每次会话都必须遵守的稳定规则，不承载历史。

## 相关

- [基线与环境 2026-10-27](baseline-2026-10-27.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
- [术语约定 2026-10-27](../rules/2026-10-27-terminology.md)
- [ask-matt 的 rule out 裁定](../decisions/2026-10-27-ask-matt-rule-out.md)
