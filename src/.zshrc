# PATH
export PATH="$HOME/.local/bin:$PATH"

# Zsh history
export HISTFILE="$HOME/.zsh_history"
export HISTFILESIZE=10000
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Tool history
export GDBHISTFILE=/dev/null
export NC_HISTORY=/dev/null
export PYTHON_HISTORY=/dev/null
export SQLITE_HISTORY=/dev/null

# Set colors and icons to 'man' and 'less'
export LESSUTFCHARDEF=e000-f8ff:p,f0001-fffff:p
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Emacs key bindings
bindkey -e
bindkey '^N' history-search-forward
bindkey '^P' history-search-backward
bindkey '^U' backward-kill-line

# Modern completion system
autoload -U compinit && compinit
eval "$(dircolors -b)"
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt '%S%p: Press TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose yes
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Aliases
alias cat='/usr/bin/bat'
alias diff='/usr/bin/diff --color=auto'
alias grep='/usr/bin/grep --color=auto'
alias hexedit='/usr/bin/hexedit --color'
alias ip='/usr/bin/ip -color=auto'
alias la='/usr/bin/lsd -a --group-directories-first'
alias ll='/usr/bin/lsd -l --group-directories-first'
alias lla='/usr/bin/lsd -la --group-directories-first'
alias ls='/usr/bin/lsd --group-directories-first'
alias wget='/usr/bin/wget --no-hsts'

# Functions

copyFile() {
  wl-copy < "$1" || return 1
  echo "[*] Copied: $(realpath -s -- "$1")"
}

extractPorts() {
  ipv4="$(grep -oPm1 '\d{1,3}(?:\.\d{1,3}){3}' "$1")" || return 1
  ports="$(grep -oP '\d+(?=/open)' "$1" | xargs | tr ' ' ',')" || return 1
  echo "[*] IPv4: $ipv4"
  echo "[*] Ports: $ports"
  wl-copy -- "$ports"
}

help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

mkt() {
    mkdir {content,exploits,recon}
}

rmk() {
    shred -zun 10 -- "$1"
}

rot13() {
  if [[ -f "$1" ]]; then
    tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$1"
  elif [[ -n "$1" ]]; then
    echo "$*" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
  else
    tr 'A-Za-z' 'N-ZA-Mn-za-m'
  fi
}

setTarget() {
    local file="$HOME/.config/waybar/target.txt"
    touch "$file"
    echo "< $(head -n 1 $file)"
    echo -n "$1" > "$file"
    echo "> $1"
}

# Zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-sudo/sudo.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fzf
source <(fzf --zsh)

# Starship prompt
PROMPT_EOL_MARK=''
eval "$(starship init zsh)"
