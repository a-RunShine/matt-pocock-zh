# 全量保真审计：engineering 后半 10 个 skill（2026-10-27）

对象：`中文版本/engineering/` 下 prototype、research、retro、setup-matt-pocock-skills、tdd、to-spec、to-tickets、triage、wayfinder、wizard 共 10 个 skill。
范围：22 个内容文件（`SKILL.md`、附属 `.md`、`template.sh` 注释与面向人的输出）+ 10 个 `agents/openai.yaml`（仅核键结构）。
性质：只读审计。除本报告外未写入任何文件，未改动译文、规则或定时任务。

## 方法

- 逐段对照英文原文与中文译文，看步骤、条件、禁用项、触发条件、情态强度、跨文件指代字符串。
- 结构核对：22 个文件的行数、代码围栏数、`#` 标题数、列表项数逐一对齐（`tdd/mocking.md` 多 1 行、`triage/AGENT-BRIEF.md` 少 8 行、`triage/OUT-OF-SCOPE.md` 少 3 行、`wizard/template.sh` 少 1 行，均为折行差异，标题/围栏/列表项数量一致）。
- 交叉引用核对：把 `wayfinder` ↔ `setup-matt-pocock-skills/issue-tracker-*.md`、`to-tickets` ↔ tracker 文档、`triage` ↔ `AGENT-BRIEF.md` / `OUT-OF-SCOPE.md` 的字符串级指代逐一比对。
- 已排重：`2026-10-27-fidelity-audit.md` 中已修复项（wizard P2-08/P2-09、`Status:`/`Blocked by:` 模板行、wayfinder 地图节名标题、`_Avoid_` 等）未重复上报；仍在的部分标注「未完全修复」。

## 结论摘要

| 级别 | 数量 |
| --- | --- |
| P1（显著失真，会误导执行） | 4 |
| P2（措辞 / 术语 / 脚手架一致性） | 16 |

10 个 skill 的译文整体准确：步骤顺序、禁用项、代码块与脚本逻辑均未被破坏；`openai.yaml` 全部只译 `display_name` / `short_description`，键结构完好；`template.sh` 去注释后逻辑与英文逐行等价。问题几乎全部集中在 `wayfinder` 与 `to-tickets` 的**跨文件指代**上：`6739f6b` 只修了标题与代码块，正文里的中文名仍在用。

---

## P1

### P1-1 `wayfinder` 把阻塞关系写反了：被阻塞方说成阻塞方

- 文件：`中文版本/engineering/wayfinder/SKILL.md:69`
- 英文原文：
  > A ticket is **unblocked** when every ticket blocking it is closed; the **frontier** is the open, unblocked, unclaimed children…
- 中文译文：
  > 当一张工单所阻塞的所有工单都已关闭时，它即为**未被阻塞（unblocked）**；**前沿（frontier）**就是那些开放、未被阻塞、未被认领的子工单…
- 问题：`every ticket blocking it`（阻塞它的那些工单，即它的 blockers）被译成「它所阻塞的工单」（它的 dependents）。主语与宾语互换，判定方向整个反过来。
- 影响：前沿查询、认领顺序、`Work through the map` 第 2 步「取前沿中最前的那张工单」全部依赖这条定义。按译文实现会把「下游已关闭」当成「自己已解锁」，在链式依赖上直接取错工单。
- 建议改法：
  > 当所有阻塞它的工单都已关闭时，它即为**未被阻塞（unblocked）**；**前沿（frontier）**就是那些开放、未被阻塞、未被认领的子工单，即已知世界的边缘。

### P1-2 `wayfinder` 用 `## 备注` 指代地图的 `## Notes` 块，指代对象不存在

- 文件：`中文版本/engineering/wayfinder/SKILL.md:124`
- 英文原文（第 124 行）：
  > **Zoom as needed**: fetch the full body of any related or closed ticket on demand; call the Skill tool for whichever skills the `## Notes` block names.
- 中文译文：
  > **按需放大**：根据需要获取任何相关或已关闭工单的完整正文；调用 Skill 工具，调用 `## 备注` 块中所列出的那些 skill。
- 问题：反引号里是被当作**字面节名**引用的 `## Notes`，译文改成了 `## 备注`，而地图正文模板（同文件 :36）与三份 tracker 文档写的都是 `## Notes` / `Notes`。地图里不存在 `## 备注` 块。
- 影响：这是「每次会话加载地图、按 Notes 里点名的 skill 取证」的执行入口。智能体按 `## 备注` 找不到内容，可能判定地图缺节、跳过取证，或自行新建一个中文节。
- 建议改法：
  > 调用 Skill 工具，调用 `## Notes` 块中所列出的那些 skill。

### P1-3 `wayfinder` 正文用中文名指代英文地图节名，一个概念两套名字（未完全修复）

- 文件：`中文版本/engineering/wayfinder/SKILL.md:13`、`:17`、`:86`、`:93`、`:97`、`:101`、`:113`、`:125`、`:126`
- 英文原文（择要）：
  > :17 … (narration, the map's **Decisions so far**) …
  > :86 The map's **Not yet specified** section is where that dim view is written down…
  > :93 **Not yet specified** excludes what's already decided **Decisions so far**…
- 中文译文（择要）：
  > :17 …（叙述、地图的"已做出的决定"）…
  > :86 地图的 **尚未明确的部分（Not yet specified）** 一节…
  > :93 **尚未明确的部分**不包括已经做出的决定（已做出的决定）…
- 问题：`6739f6b` 把 `## Destination` / `## Notes` / `## Decisions so far` / `## Not yet specified` / `## Out of scope` 五个标题恢复成英文（`verify_zh.py` 也在守），但**正文里的每一次指代仍是中文**：「已做出的决定」「尚未明确的部分」「范围之外」「备注」。同时三份 tracker 文档（`issue-tracker-github.md:41`、`-gitlab.md:41`、`-local.md:25`）写的是 `Notes / Decisions-so-far / Fog`，全部英文。
- 影响：违反 `AGENTS.md`「同一概念不得出现中英两套指代」。执行时会出现两种后果：写地图时把内容放进 `## 尚未明确的部分`（新建节），或读地图时找不到「已做出的决定」而重述已有决定。:125 的粗体指令「在地图的已做出的决定中追加一个上下文指针」是最容易照字面执行的一条。
- 建议改法：首次出现保留中文解释 + 英文名，之后**一律用英文节名**，例如
  > 在人类会阅读的一切内容中（叙述、地图的 `Decisions so far`）…
  > 地图的 **Not yet specified** 一节…
  > **Not yet specified** 不包括已经做出的决定（`Decisions so far`）…
  > **在地图的 Decisions so far 中追加一个上下文指针**

### P1-4 `to-tickets` 正文与 issue 模板把 `Blocked by` 译成「阻塞于」，与协议行冲突（未完全修复）

- 文件：`中文版本/engineering/to-tickets/SKILL.md:47`、`:62`、`:63`、`:99`
- 英文原文：
  > :47 **Blocked by**: which other tickets (if any) must complete first
  > :62 Each file's "Blocked by" lists the numbers/titles it depends on.
  > :99 ## Blocked by
- 中文译文：
  > :47 **阻塞于**：必须先完成哪些其他工单（如有）
  > :62 每个文件的"阻塞于"列出它所依赖的编号/标题。
  > :99 ## 阻塞于
- 问题：`6739f6b` 只把 `**Status:**` / `**Blocked by:**` 两行模板字段改回英文，正文的字段名与 issue 模板的节标题仍是「阻塞于」。而 tracker 文档依赖的是英文字符串：`issue-tracker-local.md:27`「`Blocked by: NN, NN` 行」、`issue-tracker-github.md:44`「或 `Blocked by` 行中某个未关闭的 issue」（两处中文版均保留英文）。
- 影响：在缺原生依赖的 GitHub/GitLab 场景下，`to-tickets` 写出的 `## 阻塞于` 不会被后续会话按 `Blocked by` 认出来，前沿查询把已阻塞工单当成可开工；本地 markdown 场景下则出现 `**Blocked by:**` 与「阻塞于」并存两种写法。
- 建议改法：字段名与节标题统一用 `Blocked by`（可括注「阻塞于」一次），例如
  > :47 **Blocked by**（阻塞于）：必须先完成哪些其他工单（如有）
  > :99 ## Blocked by

---

## P2

### P2-1 `wayfinder:13` 把许可写成必要条件（情态漂移）

- 英文：`An effort can override this in its **Notes**, carrying execution into the map itself, but absent that, produce decisions, not deliverables.`
- 中文：`只有当某个工作在其**备注（Notes）**中特别声明时，才可以把执行带入地图本身；否则，只产出决定，而不是交付物。`
- 说明：原文是「可以覆盖默认」，即允许特例；译文「只有当……才可以」把「默认规划」收紧成硬条件，并把 `Notes` 又译了一次（见 P1-3）。建议「某个工作可以在其 **Notes** 中覆盖这一默认，把执行带进地图本身；没有这种声明时，只产出决定，不产出交付物。」

### P2-2 `wayfinder:59-63` 工单正文模板的节名 `## Question` 被译成 `## 问题`

- 英文（代码块内）：`## Question` / `<the decision or investigation this ticket resolves>`
- 中文：`## 问题` / `<本工单要解决的决定或调查>`
- 说明：同一文件的地图正文模板把 `## Destination`…`## Out of scope` 全部保留英文，工单模板却把唯一的节名译掉，属同一文件内的脚手架不一致。建议 `## Question` 保留英文，只译尖括号里的说明。

### P2-3 `tdd:31` 同义反复测试的判定句被译成不通的句子

- 英文：`the assertion recomputes the expected value the way the code does（…）`
- 中文：`断言在重新计算代码计算预期值的方式（…）`
- 说明：「在重新计算……的方式」主宾错位，句子不成立，读者拿不到「断言用代码的算法重算预期值」这层意思。同仓库 `tdd/tests.md:66` 的译法是对的：「期望值用代码计算的同样方式重新算出」。建议照此改写：
  > 断言用与代码相同的方式重新算出预期值（…），因此它依照构造必然通过。

### P2-4 `tdd:32`、`to-tickets:3/9/27/40` `tracer bullet` 译作「示踪弹」

- 英文：`each test a **tracer bullet**` / `**tracer bullet** tickets`
- 中文：`每个测试都是一颗**示踪弹**` / `"示踪弹"式工单`
- 说明：The Pragmatic Programmer 的通行中译是**曳光弹**；「示踪弹」是另一种弹种，且这类名词在团队里通常照英文说。仓内一致，不算破格，但建议改为「曳光弹（tracer bullet）」并在术语表登记。

### P2-5 `retro:13` `primary sources` 译作「主要来源」，与 `research` 的「一手来源」不一致

- 英文：`Read the primary sources for the session the user specifies.`
- 中文：`阅读用户指定会话的主要来源。`
- 说明：`research/SKILL.md:10` 同一术语译作「**一手来源**」。这里指会话的原始材料（日志、diff），不是「主要/次要」。建议「阅读该会话的一手材料（日志等）」。

### P2-6 `retro:22` `No-ops` 译作「无效语句」

- 英文：`**No-ops**: look for instructions in steering files that don't modify the agent's behavior.`
- 中文：`**无效语句（No-ops）**：查找引导文件中那些不会改变智能体行为的指令。`
- 说明：术语表定的是「无效指令（no-op）」。同一段里「无效语句」与「指令」并用，指代同一对象。建议「**无效指令（no-op）**」。

### P2-7 `setup-matt-pocock-skills:59/61` `single-context` / `multi-context` 是配置取值，却被译成「单一上下文 / 多上下文」

- 英文：`Default to **single-context**（…）`；块模板 `[one-line summary of layout: "single-context" or "multi-context"]`
- 中文：`默认采用**单一上下文**`；块模板保留 `"single-context" 或 "multi-context"`
- 说明：这两个词要原样写进 `## Agent skills` 块（:99 保留英文），正文却只给中文，容易写成「单一上下文」；另外 `上下文` 在本仓同时指 context window（`context pressure` / 上下文窗口），多一层歧义。建议首次「single-context（单一上下文）」，之后用英文。

### P2-8 `issue-tracker-github.md:19`、`issue-tracker-gitlab.md:19` 把开关行本身译掉

- 英文：`**PRs as a request surface: no.** _（Set to `yes` … `/triage` reads this flag.）_` / `**MRs as a request surface: no.**`
- 中文：`**将 PR 作为请求入口：否。**` / `**将 MR 作为请求入口：否。**`
- 说明：`setup-matt-pocock-skills/SKILL.md:49` 仍用「"PR 作为请求入口（PRs as a request surface）"标志」来指这件东西，`_（Set to `yes`）_` 也保留了 `yes`。开关名被译掉后，跨文件不再有可检索的同一字符串，且「设为 `yes`」与「否」中英混排。建议保留 `**PRs as a request surface: no.**`，只在括号里加中文解释。

### P2-9 `triage:94-102` 分诊评论模板的节名与占位符被本地化

- 英文（代码块内）：`## Triage Notes` / `**What we've established so far:**` / `**What we still need from you (@reporter):**`
- 中文：`## 分诊记录` / `**目前已确认的内容：**` / `**我们仍需要你（@报告者）提供的信息：**`
- 说明：`@reporter` 是占位标识（真实值是 GitHub 用户名），`@报告者` 既不是合法 mention，也违反「占位符标识不译」。`## Triage Notes` 是每条分诊评论的固定节名，后续会话要「parse prior triage notes」。建议 `@reporter` 原样保留；模板节名按协议字符串规则保留英文，只译后面的说明句。

### P2-10 `triage:11` `same machine` 译作「相同的机器」

- 英文：`using the same roles, same states, and same machine`
- 中文：`使用相同的角色、相同的状态和相同的机器`
- 说明：这里的 machine 指前面那句的 state machine（状态机）。「相同的机器」易被读成「同一套工具/流程」。建议「同一套状态机」。

### P2-11 `triage/AGENT-BRIEF.md:122-124`、`OUT-OF-SCOPE.md:46` `.out-of-scope/` 文件字段名中英两套

- 英文：`a **Prior requests:** list`（AGENT-BRIEF:130）、`appended to its "Prior requests" list`（:138）、样例节 `## Prior requests`（OUT-OF-SCOPE:49）
- 中文：`**Prior requests:**` 保留英文（AGENT-BRIEF:124），但 `:132` 写作「其"先前的请求"列表」，`OUT-OF-SCOPE.md:46` 的样例节名译成 `## 先前的请求`
- 说明：`triage` 第 1 步要靠这些文件做去重，字段名不统一会导致同一目录里 `Prior requests` 与 `先前的请求` 并存，人工与智能体各读一套。建议样例节名保留 `## Prior requests`（可括注「先前的请求」）。

### P2-12 `to-tickets:73/90` 模板里三个字段两种语言

- 英文：`**What to build:**` / `**Blocked by:**` / `**Status:**`；`## What to build` / `## Acceptance criteria` / `## Blocked by`
- 中文：`**要构建什么：**` 与 `**Blocked by:**` / `**Status:**` 混排；`## 要构建什么` / `## 验收标准` / `## 阻塞于`
- 说明：同一模板内两个字段保留英文、一个译成中文并换成全角冒号，抄模板的人会得到混合成品的工单。建议同一张模板内字段名统一（见 P1-4）。

### P2-13 `prototype/UI.md:83` 右箭头的方向描述与左箭头不对称

- 英文：`**Left arrow**: cycles to the previous variant (wraps around).` / `**Right arrow**: cycles forward (wraps around).`
- 中文：`**左箭头**：切换到上一个变体（循环）。` / `**右箭头**：向后切换（循环）。`
- 说明：左箭头已明确是「上一个」，右箭头用「向后」既可读成「下一个」也可读成「往回」，实现时可能做成两个箭头同向。建议「切换到下一个变体（循环）」。

### P2-14 `prototype/LOGIC.md:3` `data shape` 译作「数据结构」

- 英文：`**business logic, state transitions, or data shape**`
- 中文：`**业务逻辑、状态转换或数据结构**`
- 说明：`data shape` 指数据长什么样（字段与形态），`数据结构` 是另一门课的概念。建议「数据形态」，与同文 `state model`（状态模型）成对。

### P2-15 `prototype/SKILL.md:23` `scratch DB` 译作「测试数据库」

- 英文：`If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE, wipe me" name.`
- 中文：`如果问题明确涉及数据库，就使用一个测试数据库或一个本地文件，并给它一个清晰的名称，例如 "PROTOTYPE, wipe me"（原型，可清空）。`
- 说明：`scratch` 强调「可丢弃」，`测试数据库` 暗示测试夹具环境（`tdd/mocking.md:6` 的 test DB 才是这个意思），两者在团队里通常是不同的库。建议「一次性（scratch）数据库」。

### P2-16 `prototype/UI.md:110` `disagree about structure` 译作「互相矛盾」

- 英文：`Real variants disagree about structure.`
- 中文：`真正的变体在结构上互相矛盾。`
- 说明：原意是「在结构上各持一套主张（彼此不同）」，不是「自相矛盾」。建议「真正的变体在结构上彼此不同意」。

---

## 复核未见问题（列出以便交叉验证）

- `research/SKILL.md`：逐句对应，`primary sources` → 一手来源、`Follow every claim back to the source that owns it` 均无失真。
- `wizard/SKILL.md`：此前 P2-08「仓库中的 template.sh」、P2-09「是否为……还是」已修复；步骤 1–4 的 `Done when` 完成标准、`set_secret 只用于 CI 真正需要的值` 等禁令与原文一致。
- `wizard/template.sh`：`STAGES` / `TOTAL_STAGES` / `run_wizard` / 函数体 / 正则 / 引号处理逐行等价；仅注释与 `printf` 的人读文案译为中文（banner 三行合并为两行，文本等价）。
- `setup-matt-pocock-skills/domain.md`、`issue-tracker-local.md`、`triage-labels.md`：逐句对应；`Status:` / `Blocked by:` / `## Comments` / `## Answer` / `Type:` 均保留英文。
- `tdd/SKILL.md` 除 P2-3、P2-4 外无失真：接缝预确认、`No test is written at an unconfirmed seam`、`Refactoring is not part of the loop` 强度与原文一致；`tdd/tests.md`、`tdd/mocking.md` 逐段对齐，代码块内仅注释被译。
- `to-spec/SKILL.md`：流程三步、`ready-for-agent` 标签、`<spec-template>` / `<user-story-example>` 标签均保留；模板节标题本地化与 `to-tickets` 的处理方式一致（无跨文件消费者，未单列）。
- `triage/SKILL.md` 除 P2-9、P2-10 外无失真：AI 声明逐字保留；五个状态角色、类别角色、状态转换规则、`wontfix` 三条分支与原文一致。
- `wayfinder/SKILL.md` 除 P1/P2 各项外：HITL/AFK 定义、五种工单类型、绘图与推进两个模式的步骤顺序、`每个会话绝不解决超过一张工单（研究工单除外）` 均准确。
- 10 个 `agents/openai.yaml`：键集合与取值类型与英文完全一致，仅 `display_name` / `short_description` 被译。

## 建议修复顺序

1. P1-1 `wayfinder:69` 的阻塞方向——一条错误定义会污染前沿查询。
2. P1-2 / P1-3 `wayfinder` 的 `## Notes` 与四个中文节名——同一处根因，一次改完，并考虑让 `verify_zh.py` 也检查正文里的中英双名（当前只查标题）。
3. P1-4 `to-tickets` 的「阻塞于」——与 tracker 文档的 `Blocked by` 协议对齐。
4. P2-3 `tdd:31` 与 P2-9 `triage` 模板占位符——改字即可，避免读不通与坏 mention。
5. 其余术语收敛：`tracer bullet`、`primary sources`、`no-op`、`single-context`、`data shape`。
