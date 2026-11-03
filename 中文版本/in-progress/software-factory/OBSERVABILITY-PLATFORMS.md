# 可观测性平台

> 调查于 2026-10，不保证是最新的。用它来了解情况，然后自己研究当前的选项：产品、价格、限制和测试版都变化很快。

本文帮助填充可观测性平台槽位，或决定刻意不设置它。各类型的划分依据是**人类需要看到一次运行内部的什么**：它的日志、它的智能体追踪（每次模型调用和工具调用都是一个 span），还是把这条追踪与用户系统其余部分连接起来。自托管与 SaaS 的区分横跨后三类。当一次运行需要对平台所看到的内容采取行动时，把该平台变成一个工单来源：由监控提交工单，运行再读取它。

## 执行器如何接入

每种类型都通过五种钩子之一接收数据。填充槽位时，把钩子的名称与产品一并写明。

- **Harness OTel**：智能体 harness 自己导出 OpenTelemetry。Claude Code 和 Claude Agent SDK 通过 `CLAUDE_CODE_ENABLE_TELEMETRY=1` 加上 `OTEL_*` 变量接入，提示词和工具输出需要主动开启；Codex CLI 则通过 `config.toml` 中的 `[otel]` 块接入。（[Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk/observability)、[Claude Code](https://code.claude.com/docs/en/monitoring-usage)、[Codex 配置](https://developers.openai.com/codex/config-advanced)）
- **平台推送**：模型平台替你发送追踪，例如 Claude Managed Agents 发送到在 Claude Console 中设置的 OTLP 目的地。（[Claude 文档](https://platform.claude.com/docs/en/manage-claude/opentelemetry/api)）
- **SDK 包装器**：在执行器的代码中调用一次，例如 LangSmith 的 `configure_claude_agent_sdk()`。
- **Hook 插件**：一个 Claude Code hook 在每次 Stop 时读取会话记录并发送出去，如 Langfuse 的 Claude Code 插件。
- **网关**：执行器的模型 base URL 指向一个日志代理。无需任何执行器代码，但它只能看到模型调用：harness 内部的工具调用仍然不可见。

OpenTelemetry 是通用的线路协议：harness OTel 和平台推送都可以落到任何 OTLP 后端。GenAI 语义约定（`invoke_agent`、`chat`、`execute_tool` 等 span）仍在定型，因此预计 span 名称还会变动。（[OTel GenAI 智能体 span](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans)）

## 类型 1：无（执行器或编排器产品已经足够）

**它是什么**：人类在执行器或编排器已经展示它的地方阅读每次运行：CI 运行页面、沙箱仪表盘，或保存为运行产物的智能体对话记录。无需构建任何钩子，自托管程度与执行器相同，成本也随之捆绑。

**工厂何时选它**：每天运行次数少，有一个人在盯着，问题是"它失败了吗？它打印了什么？"。大多数工厂从这里起步，当它们需要跨运行搜索、每次运行的 token 或成本汇总，或保留时长超过执行器自身的保留期时，再从这里长出去。

**入门起点**：[GitHub Actions 运行日志](https://docs.github.com/en/organizations/managing-organization-settings/configuring-the-retention-period-for-github-actions-artifacts-and-logs-in-your-organization)、[E2B 沙箱日志与指标](https://e2b.dev/docs)、[Daytona 沙箱遥测](https://www.daytona.io/docs/en/observability/otel-collection/)、[OpenAI Agents SDK 追踪](https://openai.github.io/openai-agents-python/tracing/)。沙箱产品通常也会通过 OTLP 转发同样的数据，这正是通往类型 2 的出路。

**待核实**：每个执行器产品的保留天数；有些沙箱保留得很少（截至 2026-10，Daytona 为 3 天）。

## 类型 2：LLM 与智能体追踪平台

**它是什么**：一个围绕智能体追踪构建的后端：每次运行呈现为一棵由模型调用和工具调用组成的树，附带 token 成本、提示词和会话，通常上面还有评估和数据集。

**工厂何时选它**：人类想跨多次运行追问"智能体为什么那样做？"；复盘运行或人类要对比多次运行；token 开销需要按运行汇总。自托管一个开源平台可以把对话记录留在内部。

**这一类的特征**：接收 harness OTel、SDK 包装器或 hook 插件，通常也接收平台推送。按量计费，而智能体运行的 span 很密集（每个工具调用一个 span），因此应按运行而非按请求做预算。

**入门起点**：[Langfuse](https://langfuse.com/pricing)和 [Arize Phoenix](https://phoenix.arize.com)（开源，可自托管）、[LangSmith](https://www.langchain.com/pricing-langsmith)、[Braintrust](https://www.braintrust.dev/pricing)。

**待核实**：免费层限制、计费单位（追踪、span、单位或 GB；Braintrust 于 2026-03 改为按 GB 计费）、哪个套餐解锁自托管，以及当前的归属。

## 类型 3：通用 APM 与日志后端

**它是什么**：用户已有的可观测性栈（日志、指标，以及每个服务的分布式追踪），再加上智能体或 LLM 视图。

**工厂何时选它**：团队已经为它付费；运行需要与应用自身的追踪连接（Agent SDK 会传播 `TRACEPARENT`，因此运行会嵌套在调用方的追踪之内）；或者某个监控工单来源已经从它读取数据。

**这一类的特征**：harness OTel 直接发往供应商的 OTLP 端点。按 GB、事件或主机计费，因此在已有账单上，工厂的用量只是小数目；而在新账单上，则可能是个意外。

**入门起点**：[Datadog Agent Observability](https://www.datadoghq.com/product/llm-observability/)、[Grafana Cloud](https://grafana.com/pricing/)、[Honeycomb](https://www.honeycomb.io/pricing)、[SigNoz](https://signoz.io/pricing/)（开源）。

**待核实**：智能体视图处于正式版还是预览版，哪些 harness 有设置指南，以及免费层的数据量。

## 类型 4：带请求日志的 LLM 网关

**它是什么**：位于执行器与模型提供商之间的代理，记录每一次请求和响应，并同时提供路由、密钥、预算和缓存功能。

**工厂何时选它**：用户想要每次运行的开销上限，或为众多执行器统一管理一个密钥库，而日志功能随之附带；或者 harness 本身没有导出功能。它只能看到模型调用，因此工具调用需要与类型 2 或 3 搭配使用。

**入门起点**：[LiteLLM Proxy](https://docs.litellm.ai/docs/proxy/logging)（开源，可将日志转发到 Langfuse 或 OTel）、[Portkey](https://portkey.ai/pricing)。

**待核实**：SaaS 的按请求定价，以及该产品是否仍在积极开发（截至 2026-10，Helicone 在被收购后进入了维护模式）。

## 进一步研究

用决定此槽位的问题，逐一核对每个候选项：

1. **执行器或编排器是否已经展示得足够？** 把人类需要的（跨运行搜索、每次运行成本、保留期）与运行页面或沙箱仪表盘所提供的对比。若答案为"是"，那就意味着刻意不设置。
2. **智能体 harness 如何导出追踪？** 找出 harness 支持五种钩子中的哪几种，再看产品接受哪几种。确认工具调用是以 span 的形式到达的，并确认提示词和工具输出是否需要主动开启。
3. **能否自托管？** 许可证、哪个套餐允许自托管，以及它运行在什么上。当对话记录必须留在内部时，这一点是决定性的。
4. **成本形态是什么？** 计费单位、免费层，以及按"每个工具调用一个 span、乘以每日运行次数"估算的每次运行成本。
5. **保留期多长？** 每个套餐保留多少天，对照运行出错时人类回溯的时间跨度。

**答案在哪里**：供应商的定价页面（单位、套餐、保留期）；针对具体 harness 的供应商集成文档；harness 自己的监控文档（它导出什么，哪些开关处于测试版）；OpenTelemetry GenAI 语义约定；产品仓库中的许可证和发布活跃度；供应商的更新日志或博客（归属变化）。

**最先过时的内容**：免费层限制和价格；测试版和预览版开关（Claude Code 追踪导出、Console 平台推送、供应商的智能体视图）；归属和维护状态；计费单位；保留天数；GenAI span 名称。
