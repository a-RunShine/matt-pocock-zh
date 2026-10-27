# 领域文档

工程类 skill 在探索代码库时，应当如何使用本仓库的领域文档。

## 探索之前，先阅读这些

- 仓库根目录的 **`GLOSSARY.md`**，或
- 如果存在，仓库根目录的 **`GLOSSARY-MAP.md`**：它指向每个上下文各自的 `GLOSSARY.md`。阅读与该主题相关的每一个。
- **`docs/adr/`**：阅读涉及你即将工作的区域的 ADR。在多上下文仓库中，还应检查 `src/<context>/docs/adr/` 中限定于上下文的决定。

如果这些文件中有任何一个不存在，就**静默继续**。不要指出它们的缺失，也不要预先建议创建它们。`/domain-modeling` skill（通过 `/grill-with-docs` 和 `/improve-codebase-architecture` 调用）会在术语或决定真正被确定时才惰性地创建它们。

## 文件结构

单上下文仓库（大多数仓库）：

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

多上下文仓库（根目录存在 `GLOSSARY-MAP.md`）：

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← 系统级决定
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← 上下文级决定
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## 使用术语表中的词汇

当你的输出提到某个领域概念（在 issue 标题、重构提案、假设或测试名称中）时，使用 `GLOSSARY.md` 中定义的术语。不要滑向术语表明确避免的同义词。

如果你需要的概念尚未出现在术语表中，这就是一个信号：要么你在发明项目并不使用的语言（重新考虑），要么确实存在缺口（记下来，留给 `/domain-modeling`）。

## 标记 ADR 冲突

如果你的输出与某个现有 ADR 相矛盾，应明确指出，而不是悄悄覆盖：

> _与 ADR-0007（事件溯源的订单）相矛盾，但值得重新审视，因为……_
