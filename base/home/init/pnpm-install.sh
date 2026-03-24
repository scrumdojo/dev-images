#!/usr/bin/env zsh
set -eu

~/init/zshenv-install.sh sh -c 'curl -fsSL https://get.pnpm.io/install.sh | bash'

. "$HOME/.zshenv"

pnpm config set store-dir "$WORKSPACE/.pnpm-store"
pnpm config set global-dir "$WORKSPACE/.pnpm-global"
pnpm config set global-bin-dir "$WORKSPACE/.pnpm-global/bin"
