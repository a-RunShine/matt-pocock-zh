# 上游更新比对与同步报告（2026-10-29）

## 结论摘要

- **上游前进了**：`mattpocock/skills` 的 `main` 从 `5beb35b`（2026-10-19）前进到 `59db609`，中间 2 个提交。
- **影响译本的只有 3 个文件**，全部在 `skills/engineering/setup-matt-pocock-skills/` 下；其余 7 个变更文件不在译本范围内。
- 3 个文件已由上游原文覆盖 `英文版本/`，并重译到 `中文版本/`；其余 104 个文件未动。
- `verify_zh.py` 全绿；`deploy_zh.py --apply` 同步 3 个文件到 `~/.qoder-cn/skills`，复查漂移为 0。
- 仍为 38 个 skill / 107 个文件，无新增 skill、无目录结构调整。

## 1. 上游状态

| 项 | 值 |
| --- | --- |
| 仓库 | `https://github.com/mattpocock/skills` |
| 上一基线 | `5beb35b`（2026-10-19） |
| 默认分支 / HEAD | `main` @ `59db609eb1e18aaf59b63284d0e52255aff0c63c` |
| 最新发布标签 | `v1.3.1`（指向 `24fe0ef`，2026-10-04，未变） |
| 有无新发版 | 无。`package.json` 与 `CHANGELOG.md` 仍停在 1.3.1 |

克隆位置：`C:/Users/Administrator/AppData/Local/Temp/mattpocock-skills-upstream`（纯英文临时路径）。

## 2. 本次上游提交

| commit | 标题 | PR |
| --- | --- | --- |
| `ed0de59` | `setup-matt-pocock-skills: reachable repo, legacy CONTEXT.md, tracker template fixes` | #1228 |
| `59db609` | `Close blank issues and route requests by kind` | #1169 |

## 3. 逐文件变更清单（`5beb35b` → `59db609`）

上游共 10 个文件变更（`git diff --stat`：93 插入、19 删除）。

### 3.1 影响译本（3 个，已同步并重译）

| 文件 | 变更内容 |
| --- | --- |
| `skills/engineering/setup-matt-pocock-skills/SKILL.md` | 探索阶段新增对旧 `CONTEXT.md` / `CONTEXT-MAP.md` 的检查，并提供 `git mv` 改名选项；Section A 新增「tracker 需要可访问仓库」步骤，以 `gh repo view` / `glab repo view` 能输出项目为完成标准 |
| `skills/engineering/setup-matt-pocock-skills/issue-tracker-github.md` | Conventions 新增原生阻塞依赖（`--blocked-by` / `--add-blocked-by`）与「统计未关闭阻塞项」；关闭方式改为先 `gh issue comment` 再 `gh issue close`（说明 `--comment` 在已关闭 issue 上会丢评论）；新增「只向用户自己的仓库提 issue」约束；PR 读取改为先 `gh pr view` 再 `--comments`；Wayfinding 的阻塞与前沿查询改为引用 Conventions |
| `skills/engineering/setup-matt-pocock-skills/issue-tracker-gitlab.md` | `glab mr list -F json` → `-O json`；子工单新增 `--linked-issues <map> --link-type relates_to`；前沿查询改用 `glab api projects/:id/issues/<map>/links` 并保留带 `wayfinder:<type>` 标签的未关闭 issue |

### 3.2 不影响译本（7 个，未处理）

| 文件 | 原因 |
| --- | --- |
| `.changeset/github-tracker-own-repo.md` | 发布元数据 |
| `.changeset/setup-reachable-repo-and-tracker-recipes.md` | 发布元数据 |
| `.github/ISSUE_TEMPLATE/bug.yml` | 上游仓库自用模板 |
| `.github/ISSUE_TEMPLATE/config.yml` | 上游仓库自用模板 |
| `.github/ISSUE_TEMPLATE/idea.yml` | 上游仓库自用模板 |
| `CONTRIBUTING.md` | 上游仓库贡献指南 |
| `docs/engineering/domain-modeling.md` | 上游 `docs/` 下的 FAQ 改动（旧的 `CONTEXT.md` 命名问答改为「为什么不叫 CONTEXT.md」）；`中文版本/` 下不存在该页译文，无需同步 |

## 4. 同步动作与验证

| 步骤 | 结果 |
| --- | --- |
| `英文版本/` 覆盖 3 个文件 | 完成，`git diff --stat` 与上游对应文件一致 |
| `中文版本/` 重译 3 个文件 | 完成；未在旧译文上打补丁，按新原文重译 |
| `python scripts/verify_zh.py` | 全绿（四桶对齐、frontmatter、`name` 同名、`openai.yaml` 键结构、旧术语、协议字符串计数、beta 提示、3 个脚本语法） |
| `python scripts/deploy_zh.py --apply` | 同步 3 个文件，备份至 `~/.qoder-cn/skills-backup-20261029-162631` |
| 复查漂移 | 0 |
| 提交 | `4af69ff`（同步与基线更新）、`85d9c16`（wiki 记录）、`f2159eb`（修正 `AGENTS.md` 的 `deploy_zh.py --check`） |

## 5. 过程中的问题与处置

- **校验拦下一处误译**：重译 `SKILL.md` 时初稿写出了旧文件名 `CONTEXT.md`，触发 `verify_zh.py` 的旧术语检查。改为「v1.3.0 之前的旧版上下文文件」的表述后通过，未进入提交。
- **协议字符串计数因英文原文滞后而不一致**：重译后 `wayfinder:<type>` 在中文为 5 处、英文为 4 处。原因是上游 GitLab 模板新增了一处，而本地英文原文仍是旧版。覆盖英文原文后计数一致。
- **`AGENTS.md` 的部署命令有误**：第 6 步写 `deploy_zh.py --check`，但脚本无此参数，执行会以 usage error 退出。已改为默认只读检查的写法（`f2159eb`）。

## 6. 相关

- [上游状态 2026-10-29](../wiki/upstream/2026-10-29-state.md)
- [上游更新比对报告 2026-10-27](2026-10-27-upstream-delta.md)
- [目标宪章 2026-10-27](../wiki/goals/2026-10-27-charter.md)
