# 工程（Engineering）

我日常用于代码工作的 skill。

## 用户调用

只有当你输入它们时才会触发（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[ask-matt](./ask-matt/SKILL.md)**：询问哪个 skill 或流程适合你的情况。这是本仓库用户调用型 skill 的路由器。
- **[grill-with-docs](./grill-with-docs/SKILL.md)**：拷问会话，同时构建项目的领域模型，在行内锐化术语并更新 `GLOSSARY.md` 和 ADR。
- **[triage](./triage/SKILL.md)**：通过分诊角色的状态机推进 issue。
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**：扫描代码库以发现深化机会，以可视化的 HTML 报告呈现，然后针对你所选的一项进行拷问。
- **[setup-matt-pocock-skills](./setup-matt-pocock-skills/SKILL.md)**：为工程类 skill 配置本仓库（issue tracker、分诊标签、领域文档布局）。每个仓库运行一次。
- **[to-spec](./to-spec/SKILL.md)**：把当前对话转化为规格说明，并发布到 issue tracker。
- **[to-tickets](./to-tickets/SKILL.md)**：把任何计划、规格或对话拆分为一组示踪弹式工单，每张声明其阻塞边，既可以是本地文件中的文本，也可以是真实 tracker 上的原生阻塞链接。
- **[implement](./implement/SKILL.md)**：构建规格或一组工单所描述的工作，在预先约定的接缝处驱动 `/tdd`，并在提交前以 `/code-review` 收尾。
- **[implement-spec](./implement-spec/SKILL.md)**：在一条集成分支上实现整份规格。把工单当作任务图处理，在就绪的前沿上运行实现者子智能体以实现最大并发，然后以 `/code-review` 收尾。
- **[wayfinder](./wayfinder/SKILL.md)**：把超出单个智能体会话容量的大型工作规划为 issue tracker 上的一张共享决策工单地图，并逐一解决，直到通往目的地的路径清晰。
- **[retro](./retro/SKILL.md)**：会话结束后，建议改进编码智能体的环境（导航、自动化检查、编码规范、引导文件、工具），按严重程度从高到低排列。

## 模型调用

模型或用户都可以触发（带有丰富的触发措辞，以便模型主动使用它们）。

- **[prototype](./prototype/SKILL.md)**：构建一次性原型来回答设计问题：状态/逻辑用一个可分享的 HTML 文件，或用若干可切换的 UI 变体。

- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**：针对疑难 bug 和性能回归的诊断纪律：先构建一个在此 bug 上变红的反馈回路 → 最小化 → 提出假设 → 插桩 → 修复 → 回归测试。
- **[research](./research/SKILL.md)**：依据高可信的一手来源调查问题，并把带引用的结论保存为仓库中的 Markdown 文件，以后台智能体运行。
- **[tdd](./tdd/SKILL.md)**：测试驱动开发，采用红-绿-重构循环。一次一个纵向切片地构建功能或修复 bug。
- **[domain-modeling](./domain-modeling/SKILL.md)**：主动构建并打磨项目的领域模型：质疑术语、用场景进行压力测试，并在行内更新 `GLOSSARY.md` 和 ADR。
- **[codebase-design](./codebase-design/SKILL.md)**：设计深层模块的共享纪律与词汇：小接口、干净的接缝，并能通过接口进行测试。
- **[code-review](./code-review/SKILL.md)**：沿两个维度评审自某个固定基准点以来的 diff：**规范**（是否遵循仓库的编码规范，外加 Fowler 坏味道基线？）和**规格**（是否忠实实现了源 issue/规格？），以并行子智能体运行。
- **[pr](./pr/SKILL.md)**：PR 正文应有的形态：用最小的可视化形式展示变更，给出它有效的前后证据，并判断它是单向门还是双向门（外加影响半径）。
- **[wizard](./wizard/SKILL.md)**：生成一个交互式 bash 向导，带领人类完成只有他们才能执行的步骤：配置基础设施、设置凭证或 CI 密钥、操作不熟悉的第三方控制台，或执行一次性迁移或切换。
