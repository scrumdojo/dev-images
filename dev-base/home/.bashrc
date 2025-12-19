# Non-interactive shell check
[[ $- != *i* ]] && return

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
