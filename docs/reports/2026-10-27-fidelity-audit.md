# 译文保真抽检报告（2026-10-27）

对象：`中文版本/` 相对 `engineering/` `productivity/` `in-progress/` `misc/` 英文原文的保真度。
性质：只读抽检。除本报告外未写入任何文件，未改动任何译文。

## 抽检方法

- 逐段对照英文原文与中文译文，重点看指令语义（步骤、条件、禁用项、触发条件）、情态强度、专有名词与标记字符串。
- 结构对齐核对：对 14 个文件比对代码围栏数、`#` 标题数、总行数（均对齐；`to-questionnaire` 中文少 1 行为删去多余空行，`mocking.md` 多 1 行为列表前补空行，均无害）。
- 机器校验：对 38 个中文 `SKILL.md` 做 frontmatter YAML 解析；对 38 个 `agents/openai.yaml` 做 YAML 解析；核对 `name:` 与目录名；核对样本文档内相对链接是否可解析；对 3 个脚本做「去注释后 diff」；检查 `CONTEXT.md` / `CONTEXT-MAP` 残留。
- 术语普查：统计 `skill` / `智能体` / `子智能体` / `harness` / `triage` / `commit` / `worktree` 等词的译法分布。

## 结论摘要

| 级别 | 数量 | 含义 |
| --- | --- | --- |
| P0 | 1 | 会破坏 skill 加载或直接误导执行 |
| P1 | 4 | 显著失真：指令自相矛盾、关键概念被译错、产物格式契约被改 |
| P2 | 24 | 措辞与术语问题，不改行为但影响一致性 |

整体判断：译文质量高，长句逻辑基本无误译，代码块（除下述模板）与脚本逻辑均未被破坏。问题集中在两类：**（a）少数句子在改写时把条件关系弄拧；（b）术语在「保留英文 / 译成中文」之间摇摆**。

---

## P0

### P0-1 `code-review` 的 frontmatter 不是合法 YAML，skill 元数据会解析失败

- 文件：`中文版本/engineering/code-review/SKILL.md:3`
- 英文原文：
  > `description: "... or asks to \"review since X\"."`
- 中文译文：
  > `description: "……或提出"自 X 以来的评审"时使用。"`
- 问题：英文用 `\"` 转义的双引号，译文改成了**未转义的 ASCII 双引号**，而整个标量本身又是双引号包裹。`yaml.safe_load` 在该行报 `ParserError: expected <block end>, but found '<scalar>'`。全仓 38 个中文 `SKILL.md` 中仅此一个解析失败；`agents/openai.yaml` 全部正常。
- 影响：frontmatter 无法解析，`name` / `description` 都取不到，等于该 skill 的调用标识与触发条件失效。
- 建议改法：内层引号改用中文引号或转义，例如
  `……或提出「自 X 以来的评审」时使用。`（或 `\"自 X 以来的评审\"`）；改完用 `yaml.safe_load` 复验。

---

## P1

### P1-1 `diagnosing-bugs` 第 1 阶段收尾句被改成自相矛盾

- 文件：`中文版本/engineering/diagnosing-bugs/SKILL.md:66`
- 英文原文：
  > **stop: jumping straight to a hypothesis is the exact failure this skill prevents.** No red-capable command, no Phase 2.
- 中文译文：
  > **停下来：在没有假设之前就直接跳到假设，正是本 skill 要防止的失败。** 没有能变红的命令，就没有第 2 阶段。
- 问题：「在没有假设之前就直接跳到假设」在语义上不成立（自指矛盾）。原意是「**跳过建回路、直接跳到假设**」，译文把被跳过的对象写成了「假设」本身。
- 影响：这是本 skill 最核心的禁令（禁止未建回路先猜原因）。译文变成一句读不通的话，禁令的可执行性下降，智能体容易略过。
- 建议改法：
  > **停下来：不先建回路就直接跳到假设，正是本 skill 要防止的失败。**

### P1-2 `hitl-loop.template.sh` 把「sign in」译成「签名」，且与同文件第 34 行冲突

- 文件：`中文版本/engineering/diagnosing-bugs/scripts/hitl-loop.template.sh:16`
- 英文原文（第 15–16 行注释）：
  > `# capture` prints its value back to the terminal, where the agent reads it,
  > so capture observations, and leave **signing in** to the user as a `step`.
- 中文译文：
  > 「……因此只捕获观察结果，把**签名**之类的操作作为 `step` 交给用户完成。」
- 问题：`signing in` = **登录**，不是「签名」。同一文件第 17 行 `step "打开应用 … 并登录。"` 译得正确，两处自相矛盾。该注释是模板里唯一说明「凭证类操作必须交给人、不要用 `capture` 收取」的地方。
- 影响：读脚本的智能体拿不到「不要把登录凭据 capture 进来」这条规则，可能把账号密码/验证码设计成 `capture` 项，直接违背 skill 的脱敏前提。
- 建议改法：
  > 因此只捕获观察结果，把**登录**这类操作作为 `step` 交给用户完成。

### P1-3 `GLOSSARY-FORMAT.md` 把格式契约本身译掉了：`_Avoid_` → `_避免_`

- 文件：`中文版本/engineering/domain-modeling/GLOSSARY-FORMAT.md:12` `:14` `:16` `:18` `:20` `:22` `:27` `:39`
- 英文原文（代码块内，即 GLOSSARY.md 的字面格式）：
  ```
  **Order**:
  {A one or two sentence description of the term}
  _Avoid_: Purchase, transaction
  ```
  以及 `# Glossary Map`（第 39 行）。
- 中文译文：
  ```
  **Order（订单）**：
  {一两句话描述该术语}
  _避免_：Purchase（购买）、transaction（交易）
  ```
  以及 `# 术语地图`。
- 问题：三处结构性改动叠加——(a) 术语行内插入中文括注；(b) ASCII `:` 改成全角 `：`；(c) 把下游规则依赖的字面标记 `_Avoid_` 本地化成 `_避免_`（第 27 行规则文本也随之改，形成闭环但已偏离上游契约）。
- 影响：中文 skill 产出的 `GLOSSARY.md` 与上游/英文仓库的格式不再互通；对已有英文 `GLOSSARY.md` 的仓库，`_避免_` 无法与既有 `_Avoid_` 对齐，术语表会被写成两套标记。同时违反 `AGENTS.md`「代码块内除注释外不译」的不变量。
- 建议改法：代码块恢复为英文原样（`**Order**:` / `_Avoid_:`），仅保留正文解释与规则说明为中文；若要中文化标记，需在 `AGENTS.md` 里明确登记为有意偏离，并同步 `codebase-design`、`teach/GLOSSARY-FORMAT.md` 中同类用法。
- 关联（同类但较轻）：`中文版本/engineering/domain-modeling/ADR-FORMAT.md:10` 把模板标题 `# {Short title of the decision}` 译成 `# {决定的简短标题}`——见 P2-25。

### P1-4 `writing-for-agents` 把核心概念 variance 译成统计学的「方差」

- 文件：`中文版本/productivity/writing-for-agents/SKILL.md:12`、`:39`
- 英文原文：
  > A must-have target behind a weakly worded pointer is a **variance bug**: sharpen the wording first…
  > …turns attending to them into a coin-flip: a **variance lever**, not just a legibility one.
- 中文译文：
  > 「……就是一个**方差隐患**：先打磨措辞……」
  > 「……这是一个**方差杠杆**，而不仅仅是可读性问题。」
- 问题：这里的 variance 指「同一文档多次运行时行为不一致」，不是统计量；且 `bug` 被降级为「隐患」，强度掉了一档。全文两处，都是该文的核心论点。
- 影响：读者会把「方差」读成统计学概念（或以为在讲评测指标），进而误解这一节在讨论「可读性」而非「行为稳定性」。
- 建议改法：`variance bug` → **行为不稳定缺陷（variance bug）**；`variance lever` → **影响稳定性的杠杆**。若团队已有「方差」借用的约定，请在术语表登记并至少保留英文原词括注。

---

## P2

| # | 文件:行 | 英文 | 中文 | 说明 / 建议 |
| --- | --- | --- | --- | --- |
| P2-01 | `engineering/code-review/SKILL.md:6` | Two-axis review | 双**轴**评审 | 同文件 :8/:11/:38/:80/:82 一律用「维度」，:6 用「轴」。统一为「双维度评审」。 |
| P2-02 | `engineering/code-review/SKILL.md:8` | this repo's **documented** coding standards | 本仓库的**已有**编码规范 | 丢了 "documented" 这一限定；该 skill 正是靠「记录在案的规范」与「内置坏味道基线」分层。建议「本仓库**记录在案**的编码规范」。 |
| P2-03 | `engineering/code-review/SKILL.md:21` | **Capture** the diff command once | **只捕获一次** diff 命令 | capture 在此是「固定/记下」，译成「捕获」易读成「只抓取一条」。建议「先把 diff 命令**固定下来**」。 |
| P2-04 | `engineering/diagnosing-bugs/SKILL.md:8` | Skip phases only when **explicitly** justified | 只有在有**明确**理由的情况下才跳过某个阶段 | 「explicitly」要求**说出来/写下来**的理由，不只是「自己心里有数」。建议「只有在**明确说明理由**时才跳过某阶段」。 |
| P2-05 | `engineering/diagnosing-bugs/SKILL.md:31` `:33` | Throwaway **harness** / Bisection **harness** | 一次性**测试工具** / 二分**测试工具** | 与 `ask-matt/PHASE-BOUNDARIES.md:29`、`:38`、`ask-matt/SKILL.md:75`、`chief-of-staff/SKILL.md:16` 保留英文 `harness` 不一致。harness 指「临时搭的运行装置」，不是「测试工具」。建议统一保留 `harness`（可括注「脚手架/装置」）。 |
| P2-06 | `engineering/diagnosing-bugs/SKILL.md:51` | (one service, **mocked** deps) | （一个服务、**模拟的**依赖） | `mock` 在 `tdd/` 全篇保留英文，此处译作「模拟」。建议「（一个服务、mock 掉的依赖）」。 |
| P2-07 | `engineering/diagnosing-bugs/SKILL.md:20` `:47` | a **tight** pass/fail signal；a 2-second deterministic one is **tight** | **紧凑**的通过/失败信号；才是**紧凑**的 | tight 指「短、稳、锋利」；「紧凑」更像「简洁/不冗余」。建议「**短促而稳定**的回路」。与 `writing-for-agents:69` 的 `_tight_`（紧凑）一并统一。 |
| P2-08 | `engineering/wizard/SKILL.md:10` | The delightful UX is already solved by [template.sh](template.sh) | **仓库中的** [template.sh](template.sh) 已经解决了…… | 增译「仓库中的」：模板随 skill 分发，不在用户仓库里，易让智能体去 `git ls-files` 里找。删去该限定即可。 |
| P2-09 | `engineering/wizard/SKILL.md:25` | (c) whether it's secret (hidden entry) **or** public | (c) 它**是否为**机密（隐藏输入）**还是**公开 | 「是否为……还是……」句式不成句。建议「(c) 它是机密（隐藏输入）还是公开值」。 |
| P2-10 | `engineering/wizard/template.sh:61` | step "..." is a **numbered-feeling** action the human takes in the browser | step "..." 是人类在浏览器中要执行的一个动作 | 漏译 "numbered-feeling"（带编号感的动作，用于区分 `say`）。注释补回「带编号感」。 |
| P2-11 | `engineering/domain-modeling/SKILL.md:24` | The **map** points to where each one lives | 该**地图**指向每个上下文所在的位置 | `GLOSSARY-MAP.md` 是索引/映射表，不是地图；后文与 `GLOSSARY-FORMAT.md:39` 的「术语地图」同源。建议「该**映射表**指出每个上下文的位置」。 |
| P2-12 | `engineering/domain-modeling/SKILL.md:8` | writing the glossary and decisions down the moment **they** crystallise | 在**决定**明确成形的那一刻，把术语表和决定写下来 | they = 术语与决定；译文把时点收窄到「决定」，与本节标题「术语一经确定就写」冲突。建议「在术语或决定成形的那一刻」。 |
| P2-13 | `in-progress/chief-of-staff/SKILL.md:16` | **Harness**-permitting | 在 **harness** 允许的情况下 | 与 P2-05 同源的反向不一致（此处保留英文）。两者取一。 |
| P2-14 | `in-progress/chief-of-staff/SKILL.md:51` | Agents **thrive in** the pit of success | 智能体**需要身处**「成功的坑」中 | thrive = 如鱼得水/表现最好，译成「需要」把「沃土」说成了「前提」。建议「智能体在**成功的坑**里如鱼得水」。 |
| P2-15 | `in-progress/chief-of-staff/SKILL.md:53` | API's and functions which are extremely constrained and **limited** | 极度受限、**功能单一**的 API 与函数 | 增译「功能单一」（single-purpose），原意只是「限制多」。删去或改为「能力受限」。 |
| P2-16 | `in-progress/chief-of-staff/SKILL.md:59` | like dev servers (**or production logs**) | （例如开发服务器，**或生产环境**）的日志 | 丢了第二个 logs，变成「生产环境（本身）的日志」。补为「或生产环境日志」。 |
| P2-17 | `in-progress/chief-of-staff/SKILL.md:63` `:65` | the **"no workarounds"** rule / No one-off **workarounds**, or **hacks** | **"不许有 workaround"** 规则 / 不要临时性的**变通方案**，也不要……的**黑客手段** | 同一概念三种写法（workaround / 变通方案 / 黑客手段）。建议术语表定「变通方案（workaround）」，首次出现后统一中文。 |
| P2-18 | `in-progress/chief-of-staff/SKILL.md:9` | You are the Directly Responsible Individual | 你是本目标的直接责任人（**DRI**） | 增译缩写 DRI（原文没有）。无害，但属增译；建议删去或保留英文全称。 |
| P2-19 | `productivity/writing-for-agents/SKILL.md:6` | takes the same _process_ every run **rather than** producing the same output | 采取的是同样的_过程_，**而不只是**产出同样的输出 | 「而不只是」= not merely，弱化了「过程一致 ≠ 输出一致」这一全文论点。建议「**而不是**」。 |
| P2-20 | `productivity/writing-for-agents/SKILL.md:49` | the visible steps still ahead (the **post-completion steps**) | 仍然存在的可见后续步骤（即**后续步骤**） | 术语被抹平：post-completion = 「完成之后才该看的步骤」，正是本节「隐藏后续步骤」的手法名。建议「（即**完成后步骤**）」，后文一致使用。 |
| P2-21 | `productivity/writing-for-agents/SKILL.md:35` `:39` | **Disclosed** reference；reference that should be **disclosed** | **外置**参考；应当**外置**却没有外置的参考 | 与同文 `progressive disclosure`（渐进式披露）不成一族。建议统一为「**披露出去的参考**」，或全文统一「外置」并在首次括注 disclosure。 |
| P2-22 | `productivity/to-questionnaire/SKILL.md:9` | Grill the **send**, not the **subject** | 拷问**发送行为**，而不是拷问**主题** | send 指「发送这一侧的已知信息」（给谁、要什么回来），不是「发送这个动作」；subject 指「问卷要问的主题内容」。建议「拷问**怎么发**，而不是**问什么**」。 |
| P2-23 | `productivity/to-questionnaire/SKILL.md:13` | what the user must **walk away** able to do or decide | 列出用户在**离开时**必须能够做出或决定的事项 | walk away 指「谈完之后带走的结论」，非「离场那一刻」。建议「谈完之后能够**拍板或动手**的事项」。 |
| P2-24 | `productivity/grilling/SKILL.md:13` `:19` | `❓ **Q1** - **<question title>**: <question body…>` | `❓ **Q1** - **<问题标题>**：<问题正文…>` | 代码块内模板把 ASCII `:` 改成全角 `：`（占位符译文本身可接受）。若下游按格式解析，建议保留 `: `。 |
| P2-25 | `engineering/domain-modeling/ADR-FORMAT.md:10` | `# {Short title of the decision}` | `# {决定的简短标题}` | 代码块内模板被译（与 P1-3 同源处理方式）。ADR 标题本就该用项目语言，可保留中文，但请在 `AGENTS.md` 登记「模板类代码块允许本地化」，与 P1-3 的标记类字符串区分开。 |

---

## 复验通过项（未发现问题）

- `misc/git-guardrails-claude-code`：`SKILL.md` 与英文逐段一致；`scripts/block-dangerous-git.sh` 去注释后与英文**逐字节相同**，`BLOCKED: ...` 原样保留，仅额外加了一行中文注释（可接受）。
- `engineering/wizard/template.sh`：除 banner 三行 `printf` 合并为两行（文本内容与颜色码 `%s…%s` 配对均等价）外，逻辑/变量/正则一字未改；`STAGES`、`TOTAL_STAGES`、`run_wizard` 等标记字符串原样。
- `engineering/diagnosing-bugs/scripts/hitl-loop.template.sh`：除 P1-2 那处注释外，`step`/`capture` 逻辑、`set -euo pipefail`、输出格式均未变。
- `engineering/tdd`（SKILL.md / tests.md / mocking.md）：逐段核对无失真；`WHAT/HOW` 译为「做什么/怎么做」合理；代码块内仅注释被译。
- 全部 38 个 `agents/openai.yaml`：仅 `display_name` / `short_description` 被译，键名与取值结构完好。
- 全部 38 个中文 `SKILL.md` 的 `name:` 与目录名一致（`code-review` 的失败在 YAML 层，不在名称）。
- 42 个样本文档内相对链接全部可解析；未发现 `CONTEXT.md` / `CONTEXT-MAP` 残留。
- 分诊标签字符串、`wayfinder:*`、`/setup-matt-pocock-skills`、`codebase-design`、`writing-for-agents` 等专有标识未被翻译。
- `skill`（150 处）统一保留英文，`技能`一词只出现在 `teach` 中指「人的技能」，属正确区分；`agent` 一律「智能体」，无「代理」；`subagent` 一律「子智能体」；`worktree` 保留英文。

---

## 跨文件术语表

| 英文 | 建议中文 | 是否保留英文 | 现状 |
| --- | --- | --- | --- |
| skill | （不译） | **保留** | 一致（150 处英文） |
| agent | 智能体 | 否 | 一致 |
| subagent / sub-agent | 子智能体 | 否 | 一致（56 处） |
| background agent | 后台智能体 | 否 | 一致 |
| harness | （不译），必要时括注「运行装置/脚手架」 | **保留** | **不一致**：诊断用「测试工具」，其余保留英文（P2-05/13） |
| triage（skill/流程） | `/triage` 保留；概念用「分诊」 | 部分是 | 一致 |
| commit | 提交（名词可写「提交（commit）」） | 视语境 | 一致 |
| worktree | （不译） | **保留** | 一致 |
| seam | 接缝 | 否 | 一致 |
| module / interface / depth | 模块 / 接口 / 深度 | 否 | 一致 |
| leverage / locality | 杠杆 / 局部性 | 否 | 一致 |
| mock（动词） | （不译）mock | **保留** | **不一致**：`diagnosing-bugs:51` 作「模拟」（P2-06） |
| fixture | 夹具 | 否 | 一致 |
| tight（loop） | 短促而稳定 / 紧密 | 否 | 「紧凑」偏「简洁」（P2-07） |
| variance | 行为不稳定 / 输出波动 | 建议括注 | **误作「方差」**（P1-4） |
| pit of success | 「成功的坑」（pit of success） | 括注保留 | thrive 被译成「需要」（P2-14） |
| leading word | 引领词 | 否 | 一致 |
| completion criterion | 完成标准 | 否 | 一致 |
| progressive disclosure | 渐进式披露 | 否 | 与 disclosed reference「外置」不成族（P2-21） |
| post-completion steps | 完成后步骤 | 否 | 被抹平为「后续步骤」（P2-20） |
| no-op | 无效指令（no-op） | 括注 | 一致 |
| _Avoid_ | （不译，作为标记） | **保留** | **被改成 `_避免_`**（P1-3） |
| GLOSSARY-MAP.md（概念） | 术语映射表 | 文件名保留 | 被译成「地图」（P2-11） |
| sign in | 登录 | 否 | **误作「签名」**（P1-2） |
| wayfinder:map / wayfinder:<type> / needs-triage 等标签 | （不译） | **保留** | 一致 |

## 建议的修复顺序

1. `code-review` frontmatter 引号（P0-1）——两分钟，恢复 skill 可用。
2. `hitl-loop.template.sh` 的「登录」（P1-2）——影响凭证安全规则。
3. `diagnosing-bugs:66` 的禁令句（P1-1）。
4. `GLOSSARY-FORMAT.md` 的 `_Avoid_` 与模板代码块（P1-3）——需先决定「格式契约是否本地化」，再决定是否回滚。
5. `variance` / `harness` / `mock` / `tight` 四个跨文件术语统一（P1-4、P2-05/06/07），一次性收敛到术语表。
