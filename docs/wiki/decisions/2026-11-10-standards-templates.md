# 2026-11-10 编码规范模板收进仓库

## 决定

2026-11-10，用户要求把 `/research` 调研产出的三份编码规范示例（TypeScript / Python / Java）收进本仓库，并在全局 README 说明。决定如下：

- 目录名 `CODING_STANDARDS/`，放在**仓库根**，不放 `docs/`。
- 文件名按语言区分：`typescript.md`、`python.md`、`java.md`，目录内另有一份 `README.md` 索引与使用说明。
- 全局 `README.md` 在「装到本地」之后加一节「附：编码规范模板」，并同步「目录结构」代码块。

## 理由

### 为什么放仓库根，不放 `docs/`

`AGENTS.md` 定义 `docs/` 为「元数据，不属于产出物」。这三份是**供人拷走使用的实体内容**，性质上是产出物，放进 `docs/` 与该定义矛盾。放根目录与 `英文版本/`、`中文版本/`、`实操/` 并列，位置与身份一致。

放 `docs/standards/` 也曾考虑过，因为它们确实是参考材料；最终否决的理由是上面那条定义冲突。

### 为什么保留示例事故，而不是全部改成占位符

2026-11-10 有三个候选：

- **A**：全部改成「换成你项目的真实事故」占位符
- **B**：保留完整示例，但每条事故行显式标注〔示例事故〕，目录 `README.md` 顶部再挂醒目提示
- **C**：TypeScript 那份保留完整示例，Python 与 Java 用占位符

选 **B**。这套规范的说服力来自具体事故细节，抽空细节就退化成它自己批评的「通用建议」。显式标注 + 顶层提示，可以在保留示范力的同时避免被照抄成假事故。

代价是已知的：这套文件**违反了它自己的第 3 条规则**（「规则必须能追溯到一次真实事故」）。这是有意的取舍，并在 `CODING_STANDARDS/README.md` 中明确写出，不是疏忽。

## 边界

- **不是 Matt Pocock skill 的内容**。上游 `mattpocock/skills` 里没有 `CODING_STANDARDS.md`，那只是 skill 假设「你的仓库里应该有这个文件」的约定。这三份是从 `/research` 的调研结论归纳出的模板形态。
- **不是本仓库自身的规范**。本仓库是文档项目，没有代码。`AGENTS.md` 里已写明这一点，避免误认。
- **不参与桶内对齐**，不属于译文产出物。`verify_zh.py` 只扫 `英文版本/` 与 `中文版本/` 四个桶，`deploy_zh.py` 只遍历 `中文版本/`，两者都不碰 `CODING_STANDARDS/`。
- 桌面上保留了原始三份副本（`CODING_STANDARDS.md`、`CODING_STANDARDS-python.md`、`CODING_STANDARDS-java.md`），由用户自行管理，不随仓库走。

## 依据

调研来源见 [调研：Matt Pocock 的 CODING_STANDARDS 与给 agent 的编码规范](../../reports/2026-11-10-coding-standards-research.md)。核心结论：规范属 reviewer 而非 implementer；机械规则做成确定性检查；深模块只有边界可机械化。

## 相关

- [调研报告](../../reports/2026-11-10-coding-standards-research.md)
- [CODING_STANDARDS 索引](../../../CODING_STANDARDS/README.md)
