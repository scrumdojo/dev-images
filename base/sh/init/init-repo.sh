#!/usr/bin/env bash
set -euo pipefail

# --- helpers ---
prompt_with_default() {
    # $1 = prompt label, $2 = current default value, returns chosen value on stdout
    local label="$1" default="${2-}" input
    if [[ -n "$default" ]]; then
        read -r -p "$label [$default]: " input || true
        echo "${input:-$default}"
    else
        read -r -p "$label: " input || true
        echo "${input}"
    fi
}

# --- interactive input (env as defaults) ---
GITHUB_REPO="$(prompt_with_default 'GITHUB_REPO' "${GITHUB_REPO-}")"
FORGEJO_REPO="$(prompt_with_default 'FORGEJO_REPO (optional)' "${FORGEJO_REPO-}")"

# --- validation ---
if [[ -z "$GITHUB_REPO" ]]; then
    echo "[ERROR] GITHUB_REPO is required." >&2
    exit 1
fi

# --- clone to home ---
cd ~
# Normalize and parse repo name (strip trailing slash, remove .git suffix)
_trimmed="${GITHUB_REPO%/}"
repo_leaf="${_trimmed##*/}"
repo_name="${repo_leaf%.git}"

target_dir="$WORKSPACE/$repo_name"

if [[ -d "$target_dir/.git" ]]; then
    echo "[INFO] Repository already exists at: $target_dir (skipping clone)"
else
    git clone "$GITHUB_REPO" "$target_dir"
fi

# --- optionally add/update forgejo remote ---
if [[ -n "$FORGEJO_REPO" ]]; then
    cd "$target_dir"
    echo "[INFO] Adding remote 'homelab' -> $FORGEJO_REPO"
    git remote add homelab "$FORGEJO_REPO"
    echo "[INFO] Current remotes:"
    git remote -v
fi
