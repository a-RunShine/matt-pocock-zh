# GLOSSARY.md 格式

## 结构

```md
# {上下文名称}

{一两句话，描述这个上下文是什么，以及它为何存在。}

## 语言

**Order（订单）**：
{一两句话描述该术语}
_避免_：Purchase（购买）、transaction（交易）

**Invoice（发票）**：
发货后发送给客户的付款请求。
_避免_：Bill（账单）、payment request（付款请求）

**Customer（客户）**：
下订单的个人或组织。
_避免_：Client（客户端）、buyer（买家）、account（账户）
```

## 规则

- **要有主见。** 当同一概念存在多个词时，选出最好的一个，并把其他词列在 `_避免_` 之下。
- **定义保持精炼。** 最多一到两句话。定义它_是什么_，而不是它_做什么_。
- **只收录本项目上下文特有的术语。** 通用的编程概念（超时、错误类型、工具模式）不属于这里，即使项目大量使用它们。添加一个术语之前，先问：这是该上下文独有的概念，还是一般的编程概念？只有前者才属于这里。
- **当自然形成簇群时，按小标题分组。** 如果所有术语都属于同一个连贯的领域，平铺列表也可以。

## 单上下文与多上下文仓库

**单上下文（大多数仓库）：** 仓库根目录下有一个 `GLOSSARY.md`。

**多上下文：** 仓库根目录下的 `GLOSSARY-MAP.md` 列出各个上下文、它们所在的位置，以及它们之间的关系：

```md
# 术语地图

## 上下文

- [Ordering（订单）](./src/ordering/GLOSSARY.md)：接收并跟踪客户订单
- [Billing（计费）](./src/billing/GLOSSARY.md)：生成发票并处理付款
- [Fulfillment（履约）](./src/fulfillment/GLOSSARY.md)：管理仓库拣货和发货

## 关系

- **Ordering → Fulfillment**：Ordering 发出 `OrderPlaced` 事件；Fulfillment 消费它以开始拣货
- **Fulfillment → Billing**：Fulfillment 发出 `ShipmentDispatched` 事件；Billing 消费它以生成发票
- **Ordering ↔ Billing**：共享 `CustomerId` 和 `Money` 类型
```

skill 会推断适用哪种结构：

- 如果存在 `GLOSSARY-MAP.md`，读取它以找到各个上下文
- 如果只存在根目录的 `GLOSSARY.md`，则为单上下文
- 如果两者都不存在，则在第一个术语被确定时惰性地创建根目录的 `GLOSSARY.md`

存在多个上下文时，推断当前主题与哪一个相关。如果不清楚，就询问。
