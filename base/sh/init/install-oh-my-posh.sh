#!/bin/bash

set -e

HOME_DIR="/home/$USER"
OMP_DIR="$HOME_DIR/.oh-my-posh"
BASHRC="$HOME_DIR/.bashrc"

# Install oh-my-posh
echo "export PATH=\"$HOME_DIR/.local/bin:\$PATH\"" >> "$BASHRC"
curl -s https://ohmyposh.dev/install.sh | bash -s

# Configure .bashrc
mkdir -p "$OMP_DIR"
echo "eval \"\$(oh-my-posh init bash --config $OMP_DIR/theme.omp.json)\"" >> "$BASHRC"
