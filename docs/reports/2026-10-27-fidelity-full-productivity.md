# 译文保真审计：productivity 全量（2026-10-27）

对象：`英文版本/productivity/` 与 `中文版本/productivity/` 的全部 20 个文件（7 个 skill + 桶 README + `teach/` 下 4 份格式模板 + `writing-for-agents/SKILL-MECHANICS.md` + 7 份 `agents/openai.yaml`）。
性质：只读审计。除本报告外未写入任何文件，未改动译文、规则或定时任务。

## 方法

- 逐段对照英文与中文，重点核对：步骤与完成标准、条件与触发条件、禁用项（never / only / don't）、情态强度（must / should / may）、术语与 `2026-10-27-terminology.md`、协议字符串与脚手架、句子改写后的逻辑关系。
- 结构对齐：13 份 Markdown 逐文件比行数，仅 `to-questionnaire/SKILL.md` 中文 53 行 / 英文 54 行（英文第 10–11 行是连续两个空行，中文合并为一个，无害）；代码围栏、标题层级、链接目标逐一核对一致。本桶无脚本。
- 7 份 `agents/openai.yaml`：键名与 `allow_implicit_invocation` 取值原样，仅 `display_name` / `short_description` 被译，结构合法。
- 已修复项不重复计：P2-19（rather than）、P2-20（完成后步骤）、P2-21（外置/disclosed）、P2-22（拷问怎么发）、P2-23（walk away）在本次核对中均已落实；P2-07、P2-24、P1-4 只部分落实或未落实，按「未修复」另计。

## 结论摘要

| 级别 | 数量 | 含义 |
| --- | --- | --- |
| P1 | 0 | 未发现步骤／条件／禁用项／触发条件被改写，也未发现情态被削弱到失效的句子 |
| P2 | 17 | 措辞、术语与脚手架一致性问题；不改执行路径，但影响同一概念的跨文件指代 |

整体判断：本桶译文质量高于全仓平均。所有「完成标准」「Done when」「never / only」句均逐条对上；`grilling` 的前沿／轮次／子智能体分工、`teach` 的工作区路径解析（只有 `*-FORMAT.md` 从 skill 目录解析）、`writing-for-agents` 的「先加固边界，再拆序列」防守顺序都译得准确。问题集中在两处：**（a）少数抽象名词被换成了近义词，导致同一概念两个名字**；**（b）模板代码块里的节名被本地化，与 `AGENTS.md` 的脚手架不变量冲突**。

---

## P1

无。

为防漏判，逐类复核过：`grilling` 的三条硬约束（一轮问完整个前沿、等用户回答再问下一轮、不要替用户查得到的事问用户）语义完整；`to-questionnaire` 三步的「Done when」全部保留；`teach` 的「目录惰性创建」「先与用户确认再改使命」「绝不内联未来会重复的代码」未松动；`writing-for-agents` 的「只有真正的上下文边界才能藏住后续步骤」「禁令只在无法正向表达时才保留」两句的条件关系正确。最接近 P1 的是 P2-01（桶 README 两条把「被访谈的是你」漏掉），因 `SKILL.md` 正文表述正确，降为 P2。

---

## P2

| # | 文件:行 | 英文原文 | 中文译文 | 问题 / 建议 |
| --- | --- | --- | --- | --- |
| P2-01 | `productivity/README.md:9`、`:19` | Get relentlessly interviewed about a plan… / Interview **the user** relentlessly about a plan… | 让人对一项计划或设计进行无情的访谈… / 对一项计划、决定或想法进行无情的访谈… | 受事对象「你／用户」两条都没了；`:9` 还改成了「让人对计划进行访谈」，读不出被访谈的是人。建议：`就一项计划或设计**对你**进行无情的访谈`、`就一项计划、决定或想法**对用户**进行无情的访谈`。 |
| P2-02 | `grill-me/SKILL.md:3`、`grilling/SKILL.md:6` | A **relentless** interview… / Interview the user **relentlessly** | 一场**不间断**的访谈… / **不间断**地拷问用户 | relentless 是「不依不饶」，不是「不间断」；`grilling/SKILL.md:3` 的 description 又作「无情」，三处三个说法。建议：`一场不留情面的访谈`、`不依不饶地拷问用户`。 |
| P2-03 | `writing-for-agents/SKILL.md:12`、`:39` | a **variance bug** / a **variance lever**, not just a legibility one | 一个**一致性隐患** / 一个**影响一致性的杠杆** | P1-4 只修了一半：不再误作「方差」，但术语表登记的是「行为不稳定（variance）」；`bug` 降级为「隐患」，强度掉一档。建议：`一个**行为不稳定缺陷（variance bug）**`、`一个**影响行为稳定性的杠杆**`。 |
| P2-04 | `teach/SKILL.md:63`（及 `:19`、`teach/RESOURCES-FORMAT.md:8`） | `## Assets` / See [Assets](#assets) / `# {Topic} Resources` | `## 资源` / 参见[资源](#资源) / `# {Topic} 资源` | Assets 与 Resources 在同一 skill 里同译「资源」，而 `./reference` 又叫「参考资料」，三套指代。链接能跳转，但「参见资源」易被读成 `RESOURCES.md`。建议 `## 资产（assets）` 或 `## 组件库`，`:19` 的链接文字与锚点同步。 |
| P2-05 | `teach/SKILL.md:32` | Some topics **may require more skills than knowledge**. | 有些主题**更需要技能而非知识**。 | 丢了 `may` 的保留语气，且 `more… than`（比例）变成了「而非」（取舍）。建议：`有些主题所需的技能可能多于知识。` |
| P2-06 | `teach/SKILL.md:108` | This feedback loop should be as **tight** as possible | 这个反馈循环应尽可能**紧密** | 术语表 tight → 「短促而稳定」；P2-07 只把 `writing-for-agents:69` 改成了该译法，此处仍是「紧密」，同一概念两个名字（未修复）。建议：`应尽可能短促而稳定`。 |
| P2-07 | `teach/RESOURCES-FORMAT.md:13` | Foundational text on **programming and adaptation**. Use for: anything to do with periodisation, recovery, intensity zones. | **周期化、恢复和强度区间相关问题**的奠基性文本。用于：任何关于周期化、恢复、强度区间的问题。 | 前半句丢了 `programming and adaptation`（训练计划编排与适应），变成后半句的同义重复；示例不再示范「它涵盖什么」，与同文件规则「what it covers and when to reach for it」脱节。建议：`关于训练计划编排与适应的奠基性文本。用于：周期化、恢复、强度区间相关的问题。` |
| P2-08 | `teach/RESOURCES-FORMAT.md:30`；`teach/MISSION-FORMAT.md:8/10/13/18/21`；`teach/GLOSSARY-FORMAT.md:8/12`；`teach/RESOURCES-FORMAT.md:8/10/17` | write a `## Gaps` section / `## Why` / `## Success looks like` / `## Constraints` / `## Out of scope` / `# {Topic} Glossary` / `## Terms` / `# {Topic} Resources` / `## Knowledge` / `## Wisdom (Communities)` | 写一个 `## 缺口` 小节 / `## 为什么` / `## 成功的样子` / `## 约束` / `## 范围之外` / `# {Topic} 术语表` / `## 术语` / `# {Topic} 资源` / `## 知识` / `## 智慧（社群）` | 代码围栏／行内代码里的节名是脚手架，按 `AGENTS.md` 应保持英文；`## Gaps` 还是规则明确要求写进 `RESOURCES.md` 的字面节名。注意这是**规则与实践冲突**：`domain-modeling/GLOSSARY-FORMAT.md` 修复时只恢复了样板术语名与 `_Avoid_`，节名同样译成了「## 语言」。建议节名恢复英文（正文说明仍中文），或正式登记「FORMAT 模板节名允许本地化」并同步 `domain-modeling`，二选一，不要两套并存。 |
| P2-09 | `teach/GLOSSARY-FORMAT.md:22` | `**RPE (Rate of Perceived Exertion)**:` | `**RPE**：` | 模板样例漏译括注展开，与同文件另外两条「术语（全称）：」的样式不一致，照抄会丢掉样板里的全称示范。建议：`**RPE (Rate of Perceived Exertion)**：`。 |
| P2-10 | `to-questionnaire/SKILL.md:25` | **Purpose:** why this questionnaire exists and **the decision riding on it**. | **目的：** 说明本问卷存在的原因，以及**其背后所依赖的决定**。 | 依赖方向反了：是「决定取决于问卷的回答」，不是「问卷依赖某个决定」。建议：`以及压在这份问卷上的那个决定`。 |
| P2-11 | `to-questionnaire/SKILL.md:20` | group them under `##` headings by theme **once there are more than a handful** | 当问题**超过少量**时，按主题用 `##` 标题分组 | `more than a handful` 是「超过五六个」，「超过少量」不成句，也没给出可操作门槛。建议：`当问题超过五六条时`。 |
| P2-12 | `writing-for-agents/SKILL.md:31` | all reference (a review's rules, **this skill**) | 全是参考（一份评审规则，**即本 skill**） | 两个并列例子被压成同位语，读起来像「本 skill 就是一份评审的规则」。建议：`（某份评审的规则，或本 skill）`。 |
| P2-13 | `writing-for-agents/SKILL.md:58` | merging sequences **exposes each step's later steps** to what follows | 合并序列会让**每一步都暴露在后续内容之下** | 「暴露在…之下」既不成句也把主客弄混：原意是做前面那一步时就能看见它后面的步骤。建议：`合并序列会让每一步在做的时候就看见它后面的步骤`。 |
| P2-14 | `writing-for-agents/SKILL.md:81` | Hunt **no-ops** sentence by sentence … is a **no-op** | **逐句检查无效语句（no-op）** … 就是**无效语** | 术语表登记 no-op →「无效指令（no-op）」；此处「无效语句」「无效语」两种写法，且「无效语」缺字。建议统一为「无效指令（no-op）」，末句改「就是一条无效指令」。 |
| P2-15 | `writing-for-agents/SKILL-MECHANICS.md:9` | model-invocation always _includes_ **user reach**; … never removes the human's | 模型调用始终_包含_**用户的访问权限**；…绝不会取消人类的**访问权限** | `reach` 是「触达」，同文 `:10`、`:12` 都作「触达」；「访问权限」会读成权限配置，而这里讲的是「能不能被调用」。建议：`始终_包含_用户触达；…绝不会取消人类的触达能力`。 |
| P2-16 | `grilling/SKILL.md:13`、`:19` | `❓ **Q1** - **<question title>**: <question body…>` | `❓ **Q1** - **<问题标题>**：<问题正文…>` | 模板代码块里 ASCII `:` 被改成全角「：」，智能体照抄会产出与英文模板不同的格式（P2-24 **未修复**）。建议恢复 `: `。 |
| P2-17 | `to-questionnaire/agents/openai.yaml:3` | **Front-load** questions into a doc for someone to answer | 把问题**整理**成文档，交给他人作答 | `front-load`（一次把问题前置问全）是该 skill 的核心动作，译文换成「整理」，等于丢了「前置」这层意思。建议：`把要问的问题一次性前置成文档，交给他人作答`。 |

---

## 复验通过项

- `grill-me`、`handoff`、`wait-what` 正文：逐句对齐，无增删；`handoff` 的 `argument-hint`、临时目录优先级（`$TMPDIR` → `/tmp` → `%TEMP%`）、「不要重复其他产物」均正确。
- `grilling`：前沿／轮次／设计树的定义、子智能体只查事实不替用户决定、会话结束条件三处均无失真。
- `teach`：工作区路径解析规则（`*-FORMAT.md` 从 skill 目录、其余从运行目录）译得精确；最近发展区、合意困难、流畅度与存储强度、反馈循环各节逻辑完整；`MISSION.md` / `RESOURCES.md` / `NOTES.md` / `learning-records` 文件名与编号规则未被译。
- `writing-for-agents`：信息层级三级、两种负载、共置／重复之辨、修剪四条的因果链均无倒置；`_Avoid_`、`variance`、`progressive disclosure`、`post-completion steps` 等术语与术语表对齐（`variance` 除外，见 P2-03）。
- 7 份 `openai.yaml`：键名、`allow_implicit_invocation: false`、引号结构完好；仅 `display_name` / `short_description` 被译。
- 全部 `name:` 与目录名一致；`disable-model-invocation: true` 原样；`Skill` 工具名、`<questionnaire-template>` / `<question-example>` 标签、`<slug>` / `<dash-case-name>` 占位符未被译。
- 全桶无 `CONTEXT.md` / `CONTEXT-MAP` 残留，无「代理」「子代理」「方差」「harness」误用；`技能` 仅出现在 `teach` 中指人的技能，属正确区分。

## 判为可接受、未计入

- `to-questionnaire/SKILL.md:27` 的 `**目的：**` / `**发件人：**` / `**答案将如何使用：**`：该模板是交给人的问卷、不在代码围栏内，本地化利于收件人阅读。若按 `AGENTS.md`「字段名保持英文」从严解释，则与 P2-08 同族，需一并裁决。
- `wait-what/SKILL.md:7` 把 `if the repo has more than one` 译为「如果仓库中有多个上下文」：属增译，但与 `GLOSSARY-MAP.md` 的多上下文模型一致，不误导。
- `writing-for-agents` 把 `_Don't think of an elephant_`、`_relentless_` 等示例词译成中文（`不要想到大象`、`不懈地`）：与全文「引领词保留英文原形」的用法略有张力，但示例本身是论证材料，不影响执行。
- 纯风格项（如「供智能体消费」「治愈」）不列。

## 与旧报告的关系

- `2026-10-27-fidelity-audit.md` P1-4：`variance` 已不再作「方差」，但术语仍与术语表不一致 → 部分修复，见 P2-03。
- P2-07：`writing-for-agents:69` 已改为「短促而稳定」，`teach:108` 未改 → 见 P2-06。
- P2-24：`grilling` 模板全角冒号仍在 → 见 P2-16（未修复）。
- P2-19 / P2-20 / P2-21 / P2-22 / P2-23：均已在译文中落实，本次复核通过。

## 覆盖清单

`productivity/README.md`；`grill-me`（SKILL.md、openai.yaml）；`grilling`（SKILL.md、openai.yaml）；`handoff`（SKILL.md、openai.yaml）；`teach`（SKILL.md、GLOSSARY-FORMAT.md、MISSION-FORMAT.md、LEARNING-RECORD-FORMAT.md、RESOURCES-FORMAT.md、openai.yaml）；`to-questionnaire`（SKILL.md、openai.yaml）；`wait-what`（SKILL.md、openai.yaml）；`writing-for-agents`（SKILL.md、SKILL-MECHANICS.md、openai.yaml）。共 20 个文件，逐段对照完毕。
