# 上游更新比对报告（2026-10-27）

## 结论摘要

- **上游没有前进**：`mattpocock/skills` 的 `main` 仍停在 `5beb35b`（2026-10-19），与 `AGENTS.md` 声明的基线 commit 完全一致。
- **本地英文 107 个文件与上游 HEAD 完全相同**（CRLF 归一化后逐一哈希），新增 0 / 修改 0 / 删除 0。
- **但版本标注有偏差**：`v1.3.1` 标签实际指向 `24fe0ef`（2026-10-04），比 `5beb35b` 早 15 天。`5beb35b` 是 `v1.3.1` 之后、尚未发版的 `main` 末端，仓库里有 17 个未消费的 changeset。
- 以 `v1.3.1` 发布标签为基准看，`5beb35b` 相对它改了 **18 个 skill 文件（16 改 + 1 新增 skill 共 2 个文件）**；这些改动**已经全部在本地英文基线和中文译文中**，因此本次 **没有任何文件需要重译**。
- 仍为 38 个 skill / 107 个文件，无新增 skill（相对本地基线）、无目录结构调整。

## 1. 上游状态

| 项 | 值 |
| --- | --- |
| 仓库 | `https://github.com/mattpocock/skills` |
| 默认分支 / HEAD | `main` @ `5beb35b040e3de97e54fa9e386d7e42d15c295c2` |
| HEAD 提交时间 | 2026-10-19 16:51:40 +0100 |
| HEAD 提交标题 | `chief-of-staff: keep memory in a dated, commit-cited wiki (#1304)` |
| `package.json` version | `1.3.1`（私有包，未因新提交递增） |
| 最新发布标签 | `v1.3.1`（annotated tag `0b6cee1` → commit `24fe0ef7737efae15c87225755e9f6f5965e4888`，2026-10-04） |
| `CHANGELOG.md` 最新条目 | `## 1.3.1` |
| 待发布 changeset | 17 个（见下） |

克隆位置：`C:/Users/Administrator/AppData/Local/Temp/mattpocock-skills-upstream`（仓库外临时路径，已按流程重新 `git clone --depth 1`，并 `git fetch --depth 1 origin tag v1.3.1`）。

## 2. v1.3.1 之后发布的版本与条目

**没有新版本。** `CHANGELOG.md` 顶格仍是 `## 1.3.1`，`package.json` 也是 `1.3.1`。`v1.3.1` 之后没有新 tag（远端 tag 列表止于 `v1.3.1`）。

不过 `main` 上积压了 17 个未发版 changeset，下一次发版（`1.3.2` 或 `1.4.0`）会包含：

| changeset | 主题 |
| --- | --- |
| `ask-matt-read-skill-first.md` | ask-matt 先读 skill 原文再复述或建议跳过 |
| `chief-of-staff-wiki.md` | chief-of-staff 用带日期、带 commit 引用的 wiki 保存记忆 |
| `code-review-standards-and-subagents.md` | code-review 标准来源全仓搜索；子智能体并行派发 |
| `diagnosing-bugs-prove-mutation.md` | 证明为制造红灯而做的改动确实生效 |
| `github-tracker-external-pr-list.md` | GitHub 外部 PR 分诊改用 `gh api` 分页 |
| `grilling-yes-accepts-recommendation.md` | 问题措辞让「是」接受推荐答案 |
| `handoff-temp-dir.md` | handoff 明确各平台临时目录 |
| `implement-skill-tool-wording.md` | implement 改用显式 Skill 工具调用 |
| `implement-ticket-reference.md` | implement 接收工单引用并先报标题 |
| `setup-tracker-fixes.md` | setup 时创建缺失的 tracker 标签 |
| `tdd-seam-tradeoffs.md` | tdd 每个接缝补一行取舍说明 |
| `teach-quiz-answer-position.md` | teach 测验正确答案轮换位置 |
| `teach-workspace-root.md` | teach 工作区路径解析规则 |
| `to-tickets-sub-issues.md` | to-tickets 支持原生子 issue 关系 |
| `wayfinder-labels-refs-research-prs.md` | wayfinder 标签唯一性、真实 id、research 分支不开 PR |
| `wizard-template-fixes.md` / `wizard-template-fixes-2.md` | wizard 模板交互与 .env 写入加固 |

## 3. 验证方法与结果

1. 删除旧的半成品临时目录后重新 `git clone --depth 1 https://github.com/mattpocock/skills`。
2. `git fetch --depth 1 origin tag v1.3.1` 取到发布标签；`git ls-remote origin refs/heads/main` 确认远端 `main` 末端就是 `5beb35b`。
3. 对本地 4 个英文桶的 107 个文件逐个与 `skills/<bucket>/...` 比对：先 `tr -d '\r'` 归一化行尾，再比 SHA-256；同时用 `comm` 比对相对路径集合。
4. 结果：

```
same=107  diff=0  missing=0  extra=0
```

即本地英文基线 = 上游 HEAD，**不是**「无法验证 commit」的情形：远端分支指针和内容两侧都验证过。本地只存在 `wiki/`、`reports/` 这类仓库自身目录，不属于 4 个桶的比对范围。

## 4. 变更统计

### 4.1 相对上游 HEAD（本任务要求的基线对比）

| 新增 | 修改 | 删除 |
| --- | --- | --- |
| 0 | 0 | 0 |

### 4.2 相对 `v1.3.1` 发布标签（仅供解释「v1.3.1」标注，已包含在本地基线中）

| 新增 | 修改 | 删除 | 行数 |
| --- | --- | --- | --- |
| 2（新 skill `chief-of-staff`） | 16 | 0 | +150 / -47 |

## 5. 逐文件清单与摘要（`v1.3.1` → `5beb35b`，均已在本地基线中）

### 5.1 修改（16）

1. `engineering/ask-matt/SKILL.md` — 新增一句硬性要求：在说明某个 skill 做什么、或建议跳过某一步之前，必须先读该 skill 的 `SKILL.md`，此处的概述只用于定位。
2. `engineering/code-review/SKILL.md` — issue tracker 文档改为泛称「tracker doc」，不再写死 `docs/agents/issue-tracker.md`；标准来源改为全仓搜索，`CODING_STANDARDS.md` / `CONTRIBUTING.md` 存在时必须入列；并要求两个子智能体调用同时、前台发出后聚合报告。
3. `engineering/diagnosing-bugs/SKILL.md` — 在第 2 步「看着它失败」后补充：若是通过改代码或夹具强制制造红灯，须与原始副本 `diff` 证明改动真的生效。
4. `engineering/implement/SKILL.md` — 用户传入工单引用时先从 tracker 取回并报出标题，引用含糊则追问；把 `/tdd`、`/code-review` 的口语引用改成显式「调用 Skill 工具」。
5. `engineering/setup-matt-pocock-skills/SKILL.md` — 当 B 节在 GitHub / GitLab 上跑过，要为 tracker 缺失的每个已配置标签执行 `gh label create` / `glab label create`。
6. `engineering/setup-matt-pocock-skills/issue-tracker-github.md` — 读 issue 改为 `gh issue view --json ...`；新增「把 issue 设为子 issue」操作及旧版 `gh` 的数据库 id 兜底；外部 PR 分诊改用 `gh api --paginate` + `author_association` 过滤；wayfinder 子工单指向新操作。
7. `engineering/setup-matt-pocock-skills/issue-tracker-gitlab.md` — `glab issue list` 的输出参数由 `-F json` 改为 `-O json`；前沿查询的链接端点改为按子 issue 的 iid 取。
8. `engineering/setup-matt-pocock-skills/triage-labels.md` — 「编辑右栏」改为明确点名「Label in our tracker」列。
9. `engineering/tdd/SKILL.md` — 确认接缝时，每个提议的接缝要补一行说明：能抓住什么、会漏掉什么。
10. `engineering/to-tickets/SKILL.md` — 若来源是已有 issue，发布时把每张工单设为它的子 issue；用原生阻塞边时省略模板里的 `Blocked by` 段。
11. `engineering/wayfinder/SKILL.md` — 地图与工单只带 `wayfinder:` 标签、绝不带 `ready-for-agent` 之类分诊标签；第二轮接线时才写真实 id（占位 `#<n>` 会误自动链接）；research 分支推送但不开 PR；解决工单时按 `wayfinder:<type>` 标签判类型。
12. `engineering/wizard/template.sh` — 模板加固：删掉未用的 `RED`；`_clear` 的 tput 回退修正；`ask` 改用 Readline 且 EOF 无输入即失败；`_existing` 能还原单/双引号包裹的 .env 值；`write_env` 写单引号值、以 0600 创建、穿透符号链接、并回填变量；阶段代码整体包进 `run_wizard` 后 `exit`；`open_url` 失败处理收敛到统一告警。
13. `in-progress/claude-handoff/SKILL.md` — 摘要先落到系统临时目录，再用 `-- "$(cat <summary file>)"` 以文件内容作提示词，避免 shell 执行反引号或展开 `$`。
14. `productivity/grilling/SKILL.md` — 新增一句：每个问题的措辞要让回答「是」就等于接受推荐答案。
15. `productivity/handoff/SKILL.md` — 临时目录写清楚：优先 `$TMPDIR`，否则 `/tmp`，Windows 用 `%TEMP%`。
16. `productivity/teach/SKILL.md` — 说明工作区路径从运行 `/teach` 的目录解析、只有 `*-FORMAT.md` 链接相对 skill 目录；测验要求正确答案在各题间轮换位置，且不得通过格式或顺序给线索。

### 5.2 新增（1 个 skill，2 个文件）

17. `in-progress/chief-of-staff/SKILL.md` — 新 skill：以「幕僚长」身份在单个长会话中协调子智能体与定时任务推进长期目标；所有工作下沉到子智能体以保护上下文，靠上下文指针（研究笔记、commit、wiki 页）通信；核心是持久化 wiki：`index.md` 索引、每页一件事、只引用不复述来源，并强调「写历史不写现状」（每条断言带日期，涉及代码的带 commit），外加持续改善智能体运行环境（pit of success、数据源、无 workaround）。
18. `in-progress/chief-of-staff/agents/openai.yaml` — 新 skill 的 Codex 元数据：`display_name: "Chief Of Staff"`、`short_description`，`policy.allow_implicit_invocation: false`。

> 说明：第 17 项正是上游 HEAD 提交 `chief-of-staff: keep memory in a dated, commit-cited wiki (#1304)` 的主题，也是 `v1.3.1` 标签里完全没有的内容。

## 6. 对中文译文的影响

- **因上游前进而需要重译的文件：0 个。**
- **需要新增翻译的 skill：0 个。**
- 上述 18 个文件的英文改动已全部存在于本地基线，且 `中文版本/` 对应文件已经体现了这些改动，抽查证据：
  - `ask-matt`：第 11 行「在说明某个 skill 做什么……之前，先阅读该 skill 的 SKILL.md」。
  - `code-review`：第 36 行「在仓库中搜索所有记录了代码应当如何编写的文件……」。
  - `diagnosing-bugs`：第 125 行「与一份原始副本做 `diff`，证明该修改确实生效了」。
  - `implement`：第 9、11、15 行（工单引用、Skill 工具调用）。
  - `setup-matt-pocock-skills`：第 104 行创建缺失标签；`issue-tracker-github.md` 子 issue 与 `gh api --paginate`；`issue-tracker-gitlab.md` 的 `-O json`；`triage-labels.md` 列名。
  - `tdd`：第 24 行「对每个提议的接缝，用一行说明它能抓住什么、会漏掉什么」。
  - `to-tickets`：第 63 行子 issue 处理；`wayfinder`：第 65、115、124 行标签唯一性、不开 PR、按标签判类型。
  - `wizard/template.sh`：第 106、111、137、196-222 行（Readline、0600、`run_wizard` 包裹）。
  - `chief-of-staff`：中文 68 行，与英文 HEAD 版一一对应（含 wiki 章节）。
  - `claude-handoff`、`grilling`、`handoff`、`teach`：对应句子均已译出。
- 结论：`中文版本/` 与英文基线一样，已处在 `5beb35b`，不存在「英文已更新、中文滞后」的情况。

## 7. 本地基线是否仍为 v1.3.1

**按 commit：是当前上游 HEAD；按发布版本：不是 v1.3.1。**

- `AGENTS.md` 写「v1.3.1（commit `5beb35b`）」，其中 commit 正确，但它不是 `v1.3.1` 标签的内容：`v1.3.1` 标签是 `24fe0ef`（2026-10-04），`5beb35b` 是 `main` 在 2026-10-19 的末端，中间还夹着 15 天未发版的改动。
- 因此更准确的表述是「`main` @ `5beb35b`，即 1.3.1 之后、1.3.2/1.4.0 之前的未发布状态」。
- 实操风险：若后续同步时以 `v1.3.1` 标签（`24fe0ef`）为基准重置，会丢掉 18 个文件的改动，并直接删除 `chief-of-staff` skill，破坏 38 skill / 107 文件的 1:1 结构。同步与校验都应以 commit `5beb35b`（或当时的 `main` 末端）为准。

## 8. 建议的后续动作

1. 本次**不需要翻译**，`中文版本/` 无需改动。
2. 可选（需另行授权）：把 `AGENTS.md` 的版本表述改为「`main` @ `5beb35b`（1.3.1 之后未发布）」，避免下次误用 release tag 对齐。
3. 待上游发布下一个版本（changeset 消费、`package.json` 递增、出现新 tag）后，重跑本流程；届时 `CHANGELOG.md` 会首次出现 1.3.1 之后的条目。
