# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# PATH checking
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    PATH="$HOME/bin:$PATH"
fi
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH

# Command history
export HISTCONTROL=ignoredups
export HISTFILESIZE=500
export HISTSIZE=500

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Terminal prompt
if [[ $EUID -eq 0 ]]; then PS1_COLOR='91'; else PS1_COLOR='92'; fi
PROMPT_COMMAND='PS1_GIT=$(git branch --show-current 2>/dev/null); echo'
PS1='\[\e[38;5;208;1m\]${PS1_GIT:+${PS1_GIT} }\[\e[0m\]\[\e[96;1m\]\w\[\e[0m\] \[\e[${PS1_COLOR};1m\]\$\[\e[0m\] '
