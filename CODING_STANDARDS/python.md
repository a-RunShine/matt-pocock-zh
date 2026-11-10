# CODING_STANDARDS.md（Python）

> **给谁看**：code review 阶段的 reviewer agent，不给 implementer 加载。
> **怎么来的**：每次 agent 犯错，挑一条记进来；能自动查的写成检查，只留判断题在这里。
> **怎么用**：review 时逐条对照 diff；已在工具里强制的规则，不在这里重复。
> **⚠️ 事故记录是示例**：所有"这仓库出过 N 次 bug"的说法都是编的，用时必须换成你项目里真实的那次。

本文件只写**机器判不了、但 reviewer 读 diff 时能判**的东西。凡是能写成 ruff 规则、类型约束或 pytest 的，一概不写在这里——去 `pyproject.toml` 的 `[tool.ruff]`、`Makefile` 的 `check` 目标里找。

---

## Style

### 每个 public 函数、类、属性都要有 docstring，写清参数含义、抛什么、返回 None 意味着什么

签名只说长什么样，不说什么情况下会坏。调用方读的是契约，缺了就得翻实现。

docstring 至少回答三件事：什么输入会抛 `ValueError`、什么情况返回 `None`、有没有顺序要求。

*Enforced by*: `ruff` 的 `D103`/`D101` 能查"有没有 docstring"，查不了"写没写对"。后半句由 review 执行。

---

### 不用可选参数表达"要么全传、要么全不传"，改成 `dataclass` 或两个函数

可选参数把四种合法组合都打开了，其中两种是错的。这仓库出过三次 bug，都是漏传一个可选参数导致的。〔示例事故〕

改用 `@dataclass(frozen=True)` 的参数对象，或者写两个函数名。

*Enforced by*: 无。签名的意图只能靠 review 读出来。

---

### 多处用同一个字符串字面量做比较时，改成 `Enum` 或 `Literal` 类型

字符串散落的那天起，就注定有人写错一个字符。这仓库现在有 4 处 `status == "resolved"`，其中 1 处是 `"resloved"`。〔示例事故〕

*Enforced by*: `mypy --strict` 下，`Literal["resolved"]` 写错会报错；历史代码的字符串比较待清理，靠 review 看到就改。

---

### 类型注解写完整，`mypy --strict` 通过

Python 里没有类型检查，等于整个项目只有一个运行时检查。`--strict` 下 `Any` 会传播，一次漏注解会让整条链失去类型保护。

确需逃生时用 `# type: ignore[具体错误码]`，不要裸 `# type: ignore`，也不要裸 `# noqa`。

*Enforced by*: `mypy --strict` 与 `ruff` 的 `PGH003`（禁止裸 ignore）。已接进 pre-commit。

---

## Testing

### 不要写同义反复的测试（tautological test）

`assert fn(input) == mock.return_value` 只证明 mock 在工作。测试必须断言一个独立于实现的观察结果：返回值、副作用、或调用方真正依赖的状态变化。

判断标准：如果实现改了、测试没改，这个测试是不是真的能红？不会红，它就是同义反复。

*Enforced by*: 无。这是 review 时的判断题。

---

### Mock 只允许用在 system boundary（网络、时钟、随机数、文件系统）

Mock 用在纯逻辑上，测试就变成"测试我们以为实现是什么样"。实现一改测试全红，改的都是同义反复。

本地可替代的依赖用**替身（test double）**，不要用 mock：替身是同一接口的另一个实现，mock 是对实现的假设。

Python 里具体说：`monkeypatch` 打到 `requests.get` 这类边界是合理的，打到内部 service 的私有方法就是错的。

*Enforced by*: 部分由 `conftest.py` 的 fixture 命名约定约束（`fake_*` 是替身，`mock_*` 是 mock）；"用在哪一层"由 review 判断。

---

### 每个 bug 修完，补一个能复现它的测试；测试名写清它在防什么

"修 bug 但不补测试"是这仓库 2026-03 到 2026-08 之间 5 次回归的共同原因。〔示例事故〕

测试名写 `test_rejects_when_token_expired`，不要写 `test_edge_case`。

*Enforced by*: 无。review 时看 diff 是否同时包含 fix 和 test。

---

### fixture 不要跨测试共享可变状态

`@pytest.fixture` 默认每次调用都新建实例，除非显式 `scope="session"`。共享可变 fixture 会让测试之间互相污染，且失败顺序相关，本地全绿、CI 随机红。

确需共享的只能是不可变配置。

*Enforced by*: 部分由 `pytest --strict-markers` 与 `ruff` 的 pytest 插件约束；"该不该共享"由 review 判断。

---

## Architecture

### 新的领域名词，继承它所挂靠对象的全部守卫

比如 `DraftGuard` 只管 `Post`，那么 `PostRevision` 挂在 `Post` 下面，就必须自动带上 `DraftGuard` 的写入检查，不能靠人记得。

判断方法：问一句"这个新名词挂在哪？它上面那层有什么检查？"漏掉一条就是数据损坏。

*Enforced by*: 部分由 `check_draft_guard.py` 覆盖；挂靠关系由 review 判断。

---

### 一个能力只有一个入口；别的地方不要自己拼实现

`format_duration` 已经在管时间格式化了，新代码不要再写 `f"{hours}h{minutes}m"`。这不是风格问题，是同一语义出现两套实现之后，bug 会出现在没被测的那套里。

新增入口之前，先确认现有入口真的扩展不了。

*Enforced by*: `check_single_impl.py` 查字符串拼接模式；判断"是否真的扩展不了"由 review 执行。

---

### 外部依赖必须通过注入的 port 进来，不要在实现里直接 import

`stripe`、`twilio`、`smtplib` 这类三方服务，在深度模块里必须走 port，transport 作为 adapter 注入。理由不是"好看"，是测试要能在不联网的情况下跑完整个逻辑。

只有一个 adapter 的 seam 是假 seam，别提前抽；等第二个 adapter 出现（通常是 production + test），再抽。

*Enforced by*: `import-linter` 的 `ForbiddenContract`（error 级），配置在 `pyproject.toml`。违反会红。

---

### 内部 seam 不要因为测试用得上，就开到公开接口上

测试需要观察内部状态时，改测试的观察方式，不要扩大接口。接口一旦变宽就收不回去，而"测试需要"是个会消失的理由。

Python 里具体说：不要给类加 `@property` 只为了让测试能读到私有字段；改用公开的查询方法或状态快照。

*Enforced by*: 无。review 看接口是否变宽、理由是否只是"测试需要"。

---

## 不写在这里的东西

以下内容**不进本文件**，否则会变成没人读的长文档：

| 内容 | 该去哪 |
|---|---|
| 缩进、引号、行宽、import 排序 | `ruff format` / `[tool.ruff]` |
| 命名规范、文件放哪 | `ruff` 的 `N`、`C`、`I` 规则组 |
| "要写测试""要有类型" | `make check` 的失败信号已经说了 |
| 环境怎么跑起来 | `README.md`、`Makefile` |
| 项目架构图 | `docs/ARCHITECTURE.md` |
| 依赖版本、包管理 | `uv.lock`、`pyproject.toml` |

---

## 这份文件怎么变长

1. 发现 agent 做了错的事。
2. 判断：**能机械判定吗？**
   - 能 → 写成检查（ruff 规则、pre-commit 钩子、CI job 里的哪个都行，挑最便宜的），不写在这里。
   - 不能 → 记一条到本文件，格式照上面：一句祈使句 + 为什么（带真实事故）+ 谁来强制。
3. 规则必须能追溯到一次真实事故。写不出事故的，多半是通用建议，删掉。

一份健康的 `CODING_STANDARDS.md` 只该有 5–15 条。超过这个数，说明该做成检查的还在文档里躺着。
