# 生产力（Productivity）

通用工作流工具，不限于代码。

## 用户调用

只有当你输入它们时才会触发（Claude Code：`disable-model-invocation: true`；Codex：`agents/openai.yaml` 中的 `policy.allow_implicit_invocation: false`）。

- **[grill-me](./grill-me/SKILL.md)**：让人对一项计划或设计进行无情的访谈，直到设计树的每个分支都得到解决。
- **[handoff](./handoff/SKILL.md)**：把当前对话压缩为一份交接文档，使另一个智能体可以接续工作。
- **[teach](./teach/SKILL.md)**：在多次会话中教用户一项新技能或概念，以当前目录作为有状态的教学工作区。
- **[to-questionnaire](./to-questionnaire/SKILL.md)**：把一个你无法独自回答的决定，转化为一份 Markdown 问卷，交给唯一能回答的那个人（可以异步填写，也可以在会议中一起填）。
- **[wait-what](./wait-what/SKILL.md)**：消息没被理解的那一刻就触发它。智能体会用你缺少的背景，以平白的英语，并使用你的 `GLOSSARY.md` 词汇，重新表述。

## 模型调用

模型或用户都可以触发（带有丰富的触发措辞，以便模型主动使用它们）。

- **[grilling](./grilling/SKILL.md)**：对一项计划、决定或想法进行无情的访谈，直到设计树的每个分支都得到解决。
- **[writing-for-agents](./writing-for-agents/SKILL.md)**：为智能体撰写文档：skill、AGENTS.md/CLAUDE.md，以及智能体通过指针访问的任何文档。
