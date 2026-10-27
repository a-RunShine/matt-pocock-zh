# 问题：缺少 frontmatter 自动校验

## 现象

- 2026-10-27：`中文版本/engineering/code-review/SKILL.md` 的 frontmatter 不是合法 YAML（description 内层 ASCII 双引号未转义），Python `yaml.safe_load` 在第 3 行报 scanner error。skill 的 `name` 与触发条件因此不可用。
- 2026-10-27：该文件在 `AGENTS.md` 描述的验证流程下通过了检查，因为流程只比对文件树、跑三个脚本语法、查旧术语残留，**从不解析 frontmatter**。

## 影响

- 2026-10-27：非法 YAML 会让 skill 无法被加载或无法被正确触发，是「静默失效」——文件看起来完整，校验也全绿。
- 2026-10-27：同类风险还包括 `name` 与目录名不一致、`agents/openai.yaml` 键名被误译，这些目前都靠人工信任。

## 建议

2026-10-27：新增一个只读校验脚本（例如 `scripts/verify-zh.sh`），在一次运行内完成：

1. 所有 `中文版本/**/SKILL.md` 的 frontmatter 用 YAML 解析器解析；
2. `name` 必须与 skill 目录名一致，且为英文字符串；
3. `agents/openai.yaml` 的键集合与上游完全一致；
4. 禁用字符串 / 旧术语扫描（`CONTEXT.md`、`CONTEXT-MAP` 等）；
5. 三个脚本 `bash -n`；
6. 四桶与 `中文版本/` 相对路径集合相等。

任一失败即非零退出，作为每次改动的必跑门禁。

## 状态

2026-10-27：已记录，脚本尚未创建。等待合规审计完整结果后与修复批次一起落地。

## 相关

- [审计：译文保真 2026-10-27](../audits/2026-10-27-fidelity.md)
