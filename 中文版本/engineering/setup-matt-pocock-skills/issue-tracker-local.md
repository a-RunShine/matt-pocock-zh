# Issue tracker：本地 Markdown

本仓库的 issue 和规格以 markdown 文件的形式存放在 `.scratch/` 中。

## 约定

- 每个功能一个目录：`.scratch/<feature-slug>/`
- 规格是 `.scratch/<feature-slug>/spec.md`
- 实现类 issue 每张工单一个文件，位于 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，从 `01` 开始编号，绝不使用合并在一起的单个工单文件
- 分诊状态记录在每个 issue 文件顶部附近的 `Status:` 行中（角色字符串参见 `triage-labels.md`）
- 评论和对话历史追加到文件底部，位于 `## Comments` 标题之下

## 当某个 skill 说"发布到 issue tracker"时

在 `.scratch/<feature-slug>/` 下新建一个文件（如有需要先创建目录）。

## 当某个 skill 说"获取相关工单"时

读取被引用路径处的文件。用户通常会直接给出路径或 issue 编号。

## 寻路（Wayfinding）操作

由 `/wayfinder` 使用。**地图**是一个文件，每张工单对应一个**子**文件。

- **地图**：`.scratch/<effort>/map.md`（Notes / Decisions-so-far / Fog 的正文）。
- **子工单**：`.scratch/<effort>/issues/NN-<slug>.md`，从 `01` 开始编号，问题写在正文中。`Type:` 行记录工单类型（`research`/`prototype`/`grilling`/`task`）；`Status:` 行记录 `claimed`/`resolved`。
- **阻塞**：文件顶部附近的 `Blocked by: NN, NN` 行。当它所列出的每个文件都是 `resolved` 时，工单即为未被阻塞。
- **前沿**：扫描 `.scratch/<effort>/issues/`，找出开放、未被阻塞、未被认领的文件；编号最小者优先。
- **认领**：在开始任何工作之前，设置 `Status: claimed` 并保存。
- **解决**：在 `## Answer` 标题下追加答案，设置 `Status: resolved`，然后在 `map.md` 的 Decisions-so-far 中追加一个上下文指针（摘要 + 链接）。
