# Git 托管平台

> 调查于 2026-10，不保证是最新的。用它来了解情况，然后自己研究当前的选项：产品、价格、限制和测试版都变化很快。

## 类型

### 一体化平台

与工单跟踪器、充当编排器的 CI 系统以及托管执行器打包在一起的 git 托管平台，它们共用同一条事件流和同一套权限模型。一个产品同时填充 git 托管平台、工单跟踪器、编排器和执行器四个槽位，它的 CI 运行页面通常也覆盖了可观测性平台。每个 PR、评审、标签和检查事件既是 webhook 又是原生触发器，因此这一类拥有最丰富的触发器目录。

**选择它的时机**：工厂刚起步、代码已经在那里，或用户希望只有一份账单、一个登录入口。这就是 [SKILL.md](SKILL.md) 中的"全部用 GitHub"设计。这些供应商也自带智能体，它们要么与用户的运行相互竞争，要么作为其中之一接入。

- [GitHub](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api)：默认选项；Issues、Actions、Apps，以及最大的集成生态。
- [GitLab](https://about.gitlab.com/pricing/)：issue、合并请求、CI/CD 和执行器集于一个产品，可选 SaaS 或自管理。

### 套件型 git 托管平台

作为更大套件中一个模块出售的 git 托管平台，其工单跟踪器是一个同级产品（Jira、Azure Boards），两者通过链接和 webhook 相连。跟踪器事件通过第二条流到达，因此编排器需要合并两个事件来源。

**选择它的时机**：组织已经在使用该套件，且团队成员都在 Jira 或 Azure Boards 中工作。工厂继承该跟踪器作为其人机界面。

- [Bitbucket Cloud](https://support.atlassian.com/bitbucket-cloud/docs/api-request-limits/)：Atlassian 的 git 托管平台，与 Jira 和 Bitbucket Pipelines 搭配。
- [Azure DevOps（Azure Repos）](https://learn.microsoft.com/en-us/azure/devops/integrate/concepts/rate-limits)：Repos、Boards、Pipelines 和 Entra 身份集于一个组织，因此它能填充全部四个槽位。
- [AWS CodeCommit](https://aws.amazon.com/blogs/devops/aws-codecommit-returns-to-general-availability/)：带 IAM 身份的纯 git 托管平台；需与外部跟踪器和 CI 搭配使用。

### 自托管 git 托管平台

用户在自己基础设施上运行的 git 托管平台，通常与编排器和执行器位于同一网络。由运营者设定速率限制，因此上限取决于硬件。用户要为它所填充的每个槽位负责升级、备份和可用性。

**选择它的时机**：代码必须留在内网或物理隔离环境中，用户希望零席位成本，或 SaaS API 配额会限制一个繁忙的工厂。Forgejo 和 Gitea 适合小团队，附带 issue 以及兼容 GitHub Actions 的 CI；GitLab 自管理版和 GitHub Enterprise Server 适合组织，并保留它们的 App 和服务账号。

- [Forgejo](https://forgejo.org/2026-10-release-v17-0/)：社区治理，轻量，附带 Forgejo Actions。
- [Gitea](https://about.gitea.com/)：轻量，附带 Gitea Actions；也提供托管版。
- [GitLab 自管理版](https://about.gitlab.com/install/)和 [GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@latest)：在用户自己的基础设施上运行的完整平台。

### 评审优先与去中心化的 git 托管平台

评审模型偏离"分支加 PR"形态的 git 托管平台：每次提交一个补丁集并带有投票标签，或由用户运行的节点联合组成的代码仓库。大多数工厂工具都假定使用 PR，因此预计需要自己编写更多胶水代码。在 Gerrit 中，自动检查运行由一个机器人账号投 `Verified`，而人类投 `Code-Review`。

**选择它的时机**：用户的团队本来就以这种方式评审，或更看重联合而非生态。

- [Gerrit](https://www.gerritcodereview.com/)：以补丁集评审加标签投票；Android 和 Chromium 采用的模式。
- [Tangled](https://blog.tangled.org/ci/)：基于 AT Protocol 的 git 托管，支持堆叠 PR，并自带 CI 执行器。

### 智能体原生的 git 托管平台

围绕智能体作为主要作者而构建的新型 git 托管平台：提交吞吐量高，用服务端读取取代克隆，并按智能体归属记录。整个类型都还很早期（截至 2026-10），因此门禁和速率限制可能未公开：请询问供应商。

**选择它的时机**：工厂对一个大型仓库同时运行大量运行，而克隆时间或 API 限制占主导。可以在某个单一仓库的镜像上试点其中一个，同时保留 GitHub 作为后备。

- [Cursor Origin](https://cursor.com/origin)：来自 Graphite 团队，支持与 GitHub 同步，并提供已签名的 PR、评审和推送 webhook。
- [GitLab 下一代 SCM](https://about.gitlab.com/blog/gitlab-next-gen-scm/)：重建的 GitLab 后端，提供无需克隆的智能体 API。

### 运行用的 git 存储

无界面、以 API 为先的 git 仓库，成千上万地创建：有分支、提交和 diff，但没有 PR、评审或门禁。它们只填充槽位的一半，每次运行都会签发短期的按仓库令牌。

**选择它的时机**：运行需要廉价的每次运行临时仓库或分叉（每张工单一个分叉、智能体的工作状态），而 PR 最终仍落在上面某种完整的 git 托管平台上。

- [Cloudflare Artifacts](https://www.cloudflare.com/product/artifacts/)：Workers 上兼容 git 的存储；为每个任务分叉一个基线。
- [Pierre code.storage](https://code.storage/docs)：可贴牌的 git API，支持临时分支。

## 进一步研究

用以下问题逐一核对每个候选项：

1. **触发器**：哪些事件（PR 打开、推送、提交评审、添加标签、检查完成）会以 webhook 的形式到达编排器？这些投递是否带签名？
2. **身份**：运行能否以专用的机器人或 App 身份行事？这样能保持运行可归属，允许自动评审运行批准别的身份提交的 PR，并决定运行自己的推送是否会触发下一次运行。
3. **门禁**：在用户的套餐和仓库可见性下，是否提供必需检查、必需审批和分支保护？机器人能否被加入绕过名单？
4. **速率限制**：每个执行器上的每次运行共享多少 API 配额，按什么单位计算（安装、令牌、用户、工作区），又如何随规模变化？
5. **填充的槽位**：同一产品覆盖了工单跟踪器、编排器、执行器和可观测性平台中的哪几个？

答案在一手来源中查找：REST API 与 webhook 参考、速率限制页面、定价与套餐对比页面、访问令牌或 App 文档，以及更新日志或发布说明。

最快过时的内容：测试版和预览版状态（整个智能体原生和运行用 git 存储类型）、速率限制数字、哪个套餐解锁门禁，以及收购、关停和重新开放之后的可用性。例如，截至 2026-10，AWS CodeCommit 已重新向新客户开放，而 Bitbucket Data Center 只以与 Cloud 搭配的混合许可证形式出售。

## 持久的陷阱

在设计依赖之前，先核实每一条是否仍然成立。

- **GitHub 的 `GITHUB_TOKEN` 会切断触发链**：由内置 Actions 令牌引起的事件不会启动新的工作流运行（`workflow_dispatch` 和 `repository_dispatch` 除外），因此用它推送的运行会悄无声息地阻断下一次运行。从第一天起就给运行一个 GitHub App 身份。
- **门禁通常位于付费套餐之后**：截至 2026-10，私有仓库上的 GitHub 规则集需要 Pro、Team 或 Enterprise；GitLab 的审批规则需要 Premium；强制执行的 Bitbucket 合并检查需要 Premium。
- **速率限制按身份计算，而机器人的类型会改变它**：截至 2026-10，GitHub App 安装每小时可获得 5,000 次请求，而 `GITHUB_TOKEN` 只有 1,000 次；Bitbucket 用户令牌保持基础速率，而访问令牌则会随之扩展；Azure DevOps 会按机器人的访问级别提高其配额。
- **套件型跟踪器意味着两条事件流**：编排器需要自己合并 git 托管平台和工单跟踪器的事件。
