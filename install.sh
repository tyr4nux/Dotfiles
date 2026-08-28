#!/bin/bash

if [[ $EUID -eq 0 ]]; then
  echo 'Do not run this script as root.' >&2
  exit 1
fi

GROUP_ID="$(id -g)"

if [[ -z "$USER" || -z "$UID" || -z "$GROUP_ID" ]]; then
  echo 'Could not determine USER, UID or GID correctly.' >&2
  exit 1
fi

if [[ -z "$HOME" || ! -d "$HOME" ]]; then
  echo "Could not determine home directory for $USER." >&2
  exit 1
fi

# Directory containing this script
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)" || exit 1

checkSudo() {
  case "$1" in
  "/root" | "/root"/*)
    echo '/usr/bin/sudo'
    ;;
  *)
    echo ''
    ;;
  esac
}

ensureValidDst() {
  local dst="$1"
  local parent="$(dirname -- "$dst")"

  # Check if requires sudo
  local sudoRun="$(checkSudo "$parent")"

  if $sudoRun [ -L "$parent" ]; then
    echo "Refusing parent being a symlink: $parent" >&2
    return 1
  fi

  # Create parent directory
  case "$parent" in
  "$HOME" | "$HOME"/*)
    if $sudoRun [ ! -d "$parent" ]; then
      install -o "$UID" -g "$GROUP_ID" -m 700 -d -- "$parent" || return 1
    fi
    ;;
  "/root" | "/root"/*)
    if $sudoRun [ ! -d "$parent" ]; then
      sudo install -o root -g root -m 700 -d -- "$parent" || return 1
    fi
    ;;
  *)
    echo "Refusing destination outside $HOME or /root: $dst" >&2
    return 1
    ;;
  esac
}

genSymLink() {
  if [[ $# -ne 2 ]]; then
    echo 'Usage: genSymLink <src> <dst>' >&2
    return 1
  fi

  local from="$1"
  local to="$2"

  if [[ ! -e "$from" ]]; then
    echo "Source does not exist: $from" >&2
    return 1
  fi

  if [[ -L "$from" ]]; then
    echo "Refusing to use symlink as source: $from" >&2
    return 1
  fi

  from="$(realpath -e -- "$from")" || {
    echo "Could not resolve source: $from" >&2
    return 1
  }

  # Ensure destination is in $HOME or /root
  ensureValidDst "$to" || return 1

  # Check if requires sudo
  local sudoRun="$(checkSudo "$to")"

  # Ensure destination is empty
  if $sudoRun [ -L "$to" ]; then
    $sudoRun unlink -- "$to" || return 1
  elif $sudoRun [ -f "$to" ]; then
    $sudoRun mv -- "$to" "$to.bak" || return 1
  elif $sudoRun [ -d "$to" ]; then
    echo "Refusing to replace existing directory: $to" >&2
    return 1
  fi

  # Link files
  $sudoRun ln -s -- "$from" "$to" || return 1
  echo "Linked: $to -> $from"
}

cpTemplate() {
  if [[ $# -ne 2 ]]; then
    echo 'Usage: cpTemplate <src> <dst>' >&2
    return 1
  fi

  local from="$1"
  local to="$2"

  if [[ ! -f "$from" ]]; then
    echo "Source must be an existing file: $from" >&2
    return 1
  fi

  from="$(realpath -e -- "$from")" || {
    echo "Could not resolve source: $from" >&2
    return 1
  }

  # Ensure destination is in $HOME or /root
  ensureValidDst "$to" || return 1

  # Check if requires sudo
  local sudoRun="$(checkSudo "$to")"

  # Backup file
  if $sudoRun [ -f "$to" ]; then
    $sudoRun mv -- "$to" "$to.bak" || return 1
  elif $sudoRun [ -d "$to" ]; then
    echo "Refusing to replace existing directory: $to" >&2
    return 1
  fi

  # Copy template file to destination
  case "$to" in
  "$HOME" | "$HOME"/*)
    install -o "$UID" -g "$GROUP_ID" -m 600 -- "$from" "$to" || return 1
    ;;
  "/root" | "/root"/*)
    sudo install -o root -g root -m 600 -- "$from" "$to" || return 1
    ;;
  esac

  echo "Copied: $from to $to"
}

# Bash
genSymLink "$REPO_DIR/src/.bashrc" "$HOME/.bashrc"
genSymLink "$REPO_DIR/src/.bashrc" "/root/.bashrc"

# C
genSymLink "$REPO_DIR/src/.clang-format" "$HOME/.clang-format"

# Git
genSymLink "$REPO_DIR/src/.gitconfig" "$HOME/.gitconfig"

# Kitty
genSymLink "$REPO_DIR/src/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Nano
genSymLink "$REPO_DIR/src/.nanorc" "$HOME/.nanorc"

# Neovim
#genSymLink "$REPO_DIR/src/.config/nvim" "$HOME/.config/nvim"
#genSymLink "$REPO_DIR/src/.config/nvim" "/root/.config/nvim"

# Pentesting tools
genSymLink "$REPO_DIR/src/.ffufrc" "$HOME/.ffufrc"
genSymLink "$REPO_DIR/src/.gdbinit" "$HOME/.gdbinit"
genSymLink "$REPO_DIR/src/.radare2rc" "$HOME/.radare2rc"
genSymLink "$REPO_DIR/src/.wgetrc" "$HOME/.wgetrc"

# SSH
cpTemplate "$REPO_DIR/src/.ssh/config.tmpl" "$HOME/.ssh/config"

# Starship
genSymLink "$REPO_DIR/src/.config/starship.toml" "$HOME/.config/starship.toml"
genSymLink "$REPO_DIR/src/.config/starship.toml" "/root/.config/starship.toml"

# VSCodium
genSymLink "$REPO_DIR/src/.config/VSCodium/User/settings.json" "$HOME/.config/VSCodium/User/settings.json"

# Waybar
genSymLink "$REPO_DIR/src/.config/waybar/ip.sh" "$HOME/.config/waybar/ip.sh"

# Zsh
genSymLink "$REPO_DIR/src/.zshrc" "$HOME/.zshrc"
genSymLink "$REPO_DIR/src/.zshrc" "/root/.zshrc"

# Others
genSymLink "$REPO_DIR/src/.local/share/backgrounds" "$HOME/.local/share/backgrounds"
