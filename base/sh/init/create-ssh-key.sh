#!/usr/bin/env bash
set -euo pipefail

# ---- helpers ---------------------------------------------------------------
prompt() {
    local label="$1" default="$2"
    local value
    read -r -p "$label [$default]: " value || true
    if [ -z "${value:-}" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

ensure_ssh_dirs() {
    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"

    touch "${HOME}/.ssh/known_hosts"
    chmod 600 "${HOME}/.ssh/known_hosts"

    touch "${HOME}/.ssh/config" || true
    chmod 600 "${HOME}/.ssh/config" || true
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

append_if_missing_known_hosts() {
    # $1=host $2=port
    local host="$1" port="$2"
    # Check if a host key for host:port already exists
    if ssh-keygen -F "$host" -f "${HOME}/.ssh/known_hosts" -p "$port" >/dev/null 2>&1; then
        echo "✓ known_hosts already has an entry for ${host}:${port}"
        return 0
    fi

    if ! have_cmd ssh-keyscan; then
        echo "⚠ ssh-keyscan not found; skipping host key prefill (StrictHostKeyChecking=accept-new will handle first connect)."
        return 0
    fi

    echo -n "→ Fetching host key for ${host}:${port} ... "
    if ssh-keyscan -p "$port" "$host" >> "${HOME}/.ssh/known_hosts" 2>/dev/null; then
        echo "done."
    else
        echo "failed (will rely on accept-new)."
    fi
}

upsert_ssh_config_block() {
    # $1=alias $2=hostname $3=port $4=identity_file $5=user
    local alias="$1" host="$2" port="$3" keyfile="$4" sshuser="$5"
    local cfg="${HOME}/.ssh/config"
    local begin="# >>> ${alias} (managed)"
    local end="# <<< ${alias} (managed)"

    # Remove any existing managed block for this alias
    awk -v begin="$begin" -v end="$end" '
        $0 ~ begin {skip=1; next}
        $0 ~ end {skip=0; next}
        skip!=1 {print}
    ' "$cfg" > "${cfg}.tmp" || true

    # Append fresh block
    {
        echo "$begin"
        echo "Host ${alias}"
        echo "  HostName ${host}"
        echo "  Port ${port}"
        echo "  User ${sshuser}"
        echo "  IdentityFile ${keyfile}"
        echo "  IdentitiesOnly yes"
        echo "  StrictHostKeyChecking accept-new"
        echo "$end"
    } >> "${cfg}.tmp"

    mv "${cfg}.tmp" "$cfg"
    chmod 600 "$cfg"
}

# ---- defaults --------------------------------------------------------------
DEFAULT_USER="$(whoami)"
DEFAULT_HOST="$(hostname)"
DEFAULT_MACHINE=""
DEFAULT_REMOTE_HOST=""
DEFAULT_REMOTE_PORT="2222"
DEFAULT_ALIAS="homelab"
DEFAULT_REMOTE_USER="git" # for remote git host SSH

# ---- interactive prompts ---------------------------------------------------
echo "====== SSH Key Wizard ======"
echo "Press Enter to accept defaults in [brackets]."

user="$(prompt 'Key username (used only in key name)' "$DEFAULT_USER")"
host="$(prompt 'Inner host (current container/WSL hostname)' "$DEFAULT_HOST")"
machine="$(prompt 'Outer machine name (optional)' "$DEFAULT_MACHINE")"

echo
echo "====== Remote git host ======"
remote_host="$(prompt 'Remote git host (enter to skip)' "$DEFAULT_REMOTE_HOST")"
remote_port="$(prompt 'Remote SSH port' "$DEFAULT_REMOTE_PORT")"
alias="$(prompt 'Create/Update SSH alias name' "$DEFAULT_ALIAS")"
remote_user="$(prompt 'Remote SSH user' "$DEFAULT_REMOTE_USER")"

# ---- compute key name/path -------------------------------------------------
if [ -n "$machine" ]; then
    key_tag="${user}@${host}@${machine}"
else
    key_tag="${user}@${host}"
fi

key_path="${HOME}/.ssh/${key_tag}"

# ---- sanity + prep ---------------------------------------------------------
ensure_ssh_dirs

if [ -e "$key_path" ] || [ -e "${key_path}.pub" ]; then
    echo "❌ Key already exists at: ${key_path}{,.pub}"
    echo "Aborting to avoid overwriting. (Run again with a different machine name/host/user.)"
    exit 1
fi

if ! have_cmd ssh-keygen; then
    echo "❌ ssh-keygen not found. Please install OpenSSH client tools."
    exit 1
fi

# ---- generate key (ed25519, no passphrase) --------------------------------
echo
echo "→ Generating key: ${key_path}"
ssh-keygen -t ed25519 -N "" -C "$key_tag" -f "$key_path" >/dev/null
chmod 600 "$key_path"
chmod 644 "${key_path}.pub"
echo "✓ Key created."

# ---- optional remote setup -------------------------------------------------
if [ -n "$remote_host" ]; then
    append_if_missing_known_hosts "$remote_host" "$remote_port"
    upsert_ssh_config_block "$alias" "$remote_host" "$remote_port" "$key_path" "$remote_user"
    echo "✓ SSH alias '${alias}' configured for ${remote_user}@${remote_host}:${remote_port}"
fi

# ---- finish: print public key ----------------------------------------------
echo
echo "====== Public key ======"
cat "${key_path}.pub"
echo
echo "Saved to: ${key_path}.pub"
if [ -n "$remote_host" ]; then
    echo "You can use either of these remote formats:"
    echo "  • Alias:    git@${alias}:<org>/<repo>.git"
    echo "  • Direct:   ssh://${remote_user}@${remote_host}:${remote_port}/<org>/<repo>.git"
fi

echo "Done."
