# 测试中（In Progress）

> **Beta 版本提示：** 这些 skill 是有意公开的：请试用，并告诉作者哪里出了问题。它们在成为稳定版本之前不会被包含进插件和顶层 README，也没有文档页面，并且可能随时改动或消失。上游可能随时修改这些内容，本中文版是按当时的上游版本翻译的。

插件无法获取这些 skill。请直接安装其中一个：

```bash
npx skills@latest add mattpocock/skills --skill=<name>
```

- **[chief-of-staff](./chief-of-staff/SKILL.md)**：通过协调子智能体，在单个会话中推进一个长期目标。用户调用型。
- **[loop-me](./loop-me/SKILL.md)**：通过多次会话，把自己拷问成可实现的工作流规格，以当前目录作为有状态的工作区。用户调用型。
- **[writing-beats](./writing-beats/SKILL.md)**：把文章塑造成一段由节拍组成的旅程，选择你自己的冒险风格。选定一个起始节拍，只写该节拍，然后转向下一个，直到文章抵达自然的结尾。
- **[writing-fragments](./writing-fragments/SKILL.md)**：拷问会话，挖掘你的写作片段（各式各样的写作碎片），并把它们追加到单个文档中，作为日后文章的原始素材。
- **[writing-shape](./writing-shape/SKILL.md)**：接收一份原始素材的 markdown 文件，逐段把它塑造成文章，并在每一步论证格式选择。
- **[claude-handoff](./claude-handoff/SKILL.md)**：把当前对话交接给一个全新的后台智能体，让它立即接手工作；交接摘要通过 `claude --bg` 作为其提示词传入。用户调用型。
- **[setup-ts-deep-modules](./setup-ts-deep-modules/SKILL.md)**：在 TypeScript 仓库中接入 dependency-cruiser，使每个包都成为深度模块：实现隐藏在子文件夹中，只能通过入口文件访问，测试也通过这些入口文件行使它。用户调用型。
