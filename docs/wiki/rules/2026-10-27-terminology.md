# 术语约定 2026-10-27

依据：[保真审计](../audits/2026-10-27-fidelity.md) 的跨文件术语表；落地提交 `32b3ce1`（2026-10-27）。

## 规则

- 标「保留」的词不翻译；首次出现可括注中文，之后直接用英文。
- 其余词首次出现可括注英文，之后统一用中文，不再中英混写。
- 新术语先查本页；新增或改判都要带日期。

下表条款均定于 2026-10-27（提交 `32b3ce1`），此后新增或改判在「备注」列标注日期。

## 约定

| 英文 | 中文 / 处理 | 备注 |
| --- | --- | --- |
| skill | 保留 | 全仓数量不固定，以实际译文为准 |
| agent | 智能体 | |
| subagent / sub-agent | 子智能体 | |
| background agent | 后台智能体 | |
| harness | 保留，必要时括注「运行装置」 | 不用「测试工具」 |
| triage | `/triage` 保留；概念用「分诊」 | |
| commit | 提交（名词可写「提交（commit）」） | |
| worktree | 保留 | |
| seam | 接缝 | |
| module / interface / depth | 模块 / 接口 / 深度 | |
| mock（动词） | 保留 | 不用「模拟」 |
| fixture | 夹具 | |
| tight（loop） | 短促而稳定 | 不用「紧凑」 |
| variance | 行为不稳定（variance） | 不是统计学的「方差」 |
| pit of success | 成功的坑（pit of success） | |
| progressive disclosure | 渐进式披露 | |
| disclosed reference | 外置（disclosed）参考 | 与「渐进式披露」同族 |
| post-completion steps | 完成后步骤 | 不写成「后续步骤」 |
| no-op | 无效指令（no-op） | |
| `_Avoid_` | 保留 | 术语表标记，不译 |
| GLOSSARY-MAP.md（概念） | 术语映射表 | 文件名保留 |
| sign in | 登录 | 不是「签名」 |
| workaround | 变通方案 | 首次可括注 workaround |
| hack | 取巧手段 | 不是「黑客手段」 |
| schedule | 定时任务 | 不写「日程」 |
| tracer bullet | 曳光弹（tracer bullet） | 不写「示踪弹」 |
| prose | 成段文字（prose） | 不是文学体裁「散文」 |
| block | 块 | paragraph 才译「段落」 |
| mass diagram | 体量图（面积对比图） | 不是「质量分布图」 |
| relentless | 不留情面 / 不依不饶 | 按词性选，不用「不间断」 |
| assets | 资产（assets） | 与 resources「资源」区分 |
| 分诊标签 / `wayfinder:*` / `BLOCKED:` / triage AI 声明 | 保留 | 见 [协议字符串](2026-10-27-protocol-strings.md) |
| task（工厂语境） | 任务 | 2026-11-02 新增，见 software-factory；与「运行」「执行器」成组 |
| run | 运行 | 2026-11-02 新增；与 harness「运行装置」不同义，正文不混用 |
| runner | 执行器（runner） | 2026-11-02 新增；不译「服务器 / 主机」，那些是上游明确的避免用语 |
| trigger | 触发器 | 2026-11-02 新增 |
| orchestrator | 编排器 | 2026-11-02 新增；不译「调度器」（dispatcher / scheduler 为避免用语） |
| ticket tracker | 工单跟踪器 | 2026-11-02 新增；不译「issue 跟踪器」（issue tracker 为避免用语） |
| ticket source | 工单来源 | 2026-11-02 新增；不译「数据源」（data source 为避免用语） |
| git host | git 托管平台 | 2026-11-02 新增；不译「代码托管」（code host 为避免用语） |
| observability platform | 可观测性平台 | 2026-11-02 新增 |

## 相关

- [协议字符串与脚手架](2026-10-27-protocol-strings.md)
- [保真审计 2026-10-27](../audits/2026-10-27-fidelity.md)
- [目标宪章 2026-10-27](../goals/2026-10-27-charter.md)
