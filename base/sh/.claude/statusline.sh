#!/bin/bash

# See https://code.claude.com/docs/en/statusline

# Read JSON input from stdin
input=$(cat)

# Parse Claude Code session data using jq
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Calculate total edits (lines added + removed)
changes=$((lines_added + lines_removed))

# Format cost (round to 2 decimal places)
cost_formatted=$(printf "%.2f" "$total_cost")

# Get hostname
host=$(hostname)

# Get current directory with ~ substitution
current_dir="$PWD"
if [[ "$current_dir" == "$HOME"* ]]; then
    current_dir="~${current_dir#$HOME}"
fi

# Get git info
git_info=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)

    # Only show branch if it's not main or master
    if [[ -n "$branch" && "$branch" != "main" && "$branch" != "master" ]]; then
        # Check for dirty state
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        git_info=" • 🌿 $branch ⚡• "
        else
        git_info=" • 🌿 $branch • "
        fi
    else
        git_info=" • "
    fi
else
    git_info=" • "
fi

# Build status line
echo "🐳 $host • 📁 $current_dir$git_info🤖 $model • 💰 \$$cost_formatted • ✏️ $changes edits (+$lines_added/-$lines_removed)"
