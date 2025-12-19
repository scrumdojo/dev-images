# Non-interactive shell check (disabled)
# - fnm install modifies .bashrc, so we need to allow non-interactive shells to run it
# - AVOID any echo or interactive commands in this file!
# [[ $- != *i* ]] && return

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Better defaults
shopt -s checkwinsize   # Update LINES/COLUMNS after each command
shopt -s cdspell        # Autocorrect typos in cd
shopt -s dirspell       # Autocorrect typos in tab completion

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias ..='cd ..'

# Editor
export EDITOR=nano
export VISUAL=$EDITOR

PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
PATH="$WORKSPACE/.pnpm-global/bin:$PATH"
