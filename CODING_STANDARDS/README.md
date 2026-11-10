# CODING_STANDARDS

三份**可以直接拷进项目使用**的编码规范模板：TypeScript、Python、Java。

| 文件 | 技术栈 | 参考工具链 |
| --- | --- | --- |
| [typescript.md](typescript.md) | TypeScript | oxlint、dependency-cruiser |
| [python.md](python.md) | Python | ruff、mypy --strict、import-linter |
| [java.md](java.md) | Java | Checkstyle、SpotBugs、Error Prone、ArchUnit |

## ⚠️ 用之前先读这段

**所有事故记录都是示例，是编的。** 比如"2026-03 到 2026-08 五次回归"这类说法，并不对应任何真实仓库。

每条规则都必须能追溯到一次真实事故——这是模板自己写下的规则。**照抄进项目而不替换事故，等于引用从没发生过的 bug**，读的人会失去对整份文件的信任。

正确用法：

1. 读一遍，理解**形态**（祈使句标题 + 为什么 + 谁在强制）
2. 拷进项目，改名成 `CODING_STANDARDS.md`
3. 逐条替换"为什么"，写你项目里真实出过的事；写不出事故的规则就删掉

## 这三份是什么、不是什么

**是**：从 `/research` 调研 Matt Pocock 的 `CODING_STANDARDS.md` 约定之后，归纳出的模板形态。三条共同原则：

- 规范**属于 reviewer**，不是 implementer——review 时才加载，不为实现阶段花 token
- **机械规则做成检查**，`full stop`。check 会红，句子不会。这里只留机器判不了的判断题
- 每条都要挂上**谁在强制**：某个 lint 规则、某个测试，或者显式写"无。这是 review 时的判断题"

**不是**：Matt Pocock skill 的内容。上游 `mattpocock/skills` 里没有 `CODING_STANDARDS.md`，那只是一个约定——skill 假设"你的仓库里应该有这个文件"。

**也不是**：本仓库自身的规范。本仓库是文档项目，没有代码；这些模板是向外提供的参考。

## 使用姿势

每个项目的 `CODING_STANDARDS.md` **只该有 5–15 条**。超过这个数，说明该做成检查的还躺在文档里。

写之前先过一遍判据：**如果这条能写成 lint 规则、类型约束或测试，就不要写进文档。** 剩下的通常是领域不变式、单一入口、跨文件一致性、"看起来对但其实是错"的设计教训、接口契约要求。

配套的 `AGENTS.md` 只留几行 pointer，不要把规范抄进去——它每次会话都加载，规则写在那里等于为每条规则付一次 token。

## 相关

- 调研报告：[docs/reports/2026-11-10-coding-standards-research.md](../docs/reports/2026-11-10-coding-standards-research.md)
- 立此为照的决策：[docs/wiki/decisions/2026-11-10-standards-templates.md](../docs/wiki/decisions/2026-11-10-standards-templates.md)
