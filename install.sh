#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
LOG_FILE="$DOTFILES_DIR/install.log"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

mkdir -p "$DOTFILES_DIR/backup" "$HOME/.cache/zsh" "$HOME/Pictures/Screenshots" "$HOME/.local/bin"
exec > >(tee -a "$LOG_FILE") 2>&1

run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    printf '[dry-run] %q ' "$@"; printf '\n'
  else
    "$@"
  fi
}

require_arch() {
  [[ -f /etc/arch-release ]] || { echo "This installer expects Arch Linux."; exit 1; }
}

install_pacman_packages() {
  local packages=(
    base-devel i3-wm autotiling-rs polybar rofi picom dunst alacritty zsh tmux
    feh scrot imagemagick i3lock xss-lock xdg-utils xdotool slop
    brightnessctl playerctl pipewire pipewire-pulse pavucontrol
    network-manager-applet blueman neovim firefox thunar thunar-archive-plugin
    thunar-volman tumbler ranger ueberzug highlight atool w3m btop fastfetch
    bat eza fd ripgrep fzf git-delta noto-fonts inter-font
    ttf-jetbrains-mono-nerd papirus-icon-theme lxappearance flameshot autorandr
    xorg-xrdb xorg-xrandr xclip stow ly tlp tlp-rdw bluez bluez-utils vulkan-radeon
    libva-utils sof-firmware alsa-utils zsh-autosuggestions zsh-syntax-highlighting
    rtkit wireless-regdb accountsservice xdg-desktop-portal xdg-desktop-portal-gtk
    gvfs gvfs-mtp gvfs-gphoto2 polkit-gnome trash-cli file-roller zip unzip
    7zip unrar ffmpegthumbnailer poppler-glib xdg-user-dirs noto-fonts-emoji
    ttf-liberation man-db man-pages reflector pacman-contrib qt5ct qt6ct kvantum
    xsettingsd dkms linux-zen-headers
  )
  run sudo pacman -Syu --needed --noconfirm "${packages[@]}"
}

ensure_yay() {
  command -v yay >/dev/null 2>&1 && return 0
  local build_dir="$HOME/.cache/yay-build"
  run rm -rf "$build_dir"
  run git clone https://aur.archlinux.org/yay.git "$build_dir"
  (cd "$build_dir" && run makepkg -si --noconfirm)
}

install_aur_packages() {
  ensure_yay || return 0
  run yay -S --needed --noconfirm xidlehook bibata-cursor-theme gruvbox-dark-gtk zsh-theme-powerlevel10k-git thinkfan zen-browser-bin displaylink evdi-dkms
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
  local backup_root="$DOTFILES_DIR/backup/$(date +%Y%m%d-%H%M%S)"
  local packages=(i3 polybar rofi picom dunst alacritty tmux zsh git nvim btop fastfetch ranger gtk qt profile xresources xsettingsd scripts browser systemd autorandr wallpaper wireplumber portal)
  for pkg in "${packages[@]}"; do
    backup_package_targets "$pkg" "$HOME" "$backup_root"
    run stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  done
}

install_system_configs() {
  local backup_root="$DOTFILES_DIR/backup/system-$(date +%Y%m%d-%H%M%S)"
  local pairs=(
    "$DOTFILES_DIR/ly/etc/ly/config.ini:/etc/ly/config.ini"
    "$DOTFILES_DIR/tlp/etc/tlp.d/01-thinkpad-e14-amd.conf:/etc/tlp.d/01-thinkpad-e14-amd.conf"
    "$DOTFILES_DIR/thinkfan/etc/thinkfan.yaml:/etc/thinkfan.yaml"
    "$DOTFILES_DIR/lm_sensors/etc/sensors.d/thinkpad-e14-ddr5.conf:/etc/sensors.d/thinkpad-e14-ddr5.conf"
    "$DOTFILES_DIR/lm_sensors/etc/sensors.d/thinkpad-isa.conf:/etc/sensors.d/thinkpad-isa.conf"
    "$DOTFILES_DIR/bluetooth/etc/bluetooth/main.conf:/etc/bluetooth/main.conf"
  )
  for pair in "${pairs[@]}"; do
    local src="${pair%%:*}"
    local dst="${pair#*:}"
    if [[ -e "$dst" || -L "$dst" ]]; then
      run sudo mkdir -p "$backup_root/$(dirname "${dst#/}")"
      run sudo mv "$dst" "$backup_root/${dst#/}"
    fi
    run sudo install -Dm644 "$src" "$dst"
  done
}

enable_services() {
  run sudo systemctl enable NetworkManager.service
  run sudo systemctl enable bluetooth.service
  run sudo systemctl enable tlp.service
  run sudo systemctl enable lm_sensors.service
  run sudo systemctl enable thinkfan.service thinkfan-sleep.service thinkfan-wakeup.service
  if systemctl list-unit-files displaylink.service >/dev/null 2>&1; then
    run sudo systemctl enable displaylink.service
  fi
  for dm in gdm.service sddm.service lightdm.service; do
    if systemctl list-unit-files "$dm" >/dev/null 2>&1; then
      run sudo systemctl disable "$dm" || true
    fi
  done
  run sudo systemctl enable ly@tty2.service
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

main() {
  require_arch
  install_pacman_packages
  install_aur_packages || echo "AUR package install skipped or failed; continuing."
  setup_shell_tools
  stow_home
  install_system_configs
  enable_services
  enable_user_services
  apply_browser_preferences
  apply_user_settings
  echo "Done. Reboot to load boot, display manager and power-management changes."
}

main "$@"
