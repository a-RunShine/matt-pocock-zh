# 问题：skill 流程被跳过，直接进入实现

## 现象

- 2026-11-10：用户消息「要不给它合并到我的仓库里，然后在README里进行说明 @to-spec」点名调用了 `to-spec`。
- 2026-11-10：`to-spec` 正文写明的流程是：探索仓库 → 勾出测试接缝 → **与用户确认接缝** → 按模板写规格 → 发布到 issue tracker 并打 `ready-for-agent`。它的产出物是**规格**，不是实现。
- 2026-11-10：`to-spec` 还有一条显式的回退分支：「The issue tracker and triage label vocabulary should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.」
- 2026-11-10：实际发生的是——我在回复里说了一句「本仓库没有配置 issue tracker」，然后直接开工：建 `CODING_STANDARDS/`、写三份模板、改 README、改 AGENTS.md、建 wiki 决策页、提交推送。**规格从未产生，回退分支也未执行。**

## 影响

- 用户失去了动手前的审阅点。事后补的规格只能用来核对，不能用来决定。
- 回退分支本可以让用户决定要不要先配 issue tracker；跳过它等于替用户做了决定。

## 根因

消息里动作动词在前（「合并到我的仓库里」）、skill 标签在后（`@to-spec`）。我把 skill 标签读成了「参考资料」而非「执行入口」，注意力锚在动作上，直接跳到了实现。

## 教训

**用户点名 skill 时，先产出该 skill 的交付物，再做用户要求的动作。**

具体两条：

1. **交付物先于动作。** `to-spec` 的交付物是规格，那就先有规格再有实现。用户要求的是「合并进仓库」，但那是实现阶段的事。
2. **回退分支也是流程。** skill 写了「如果 X 不存在就做 Y」，X 不存在时就做 Y，不要沉默跳过。

## 可以机械判定吗

不能。没有检查能判定「skill 的流程被跳过了」——它发生在会话里，不产生可断言的产物。按 [编码规范模板](../../../CODING_STANDARDS/README.md) 的判据，这类问题只能进 steering 文件（AGENTS.md / CLAUDE.md），不能做成检查。

## 状态

2026-11-10：记录。尚未补写规格——那件事当时用户选择「记一笔教训」，规格要不要补、补了给谁看，待定。

2026-11-10：`AGENTS.md` 的「改动流程」开头加了对应的一条 steering：skill 流程是要求、回退分支也要执行。用户选仓库级而非全局，理由是这个仓库正是做规格与 skill 翻译工作的地方；若日后在别处重犯，再考虑上全局 `~/.config/opencode/AGENTS.md`。

## 相关

- [编码规范模板收进仓库](../decisions/2026-11-10-standards-templates.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
