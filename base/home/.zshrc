# Enable color support ($LS_COLORS)
eval "$(dircolors -b)"

# History
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Better defaults
setopt AUTO_CD               # cd by typing directory name
setopt CORRECT               # Autocorrect typos in commands
setopt NO_BEEP               # Disable terminal bell
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shell

# Completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                     # arrow-navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # colored completions

# Aliases
alias bat='batcat'

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# syntax-highlighting must be last
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History substring search key bindings
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# fzf defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

PATH="$HOME/.local/bin:$PATH"
PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
PATH="$WORKSPACE/.pnpm-global/bin:$PATH"
