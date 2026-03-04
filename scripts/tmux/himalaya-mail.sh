#!/bin/sh
set -eu

session="himalaya-mail"
log_prefix="[himalaya-mail]"
config_default="$HOME/Library/Application Support/himalaya/config.toml"
config="${HIMALAYA_CONFIG:-$config_default}"

if ! command -v tmux >/dev/null 2>&1; then
  echo "$log_prefix tmux not found"
  exit 1
fi

if ! command -v himalaya >/dev/null 2>&1; then
  echo "$log_prefix himalaya not found"
  exit 1
fi

if [ ! -f "$config" ]; then
  echo "$log_prefix config not found at $config"
  exit 0
fi

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

gmail_accounts="$(awk '
  /^\[accounts\.[^]]+\][[:space:]]*$/ {
    account = $0
    sub(/^\[accounts\./, "", account)
    sub(/\][[:space:]]*$/, "", account)
    next
  }
  account != "" && /^[[:space:]]*email[[:space:]]*=[[:space:]]*"/ {
    email = $0
    sub(/^[[:space:]]*email[[:space:]]*=[[:space:]]*"/, "", email)
    sub(/".*$/, "", email)
    if (tolower(email) ~ /@gmail\.com$/ || tolower(email) ~ /@googlemail\.com$/) {
      printf "%s\t%s\n", account, email
    }
    account = ""
  }
' "$config")"

if [ -z "$gmail_accounts" ]; then
  echo "$log_prefix no Gmail accounts found in $config"
  exit 0
fi

count="$(printf "%s\n" "$gmail_accounts" | awk 'NF { c += 1 } END { print c + 0 }')"
echo "$log_prefix creating session with $count Gmail account(s)"

first_line="$(printf "%s\n" "$gmail_accounts" | head -n 1)"
rest_lines="$(printf "%s\n" "$gmail_accounts" | tail -n +2 || true)"

tab="$(printf '\t')"
IFS="$tab" read -r first_account first_email <<EOF
$first_line
EOF

tmux new-session -d -s "$session" -n "$first_account"
tmux send-keys -t "$session:$first_account" "clear; echo \"[$first_account] $first_email\"; himalaya envelope list -a \"$first_account\" -f INBOX --page-size 25 || true" C-m

printf "%s\n" "$rest_lines" | while IFS="$tab" read -r account email; do
  [ -n "$account" ] || continue
  tmux new-window -t "$session" -n "$account"
  tmux send-keys -t "$session:$account" "clear; echo \"[$account] $email\"; himalaya envelope list -a \"$account\" -f INBOX --page-size 25 || true" C-m
done

tmux select-window -t "$session:$first_account"
echo "$log_prefix ready"
