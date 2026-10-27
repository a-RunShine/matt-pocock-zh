# 保真全量审计：in-progress 与 misc（2026-10-27）

对象：`中文版本/in-progress/`、`中文版本/misc/` 下 11 个 skill 的全部文件，外加两个桶的 `README.md`，逐文件对照 `英文版本/`。
性质：只读审计。除本报告外未写入任何文件，未改动译文、规则或脚本。

覆盖清单（13 组、26 个文件，全部逐段对照）：

- `in-progress`：chief-of-staff、claude-handoff、loop-me、setup-ts-deep-modules（含 `dependency-cruiser.config.cjs`）、writing-beats、writing-fragments、writing-shape，以及 `in-progress/README.md`
- `misc`：git-guardrails-claude-code（含 `scripts/block-dangerous-git.sh`）、migrate-to-shoehorn、scaffold-exercises、setup-pre-commit，以及 `misc/README.md`
- 11 个 `agents/openai.yaml` 逐一 diff

## 方法

- 逐段对照英文原文与中文译文，重点看步骤、条件、禁用项、触发条件、情态强度（must / should / may / never / only）与术语。
- 结构核对：11 个 `SKILL.md` 的行数、`#` 标题数、代码围栏数全部一致（`writing-fragments` 中文少 1 行，是英文一处软换行在中文里并成一行，内容无缺失）；两个 README 条目全部对得上。
- 机械比对：`block-dangerous-git.sh` 与 `dependency-cruiser.config.cjs` 对英文做「去注释 diff」，脚本逐字节相同（仅多一行中文注释），配置仅注释被译；`openai.yaml` 仅 `display_name` / `short_description` 被译。
- 定向扫描：对全部段落做否定词/情态词（never / not / only / unless / rather than / instead）与英文对齐检查，未发现任一禁令、限定或情态强度在中文里丢失。
- 标识核对：`<what-to-do>` / `<supporting-info>`、`workflows/*.md`、`NOTES.md`、`tests-through-entrypoints`、`lint:boundaries`、`PACKAGES_ROOT`、`CLAUDE.md` / `AGENTS.md`、`BLOCKED`、`pnpm ai-hero-cli internal lint`、提交信息字面串等均原样保留。

## 结论摘要

| 级别 | 数量 | 含义 |
| --- | --- | --- |
| P1 | 1 | 显著失真：核心规则的适用单位被收窄，且同文档内一词两译 |
| P2 | 7 | 措辞与术语，不改行为但影响一致性 |

整体判断：这两个桶的译文质量高于上次抽检的平均水平，未发现禁用项丢失、条件反转或协议字符串被译。唯一的结构性问题是 `writing-shape` 把 block 一律译作「段落」；其余为术语收敛与个别漏译。

---

## P1

### P1-1 `writing-shape` 把 block 全篇译作「段落」，核心的 grounding 约束被收窄到段落

- 文件：`中文版本/in-progress/writing-shape/SKILL.md:22`、`:24`、`:30`、`:35`、`:37`（对照同文件 `:25`、`:61`、`:71` 又把 block 译作「块」）
- 英文原文：
  > `:22` Everything else must be grounded by a **block** before a later **block** can lean on it.
  > `:24` The next **block** may only lean on grounded concepts … Argue about the form the next **block** takes: a paragraph, a list, a table, a callout, a quote, a code block.
  > `:30` Every **concept** has to be **grounded** before a **block** can lean on it … met it in an earlier **block**. A **block** that reaches for an ungrounded concept loses the reader.
- 中文译文：
  > `:22` 其余概念都必须先由某个**段落**建立理解，之后的**段落**才能依赖它们。
  > `:24` 下一**段**只能依赖已建立理解的概念……就下一**段**的形式展开讨论：段落、列表、表格、提示框、引文还是代码块。
  > `:30` 每个**概念**在被**段落**依赖之前……在前面的某个**段落**中已经接触过它。如果一个**段落**引用了尚未建立理解的概念，读者就会跟丢。
- 问题：block 是该 skill 的计量单位，明确包含列表、表格、提示框、引文、代码块；译文统一换成「段落」，造成三处后果：
  1. 规则的适用范围被收窄——只有段落受 grounding 约束，表格/列表/代码块里的未落地概念按中文字面不再受限；
  2. `:24` 出现自相矛盾句：「下一段的形式……段落、列表、表格」——「段落」同时被当作整体和形式之一；
  3. 同文档内一词两译（`:25`、`:71` 作「块」，其余作「段落」）。
- 影响：grounding 检查是 `writing-shape` 的核心机制，也是「逐段生长 + 每一步论证格式」的判据；收窄后智能体可能在一张表格里塞进读者尚未接触的概念而不自知。
- 建议改法：block 统一作「块」，paragraph 才作「段落」：
  - `:22` → 「其余概念都必须先由某个**块**建立理解，之后的**块**才能依赖它们。」
  - `:24` → 「下一个**块**只能依赖已建立理解的概念……就下一个**块**的形式展开讨论：段落、列表、表格、提示框、引文还是代码块。」
  - `:30` → 「每个**概念**在被**块**依赖之前……在更早的**块**中已经接触过它。如果一个**块**引用了尚未建立理解的概念，读者就会跟丢。」
  - `:35` → 「由某个**块**建立该概念」；`:37` → 「要么在更早的**块**中建立」。
  - `:25`、`:61`、`:71` 已有「块」，改完即一致。

---

## P2

| # | 文件:行 | 英文 | 中文 | 说明 / 建议 |
| --- | --- | --- | --- | --- |
| P2-01 | `in-progress/writing-shape/SKILL.md:49` `:63` `:65` | Is this **prose**, or should it be a list? / **Prose vs. list.** Prose carries argument | 这里是**散文**，还是应该做成列表？为什么用散文？ / **散文 vs. 列表。** 散文承载论证 | prose 指「成段的正文」，不是文学体裁「散文」；此处讲的是技术文章里连续行文与列表的取舍，译作「散文」会让智能体误以为要写文学化文风。建议统一为「成段文字（prose）」：「这里是成段文字，还是应该做成列表？为什么用成段文字？」 |
| P2-02 | `in-progress/writing-fragments/SKILL.md:36` `:38` | (one term that names the idea, the way _tracer bullets_ …) / the most valuable fragment to **land** | （就像 _tracer bullets_（示踪弹）……能概括一整套模式那样） / 引领词是最有价值的片段 | 两处漏译：`one term that names the idea`（一个为该想法命名的词）整句丢失，而这正是「引领词」的定义支点；`to land`（值得落地）也丢了。建议 `:36` 补为「（一个为该想法命名的词，就像 _tracer bullets_ 或 _fog of war_ 能概括一整套模式那样）」，`:38` 改为「引领词是最值得落地的片段」。 |
| P2-03 | `in-progress/loop-me/SKILL.md:3` | Grill me about **specs** for the workflows I want to build, **within this workspace**. | 围绕我想构建的工作流对我进行拷问，本工作区内使用。 | 触发描述漏掉 `specs`（产出物），且末句「本工作区内使用」悬空，读成「供本工作区使用」，与原文「在工作区内进行」不同。建议：「在当前工作区内，围绕我想构建的工作流**规格**对我进行拷问。」 |
| P2-04 | `in-progress/setup-ts-deep-modules/SKILL.md:3` | … User-invoked. | ……由用户调用。 | 同一词 `User-invoked` 在 `in-progress/README.md:16-17` 作「用户调用型」，此处作「由用户调用」，两种说法并存。建议统一为「用户调用型。」（claude-handoff 同句已无此问题） |
| P2-05 | `in-progress/chief-of-staff/SKILL.md:22` | Use background agents so you can stay in **active dialogue** with the user. | 使用后台智能体，使你能与用户保持**积极的对话**。 | active 是「持续/在线」，不是「积极（正面、热情）」，false friend 式偏移。建议「使你能与用户保持**持续的对话**」。 |
| P2-06 | `in-progress/loop-me/SKILL.md:18` `:20` vs `in-progress/chief-of-staff/SKILL.md:14` `:16` | a **schedule** (every morning) / recurring **schedules** | 一个**日程**（每天早上） / 周期性**定时任务** | 同一上游概念两个中文名（日程 / 定时任务），两个 skill 又同属一套 harness 调度语境。建议统一为「定时安排」或「定时任务」并在 `2026-10-27-terminology.md` 登记 `schedule`。 |
| P2-07 | `misc/migrate-to-shoehorn/SKILL.md:41` `:46` | `// Only care about body.id but must fake entire Request` / `// ...fake all 20 properties` | 原样英文 | 代码围栏内的注释按规则可译，且同批次的 `dependency-cruiser.config.cjs` 注释已全译，此处两处注释未译（漏译，非风格偏好）。建议译为「只关心 body.id，却必须伪造整个 Request」「……把 20 个属性全部伪造」。 |

---

## 复核通过项（逐项确认无问题）

- `misc/git-guardrails-claude-code`：`SKILL.md` 逐段一致；`scripts/block-dangerous-git.sh` 去注释后与英文**逐字节相同**，`BLOCKED: ...` 原样，仅多一行中文注释（可接受）。JSON 片段（含 `"$CLAUDE_PROJECT_DIR"` 转义）、验证命令原样。
- `misc/setup-pre-commit`：8 个步骤、`**Adapt**` 分支（无 `typecheck`/`test` 脚本则省略该行）、`.prettierrc` 默认值、提交信息字面串 `Add pre-commit hooks (husky + lint-staged + prettier)` 全部保留。
- `misc/scaffold-exercises`：目录命名规则、lint 规则 8 条（含 `explainer.1/`、`.gitkeep`、`speaker-notes.md`、`pnpm run exercise`）、`git mv` 示例、readme 桩映射全部对齐；模板 `# 练习标题` 属给人填写的内容，允许。
- `in-progress/claude-handoff`：`claude --bg --name "<descriptive name>" -- "$(cat <summary file>)"` 原样；「通过文件传递可避免 shell 执行反引号或展开 `$`」这一理由句未走样；`-n`/`--name` 的 `always` 译为「务必」，强度保持。
- `in-progress/writing-beats`：5 步流程（含「重复第 3–5 步」这一上游写法）与 `Grounding` 全部对齐；「已建立理解（grounded）」全篇统一；`[建立理解](#建立理解)` 锚点与中文标题一致。
- `in-progress/setup-ts-deep-modules`：六条规则/边界、`Done when` 五处、`PACKAGES_ROOT` 与 `.cjs` 说明、`tests-through-entrypoints` 实测步骤、`README.md` 上下文指针示例全部原样；`barrel` 首次括注英文，后续统一「桶文件」。
- `dependency-cruiser.config.cjs`：去掉注释后与英文完全一致（规则名、正则、`$1` 反向引用、severity 未动）。
- 全部 11 个 `agents/openai.yaml`：键名与 `allow_implicit_invocation: false` 原样，仅译 `display_name` / `short_description`。
- 11 个 `name:` 与目录名一致；`in-progress` 五个 beta skill 的 `disable-model-invocation: true` 均在位。
- `in-progress/README.md` 的 beta 提示按要求不计（有意添加）；6 条上游条目逐条对齐。
- 术语表核对：`skill` 全保留英文、`agent`→智能体、`subagent`→子智能体、`background agent`→后台智能体、`harness` 保留、`fixture`→夹具、`seam`→接缝、`pit of success`→「成功的坑」（pit of success）、`hack`→取巧手段、`workaround`→变通方案；未出现「技能 / 代理 / 模拟 / 方差 / 黑客 / 签名」等禁用译法；无 `CONTEXT.md` / `CONTEXT-MAP` 残留。

## 复核但未计入

- `in-progress/README.md:11` 多出 `chief-of-staff` 条目（英文版 README 未列该 skill，实际目录里有）。信息正确、且该 skill 为 `disable-model-invocation: true`，补上安装入口反而更完整，不构成误导；若要求与上游逐字对齐可删。
- `writing-fragments:36` 为 `_tracer bullets_` / `_fog of war_` 加中文括注，符合「保留原词 + 首次可括注」的约定。
- `writing-shape:55` 把 "read as one voice" 译作「读起来像一个声音」，略显直译，但语义未拧；未计入。

## 上一轮报告（2026-10-27 抽检）问题复核

| 旧编号 | 现状 |
| --- | --- |
| P2-13 `chief-of-staff:16` harness 反而不一致 | **已修复**：保留 `harness`，与术语表一致 |
| P2-14 `chief-of-staff:51` thrive | **已修复**：「在『成功的坑』（pit of success）里如鱼得水」 |
| P2-15 `chief-of-staff:53` 增译「功能单一」 | **已修复**：现为「极度受限、能力有限的 API 与函数」 |
| P2-16 `chief-of-staff:59` 生产环境日志 | **已修复**：「例如开发服务器或生产环境日志」 |
| P2-17 `chief-of-staff:63/65` workaround / hack | **已修复**：「不许有 workaround」规则 +「变通方案」「取巧手段」，已按建议分工 |
| P2-18 `chief-of-staff:9` 增译 DRI | **已修复**：缩写已删 |
| 复验项 `misc/git-guardrails-claude-code` | 无回归，仍与英文逐字节一致 |
