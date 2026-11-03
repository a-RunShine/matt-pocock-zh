# 执行器

> 调查于 2026-10，不保证是最新的。用它来了解情况，然后自己研究当前的选项：产品、价格、限制和测试版都变化很快。

执行器是**一次性的**：每次运行都在一台全新的机器上启动，并且不留下任何东西。有五种类型可以填充这个槽位。它们的区别主要在于：由谁拥有智能体循环，以及由谁拥有机器。

| 类型 | 智能体循环 | 机器 | 同时填充 |
| --- | --- | --- | --- |
| CI 执行器 | 你的，运行在 CI 任务之内 | CI 供应商的，或你自己的 | 编排器、可观测性平台 |
| MicroVM API | 你的，在编排器中或执行器上 | 提供商的 | 无 |
| 打包的智能体平台 | 供应商的 | 供应商的 | 编排器、可观测性平台的一部分 |
| 自带 worker | 供应商的 | 你的 | 编排器、可观测性平台的一部分 |
| 自有 VPS 或容器 | 你的 | 你的 | 无 |

执行器的选择是按运行来定的：用便宜的 CI 执行器跑评审运行，用 microVM 跑实现者运行，是一种正常的设计。

## CI 执行器

每个 CI 任务都有一台全新的虚拟机或 Pod，由 git 托管平台自己的工作流引擎启动；智能体 CLI 只是任务中的一步。编排器通过工作流触发器（工单、PR、定时任务、手动派发）启动一次运行，并利用并发组确保两次运行不会同时作用于同一张工单。托管执行器在设计上就是一次性的；自托管执行器则通过临时模式达到同样效果，即每个任务一个 Pod，用完即删。费用按分钟计。

**选择它的时机**：git 托管平台是 GitHub 或 GitLab，且每个触发器都是 git 托管平台事件或时钟时：工作流文件即编排器，运行页面即可观测性平台，因此一个产品同时填充三个槽位。

入门起点：
- [GitHub Actions](https://docs.github.com/en/actions/reference/limits)：全 GitHub 工厂的默认选择；[定价](https://docs.github.com/en/billing/reference/actions-runner-pricing)。
- [Claude Code GitHub Action](https://code.claude.com/docs/en/github-actions)：把 Claude Code 作为工作流的一步。
- [GitLab 托管执行器](https://docs.gitlab.com/ci/runners/hosted_runners/linux/)：每个任务一台临时虚拟机。
- [Actions Runner Controller](https://docs.github.com/en/actions/concepts/runners/actions-runner-controller)：自托管，在用户自己的 Kubernetes 上每个任务一个临时 Pod。

## MicroVM API

一次 SDK 调用大约在一秒内创建一台隔离的 microVM（供应商称之为"沙箱"）；编排器向其中执行命令，或在其中启动智能体 CLI。费用按 vCPU 和内存的秒数计。编排器为每次运行创建一台，结束时销毁，并设置超时作为兜底。提供商还提供持久化功能（暂停/恢复、快照、磁盘）；工厂把它当作缓存使用，并把运行之间的记忆保存在工单跟踪器、git 托管平台和编排器中。

**选择它的时机**：工厂有自己的编排器（一台服务器、一个队列），并且希望大量短时、并行的运行，而又不想管理机器。比较时看最长运行时长、并发上限，以及等待模型响应的时间是否计费：截至 2026-10，Vercel 只对活跃 CPU 计费，因此在那里等待模型的时间几乎免费。

入门起点：[E2B](https://e2b.dev/pricing)、[Daytona](https://www.daytona.io/pricing)、[Modal Sandboxes](https://modal.com/docs/guide/sandboxes)、[Vercel Sandbox](https://vercel.com/docs/vercel-sandbox/pricing)。

## 打包的智能体平台

一个托管的编码智能体，自带执行器：供应商为每次运行配备一台全新的虚拟机或容器，在其中运行自己的智能体循环，并推送一个分支或 PR。只有分支会保留下来。运行可以由 git 托管平台或工单跟踪器中的 @提及或分配、一条聊天消息、一个定时任务或一次 HTTP 调用启动，因此该平台填充了编排器的大部分职能；其对话记录视图则填充可观测性平台。费用计入席位或订阅，或按次收费。

**选择它的时机**：用户希望运动部件最少，并且对该供应商的智能体感到满意。确认它的触发器覆盖用户的工单跟踪器。

入门起点：
- [Claude Code 云端](https://code.claude.com/docs/en/claude-code-on-the-web)，配合用于 cron、API 和 GitHub 事件触发的[定时任务](https://code.claude.com/docs/en/routines)。
- [Claude Managed Agents](https://platform.claude.com/docs/en/managed-agents/overview)：以 API 为先；针对某个环境创建运行，并流式接收事件。
- [Codex 云端](https://developers.openai.com/codex/cloud)：每个任务一个容器。
- [Copilot 编码智能体](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)：把 issue 分配给 Copilot；其执行器是一台 GitHub Actions 执行器。

## 自带 worker

打包平台保留其智能体循环和运行队列，但工具调用在用户托管的 worker 上执行。worker 主动向供应商轮询，认领一次运行，执行它，然后退出：形态与自托管 CI 执行器相同。一次性由用户负责：把 worker 运行在 Kubernetes 或 microVM API 之下，使每次运行都得到一块全新的磁盘。费用是供应商的席位或用量加上用户自己的机器。

**选择它的时机**：用户想要一个打包的智能体，但运行必须能访问私有网络、把数据保留在用户自己的机器上，或使用定制硬件。

入门起点：[Claude Code 自托管环境](https://code.claude.com/docs/en/self-hosted-environments)、[Cursor 自托管池](https://cursor.com/docs/cloud-agent/self-hosted-pool)、[基于 ARC 的 Copilot 编码智能体](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/customize-the-agent-environment)。

## 自有 VPS 或容器

用户租用或自己运行的一台机器，每次运行配一个全新的容器（或机器）：机器可能存活数月，容器只存活一次运行。最长运行时长取决于编排器设定的截止时间。一次性由 `docker run --rm`、设置了 `ttlSecondsAfterFinished: 0` 的 Kubernetes Job，或运行结束时销毁的机器来保证；所有缓存都放在下一次运行视为可选的路径上。费用是固定的月费，或按运行秒数计。

**选择它的时机**：运行时间长、稳定或负载重，每小时成本占主导，或服务器上已经托管着编排器。

入门起点：[Fly Machines](https://docs.fly.io/machines/overview)（[定价](https://docs.fly.io/about/pricing)）、[Hetzner Cloud](https://www.hetzner.com/cloud/) 加 Docker、[Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)。

## 进一步研究

### 决定槽位的问题

结合工厂的运行情况，用以下问题核对每个候选项：

1. **编排器如何启动一次运行？** 是工作流触发器、SDK 调用、@提及、HTTP 调用，还是由 worker 认领的供应商队列？这是否符合设计中已经指明的编排器？
2. **最长运行时长和并发上限是多少？** 找出每个套餐等级的默认超时和上限，以及达到上限时会发生什么。拿它们去对照设计中最长的一次运行和最繁忙的突发。
3. **成本的形态是什么？** 按分钟、按 vCPU 和内存的秒数、仅按活跃 CPU、按运行、按席位，还是固定月费？等待模型的时间是否计费？模型 token 是包含在价格里，还是额外收费？
4. **如何实现一次性？** 默认全新、一个临时标志，还是编排器自己的拆除流程？存在哪些持久化功能，设计能否只把它们用作缓存？
5. **一次运行能访问什么？** 私有网络访问、出站防火墙或白名单、密钥如何送达执行器，以及还有谁能读取它们。
6. **它还填充了哪些其他槽位？** 把它读取的触发器算作编排器覆盖，把它的运行页面或对话记录算作可观测性平台覆盖。

### 答案在哪里

- 供应商的**限制或配额页面**和**定价页面**，优先于产品首页。
- 创建调用的 **SDK 或 API 参考**：它的超时、生命周期和网络参数。
- 防火墙、白名单和密钥处理的**安全或网络文档**。
- 测试版、预览版和正式版状态，以及套餐限制（Team、Enterprise）的**更新日志或发布说明**。
- 对于 CI 执行器，查看 git 托管平台的**计费文档**。

### 最先过时的内容

- **价格与免费额度。** 截至 2026-10，GitHub 曾宣布对自托管执行器按分钟收费，之后又推迟了。
- **测试版、预览版和抢先体验状态**，以及哪些套餐解锁某项功能。截至 2026-10，Claude Managed Agents 和 Claude Code 自托管环境都还处于测试版。
- **各等级的默认超时和最长运行时长。**
- **打包平台上的触发器集成**：哪些工单跟踪器和聊天工具能启动运行。
- **启动时间**，这是供应商自己的说法；如果它很重要，请自行测量。

上面的类型特征（由谁拥有循环、由谁拥有机器、填充哪些槽位）变化缓慢；请以它们为准，而不是这里的任何数字。
