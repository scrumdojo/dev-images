#!/usr/bin/env sh

set -eu

case "$(uname -m)" in
    x86_64) lazygit_arch="Linux_x86_64" ;;
    aarch64|arm64) lazygit_arch="Linux_arm64" ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

# Resolve latest version via redirect, avoiding the unauthenticated GitHub API rate limit
lazygit_version="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazygit/releases/latest | sed 's|.*/tag/v||')"
tmpdir="$(mktemp -d)"

cleanup() {
    rm -rf "$tmpdir"
}

trap cleanup EXIT INT TERM

curl -fLo "$tmpdir/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_${lazygit_arch}.tar.gz"
tar -xf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit

mkdir -p "$HOME/.local/bin"
install -m 0755 "$tmpdir/lazygit" "$HOME/.local/bin/lazygit"

"$HOME/.local/bin/lazygit" --version
