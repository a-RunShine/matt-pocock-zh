# Issue tracker：GitLab

本仓库的 issue 和规格以 GitLab issue 的形式存在。所有操作都使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。

## 约定

- **创建 issue**：`glab issue create --title "..." --description "..."`。多行描述使用 heredoc。传入 `--description -` 可打开编辑器。
- **阅读 issue**：`glab issue view <number> --comments`。需要机器可读输出时使用 `-F json`。
- **列出 issue**：`glab issue list -O json`，配合适当的 `--label` 过滤。
- **评论 issue**：`glab issue note <number> --message "..."`。GitLab 把评论称为 "note"。
- **添加/移除标签**：`glab issue update <number> --label "..."` / `--unlabel "..."`。多个标签可用逗号分隔，或重复使用该参数。
- **关闭**：`glab issue close <number>`。`glab issue close` 不接受关闭评论，因此先用 `glab issue note <number> --message "..."` 发布说明，再关闭。
- **合并请求**：GitLab 把 PR 称为 "merge request"。使用 `glab mr create`、`glab mr view`、`glab mr note` 等，形式与 `gh pr ...` 相同，只是把 `pr` 换成 `mr`，并用 `note`/`--message` 代替 `comment`/`--body`。

从 `git remote -v` 推断仓库；在克隆的目录内运行时 `glab` 会自动完成这一点。

## 将合并请求作为分诊入口

**MRs as a request surface: no.**（将 MR 作为请求入口：否） _（如果本仓库把外部合并请求当作功能请求，就设为 `yes`；`/triage` 会读取此标志。）_

设为 `yes` 时，MR 与 issue 使用相同的标签和状态，使用对应的 `glab mr` 命令：

- **阅读 MR**：`glab mr view <number> --comments`，以及用 `glab mr diff <number>` 查看 diff。
- **列出用于分诊的外部 MR**：`glab mr list -F json`，然后只保留作者不是项目成员/所有者的 MR（即贡献者的 MR，而不是维护者正在进行的工作）。
- **评论 / 打标签 / 关闭**：`glab mr note`、`glab mr update --label`/`--unlabel`、`glab mr close`。

与 GitHub 不同，GitLab 对 issue 和 MR 分别编号，因此一旦知道维护者指的是哪个入口，`#42` 就没有歧义。

## 当某个 skill 说"发布到 issue tracker"时

创建一个 GitLab issue。

## 当某个 skill 说"获取相关工单"时

运行 `glab issue view <number> --comments`。

## 寻路（Wayfinding）操作

由 `/wayfinder` 使用。**地图**是一个单独的 issue，其**子** issue 即为工单。

- **地图**：一个带有 `wayfinder:map` 标签的单独 issue，承载 Notes / Decisions-so-far / Fog 的正文。`glab issue create --label wayfinder:map`。（在提供原生 epic 的 GitLab 版本上，也可以由一个 epic 承载地图；带标签的 issue 则在任何版本上都可用。）
- **子工单**：一个 issue，其描述顶部带有 `Part of #<map>`，并带有标签 `wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。认领之后，工单即分配给正在推进的开发者。
- **阻塞**：GitLab 的**原生阻塞链接**，这是规范的、在 UI 中可见的表示。通过 `/blocked_by #<n>` 快捷操作添加，以评论（note）形式发布（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻塞链接是 Premium/Ultimate 功能；在免费版（或不可用的地方），退回到描述顶部的 `Blocked by: #<n>, #<n>` 行。当每个阻塞项都已关闭时，工单即为未被阻塞。
- **前沿查询**：`glab issue list -O json`，限定在地图的子项中，剔除任何带有未关闭阻塞项的：即指向未关闭 issue 的原生 `blocked_by` 链接（`glab api projects/:id/issues/<child-iid>/links`），或 `Blocked by` 行中某个未关闭的 issue，或已有负责人的。按地图顺序取第一个。
- **认领**：`glab issue update <n> --assignee @me`，这是会话的第一次写入。
- **解决**：`glab issue note <n> --message "<answer>"`，然后 `glab issue close <n>`，再在地图的 Decisions-so-far 中追加一个上下文指针（摘要 + 链接）。
