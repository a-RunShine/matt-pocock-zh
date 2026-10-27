#!/usr/bin/env bash
#
# 向导（wizard）会一步步带领人类完成一个手动流程。
# 由 /wizard skill 生成。
#
# "STAGES" 标记之上的所有内容都是向导库：不要手动编辑。
# 请在该标记之下编写每个步骤的阶段。

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# 向导库：体验友好且一致，所有向导完全相同。
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""
fi

# 作者在阶段部分的开头设置此值。
TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # 本次运行写入 ENV_FILE 的 KEY
WRITTEN_SECRET=() # 本次运行设置的 secret 名称
SKIPPED=()        # 无法完成的事项（例如缺少 gh）

# _clear 清空终端，使屏幕上只显示当前步骤。输出不是终端时不执行任何操作，
# 使管道日志保持可读。
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1 && tput clear 2>/dev/null; then return 0; fi
  printf '\033[2J\033[3J\033[H'
}

# banner "标题" 显示开场画面：本向导做什么。
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  共 %s 个阶段%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  由你在浏览器中操作；本向导会准确告诉你该做什么，并捕获你复制回来的值。\n' "$DIM"
  printf '  随时可以按 Ctrl-C 停止，之后重新运行即可，因为它会记住已保存的值。%s\n' "$RESET"
  pause "准备好开始了吗？"
}

# stage "名称" 清空屏幕，然后宣布一个阶段并显示进度。
# 清屏可以只保留当前步骤在屏幕上。
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%s▸ 阶段 %s/%s · %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

# say "..." 打印一行普通说明。
say()  { printf '  %s\n' "$1"; }
# step "..." 是人类在浏览器中要执行的一个动作。
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL 在人类的浏览器中打开它，跨平台，包括 WSL。
open_url() {
  local url="$1"
  printf '  %s↗ 正在打开%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else false; fi
  } >/dev/null 2>&1 || warn "无法打开浏览器，请手动访问：$url"
}

# pause "消息" 等待人类确认他们已完成手动部分。
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-按回车继续}" "$RESET"
  read -r _ || true
}

# confirm "问题" 是一个 y/N 确认门；回答 yes 时返回成功。
confirm() {
  local reply=""
  printf '  %s? %s [y/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[Yy] ]]
}

# _existing KEY：ENV_FILE 中 KEY 的当前值（如果有），并撤销 write_env 写入的
# 单引号或普通 dotenv 双引号值。
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line value sq="'\\''"; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  value="${line#*=}"
  if [[ "$value" == \'*\' ]]; then value="${value:1:${#value}-2}"; value="${value//"$sq"/\'}"
  elif [[ "$value" == \"*\" ]]; then
    value="${value:1:${#value}-2}"
    [[ "$value" == *[\\\$\"]* ]] && return 1   # 含转义、$ 或 "：无法安全解码，需重新询问
  fi
  printf '%s' "$value"
}

# ask KEY "提示" 将值读入 $KEY。重新运行时，将 .env 中的现有值作为默认值提供
# （直接按回车即保留）。输入可见（非机密），可用 Readline 编辑。
# 在 EOF 且无输入时失败。
ask() {
  local key="$1" prompt="$2" current input s=$'\001' e=$'\002' p rc=0
  current=$(_existing "$key" || true)
  # Readline 需要把颜色码包裹在 \001..\002 中，才能正确定位光标。
  p="  $s$BOLD$e$prompt$s$RESET$e "
  [[ -n "$current" ]] && p+="$s$DIM$e[按回车保留当前值]$s$RESET$e "
  read -e -r -p "$p" input || rc=1
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret KEY "提示" 与 ask 类似，但输入是隐藏的。
ask_secret() {
  local key="$1" prompt="$2" current input rc=0
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[按回车保留当前值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || rc=1
  printf '\n'
  if (( rc )) && [[ -z "$input" ]]; then return 1; fi
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env KEY VALUE 将 KEY='VALUE' 写入（upsert）到 ENV_FILE（替换已有的同名行），
# 并设置 $KEY。具有幂等性。若文件不存在，则以 0600 权限创建；通过符号链接写入，
# 并保留已有文件的权限。
write_env() {
  local key="$1" value="$2" tmp sq="'\\''"
  [[ -e "$ENV_FILE" ]] || (umask 077 && : > "$ENV_FILE")
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf "%s='%s'\n" "$key" "${value//\'/$sq}" >> "$tmp"
  cat "$tmp" > "$ENV_FILE"
  rm -f "$tmp"
  printf -v "$key" '%s' "$value"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ 已写入%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

# set_secret NAME VALUE 通过 gh 设置 GitHub Actions 仓库 secret。如果 gh 不可用或未认证，
# 则退化为警告（并记录下来）。
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ 已设置%s GitHub secret %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub secret $name（请手动设置：gh secret set $name）")
  warn "已跳过 GitHub secret $name：gh 尚未就绪；请稍后设置"
}

# set_var NAME VALUE 设置 GitHub Actions 仓库变量（非机密）。
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ 已设置%s GitHub 变量 %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub 变量 $name")
  warn "已跳过 GitHub 变量 $name，gh 尚未就绪；请稍后设置"
}

# finish 先清屏，然后显示所有已配置内容的结束摘要。
finish() {
  _clear
  printf '\n%s%s  ✓ 设置完成%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "已向 $ENV_FILE 写入 ${#WRITTEN_ENV[@]} 个值：${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "已设置 ${#WRITTEN_SECRET[@]} 个 GitHub secret：${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "仍需手动完成："
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES：在此部分编写。每个人类操作步骤对应一个 stage()。
# 替换下面的示例。TOTAL_STAGES 应与你编写的阶段数一致。
# 请把每个阶段都放在 run_wizard 之内，并保持最后一行不变：bash 会在第一次提示前
# 解析整个文件，因此运行途中的编辑不会破坏它。
# ──────────────────────────────────────────────────────────────────────────

run_wizard() {

TOTAL_STAGES=1

banner "Stripe 设置"

# ── 示例阶段：替换为你的真实步骤 ───────────────────────────────────────────
stage "Stripe：API 密钥"
say "我们将获取你的 Stripe 测试密钥，并为本地开发和 CI 保存它们。"
open_url "https://dashboard.stripe.com/test/apikeys"
step "在 API keys 页面上，复制 Publishable key（以 pk_test_ 开头）。"
ask STRIPE_PUBLISHABLE_KEY "粘贴 publishable key："
step "在 Secret key 那一行点击 'Reveal test key'，然后复制它。"
ask_secret STRIPE_SECRET_KEY "粘贴 secret key："
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # CI 需要这一个
# ──────────────────────────────────────────────────────────────────────────

finish
}

run_wizard "$@"; exit
