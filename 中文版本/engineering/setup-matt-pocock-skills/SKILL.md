---
name: setup-matt-pocock-skills
description: "为本仓库配置工程类 skill：设置其 issue tracker、分诊标签词汇和领域文档布局。在首次使用其他工程类 skill 之前运行一次。"
disable-model-invocation: true
---

# 设置 Matt Pocock 的 Skills

为工程类 skill 搭建其所依赖的每仓库配置：

- **Issue tracker**：issue 存放在哪里（默认 GitHub；开箱即用还支持本地 markdown）
- **分诊标签**：五个规范分诊角色所使用的字符串
- **领域文档**：`GLOSSARY.md` 和 ADR 存放在哪里，以及读取它们的使用规则

这是一个由提示驱动的 skill，而不是确定性脚本。先探索，展示所发现的内容，与用户确认，然后再写入。

## 流程

### 1. 探索

查看当前仓库，了解其起始状态。读取已有的内容；不要做假设：

- `git remote -v` 和 `.git/config`：这是一个 GitHub 仓库吗？是哪一个？
- 仓库根目录的 `AGENTS.md` 和 `CLAUDE.md`：是否存在其中之一？其中是否已有 `## Agent skills` 一节？
- 仓库根目录的 `GLOSSARY.md` 和 `GLOSSARY-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目录
- `docs/agents/`：此 skill 之前的产出是否已经存在？
- `.scratch/`：说明已在使用本地 markdown 的 issue tracker 约定
- `triage` skill 是否已安装？（同级存在 `triage` skill 文件夹，或 `triage` 在你的可用 skill 中。）这决定了 B 节是否需要运行。
- 单体仓库（monorepo）信号：`pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 字段，或拥有自身 `src/` 的已填充 `packages/*`。这些只出现在真正庞大的多包仓库中；它们的缺席即意味着 single-context（单一上下文），这几乎是所有仓库的情况。

### 2. 展示发现并询问

总结已有的和缺失的内容。然后按顺序处理各节。一节一个答案，再进入下一节。

每节都以推荐答案开头，让用户一个词即可接受。只有当选择确实存在分支时，才附上一行解释；如果探索已经确定了某节的答案，则跳过该节（未安装 `triage` 时跳过 B 节；没有单体仓库时跳过 C 节）。

**A 节：Issue tracker。**

> 说明：“issue tracker”是本仓库 issue 的存放位置。`to-tickets`、`triage`、`to-spec` 等 skill 会读写它。它们需要知道是调用 `gh issue create`、写入 `.scratch/` 下的 markdown 文件，还是遵循你描述的其他工作流。请选择你在本仓库中实际跟踪工作的地方。

默认立场：这些 skill 是为 GitHub 设计的。如果 `git remote` 指向 GitHub，就推荐它。如果 `git remote` 指向 GitLab（`gitlab.com` 或自托管主机），就推荐 GitLab。否则（或用户有偏好时），提供以下选项：

- **GitHub**：issue 存放在仓库的 GitHub Issues 中（使用 `gh` CLI）
- **GitLab**：issue 存放在仓库的 GitLab Issues 中（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **本地 markdown**：issue 以 `.scratch/<feature>/` 下的文件形式存在于本仓库中（适合单人项目或没有远程仓库的仓库）
- **其他**（Jira、Linear 等）：请用户用一段话描述工作流；该 skill 会将其记录为自由文本

将选择记录在 `docs/agents/issue-tracker.md` 中。GitHub 和 GitLab 模板包含一个"PR 作为请求入口（PRs as a request surface）"标志，默认**关闭**。保持关闭，并且不要主动提起：想让外部 PR 进入分诊队列的用户，日后可以在该文件中自行切换此标志。

**B 节：分诊标签词汇。** 如果 `triage` skill 未安装（探索已告知），则完全跳过本节，因为未安装的 skill 不需要标签。

如果已安装，只问一个问题：

> 你是否要保留默认的分诊标签？（推荐：**是**）

默认标签即五个规范角色，每个标签字符串与其名称相同：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。如果用户选择**是**，就原样写入。只有当用户选择**否**（通常是因为其 tracker 已使用其他名称，例如用 `bug:triage` 代表 `needs-triage`）时，才收集覆盖值，使 `triage` 应用已有标签，而不是创建重复的标签。

**C 节：领域文档。** 默认采用 **single-context**（仓库根目录下一个 `GLOSSARY.md` 加 `docs/adr/`）。这适合几乎所有仓库，无需询问即可写入。

只有在探索发现单体仓库信号时，才提供 **multi-context**（根目录下的 `GLOSSARY-MAP.md` 指向各上下文的 `GLOSSARY.md` 文件）。然后确认用户想要哪种布局。

### 3. 确认并编辑

向用户展示以下内容的草稿：

- 要添加到 `CLAUDE.md` / `AGENTS.md` 中某一个文件的 `## Agent skills` 块（选择规则见第 4 步）
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md` 和 `docs/agents/triage-labels.md` 的内容（最后一个仅在安装了 `triage` 时）

在写入前，让用户可以编辑。

### 4. 写入

**选择要编辑的文件：**

- 如果存在 `CLAUDE.md`，就编辑它。
- 否则，如果存在 `AGENTS.md`，就编辑它。
- 如果两者都不存在，询问用户要创建哪一个；不要替他们选择。

当 `CLAUDE.md` 已存在时，绝不创建 `AGENTS.md`（反之亦然）；始终编辑已经存在的那个。

如果所选文件中已存在 `## Agent skills` 块，就原地更新其内容，而不是追加一个重复的块。不要覆盖周围章节中用户的编辑。

该块的内容：

```markdown
## Agent skills

### Issue tracker

[一行概括 issue 的跟踪位置]。参见 `docs/agents/issue-tracker.md`。

### Triage labels

[一行概括标签词汇]。参见 `docs/agents/triage-labels.md`。

### Domain docs

[一行概括布局："single-context" 或 "multi-context"]。参见 `docs/agents/domain.md`。
```

只有在安装了 `triage` 且运行了 B 节时，才包含 `### Triage labels` 子块，并写入 `docs/agents/triage-labels.md`。否则两者都省略。

当 B 节在 GitHub 或 GitLab 上运行时，为 tracker 中缺失的每个已配置标签创建它（`gh label create` / `glab label create`）。

然后使用本 skill 文件夹中的种子模板作为起点，写入文档文件：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md)：本地 markdown issue tracker
- [triage-labels.md](./triage-labels.md)：标签映射（仅当安装了 `triage` 时）
- [domain.md](./domain.md)：领域文档的使用规则与布局

对于"其他"类 issue tracker，根据用户的描述，从零编写 `docs/agents/issue-tracker.md`。

### 5. 完成

告诉用户设置已完成，并说明哪些工程类 skill 现在将读取这些文件。提醒他们以后可以直接编辑 `docs/agents/*.md`；只有当他们想切换 issue tracker 或从头开始时，才需要重新运行本 skill。
