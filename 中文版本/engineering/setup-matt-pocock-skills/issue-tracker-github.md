# Issue tracker：GitHub

本仓库的 issue 和规格以 GitHub issue 的形式存在。所有操作都使用 `gh` CLI。

## 约定

- **创建 issue**：`gh issue create --title "..." --body "..."`。多行正文使用 heredoc。
- **阅读 issue**：`gh issue view <number> --json number,title,body,labels,comments`。
- **列出 issue**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，配合适当的 `--label` 和 `--state` 过滤。
- **把 issue 设为某父 issue 的子 issue**：`gh issue create --parent <parent> ...`，或之后用 `gh issue edit <parent> --add-sub-issue <child>`（需要 `gh` 2.94+）。旧版 `gh`：`gh api --method POST repos/<owner>/<repo>/issues/<parent>/sub_issues -F sub_issue_id=<child-db-id>`（数据库 id，参见下方的**阻塞**）。如果没有子 issue 功能，就在子 issue 正文顶部写 `Part of #<parent>`。
- **评论 issue**：`gh issue comment <number> --body "..."`
- **添加/移除标签**：`gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **关闭**：`gh issue close <number> --comment "..."`

从 `git remote -v` 推断仓库；在克隆的目录内运行时 `gh` 会自动完成这一点。

## 将 Pull Request 作为分诊入口

**将 PR 作为请求入口：否。** _（如果本仓库把外部 PR 当作功能请求，就设为 `yes`；`/triage` 会读取此标志。）_

设为 `yes` 时，PR 与 issue 使用相同的标签和状态，使用对应的 `gh pr` 命令：

- **阅读 PR**：`gh pr view <number> --comments`，以及用 `gh pr diff <number>` 查看 diff。
- **列出用于分诊的外部 PR**：`gh api --paginate 'repos/{owner}/{repo}/pulls?state=open' --jq '.[] | select(.author_association | IN("OWNER","MEMBER","COLLABORATOR") | not) | {number, title, author: .user.login, author_association, labels: [.labels[].name]}'`。
- **评论 / 打标签 / 关闭**：`gh pr comment`、`gh pr edit --add-label`/`--remove-label`、`gh pr close`。

GitHub 的 issue 和 PR 共用一个编号空间，因此裸的 `#42` 可能指两者之一：先用 `gh pr view 42` 解析，失败则回退到 `gh issue view 42`。

## 当某个 skill 说"发布到 issue tracker"时

创建一个 GitHub issue。

## 当某个 skill 说"获取相关工单"时

按照上面的**阅读 issue**进行读取。

## 寻路（Wayfinding）操作

由 `/wayfinder` 使用。**地图**是一个单独的 issue，其**子** issue 即为工单。

- **地图**：一个带有 `wayfinder:map` 标签的单独 issue，承载 Notes / Decisions-so-far / Fog 的正文。`gh issue create --label wayfinder:map`。
- **子工单**：一个作为 GitHub 子 issue 关联到地图的 issue（参见上面的**把 issue 设为某父 issue 的子 issue**）。如果未启用子 issue，就把子项加入地图正文中的任务列表，并在子项正文顶部放置 `Part of #<map>`。标签：`wayfinder:<type>`（`research`/`prototype`/`grilling`/`task`）。认领之后，工单即分配给正在推进的开发者。
- **阻塞**：GitHub 的**原生 issue 依赖**，这是规范的、在 UI 中可见的表示。添加依赖边的方式为 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`，其中 `<blocker-db-id>` 是阻塞项的数字**数据库 id**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，_而不是_ `#number` 或 `node_id`）。GitHub 会报告 `issue_dependencies_summary.blocked_by`（仅包含未关闭的阻塞项，即实时的门控）。如果依赖功能不可用，就退回到子项正文顶部的 `Blocked by: #<n>, #<n>` 行。当每个阻塞项都已关闭时，工单即为未被阻塞。
- **前沿查询**：列出地图未关闭的子项（`gh issue list --state open`，限定在地图的子 issue / 任务列表中），剔除任何带有未关闭阻塞项（`issue_dependencies_summary.blocked_by > 0`，或 `Blocked by` 行中某个未关闭的 issue）或已有负责人的。按地图顺序取第一个。
- **认领**：`gh issue edit <n> --add-assignee @me`，这是会话的第一次写入。
- **解决**：`gh issue comment <n> --body "<answer>"`，然后 `gh issue close <n>`，再在地图的 Decisions-so-far 中追加一个上下文指针（摘要 + 链接）。
