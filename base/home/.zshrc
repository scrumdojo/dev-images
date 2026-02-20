# History
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY

# Better defaults
setopt AUTO_CD             # cd by typing directory name
setopt CORRECT             # Autocorrect typos in commands

# Aliases
alias bat='batcat'

PATH="$HOME/.local/bin:$PATH"
PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
PATH="$WORKSPACE/.pnpm-global/bin:$PATH"
