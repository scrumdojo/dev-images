#!/usr/bin/env zsh
#
# Run an installer that appends to .zshrc, then move what it
# appended into .zshenv instead. Idempotent on re-runs.

set -eu

zshrc="$HOME/.zshrc"
zshenv="$HOME/.zshenv"
pre=$(wc -c < "$zshrc")

"$@"

appended=$(tail -c +"$(( pre + 1 ))" "$zshrc")
[ -z "$appended" ] && exit 0
head -c "$pre" "$zshrc" > "$zshrc.tmp" && mv "$zshrc.tmp" "$zshrc"

fingerprint=$(printf '%s\n' "$appended" | grep -m1 '.' || true)
grep -qF "$fingerprint" "$zshenv" || printf '%s\n' "$appended" >> "$zshenv"
