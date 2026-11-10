# Matt Pocock 的 `CODING_STANDARDS.md` 与「给 agent 的编码规范」调研

- 调研日期：2026-11-10
- 调研范围：`github.com/mattpocock/skills`（上游 `main`）、`github.com/mattpocock` 下其他公开仓库、`aihero.dev`、`dictionary-of-ai-coding`、Matt 的 X / LinkedIn 公开帖
- 标注约定：**【原文】**＝来源里明确写了；**【推断】**＝我基于多条原文的归纳，来源没有直接这样说

> 说明：本仓库 `英文版本/` 是上游 `main` @ `4ae2317` 的快照。本次同时核对了上游当前 `main`（含 `docs/` 站点的 prose 版本）与本地快照，两者在被引用的这些 skill 上一致。凡引用上游当前 `main` 的路径，链接都指向 `blob/main`。

---

## 摘要：5 条核心发现

1. **【原文】他没在 `mattpocock/skills` 仓库里放 `CODING_STANDARDS.md`；他放的是「要求你的仓库里有这个文件」的约定。** 上游 `main` 的完整文件树里没有这个文件名（`find` 全树只命中 `retro` / `code-review` 的正文引用）。这个文件是**给 reviewer agent 读的**，不是给 implementer 读的。
2. **【原文】三层分工是明确的：`AGENTS.md`/`CLAUDE.md`（每次会话都加载，只放 navigation pointer）→ `CODING_STANDARDS.md`（review 时才读）→ 自动化检查（lint/type/test/pre-commit/CI）。** `retro` 还有一条硬规则：`AGENTS.md` 太胖时，把里面的 steering **搬出去**，搬到 standards 或 checks，而不是继续加。
3. **【原文】他明确主张「能用确定性检查表达的规则就不要写进文档」，而且用的是 "full stop"、"Default to building the check over writing the rule" 这种措辞。** 机械违规（banned API、import shape、file-location rule）一律做成检查；`CODING_STANDARDS.md` 只留给真正的 judgement call（跨文件一致性、"matches the surrounding style"）。
4. **【原文】深模块在他这里有精确词汇表（module / interface / depth / seam / adapter / leverage / locality），并且**明确拒绝**把深度定义成「实现行数 ÷ 接口行数」**（Ousterhout 的原始定义）；深度 = 接口上的 leverage。可机械化的只有**边界**（entry point 之外不可 import），不可机械化的是**深度本身与 seam 位置**。他用 `in-progress/setup-ts-deep-modules` + dependency-cruiser 四条 `error` 规则把边界变成 CI 会红的检查。
5. **【原文＋推断】「vibe coding 用的规范」本质上不是一份更长的文档，而是一套**让 review 可自动化的检查 + 一份只写判断题的 standards 文件**。** Matt 自己的定位是「not vibe coding」（README 第一句），而 `dictionary-of-ai-coding` 对 vibe coding 的定义是「不接受人工 review」——一旦不接受人工 review，automated checks 与 automated review 就是唯一的 gate。所以给 vibe coding 写规范，重点必然压在「能自动判定的」那一侧。

---

## 1. 他到底有没有做 `CODING_STANDARDS.md`？

### 1.1 `mattpocock/skills` 仓库里没有这个文件【原文】

核对方式：拉取 `https://api.github.com/repos/mattpocock/skills/git/trees/main?recursive=1`（282 个条目），全树不存在名为 `CODING_STANDARDS.md` / `coding-standards.md` 的文件；`CODING_STANDARDS` 只作为**正文里的字符串**出现在三个文件：

| 文件 | 出现位置 |
| --- | --- |
| `skills/engineering/code-review/SKILL.md:36` | "When `CODING_STANDARDS.md` or `CONTRIBUTING.md` exists, it must be on the list." |
| `skills/engineering/retro/SKILL.md:19,42` | "Reserve `CODING_STANDARDS.md` for genuine **judgement calls**…" / "`CODING_STANDARDS.md`: this file is read during review, not implementation." |
| `skills/in-progress/chief-of-staff/SKILL.md:62` | "CODING_STANDARDS.md files which let code reviewers enforce best practices" |

`docs/engineering/retro.md` 里有一句直接回答「这个文件从哪来」：

> **【原文】** "No skill ships the file. The first time a session finds a judgement-call rule for the reviewer, `retro` proposes to create it. After you accept, `code-review` reads it. Any other standards doc you already keep, such as `CONTRIBUTING.md`, works the same way."
> — <https://aihero.dev/skills-retro>

所以答案是：**有，但不是他仓库里的产物，而是这套 skill 假设的「你仓库里的一个文件名」。** 他自己在个人仓库里确实在用这个约定（见 1.3）。

### 1.2 谁读它：reviewer，不是 implementer【原文】

这是他这套体系里最反直觉、也最一致的一条。

> **【原文】** "Remember that all work goes through two stages: implementation and review. The implementation agent has the most **context pressure**. They are responsible for exploration, writing code, and debugging failures. The review agent has the least context pressure - it receives a diff, so no exploration needed. … This means that the review agent should be responsible for imposing coding standards, not the implementation agent."
> — `skills/engineering/retro/SKILL.md` §Implementation vs Review（<https://github.com/mattpocock/skills/blob/main/skills/engineering/retro/SKILL.md>）

> **【原文】** "The leading idea is that standards belong to the **reviewer**, not the implementer. … So a new rule goes where there is room to apply it, which is review. It never goes in AGENTS.md, which loads into every session's context window whether it is relevant or not."
> — <https://aihero.dev/skills-retro>

配上 `code-review` 的两轴结构，规范的作用就很清楚了：**Standards 轴**回答"built right?"，**Spec 轴**回答"the right thing?"，两轴故意不合并、不重排。

> **【原文】** "**Standards**: does the code conform to this repo's documented coding standards? **Spec**: does the code faithfully implement the originating issue / spec?" / "Reporting them separately stops one axis from masking the other."
> — `skills/engineering/code-review/SKILL.md`

Standards 轴的输入有三层（这是 `code-review` 第 3 步的原文顺序）：

1. 仓库里**所有**记录「代码该怎么写」的文件；`CODING_STANDARDS.md` 与 `CONTRIBUTING.md` 存在时**必须在列表里**。
2. 之上的 **smell baseline**：Fowler《Refactoring》第 3 章的 12 个 code smell，仓库什么都没写时也生效。
3. 两条约束把 baseline 钉死：**"The repo overrides."**（仓库写了的标准永远赢）与 **"Always a judgement call."**（baseline 只能是"possible Feature Envy"这种标注，不能算 hard violation），以及 **"skip anything tooling already enforces"**。

### 1.3 他真实在用的 `CODING_STANDARDS.md`【原文】

三个公开实例，恰好对应三种规模：

| 仓库 / 路径 | 体量 | 特征 |
| --- | --- | --- |
| `mattpocock/course-video-manager/CODING_STANDARDS.md` | ~21.9 KB，8 个一级节 | 生产级实例：Effect 用法、`any` 泄漏、Draft guard、DB client 工厂、sidecar 后台任务、action menu、duration formatter、deep modules、testing |
| `mattpocock/sandcastle/.sandcastle/CODING_STANDARDS.md` | ~15.9 KB | 同上的"agent 版"，末尾是 **The lint ratchet**（baseline 只许缩不许涨、禁止 disable comment、new-file budget） |
| `mattpocock/mise-en-place/.sandcastle/CODING_STANDARDS.md` | 700 B | **空模板**，只有 `## Style` / `## Testing` / `## Architecture` 三个待填节 |

`course-video-manager/CODING_STANDARDS.md` 的开头定义了这份文件的用途：

> **【原文】** "The rules a human or an agent holds in their head while writing and reviewing code here. Each rule's essence is here; the longer reasoning lives in the doc it links."
> — <https://github.com/mattpocock/course-video-manager/blob/main/CODING_STANDARDS.md>

它的体例非常值得抄：**每条规则 = 一句祈使句标题 + 为什么（真实事故编号）+ 谁来强制（哪个 rule / 哪个 `scripts/check-*.ts`）**。三个例子：

> **【原文】** "Enforced by type-aware oxlint (`typescript/only-throw-error`, an error in `.oxlintrc.json` that allows `data()`)."
> **【原文】** "An `any` switches the type checker off for every value that flows through it. … The cost, from this repo: `makeLoader` took `ManagedRuntime<any, any>` with an unconstrained `R`, so a route asking for an unprovided service type-checked across all 111 route modules and the Animatic page 500ed on every load."
> **【原文】** "**A NEW NOUN INHERITS THE GUARD FROM WHAT IT HANGS OFF**… The ~250 stranded writes that taught this: [`docs/DRAFT_GUARD.md`](./docs/DRAFT_GUARD.md)."

模板里的那句注释更是把设计意图写在脸上：

> **【原文】** "The reviewer agent loads it during code review via @.sandcastle/CODING_STANDARDS.md so these standards are enforced during review **without costing tokens during implementation**."
> — `sandcastle/src/templates/sequential-reviewer/CODING_STANDARDS.md` 与 `parallel-planner-with-review/CODING_STANDARDS.md`（两处字节相同）

并且 Sandcastle 的 review prompt 第 5 步就是去读它：

> **【原文】** "5. **Apply project standards**: Follow the coding standards defined in @.sandcastle/CODING_STANDARDS.md"
> — <https://github.com/mattpocock/sandcastle/blob/main/src/templates/sequential-reviewer/review-prompt.md>

### 1.4 这份文件怎么长出来：`/retro` 闭环【原文】

> **【原文】** "My answer is that if you're using it right, it should only be empty for about 5 minutes. Every meaningful thing your agent gets wrong should be noted into CODING_STANDARDS. - Forget to implement dark mode? - Forgot a validation rule? - Used the wrong framework primitive? Use /retro to fill it up, or modify it yourself."
> — Matt Pocock, LinkedIn（<https://www.linkedin.com/posts/mapocock_tons-of-folks-ask-me-how-do-i-create-a-codingstandardsmd-activity-7515667908497424384-iC6v>）

> **【原文】** "1. Notice the agent is doing something bad 2. Write it in CODING_STANDARDS.md (root of the repo) 3. /code-review picks it up and enforces it at review time. I have hundreds of lines in my CODING_STANDARDS.md files"
> — Matt Pocock, X, 2026-08-14（<https://x.com/mattpocockuk/status/2088256432265167185>）

> **【原文】** "echo \"Tautological tests considered harmful.\" >> CODING_STANDARDS.md. From then on, /code-review will pick this up"
> — Matt Pocock, X, 2026-08-27（<https://x.com/mattpocockuk/status/2093068185830347088>）

还有一个未落地的想法（说明他把这份文件也当"可以批量消费的输入"）：

> **【原文】** "Thinking about making a skill called /fix-one-thing: \"Read CODING_STANDARDS.md. Find a violation in the codebase, and fix it. Make the PR small and easy to review…\""
> — Matt Pocock, X, 2026-09-25（<https://x.com/mattpocockuk/status/2103506709633466648>）。注意这条帖子的回复里有反对意见："The agent will just invent violations for you."——**该 skill 目前不在仓库里**，属未实现构想。

### 1.5 小结

- **【原文】** 文件存在，是**约定 + 他自己的实践**，不是 skill 包自带的资产。
- **【原文】** 读者是 reviewer（`/code-review` 的 Standards 轴），不是 implementer。
- **【原文】** 内容是「实现者可能不知道、但 review 时看得出来」的判断类规则，且每条尽量挂到一个自动检查上。
- **【推断】** 之所以不随包发布，是因为这个文件必须绑定具体仓库的技术栈与事故史；发一个通用版等于发一堆 no-op（这与 `writing-for-agents` 的 no-op 判据一致）。

---

## 2. 三层（其实是四层）分工

### 2.1 一句话版本

| 层 | 何时进入 context | 放什么 | 不放什么 |
| --- | --- | --- | --- |
| `AGENTS.md` / `CLAUDE.md` | 每个 session、每一轮都在 | navigation pointer、包管理器、非标准命令、硬约束 | 风格指南、类型规则、review 规则、任何"只在一成任务里有用"的东西 |
| `CODING_STANDARDS.md` | **只在 review 时** | judgement call：跨文件一致性、领域不变式、"看起来像不像这个仓库" | 机械规则（→ checks）、环境已有事实（→ 去读配置） |
| 自动化检查（lint / type / test / pre-commit / CI） | 每次运行、失败才进 context | 一切可确定性判定的东西 | 需要品味的东西 |
| `GLOSSARY.md` + `docs/adr/` | 被 pointer 命中时 | 领域语言、难以回退的决策 | 代码风格 |

### 2.2 `AGENTS.md`：只放 pointer，而且要"极其吝啬"【原文】

> **【原文】** "`CLAUDE.md`/`AGENTS.md`: these files are pushed to the context window of any agent working in this repo. They should be used **incredibly sparingly**, usually only for **navigation pointers** to other files."
> — `skills/engineering/retro/SKILL.md:41`

> **【原文】** "The agent keeps making the same mistake. Should I add a line to `CLAUDE.md`? Usually not, and `retro` pushes back on this more than anything else. A line in `CLAUDE.md` loads into every session, gives less weight to everything else in the file, and goes out of date as the code changes."
> — <https://aihero.dev/skills-retro>

配套的 `retro` 分类里还有专门一格：

> **【原文】** "**Global AGENTS.md**: are there any steering instructions that should be moved to coding standards (or automated checks) instead? _Use when_ the AGENTS.md file is particularly large - in the repo OR the user's global scope."

以及 `ask-matt` 对整条闭环的总结：

> **【原文】** "Mechanical mistakes become deterministic checks; judgement calls become coding standards."
> — `skills/engineering/ask-matt/SKILL.md:34`

### 2.3 `CODING_STANDARDS.md`：审阅期加载，超过 1000 行就要再挂 pointer【原文】

> **【原文】** "`CODING_STANDARDS.md`: this file is read during review, not implementation. Add **navigation pointers** to docs folders if the standards file gets more than 1,000 lines long."
> — `skills/engineering/retro/SKILL.md:42`

注意这里的二级结构：**standards 文件本身也可以再分层**。`course-video-manager` 就是这么做的——根文件写"essence + 链接"，细节推到 `docs/EFFECT_STANDARDS.md`、`docs/TESTING_STANDARDS.md`、`docs/DRAFT_GUARD.md`、`docs/FRONTEND_STATE.md`、`docs/KEYBOARD_SHORTCUTS.md`。

### 2.4 自动化检查：没有 guardrail 本身就是一条 finding【原文】

> **【原文】** "A repo with no **guardrail** (no pre-commit hook and no CI job running its lint/typecheck/test command) is itself a finding: an un-linted repo is a standing missed opportunity, not a neutral default."
> — `skills/engineering/retro/SKILL.md:18`

> **【原文】** "Read the repo's own check command first (its `package.json`/build-tool `lint`/`check` scripts, its CI workflow), so a check that already exists but sits unwired or silently broken is the finding, not a reinvention."
> — 同上

### 2.5 判定树

**【推断】** 把上面的原文压成一条决策链（原文没有画成一张图，但每一步的措辞都能对上）：

```
犯错 / 想立规矩
  ├─ 这台机器能判真假吗？（固定语法模式、禁用的 API、import 形状、文件位置）
  │     └─ 能 → 写检查：仓库自己的 linter 自定义规则 / pre-commit hook / CI job
  │            选"最便宜"的那个，别三样都上
  │            已经存在但没接上 → 接上，别重造
  ├─ 只有在 review 一个 diff 时才看得出来吗？（跨文件一致性、是否贴合周边风格）
  │     └─ 是 → CODING_STANDARDS.md（reviewer 读）
  ├─ 是"去哪找东西"的成本吗？
  │     └─ 是 → navigation pointer（从 agent 已经在读的文件指过去）
  ├─ 是领域词汇/决策吗？
  │     └─ 是 → GLOSSARY.md / docs/adr/
  └─ 是"每次都必须知道"的硬事实吗？（包管理器、非标准命令）
        └─ 是 → AGENTS.md 一行
```

### 2.6 为什么 `AGENTS.md` 这么"贵"：两本账【原文】

`writing-for-agents` 给了这套分工的理论底座：

> **【原文】** "**Context load** is the cost of always-loaded material on the agent's window: an `AGENTS.md` line, a skill description, anything sitting in context every turn, spending tokens and attention whether or not it fires. **Cognitive load** is the cost on the human."
> — `skills/productivity/writing-for-agents/SKILL.md`

> **【原文】** "The **environment** is a source of truth too (`package.json` scripts, config files, the directory layout, `--help` output), and a document that restates it is a **cache**: a copy of a lookup, earning its load only when the lookup is expensive. Cache what the agent cannot find by looking… Leave the one-file, one-command lookups to the environment, where they cannot go stale."
> — 同上

`aihero.dev` 的 AGENTS.md 长文给了可操作的极简清单：

> **【原文】** "Consider this the absolute minimum: **One-sentence project description** … **Package manager** (if not npm) … **Build/typecheck commands** (if non-standard). That's honestly it. Everything else should go elsewhere."
> — <https://www.aihero.dev/a-complete-guide-to-agents-md>

---

## 3. 机械规则 vs 判断题：他是否主张"能确定性检查的就别写进文档"？

**是，而且是这套体系里措辞最强的一条。**【原文】

> **【原文】** "Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check, **full stop**: a custom rule in the repo's own linter, a new pre-commit hook, or a new CI job, whichever the repo's language and existing guardrail make cheapest. **Default to building the check over writing the rule.** Reserve `CODING_STANDARDS.md` for genuine **judgement calls** (cross-file consistency, \"matches the surrounding style,\" anything no guardrail could ever substitute for)."
> — `skills/engineering/retro/SKILL.md:19`

> **【原文】** "A **mechanical** violation (a banned API, an import shape, a file-location rule) gets a deterministic check, because **a check can fail and a sentence in a standards file can't**."
> — <https://aihero.dev/skills-retro>

`code-review` 端有对应的消费侧规则（**三层**都提到"跳过工具已经管的"）：

> **【原文】** "Like any standard here, **skip anything tooling already enforces**."（smell baseline）
> **【原文】** "Skip anything tooling enforces."（Standards sub-agent 的 brief）
> — `skills/engineering/code-review/SKILL.md:41,66`

> **【原文】** "Both axes skip anything your linter already enforces."
> — `docs/engineering/code-review.md`（<https://aihero.dev/skills-code-review>）

### 3.1 边界条件（他也承认的弱点）【原文】

- **检查会堆成新的债**：「It does not audit the lint rules, hooks, or CI jobs it proposed last month. … A rule that fires constantly on good code is the sign to remove it.」——同一篇 retro 文档把自己这一格标为 "its weakest spot"。
- **检查只证明被断言的性质**：`dictionary-of-ai-coding` 的 *Automated check* 条目写得很直白：「a check only catches what it asserts — green checks mean the asserted properties hold, not that the code is right. The judgement-shaped gaps are what automated review and human review are for.」（<https://github.com/mattpocock/dictionary-of-ai-coding/blob/main/dictionary/Automated%20check.md>）
- **prose 规则仍要人写**：`retro` 只提议，不改文件、不装 hook（"It waits. `retro` only proposes."）。

### 3.2 【推断】他这条主张的真实动机

不是"文档没用"，而是**三个具体成本**叠加：

1. always-load 的 token 与注意力成本（`writing-for-agents` 的 context load）；
2. prose 规则**不会失败**，所以违反它可以一路合进 main；
3. implementer 的 context 压力最大，把规则放它那儿等于放在最没余力执行的位置（`retro` 的 Implementation vs Review）。

所以在"能写成检查"这件事上，他的判据不是"哪种表达更清楚"，而是"哪种能产生一个**会红的信号**"。

---

## 4. 深模块（deep modules）：哪些约束能写成规范

### 4.1 词汇表：不许换词【原文】

`codebase-design` 的 glossary 是"用词即设计"：

| 词 | 定义（原文要点） | **禁用**的近义词 |
| --- | --- | --- |
| **Module** | 任何有 interface 与 implementation 的东西；刻意与尺度无关（函数、类、包、跨层切片都算） | unit, component, service |
| **Interface** | caller 必须知道的**全部**：类型签名，外加 invariants、ordering constraints、error modes、required configuration、performance characteristics | API, signature |
| **Depth** | **leverage at the interface**：caller 或 test 每学一单位 interface 能撬动多少 behavior；deep = 小接口后面大量行为，shallow = 接口复杂度接近实现 | — |
| **Seam** | Michael Feathers 的术语：能改行为而不用改那一处的地方；它是 interface 所在的**位置** | boundary（与 DDD 的 bounded context 冲突） |
| **Adapter** | 在某个 seam 上满足某 interface 的具体物；描述**角色**而非实质 | — |
| **Leverage / Locality** | caller 得到的（每单位接口更多能力）／maintainer 得到的（改动、bug、知识、验证集中在一处） | — |

> **【原文】** "**Depth is a property of the interface, not the implementation.**" / "**The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep." / "**The interface is the test surface.**" / "**One adapter means a hypothetical seam. Two adapters means a real one.**"
> — `skills/engineering/codebase-design/SKILL.md` §Principles

**他明确否决了 Ousterhout 的深度定义**：

> **【原文】** "**Depth as ratio of implementation-lines to interface-lines** (Ousterhout): rewards padding the implementation. We use depth-as-leverage instead."
> — 同上 §Rejected framings

也有公开文章把这条讲给非 skill 读者：

> **【原文】** "Deep modules create a natural seam in your codebase. You carefully control and design the interface. The implementation inside? Delegate that to AI. … These are **grey box modules**. You own the interface. AI owns the implementation. Tests keep it honest."
> — <https://www.aihero.dev/how-to-make-codebases-ai-agents-love>

### 4.2 `DEEPENING.md`：按依赖类型决定 seam 在哪【原文】

四类依赖，分类决定"怎么跨 seam 测"：

1. **In-process**（纯计算、内存状态、无 I/O）→ 总是可以合并，直接通过新接口测，不需要 adapter。
2. **Local-substitutable**（PGLite 替 Postgres、内存文件系统）→ 有替身就能深化，seam 是**内部的**，不在外部接口上开 port。
3. **Remote but owned**（自己的服务跨网络）→ 在 seam 上定义 **port**，逻辑在 deep module 里，transport 作为 **adapter** 注入；测试用 in-memory adapter。
4. **True external**（Stripe/Twilio）→ 外部依赖作为注入的 port，测试给 mock adapter。

> **【原文】** "**One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection."
> **【原文】** "**Internal seams vs external seams.** … Don't expose internal seams through the interface just because tests use them."
> **【原文】** "Tests should survive internal refactors, since they describe behaviour, not implementation. If a test has to change when the implementation changes, it's testing past the interface."
> — `skills/engineering/codebase-design/DEEPENING.md`

### 4.3 哪些能变成机械规则，哪些不能

**【原文】** 能机械化的部分，他已经做成了一个 skill：`in-progress/setup-ts-deep-modules`，用 dependency-cruiser 把"entry point 之外不可 import"变成四条 `error` 级规则：

| 规则名 | 内容 |
| --- | --- |
| `entrypoint-boundary-from-app` | 包外代码只能 import 包的**根文件**（entry points），不能碰子目录 |
| `entrypoint-boundary-across-packages` | 包内文件互相自由 import，但跨包只能走对方 entry points |
| `tests-through-entrypoints` | `<pkg>/tests/` 可以 import 任何包的 entry points 和自己的 fixtures，**不能** import 任何包的内部（包括自己的） |
| `no-circular` | 无循环依赖 |

外加两条命令级约束（原文）：`lint:boundaries` 必须折进仓库的 umbrella check（与 typecheck 同一条命令）；写完必须**证明规则会咬人**——"a config that doesn't fail on a violation is worthless"，步骤是 pass → 故意加深层 import 必须 fail → 还原必须 pass。

> **【原文】** "Public vs private is decided by **depth**: a package's root files are entry points; anything in a subfolder is private. … Adding an entry point is just adding a root file (no barrel)."
> — `skills/in-progress/setup-ts-deep-modules/SKILL.md`

**不能机械化的部分**【原文＋推断】：

- **深度本身**。deletion test 是思想实验（"imagine deleting the module"），没有可断言的输出。
- **seam 的位置**。原文只说"Where to put the seam is its own design decision"，`improve-codebase-architecture` 用**grilling** 而不是规则来收敛它。
- **接口是否过宽**。"Can I reduce the number of methods? Can I simplify the parameters? Can I hide more complexity inside?"——这是三个提问，不是三条阈值。
- **【推断】** 唯一可以半机械化的替代指标是 `max-lines` / `max-lines-per-function` / `max-statements` / `complexity` 这类"浅层代理指标"，Matt 在 `sandcastle` 的 new-file budget 里确实用了（300 / 50 / 20 / 15），但他**没有**把这些说成"深度的定义"。

### 4.4 一个重要的反面证据：他反对把深模块等同于目录结构【原文】

> **【原文】** "deep modules are about the design of the interface and accessing through a strict interface, no matter what the file system looks like. It seems perfectly possible that you could have shallow modules with this approach."（issue #95 的回复）
> **【原文】** "I think you might be tying the concept of modules too closely to the file system. The file system can certainly be a useful hint to the shape of modules, but there's no need to use the file system in the construction of deep modules."（issue #458）
> — 转引自 <https://aihero.dev/skills-codebase-design>

以及他也承认这个 skill **不回答"怎么强制"**：

> **【原文】** "This is the most-asked question about the skill and the skill does not answer it. … People often ask for a `TYPESCRIPT.md` with concrete file and module layouts for the principles, and it does not exist."
> — <https://aihero.dev/skills-codebase-design>、<https://aihero.dev/skills-improve-codebase-architecture>

**【推断】** 这解释了为什么"深模块"在规范里只能写两件事：**① 一条可执行的边界规则**（entry point / 子目录），**② 一组 review 时的提问**（deletion test、第二个 adapter 叫什么、接口有没有写清 invariants / ordering / error modes）。写"模块要深"这种话是 no-op。

---

## 5. 给 vibe coding 的规范应该写什么：可落地提纲

### 5.1 先接受一个前提

**【原文】** Matt 对 vibe coding 的定义（不是"低质量 AI 编程"，而是**一种 review 立场**）：

> "A working pattern where the user accepts the agent's code without **human review**. The diff is treated as opaque… Automated review and automated checks may still run; vibe coding is silent on both."
> "**Avoid:** 'vibe coding' as a synonym for 'low-quality AI coding' — the term names the review stance, not the resulting code."
> "With human review gone, whatever automated verification still runs — tests, types, automated review — is **the only gate** the code passes through."
> — <https://github.com/mattpocock/dictionary-of-ai-coding/blob/main/dictionary/Vibe%20coding.md>

**【推断】** 直接推论：给 vibe coding 的规范，**密度必须压在"机器能判"的那一侧**；文档侧只保留"机器判不了、但 review agent 判得了"的部分。这与 §3 的主张是同一件事。

同时注意他自己的站位：

> **【原文】** "My agent skills that I use every day to do real engineering — **not vibe coding**."
> — <https://github.com/mattpocock/skills#readme>

**【推断】** 所以他并没有一份"vibe coding 规范"可以直接抄；下面的提纲是把他的**工程规范体系**按 vibe coding 的约束（无人读 diff）重新排序的产物。哪一条来自哪句原文，我逐条标了。

### 5.2 A 类：该写成自动检查（按优先级）

| # | 检查 | 依据 |
| --- | --- | --- |
| A1 | **umbrella check 一条命令**（`pnpm check` / `npm run check`）串起 typecheck + lint + test，pre-commit 与 CI 都跑同一条 | 【原文】retro 的 automated checks 格；"no guardrail is itself a finding" |
| A2 | **typecheck 严格档**：`strict`、禁 `any` 新增、禁非空断言 `!` | 【原文】course-video-manager "Every `any` is a leak"；`tpillai` 的示例文件里 "Do not write `any`, and do not write `!`"（注意：后者是第三方仓库，非 Matt 本人） |
| A3 | **lint ratchet**：baseline 只许缩不许涨；新增违规直接红；禁 `eslint-disable` / `@ts-ignore` 白名单外 | 【原文】`sandcastle/.sandcastle/CODING_STANDARDS.md` §The lint ratchet |
| A4 | **新文件预算**：`max-lines` 300、`max-lines-per-function` 50、`max-statements` 20、`complexity` 15、`import/max-dependencies` 10 | 【原文】同上 §New-file budget |
| A5 | **模块边界**：dependency-cruiser 四条 `error` 规则（见 §4.3），且要有"故意违反必须红"的自证测试 | 【原文】`setup-ts-deep-modules` |
| A6 | **禁止旁路**：DB client 只能来自工厂、Windows 进程只能走 guard、`git` spawn 只能走封装、`sonner` 只能从一个 toast 模块 import | 【原文】course-video-manager 的 `check-db-clients.sh`、`guardWindows()`、`hostGit()`、`check-toast-import.sh` —— 全是"单点入口 + 脚本拦截"的同一形状 |
| A7 | **测试质量**：tautological test 视为违规；mock 只在 system boundary | 【原文】tdd skill 的 anti-patterns（tautological / implementation-coupled）；course-video-manager "Mock at **system boundaries** only" |
| A8 | **文档新鲜度**：文档提到的路径/链接必须存在（link checker、docs-guide test） | 【原文】sandcastle `tests/docs-guide.test.ts` 会因 toc / README / glossary 漂移而红 |

### 5.3 B 类：该写成 `CODING_STANDARDS.md`（判断题）

写之前先过一遍 §3 的判据：**如果这条能被 A 类表达，就不要写在这里。** 剩下的通常是这五类：

1. **领域不变式（domain invariants）**
   例："A write to anything a Version owns goes through the Draft guard… **A NEW NOUN INHERITS THE GUARD FROM WHAT IT HANGS OFF**"。
   特征：规则本身是一个语义判断（"这个新名词挂在谁下面"），但违反的后果是数据损坏。
2. **单一入口原则（one way to do it）**
   例："Every duration goes through `formatDuration`"、"Every toast comes from `@/components/ui/toast`"、"Every action menu is built with `EntityMenuContent`"。
   **【推断】** 这类最适合"文档写意图 + 脚本查违规"双写：文档解释为什么，脚本抓漏网。
3. **跨文件一致性 / 贴合周边风格**
   原文直接点名这是 standards 的正当内容："cross-file consistency, \"matches the surrounding style\""。
4. **"看起来对但其实是错"的设计教训**
   例：optional parameter 是 bug 大户；`@internal` 属性做 test override 会污染类型 → 改用一层 test config layer。
   特征：无法机械判定，但 reviewer 看到签名就能判断。
5. **接口契约的书写要求**
   例："Every public-facing property or function has a JSDoc"；interface 必须写清 invariants / ordering / error modes（`codebase-design` 对 interface 的定义）。

每条建议采用他自己文件的体例（这是 §1.3 观察到的，**不是**他明文规定的格式）：

```md
### <一句祈使句，说清"做什么">

<为什么：一句话机制 + 一个真实事故/编号>

Enforced by <rule 名 / scripts/check-x.ts / 具体测试文件>（能机械化时）
Detail: <链接到长文档>
```

### 5.4 C 类：`AGENTS.md` 只留这几行

**【原文】** 极简清单（one-sentence description、package manager、非标准 build/typecheck 命令），其余全部推给 pointer：

```md
This repo is <一句话>.
Uses pnpm workspaces.
Checks: `pnpm check` (typecheck + lint + test).
Packages are deep modules: see src/packages/README.md before adding or importing one.
Coding standards live in CODING_STANDARDS.md (review-time only).
```

最后一行那类 pointer 的措辞是有讲究的（`writing-for-agents` 的 context pointer）：**要写触发条件，不只写文件名**。

> **【原文】** "A must-have target behind a weakly worded pointer is a variance bug: sharpen the wording first, and inline the material only if sharpening fails."
> **【原文】** "Front-load the leading word" / "One trigger per branch."
> — `skills/productivity/writing-for-agents/SKILL.md`

### 5.5 D 类：让规范自己长大的机制

| 机制 | 做法 | 依据 |
| --- | --- | --- |
| **retro 闭环** | 每次翻车后问：这是机械错误（→ 检查）还是判断题（→ standards）？ | 【原文】retro 的六格分类 |
| **只增可验证的** | 规则必须能被某次真实事故追溯，否则是 generic advice | 【原文】retro "Every candidate must come from the session's own record" |
| **删除机制** | 频繁误报的检查要删；`AGENTS.md` 应该越来越短 | 【原文】"A rule that fires constantly on good code is the sign to remove it." |
| **规范分册** | 根文件写 essence + 链接；超过 1000 行必须挂 pointer | 【原文】retro §Files |

### 5.6 最小可行版本（如果今天就要落地）

**【推断】** 按"vibe coding 无人读 diff"的约束排优先级：

1. 一条 `check` 命令（typecheck + lint + test），接进 pre-commit 与 CI。
2. 模块边界四条 dependency-cruiser 规则 + 一次"故意违规必须红"的自证。
3. `CODING_STANDARDS.md` 只写 5–15 条判断题，每条挂一个检查或一个事故。
4. `AGENTS.md` 压到 10 行以内，只留 pointer。
5. 跑一次 `/retro`，把这次的翻车变成上面三者之一。

---

## 6. 未找到 / 无法确认的部分

| 问题 | 结论 |
| --- | --- |
| `mattpocock/skills` 里有 `.changeset/` 提到 standards 吗？ | **未找到**。现有 4 个 changeset（`chief-of-staff-shared-wiki-procedures`、`implementer-fresh-per-ticket`、`software-factory-skill`、`README`）都不涉及 standards。最接近的是 `CHANGELOG.md` 1.3.2 里 `code-review` 那条："now searches the repo for standards files and always hands `CODING_STANDARDS.md` / `CONTRIBUTING.md` to the Standards sub-agent (#1065)"。 |
| 他有没有公开的 `CODING_STANDARDS.md` 模板（像 sandcastle 那 700 B 那种）？ | **有**，就是 sandcastle 的 `src/templates/*/CODING_STANDARDS.md`（两个模板字节相同），三个空节：Style / Testing / Architecture。 |
| `/fix-one-thing` skill 存在吗？ | **不存在**（2026-09-25 的构想帖；上游 `main` 无此 skill）。 |
| 他有没有一篇专门讲 `CODING_STANDARDS.md` 的文章？ | **未找到**。最接近的是 `/retro` 的 docs 页（含"这个文件从哪来"的 FAQ），其余散落在 X / LinkedIn。 |
| `agent-rules-books` 仓库是规范合集吗？ | **不是**（只有一张 `books-ai-rules.png` 等资产，无 standards 文档）。 |
| `total-typescript-monorepo` 里的 `.cursor/rules/*.mdc` 算什么？ | **【推断】** 属"更早一代的 steering 文件"（`default-exports.mdc`、`import-type.mdc`、`discriminated-unions.mdc` 等 20+ 条），形态是 always-load 的规则集，与他现在"只留 pointer、规则进检查"的主张相反。可作为"旧做法 vs 新做法"的对照，但**不要**当成他现在的推荐。 |
| aihero.dev 上那条"标准属于 reviewer"的原始视频/课程？ | 至少 `skills-retro` 与 `skills-code-review` 两页公开可读；workshop 页（`/workshops/day-2-steering-7ucsx`）需登录，**未核实**内部是否有更细的分层论述。 |

---

## 7. 来源清单

**一手：仓库文件**

- `mattpocock/skills` — `skills/engineering/code-review/SKILL.md`
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/code-review/SKILL.md>
- `mattpocock/skills` — `skills/engineering/retro/SKILL.md`
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/retro/SKILL.md>
- `mattpocock/skills` — `skills/engineering/codebase-design/SKILL.md` / `DEEPENING.md` / `DESIGN-IT-TWICE.md`
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md>
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DEEPENING.md>
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/DESIGN-IT-TWICE.md>
- `mattpocock/skills` — `skills/engineering/improve-codebase-architecture/SKILL.md`
  <https://github.com/mattpocock/skills/blob/main/skills/engineering/improve-codebase-architecture/SKILL.md>
- `mattpocock/skills` — `skills/productivity/writing-for-agents/SKILL.md`
  <https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-for-agents/SKILL.md>
- `mattpocock/skills` — `skills/in-progress/setup-ts-deep-modules/SKILL.md` + `dependency-cruiser.config.cjs`
  <https://github.com/mattpocock/skills/blob/main/skills/in-progress/setup-ts-deep-modules/SKILL.md>
- `mattpocock/skills` — `skills/in-progress/chief-of-staff/SKILL.md`、`skills/engineering/ask-matt/SKILL.md`、`skills/engineering/tdd/SKILL.md`、`skills/engineering/implement/SKILL.md`
- `mattpocock/skills` — `CLAUDE.md`（`AGENTS.md` 只是 `CLAUDE.md` 的转发）
  <https://github.com/mattpocock/skills/blob/main/CLAUDE.md>
- `mattpocock/skills` — `CHANGELOG.md` 1.3.2（`code-review` 的 standards 改动）
  <https://github.com/mattpocock/skills/blob/main/CHANGELOG.md>

**一手：他真实在用的 standards 文件**

- `mattpocock/course-video-manager/CODING_STANDARDS.md`
  <https://github.com/mattpocock/course-video-manager/blob/main/CODING_STANDARDS.md>
- `mattpocock/course-video-manager/docs/TESTING_STANDARDS.md`、`docs/EFFECT_STANDARDS.md`
  <https://github.com/mattpocock/course-video-manager/blob/main/docs/TESTING_STANDARDS.md>
- `mattpocock/sandcastle/.sandcastle/CODING_STANDARDS.md`
  <https://github.com/mattpocock/sandcastle/blob/main/.sandcastle/CODING_STANDARDS.md>
- `mattpocock/sandcastle/src/templates/sequential-reviewer/CODING_STANDARDS.md`（700 B 空模板）
  <https://github.com/mattpocock/sandcastle/blob/main/src/templates/sequential-reviewer/CODING_STANDARDS.md>
- `mattpocock/sandcastle/src/templates/sequential-reviewer/review-prompt.md`（第 5 步读 standards）
  <https://github.com/mattpocock/sandcastle/blob/main/src/templates/sequential-reviewer/review-prompt.md>
- `mattpocock/mise-en-place/.sandcastle/CODING_STANDARDS.md`（空模板）
- `mattpocock/sandcastle/CLAUDE.md`、`mattpocock/mise-en-place/CLAUDE.md`、`mattpocock/ai-hero-cli/CLAUDE.md`（pointer 风格对照）

**一手：aihero.dev / dictionary**

- `/skills-retro` — <https://aihero.dev/skills-retro>
- `/skills-code-review` — <https://aihero.dev/skills-code-review>
- `/skills-codebase-design` — <https://aihero.dev/skills-codebase-design>
- `/skills-improve-codebase-architecture` — <https://aihero.dev/skills-improve-codebase-architecture>
- `/skills-writing-for-agents` — <https://aihero.dev/skills-writing-for-agents>
- *A Complete Guide To AGENTS.md* — <https://www.aihero.dev/a-complete-guide-to-agents-md>
- *How To Make Codebases AI Agents Love* — <https://www.aihero.dev/how-to-make-codebases-ai-agents-love>
- `dictionary-of-ai-coding`：`Automated check.md`、`Vibe coding.md`、`AGENTS.md.md`、`Environment.md`、`Software factory.md`
  <https://github.com/mattpocock/dictionary-of-ai-coding>

**一手：他的公开帖**

- X 2026-08-14 — "Write it in CODING_STANDARDS.md … I have hundreds of lines"
  <https://x.com/mattpocockuk/status/2088256432265167185>
- X 2026-08-27 — "echo \"Tautological tests considered harmful.\" >> CODING_STANDARDS.md"
  <https://x.com/mattpocockuk/status/2093068185830347088>
- X 2026-09-25 — `/fix-one-thing` 构想（未实现）
  <https://x.com/mattpocockuk/status/2103506709633466648>
- LinkedIn — "it should only be empty for about 5 minutes"
  <https://www.linkedin.com/posts/mapocock_tons-of-folks-ask-me-how-do-i-create-a-codingstandardsmd-activity-7515667908497424384-iC6v>

**第三方（仅作对照，不作为 Matt 的主张）**

- `tpillai/matt-pocock-skill-demo/CODING_STANDARDS.md` — 一句很好的写法示范："Judgement calls for reviewing changes in this repo. Mechanical rules live in tests (`LibraryServiceContractTest`) and the pre-commit hook, not here."
  <https://github.com/tpillai/matt-pocock-skill-demo/blob/main/CODING_STANDARDS.md>
- `tomaspeirotti/matt-pocock-aihero-cohort/CODING_STANDARDS.md` — cohort 学员的实践版
