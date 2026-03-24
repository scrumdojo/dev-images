#!/usr/bin/env zsh
set -eu

~/init/zshenv-install.sh sh -c 'curl -fsSL https://fnm.vercel.app/install | bash'

sed -i 's/fnm env/fnm env --use-on-cd/' "$HOME/.zshenv"
