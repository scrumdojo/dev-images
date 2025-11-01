#!/bin/bash

set -e

# Detect Debian arch → release asset arch
arch="$(dpkg --print-architecture)"
case "$arch" in
    amd64)  asset_arch="x86_64" ;;
    arm64)  asset_arch="aarch64" ;;
    *)
        echo "Unsupported architecture: $arch" >&2
        exit 1
        ;;
esac

tmpdir="$(mktemp -d)"
cleanup() {
    rm -rf "$tmpdir";
}
trap cleanup EXIT

# Fetch latest release asset URL without jq
api_url="https://api.github.com/repos/microsoft/edit/releases/latest"
echo "Querying: $api_url"
asset_url="$(
    curl -sL "$api_url" \
        | grep -oE "https://github.com/microsoft/edit/releases/download/[^\" ]*edit-[0-9.]+-${asset_arch}-linux-gnu\.tar\.zst" \
        | head -n1
)"

if [[ -z "${asset_url:-}" ]]; then
  echo "Could not find a matching asset for ${asset_arch}" >&2
  exit 1
fi

echo "Downloading: $asset_url"
curl -L "$asset_url" -o "$tmpdir/edit.tar.zst"

# Decompress & extract
zstd -d "$tmpdir/edit.tar.zst" -o "$tmpdir/edit.tar"
tar -xf "$tmpdir/edit.tar" -C "$tmpdir"

# Install binary as /usr/local/bin/edit
install -m 0755 "$tmpdir/edit" /usr/local/bin/edit

echo "Microsoft Edit installed: $(/usr/local/bin/edit --version || true)"
