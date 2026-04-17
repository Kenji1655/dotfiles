#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
LOG_FILE="$DOTFILES_DIR/install-ubuntu.log"
DRY_RUN=0
INSTALL_OPTIONAL=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --optional) INSTALL_OPTIONAL=1 ;;
    *)
      printf 'Unknown option: %s\n' "$arg" >&2
      printf 'Usage: %s [--dry-run] [--optional]\n' "$0" >&2
      exit 2
      ;;
  esac
done

mkdir -p "$DOTFILES_DIR/backup" "$HOME/.cache/zsh" "$HOME/Pictures/Screenshots" "$HOME/Videos/Recordings" "$HOME/.local/bin"
exec > >(tee -a "$LOG_FILE") 2>&1

run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    printf '[dry-run] %q ' "$@"; printf '\n'
  else
    "$@"
  fi
}

require_ubuntu_2404() {
  [[ -r /etc/os-release ]] || { echo "Missing /etc/os-release."; exit 1; }
  # shellcheck disable=SC1091
  . /etc/os-release

  [[ "${ID:-}" == "ubuntu" ]] || { echo "This installer expects Ubuntu 24.04.x."; exit 1; }
  [[ "${VERSION_ID:-}" == "24.04" ]] || {
    echo "This installer was written for Ubuntu 24.04.x; detected ${VERSION_ID:-unknown}."
    exit 1
  }
}

apt_install_available() {
  local available=()
  local missing=()
  local pkg

  for pkg in "$@"; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      missing+=("$pkg")
    fi
  done

  if ((${#available[@]})); then
    run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${available[@]}"
  fi

  if ((${#missing[@]})); then
    printf 'Packages not found in apt and skipped: %s\n' "${missing[*]}"
  fi
}

install_apt_packages() {
  run sudo apt-get update
  run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
  run sudo add-apt-repository -y universe
  run sudo apt-get update

  local packages=(
    build-essential git stow curl ca-certificates unzip xz-utils
    i3-wm i3status i3lock xss-lock polybar rofi picom dunst alacritty zsh tmux
    feh scrot imagemagick x11-xserver-utils xdotool slop xclip xdg-utils xdg-user-dirs
    brightnessctl playerctl pipewire-pulse pavucontrol network-manager-gnome blueman
    neovim firefox thunar thunar-archive-plugin thunar-volman tumbler ranger
    highlight atool w3m btop fastfetch bat eza fd-find ripgrep fzf git-delta
    fonts-noto fonts-inter fonts-liberation fonts-noto-color-emoji fonts-jetbrains-mono
    papirus-icon-theme lxappearance flameshot autorandr
    gvfs gvfs-backends policykit-1-gnome trash-cli file-roller zip p7zip-full unrar
    ffmpeg ffmpegthumbnailer libpoppler-glib8 libnotify-bin
    qt5ct qt6ct qt5-style-kvantum qt5-style-kvantum-themes xsettingsd
    python3-pip python3-pipx
    zsh-autosuggestions zsh-syntax-highlighting
  )

  apt_install_available "${packages[@]}"
}

install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  [[ -d "$font_dir" ]] && return 0

  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] install JetBrainsMono Nerd Font into $font_dir"
    return 0
  fi

  mkdir -p "$font_dir"
  local zip_file="$HOME/.cache/JetBrainsMonoNerdFont.zip"

  if command -v curl >/dev/null 2>&1 && command -v unzip >/dev/null 2>&1; then
    run curl -fL -o "$zip_file" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    run unzip -o "$zip_file" -d "$font_dir"
    run fc-cache -fv "$HOME/.local/share/fonts"
  else
    echo "curl/unzip missing; Nerd Font install skipped."
  fi
}

install_gruvbox_gtk_fallback() {
  local theme_dir="$HOME/.themes/gruvbox-dark-gtk"
  [[ -d /usr/share/themes/gruvbox-dark-gtk || -d "$theme_dir" ]] && return 0

  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] create local fallback GTK theme at $theme_dir"
    return 0
  fi

  run mkdir -p "$theme_dir/gtk-3.0" "$theme_dir/gtk-4.0"

  cat > "$theme_dir/index.theme" <<'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=gruvbox-dark-gtk

[X-GNOME-Metatheme]
GtkTheme=gruvbox-dark-gtk
IconTheme=Papirus-Dark
CursorTheme=Bibata-Modern-Classic
EOF

  cat > "$theme_dir/gtk-3.0/gtk.css" <<'EOF'
@define-color theme_bg_color #1d2021;
@define-color theme_fg_color #fbf1c7;
@define-color theme_base_color #282828;
@define-color theme_text_color #fbf1c7;
@define-color theme_selected_bg_color #8ec07c;
@define-color theme_selected_fg_color #1d2021;
window, dialog, popover { background-color: #1d2021; color: #fbf1c7; }
headerbar, .titlebar { background-color: #282828; color: #fbf1c7; }
entry, textview, list, treeview { background-color: #282828; color: #fbf1c7; }
button { background-color: #3c3836; color: #fbf1c7; }
button:hover { background-color: #504945; }
EOF

  cp "$theme_dir/gtk-3.0/gtk.css" "$theme_dir/gtk-4.0/gtk.css"
}

clone_if_missing() {
  local url="$1" dest="$2"
  [[ -d "$dest" ]] && return 0
  run git clone --depth=1 "$url" "$dest"
}

setup_shell_tools() {
  clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  clone_if_missing https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [[ -n "$zsh_path" && "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
    run chsh -s "$zsh_path"
  fi
}

setup_autotiling_compat() {
  if command -v autotiling-rs >/dev/null 2>&1; then
    return 0
  fi

  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] install autotiling compatibility wrapper for autotiling-rs"
    return 0
  fi

  if command -v pipx >/dev/null 2>&1; then
    run pipx ensurepath || true
    run pipx install autotiling || true
  fi

  if command -v autotiling >/dev/null 2>&1 && [[ ! -e "$HOME/.local/bin/autotiling-rs" ]]; then
    cat > "$HOME/.local/bin/autotiling-rs" <<'EOF'
#!/usr/bin/env bash
exec autotiling "$@"
EOF
    chmod +x "$HOME/.local/bin/autotiling-rs"
  fi
}

setup_ubuntu_command_compat() {
  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] create Ubuntu command compatibility wrappers for fd/bat when needed"
    return 0
  fi

  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    cat > "$HOME/.local/bin/fd" <<'EOF'
#!/usr/bin/env bash
exec fdfind "$@"
EOF
    chmod +x "$HOME/.local/bin/fd"
  fi

  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    cat > "$HOME/.local/bin/bat" <<'EOF'
#!/usr/bin/env bash
exec batcat "$@"
EOF
    chmod +x "$HOME/.local/bin/bat"
  fi
}

install_optional_packages() {
  [[ "$INSTALL_OPTIONAL" == 1 ]] || return 0

  local packages=(
    tlp tlp-rdw thinkfan dkms linux-headers-generic
  )

  apt_install_available "${packages[@]}"

  cat <<'EOF'

Optional laptop packages were installed, but their system configs were not applied automatically.
Review these Arch-origin configs before copying them on Ubuntu:
- tlp/etc/tlp.d/01-thinkpad-e14-amd.conf
- thinkfan/etc/thinkfan.yaml

DisplayLink is intentionally not installed by this Ubuntu script because the Ubuntu installer flow changes often.
Install it manually from Synaptics/DisplayLink if this machine needs a dock.
EOF
}

backup_conflict() {
  local target="$1" backup_root="$2"
  [[ -e "$target" || -L "$target" ]] || return 0
  local rel="${target#/}"
  local dest="$backup_root/$rel"
  run mkdir -p "$(dirname "$dest")"
  run mv "$target" "$dest"
}

backup_package_targets() {
  local package="$1" target_root="$2" backup_root="$3"
  local package_dir="$DOTFILES_DIR/$package"
  [[ -d "$package_dir" ]] || return 0
  while IFS= read -r -d '' src; do
    local rel="${src#$package_dir/}"
    local target="$target_root/$rel"
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
        continue
      fi
      backup_conflict "$target" "$backup_root"
    fi
  done < <(find "$package_dir" -type f -print0)
}

stow_home() {
  local backup_root="$DOTFILES_DIR/backup/ubuntu-$(date +%Y%m%d-%H%M%S)"
  local packages=(
    i3 polybar rofi picom dunst alacritty tmux zsh git nvim btop fastfetch ranger
    gtk qt profile xresources xsettingsd scripts browser systemd wallpaper portal
  )

  for pkg in "${packages[@]}"; do
    backup_package_targets "$pkg" "$HOME" "$backup_root"
    run stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  done
}

enable_user_services() {
  if [[ -f "$HOME/.config/systemd/user/xsettingsd.service" ]]; then
    run systemctl --user daemon-reload
    run systemctl --user enable --now xsettingsd.service || true
  fi
}

apply_browser_preferences() {
  local template="$HOME/.config/browser-userjs/user.js"
  [[ -f "$template" ]] || return 0

  local roots=(
    "$HOME/.mozilla/firefox"
    "$HOME/snap/firefox/common/.mozilla/firefox"
    "$HOME/.config/zen"
  )

  local root profile
  for root in "${roots[@]}"; do
    [[ -f "$root/profiles.ini" ]] || continue
    while IFS= read -r profile; do
      [[ -d "$profile" ]] || continue
      run install -Dm644 "$template" "$profile/user.js"
    done < <(
      awk -F= -v root="$root" '
        $1 == "Path" {
          if ($2 ~ /^\//) print $2;
          else print root "/" $2;
        }
      ' "$root/profiles.ini"
    )
  done
}

apply_user_settings() {
  [[ -f "$HOME/.Xresources" ]] && run xrdb -merge "$HOME/.Xresources" || true
  run xdg-mime default thunar.desktop inode/directory || true
  run gsettings set org.gnome.desktop.interface gtk-theme gruvbox-dark-gtk || true
  run gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark || true
  run gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic || true
  run gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
  command -v update-desktop-database >/dev/null 2>&1 && run update-desktop-database "$HOME/.local/share/applications" || true
}

enable_desktop_services() {
  run sudo systemctl enable NetworkManager.service || true
  run sudo systemctl enable bluetooth.service || true
}

print_notes() {
  cat <<'EOF'

Ubuntu install finished.

Notes:
- Reboot, then choose the i3 session on the login screen.
- This Ubuntu installer does not install Ly, TLP, thinkfan or DisplayLink by default.
- If Polybar backlight does not appear, adjust the backlight card in ~/.config/polybar/config.ini.
- Zen Browser is only configured if it is installed at /opt/zen-browser-bin/zen-bin.
- Firefox/Zen user.js is applied only after browser profiles exist; run this installer again after opening the browsers once.
EOF
}

main() {
  require_ubuntu_2404
  install_apt_packages
  install_optional_packages
  install_nerd_font
  install_gruvbox_gtk_fallback
  setup_shell_tools
  setup_autotiling_compat
  setup_ubuntu_command_compat
  stow_home
  enable_desktop_services
  enable_user_services
  apply_browser_preferences
  apply_user_settings
  print_notes
}

main "$@"
