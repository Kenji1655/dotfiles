#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

cd "$DOTFILES_DIR"

packages=(
  i3 polybar rofi picom dunst alacritty tmux zsh git nvim btop fastfetch ranger
  yazi gtk qt profile xresources xsettingsd scripts browser systemd autorandr
  wallpaper wireplumber portal
)

for pkg in "${packages[@]}"; do
  [[ -d "$pkg" ]] || continue
  stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

apply-theme gruvbox || true

if command -v i3-msg >/dev/null 2>&1; then
  i3-msg reload >/dev/null 2>&1 || true
fi

printf 'Dotfiles restored. Run ./doctor.sh to verify the system.\n'
