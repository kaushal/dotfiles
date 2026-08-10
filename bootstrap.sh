#!/usr/bin/env bash
# Install these dotfiles: packages, then symlinks. Safe to re-run.
#
#   ./bootstrap.sh              # packages + symlinks
#   ./bootstrap.sh --link-only  # skip package installation
#
# Existing real files are backed up to <file>.bak-<timestamp> before linking.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"
LINK_ONLY="${1:-}"

say() { printf '\033[1;34m→\033[0m %s\n' "$*"; }

link() {                       # link <repo-relative-src> <absolute-dest>
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then rm "$dest"
  elif [ -e "$dest" ]; then
    say "backing up $dest → $dest.bak-$STAMP"
    mv "$dest" "$dest.bak-$STAMP"
  fi
  ln -s "$src" "$dest"
  printf '   %s → %s\n' "${dest/#$HOME/~}" "${src/#$HOME/~}"
}

# ------------------------------------------------------------------- packages
if [ "$LINK_ONLY" != "--link-only" ]; then
  case "$(uname -s)" in
    Darwin)
      if command -v brew >/dev/null; then
        say "installing packages (Homebrew)"
        brew bundle --file="$DOTFILES/packages/Brewfile" || say "some formulae failed — continuing"
      else
        say "Homebrew not found — skipping packages (https://brew.sh)"
      fi
      ;;
    Linux)
      if command -v apt-get >/dev/null; then
        say "installing packages (apt)"
        pkgs=$(grep -vE '^\s*#|^\s*$' "$DOTFILES/packages/apt.txt" | tr '\n' ' ')
        sudo apt-get update -qq
        # shellcheck disable=SC2086
        sudo apt-get install -y $pkgs || say "some packages failed — continuing"
      fi
      ;;
  esac
fi

# ------------------------------------------------------------------- symlinks
say "linking configs"
link zsh/zshrc            "$HOME/.zshrc"
link git/gitconfig        "$HOME/.gitconfig"
link git/gitignore_global "$HOME/.gitignore_global"
link herdr/config.toml    "$HOME/.config/herdr/config.toml"

# ---------------------------------------------------------------------- local
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zsh/zshrc.local.example" "$HOME/.zshrc.local"
  chmod 600 "$HOME/.zshrc.local"
  say "created ~/.zshrc.local for machine-local settings (not in git)"
fi

# ----------------------------------------------------------------------- shell
if [ "${SHELL##*/}" != "zsh" ] && command -v zsh >/dev/null; then
  say "your login shell is ${SHELL##*/}; switch with: chsh -s $(command -v zsh)"
fi

say "done — open a new shell, or: source ~/.zshrc"
