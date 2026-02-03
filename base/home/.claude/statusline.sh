# See https://code.claude.com/docs/en/statusline

# Read Claude Code session data JSON from stdin
input=$(cat)

# Get the working directory from Claude Code session data
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
if [[ "$current_dir" == "$HOME"* ]]; then
    current_dir="~${current_dir#$HOME}"
fi

# Get git info
git_info=""
if git rev-parse --git-dia > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)

    # Check if we're in a worktree
    is_worktree=""
    if git rev-parse --git-common-dir > /dev/null 2>&1; then
        git_common_dir=$(git rev-parse --git-common-dir)
        git_dir=$(git rev-parse --git-dir)
        if [[ "$git_common_dir" != "$git_dir" ]]; then
            is_worktree="🌳 "
        fi
    fi

    if [[ -n "$branch" ]]; then
        # Check for dirty state
        is_dirty=""
        if ! git -C "$current_dir" diff-index --quiet HEAD -- 2>/dev/null; then
            is_dirty="🪶"
        fi
        git_info="$is_worktree🌿 $branch $is_dirty"
    fi
fi

# Model
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Format context percentage
context_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
if [[ "$context_percentage" != "0" && "$context_percentage" != "null" ]]; then
    context_info="${context_percentage}%"
else
    context_info="N/A"
fi

# Cost
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost=$(printf "\$%.2f" "$total_cost")

# Format token usage with thousands separators
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
input_tokens_formatted=$(printf "%'d" "$input_tokens" 2>/dev/null || echo "$input_tokens")
output_tokens_formatted=$(printf "%'d" "$output_tokens" 2>/dev/null || echo "$output_tokens")
token_info="${input_tokens_formatted} in / ${output_tokens_formatted} out"

# Edits
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
changes=$((lines_added + lines_removed))

# Build status line
echo "🐳 $HOSTNAME • 📁 $current_dir • $git_info • 🤖 $model • 📊 $context_info • 💰 $cost • 🔢 $token_info • ✏️ $changes edits (+$lines_added/-$lines_removed)"
