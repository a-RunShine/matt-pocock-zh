# CODING_STANDARDS.md（TypeScript）

> **给谁看**：code review 阶段的 reviewer agent，不给 implementer 加载。
> **怎么来的**：每次 agent 犯错，挑一条记进来；能自动查的写成检查，只留判断题在这里。
> **怎么用**：review 时逐条对照 diff；已在工具里强制的规则，不在这里重复。
> **⚠️ 事故记录是示例**：所有"这仓库出过 N 次 bug"的说法都是编的，用时必须换成你项目里真实的那次。

本文件只写**机器判不了、但 reviewer 读 diff 时能判**的东西。凡是能写成 lint 规则、类型约束或测试的，一概不写在这里——去 `package.json` 里的 `check` 命令找。

---

## Style

### 每个 public 暴露的函数、属性、类型都必须有 JSDoc，且写清 invariants、错误模式、null 的含义

签名只说"长什么样"，不说"什么情况下会坏"。调用方按签名写代码，读的是 invariants 和 error modes，缺了就得去翻实现。

JSDoc 至少回答三件事：什么输入会让它抛错、什么输入会返回 `undefined`、有没有顺序要求。

*Enforced by*: `jsdoc/require-param` 能查"有没有注释"，查不了"写没写对"。后半句由 review 执行。

---

### 不要用可选参数表达"要么全传、要么全不传"，改成重载或参数对象

可选参数把四种合法组合都打开了，其中两种是错的。这个仓库出过三次 bug，都是漏传其中一个可选参数导致的。〔示例事故〕

改用参数对象，或者写两个函数名。

*Enforced by*: 无。签名的意图只能靠 review 读出来。

---

### 多个 `if` 用同一个字符串字面量做比较时，改成一次枚举定义

字符串散落的那天起，就注定有人会写错一个字符。这个仓库现在有 4 处 `status === "resolved"`，其中 1 处是 `"resloved"`。〔示例事故〕

*Enforced by*: `unicorn/prefer-enum`（配置在 `.oxlintrc.json`）。已覆盖新代码，历史代码待清。

---

## Testing

### 不要写同义反复的测试（tautological test）

`expect(fn(input)).toEqual(mockReturnValue)` 只证明 mock 在工作。测试必须断言一个**独立于实现**的观察结果：返回值、副作用、或调用方真正依赖的状态变化。

判断标准：如果实现改了、测试没改，这个测试是不是真的能红？如果不会红，它就是同义反复。

*Enforced by*: 无。这是 review 时的判断题。

---

### Mock 只允许用在 system boundary（网络、时钟、随机数、文件系统）

Mock 用在纯逻辑上，测试就变成"测试我们以为实现是什么样"。实现一改测试全红，改的都是同义反复。

本地可替代的依赖用**替身（test double）**，不要用 mock：替身是同一接口的另一个 adapter，mock 是对实现的假设。

*Enforced by*: 部分由 `mock-factory.ts` 约束（只暴露这四种 boundary 的 mock 工厂）；"用在哪一层"由 review 判断。

---

### 每个 bug 修完，补一个能复现它的测试；测试名里写清楚它在防什么

"修 bug 但不补测试"是这个仓库 2026-03 到 2026-08 之间 5 次回归的共同原因。〔示例事故〕

测试名写 `should reject when token expired`，不要写 `test edge case`。

*Enforced by*: 无。review 时看 diff 是否同时包含 fix 和 test。

---

## Architecture

### 新的领域名词，继承它所挂靠对象的全部守卫

比如 DraftGuard 只管 `Post`，那么 `PostRevision` 挂在 `Post` 下面，就必须自动带上 DraftGuard 的写入检查，不能靠人记得。

判断方法：问一句"这个新名词挂在哪？它上面那层有什么检查？"漏掉一条就是数据损坏。

*Enforced by*: 部分由 `check-draft-guard.ts` 覆盖；挂靠关系由 review 判断。

---

### 一个能力只有一个入口；别的地方不要自己拼实现

`formatDuration` 已经在管时间格式化了，新代码不要再写 `hours + "h" + minutes + "m"`。这不是风格问题，是同一语义出现两套实现之后，bug 会出现在没被测的那套里。

新增入口之前，先确认现有入口真的扩展不了。

*Enforced by*: `check-single-impl.sh` 查字符串拼接模式；判断"是否真的扩展不了"由 review 执行。

---

### 外部依赖必须通过注入的 port 进来，不要在实现里直接 import

`Stripe`、`Twilio`、`SMTP` 这类三方服务，在深度模块里必须走 port，transport 作为 adapter 注入。理由不是"好看"，是**测试要能在不联网的情况下跑完整个逻辑**。

只有一个 adapter 的 seam 是假 seam，别提前抽；等第二个 adapter 出现（通常是 production + test），再抽。

*Enforced by*: `dependency-cruiser` 的 `no-external-direct-import`（error 级）。配置改了会红。

---

### 内部 seam 不要因为测试用得上，就开到公开接口上

测试需要观察内部状态时，改测试的观察方式，不要扩大接口。接口一旦变宽就收不回去，而"测试需要"是个会消失的理由。

*Enforced by*: 无。review 看接口是否变宽、理由是否只是"测试需要"。

---

## 不写在这里的东西

以下内容**不进本文件**，否则会变成没人读的长文档：

| 内容 | 该去哪 |
|---|---|
| 缩进、引号、分号、import 顺序 | 格式化器 / lint 配置 |
| 命名规范、文件放哪 | `eslint` 规则、`dependency-cruiser` 规则 |
| "要写测试""要有类型" | `npm run check` 的失败信号已经说了 |
| 环境怎么跑起来 | `README.md` |
| 项目架构图 | `docs/ARCHITECTURE.md` |

---

## 这份文件怎么变长

1. 发现 agent 做了错的事。
2. 判断：**能机械判定吗？**
   - 能 → 写成检查（lint 规则、pre-commit 钩子、CI job 里的哪个都行，挑最便宜的），不写在这里。
   - 不能 → 记一条到本文件，格式照上面：一句祈使句 + 为什么（带真实事故）+ 谁来强制。
3. 规则必须能追溯到一次真实事故。写不出事故的，多半是通用建议，删掉。

一份健康的 `CODING_STANDARDS.md` 只该有 5–15 条。超过这个数，说明该做成检查的还在文档里躺着。
