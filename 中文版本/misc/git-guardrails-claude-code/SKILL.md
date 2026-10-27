---
name: git-guardrails-claude-code
description: 设置 Claude Code 钩子，在危险的 git 命令（push、reset --hard、clean、branch -D 等）执行之前将其拦截。当用户希望防止破坏性的 git 操作、添加 git 安全钩子，或在 Claude Code 中阻止 git push/reset 时使用。
---

# 设置 Git 护栏

设置一个 PreToolUse 钩子，在 Claude 执行危险的 git 命令之前将其拦截并阻止。

## 会被阻止的内容

- `git push`（所有变体，包括 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被阻止时，Claude 会看到一条消息，告知它无权访问这些命令。

## 步骤

### 1. 询问作用范围

询问用户：是仅为**当前项目**安装（`.claude/settings.json`），还是为**所有项目**安装（`~/.claude/settings.json`）？

### 2. 复制钩子脚本

随附的脚本位于：[scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

根据作用范围，将其复制到目标位置：

- **项目级**：`.claude/hooks/block-dangerous-git.sh`
- **全局**：`~/.claude/hooks/block-dangerous-git.sh`

使用 `chmod +x` 使其可执行。

### 3. 将钩子添加到设置中

添加到对应的设置文件中：

**项目级**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**全局**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

如果设置文件已存在，请把钩子合并进已有的 `hooks.PreToolUse` 数组中。不要覆盖其他设置。

### 4. 询问是否需要自定义

询问用户是否想为被阻止的列表添加或移除某些模式。相应地编辑复制后的脚本。

### 5. 验证

运行一次快速测试：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

应以退出码 2 退出，并向 stderr 打印 BLOCKED 消息。
