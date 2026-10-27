# 2026-10-27 同步到实际安装目录

## 决定

2026-10-27，用户批准把首轮修复同步到 Qoder 实际加载的 skills 目录 `C:/Users/Administrator/.qoder-cn/skills`。

## 同步前状态

2026-10-27：安装目录有 38 个 Matt 中文 skill，与 `中文版本/` 相比，只有 9 个文件不同、0 个缺失 skill、0 个多余文件。也就是说，仓库已修复，但 Qoder 加载的仍是修复前副本，`code-review` 的 frontmatter 仍然非法。

## 执行

- 工具：`scripts/deploy_zh.py`（默认只读检查，`--apply` 才写入）。
- 2026-10-27：同步 9 个文件；覆盖前备份到 `C:/Users/Administrator/.qoder-cn/skills-backup-20261027-140955`。
- 2026-10-27：再次只读检查，漂移为 0。
- 2026-10-27：验证安装目录的 `code-review/SKILL.md` 可被 YAML 解析（`name=code-review`），`hitl-loop.template.sh` 通过 `bash -n`。
- 2026-10-27：P2 批次（提交 `32b3ce1`）再次同步 11 个文件，备份到 `C:/Users/Administrator/.qoder-cn/skills-backup-20261027-141707`；复查漂移为 0。

## 边界

- `C:/Users/Administrator/.cc-switch/skills` 是英文上游安装位，不属于中文译本，未触碰。
- 同步不做删除：安装目录多出的文件只报告，交人工确认。

## 相关

- [协议字符串与脚手架](../rules/2026-10-27-protocol-strings.md)
- [定时任务 2026-10-27](2026-10-27-scheduled-tasks.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
