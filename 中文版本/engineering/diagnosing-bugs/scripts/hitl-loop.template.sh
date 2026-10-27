#!/usr/bin/env bash
# 人在回路的复现循环。
# 复制此文件，编辑下面的步骤，然后运行它。
# 智能体运行脚本；用户在终端中按提示操作。
#
# 用法：
#   bash hitl-loop.template.sh
#
# 两个辅助函数：
#   step "<指令>"               → 显示指令，等待回车
#   capture VAR "<问题>"        → 显示问题，将回答读入 VAR
#
# 最后，捕获的值会以 KEY=VALUE 的形式打印出来，供智能体解析。
#
# `capture` 会把它的值打印回终端，智能体从那里读取，
# 因此只捕获观察结果，把签名之类的操作作为 `step` 交给用户完成。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [完成后按回车] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 在下方编辑 ---------------------------------------------------------

step "打开应用 http://localhost:3000 并登录。"

capture ERRORED "点击 'Export' 按钮。它是否抛出了错误？(y/n)"

capture ERROR_MSG "粘贴错误信息（若无则填 'none'）："

# --- 在上方编辑 ---------------------------------------------------------

printf '\n--- 已捕获 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
