# 全量保真审计：engineering 前半 10 个 skill（2026-10-27）

对象：`中文版本/engineering/` 下 ask-matt、code-review、codebase-design、diagnosing-bugs、domain-modeling、grill-with-docs、implement、implement-spec、improve-codebase-architecture、pr。
性质：只读审计。除本文件外未写入任何内容，未改动译文、规则与定时任务。

## 方法

- 逐段对照英文与中文全部 17 个 `.md`，外加 `diagnosing-bugs/scripts/hitl-loop.template.sh` 的注释与提示文字（逻辑、变量、正则未变）。
- 10 个 `agents/openai.yaml` 用 `yaml.safe_load` 比对键结构（全部 shape-equal，仅 `display_name` / `short_description` 被译）。
- 结构核对：17 个 `.md` 的行数、代码围栏数、`#` 标题数逐一对齐（无缺段、无多段）。
- 已核对 `docs/reports/2026-10-27-fidelity-audit.md` 的 5 条 P0/P1 与 25 条 P2：本批 skill 相关项除特别注明外均已修复，本文不重复；仅记录仍残留或新发现的问题。

## 结论

| 级别 | 数量 |
| --- | --- |
| P1 | 1 |
| P2 | 7 |

整体：与首轮抽检相比已明显收敛，`harness` / `mock` / `tight` / `must`→「必须」等术语与情态基本一致，未发现漏译步骤、增删条件或改动禁用项的情况。剩余问题集中在「同一句两处译法互斥」和「模板脚手架仍是中英混排」。

---

## P1

### P1-1 `ask-matt`：`Continue` 到底该「先排除」还是「先考虑」，两处译法互斥且一处不成句

- 文件：`中文版本/engineering/ask-matt/SKILL.md:79`、`中文版本/engineering/ask-matt/PHASE-BOUNDARIES.md:21`
- 英文原文：
  > why the primary-source cost makes **Continue** the one to rule out first
  >
  > Continue costs nothing and loses nothing, so rule it out before anything else.
- 中文译文：
  > 为什么一手来源的成本使**继续**成为应当首先排除的选项
  >
  > 继续既不花费任何代价，也不丢失任何东西，因此先排除其他选项之前，应先考虑它。
- 问题：同一句在两处被译成相反意思——SKILL.md 说「先把『继续』排除掉」，PHASE-BOUNDARIES 说「先考虑『继续』，再排除其他」。PHASE-BOUNDARIES 那句还用了「先……之前」的不成句句式。而决策树正文（第 1 问「能否在本会话中继续……第一个是即胜出」，以及「继续既不花费也不丢失」）明确把「继续」当作首选判定。
- 影响：这是阶段边界决策的入口规则。执行者读到 SKILL.md 的概述会以为「继续」应被优先舍弃，与 PHASE-BOUNDARIES 的树、以及主流程「保持一个不间断上下文窗口」的建议相反，可能提前 `/compact` 或 `/clear`。
- 建议改法：按正文逻辑统一为「因此先把『继续』这一项定下来（能继续就不必再看其余四项）」；SKILL.md 同步改为「为什么一手来源的代价使『继续』成为应当最先定夺的选项」。若坚持 `rule out` 的字面义，则两处都必须写成「先排除其余四个选项」并注明对象，同时对照上游确认原句是否笔误（`rule it out` 与前后文语义相抵）。

---

## P2

| # | 文件:行 | 英文 | 中文 | 说明 / 建议 |
| --- | --- | --- | --- | --- |
| P2-1 | `domain-modeling/GLOSSARY-FORMAT.md:10` `:12` `:14` `:16` `:18` `:20` `:22` `:41` `:47` | 代码块内 `## Language`、`**Order**:`、`_Avoid_: Purchase, transaction`、`## Contexts`、`## Relationships` | `## 语言`、`**Order**：`、`_Avoid_：Purchase、transaction`、`## 上下文`、`## 关系` | **未修复（部分）**。首轮 P1-3 只把 `# Glossary Map` 改回英文，同模板内其余节名仍译、冒号仍为全角，导致同一份「可直接照抄的格式契约」中英混排。建议代码块内节名恢复英文、冒号用 ASCII `: `，只保留正文解释为中文。同类（正文内、影响小）：`codebase-design/SKILL.md:14/16/22` 的 `_Avoid_：` 亦为全角冒号。 |
| P2-2 | `improve-codebase-architecture/SKILL.md:41` | **Mermaid via CDN** for diagrams where a graph/flow/sequence reliably communicates the structure | 并在图和结构关系较为清晰时使用 **Mermaid（通过 CDN）** 绘制图表 | 丢掉 graph / flow / sequence 三种图型，把「能可靠表达结构」弱化为「较为清晰」，Mermaid 的选用标准变模糊。建议「当图（graph）、流程（flow）或时序（sequence）能可靠表达结构时用 Mermaid」。 |
| P2-3 | `improve-codebase-architecture/SKILL.md:41`、`HTML-REPORT.md:3`、`HTML-REPORT.md:86` | mass diagrams / `### Mass diagram` | 质量分布图 | mass 指「体量、面积」，不是物理/统计的「质量」。这里的图是「接口面积 vs 实现面积」的方块对比，译成「质量分布图」会把执行者引向统计图。建议「体量图（面积对比图）」。 |
| P2-4 | `diagnosing-bugs/SKILL.md:112` | establish a baseline measurement (timing harness, `performance.now()`, profiler, query plan) | 先建立基线测量（计时工具、`performance.now()`、性能分析器、查询计划） | 术语表要求 harness 保留；同文件 `:31` `:33` 已改为「一次性 harness」「二分 harness」，此处漏改。建议「计时 harness」。 |
| P2-5 | `ask-matt/SKILL.md:54` | so go straight to `/implement` only when the effort turned out genuinely small | 只有当工作结果确实很小时，才直接跳到 `/implement` | effort 指投入的工作量，不是「工作结果」；「结果很小」读起来像产出单薄。建议「只有当工作量确实很小时」。 |
| P2-6 | `ask-matt/SKILL.md:66`、`domain-modeling/SKILL.md:50` | resolve an overloaded word / vague or overloaded terms | 消解一个被过度使用的词 / 含糊或被过度使用的术语 | overloaded 是「一词承载多种含义」，不是 overused（被过度使用）。ask-matt 处有括注救回语义，domain-modeling 处无括注，直接改变了「打磨模糊语言」的对象。建议「含义超载的词」。 |
| P2-7 | `grill-with-docs/SKILL.md:3`、`ask-matt/SKILL.md:85` | A relentless interview… / the same relentless interview as `/grill-with-docs` | 一场不间断的访谈 / 相同的无情访谈 | 同一概念两种译法（`/grill-me` 的描述亦作「不间断」）。建议统一，例如描述层也用「无情访谈」。 |

---

## 复核通过项（本批未发现问题）

- `code-review`：P0-1 的 frontmatter 引号已恢复为 `\"`，`yaml.safe_load` 可解析；「双轴」已统一为「双维度」，「documented」已补回「记录在案」，「Capture the diff command once」已改为「先把 diff 命令固定下来」；12 条坏味道的名称与修复动作逐条对应，未发现漏项。
- `diagnosing-bugs`：P1-1（第 1 阶段禁令句）、P1-2（「登录」）、P2-04/05/06/07 均已修复；六个阶段的勾选项、`[DEBUG-…]` 前缀规则、`red-capable` 与「正确接缝」的条件关系均与英文一致。`hitl-loop.template.sh` 除注释外逻辑未变。
- `codebase-design`（SKILL / DEEPENING / DESIGN-IT-TWICE）：`_Avoid_` 保留、接缝/适配器/深度/杠杆/局部性术语一致；「删除测试」「接口即测试表面」「一个适配器 = 假设性接缝」三处原则译法前后统一。
- `domain-modeling/SKILL.md`：P2-11「映射表」、P2-12「术语或决定」已修复，`GLOSSARY-MAP.md` 概念不再出现「地图」。
- `ask-matt`：P2-01（双维度）、「短促而稳定的反馈回路」、`harness` 保留等处已一致；`/handoff`、`/compact`、子智能体四选项的条件无增删。
- `improve-codebase-architecture`：删除测试、ADR 冲突「只在摩擦真实时提出」、`Strong` / `Worth exploring` / `Speculative` 与依赖类别标签均原样保留。
- `pr`：模板字段 `Summary` / `Evidence` / `Merge Danger` / `Door` / `Blast Radius` 及 `<one-way or two-way>` 原样；示例代码块内注释与英文相同（未译），符合代码围栏规则。
- `implement` / `implement-spec` / `grill-with-docs`：步骤与条件（工单引用、集成分支、草稿 PR 时机、frontier 触发）均无增删；`disable-model-invocation` 与 `tdd` / `code-review` 的调用名未变。
- `agents/openai.yaml`：10 个文件键结构与英文一致，`allow_implicit_invocation` 取值未改。

## 建议修复顺序

1. `ask-matt` 的 `rule out`（P1-1）——决策入口，两处需一并改并核对上游原意。
2. `GLOSSARY-FORMAT.md` 代码块脚手架（P2-1）——与首轮 P1-3 同源，属未修完的尾巴。
3. `mass diagram` 与 Mermaid 选用标准（P2-3、P2-2）——影响 HTML 报告的实际产出形态。
4. `timing harness`（P2-4）——一次词替换即可与 P2-05 收口。
5. 其余措辞（P2-5、P2-6、P2-7）。
