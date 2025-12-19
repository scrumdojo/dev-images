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

    # Only show branch if it's not main or master
    if [[ -n "$branch" && "$branch" != "main" && "$branch" != "master" ]]; then
        # Check for dirty state
        is_dirty=""
        if ! git -C "$current_dir" diff-index --quiet HEAD -- 2>/dev/null; then
            is_dirty="⚡ "
        fi
        git_info="$is_worktree🌿 $branch $is_dirty• "
    fi
fi

# Model
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Cost
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost=$(printf "\$%.2f" "$total_cost")

# Edits
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
changes=$((lines_added + lines_removed))

# Build status line
echo "🐳 $HOSTNAME • 📁 $current_dir • $git_info • 🤖 $model • 💰 $cost • ✏️ $changes edits (+$lines_added/-$lines_removed)"
