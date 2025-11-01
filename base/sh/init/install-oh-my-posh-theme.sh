#!/bin/bash

set -e

OMP_DIR="/home/$USER/.oh-my-posh"
THEME_URL="https://raw.githubusercontent.com/ksmutny/win-config/main/config/oh-my-posh/nebula-surge.omp.json"

curl -s $THEME_URL > "$OMP_DIR/theme.omp.json"
