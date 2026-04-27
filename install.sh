#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
LOG_FILE="${DOTFILES_LOG_FILE:-$STATE_DIR/install-$(date +%Y%m%d-%H%M%S).log}"
DOTFILES_PROFILE="${DOTFILES_PROFILE:-thinkpad-e14-amd}"

DOTFILES_PROFILE_NAME="portable"
DOTFILES_PROFILE_DESCRIPTION="Portable dotfiles defaults"
ENABLE_THINKPAD_STACK=0
ENABLE_DISPLAYLINK=0
ENABLE_GRUB_THEME=0
ENABLE_BLUETOOTH=1
ENABLE_DOCKER=1
ENABLE_UFW=1
ENABLE_ZRAM=1
ENABLE_SYSTEMD_HOMED=0
DISABLE_POWER_PROFILES_DAEMON=0
LY_TTY="tty2"
GRUB_THEME_NAME="lenovo-thinkpad-efi"
GRUB_KERNEL_FLAGS=""

DRY_RUN=0
UPGRADE_SYSTEM=1
CONFIGURE_SERVICES=1
INSTALL_VSCODE_EXTENSIONS=1
ONLY_PHASES=""
SKIP_PHASES=""

ALL_PHASES=(
  packages
  aur
  shell
  dev
  stow
  system-configs
  grub
  services
  dev-services
  user-services
  vscode
  browser
  theme
  package-lists
  verify
)

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Single full installer for this Arch Linux workstation.

Options:
  --dry-run                   Print commands without running them.
  --only <phases>             Run only comma-separated phases.
  --skip <phases>             Skip comma-separated phases.
  --no-upgrade                Do not run a full pacman -Syu; install missing packages only.
  --no-services               Install packages/configs, but do not initialize dev services.
  --no-vscode-extensions      Skip VS Code extension installation.
  --list-phases               Print available phases.
  DOTFILES_PROFILE=<name>     Select a profile from profiles/<name>.conf.
  -h, --help                  Show this help.

Phases:
  packages, aur, shell, dev, stow, system-configs, grub, services,
  dev-services, user-services, vscode, browser, theme, package-lists, verify
EOF
}

list_phases() {
  printf '%s\n' "${ALL_PHASES[@]}"
}

contains_csv() {
  local csv="$1" needle="$2" item
  IFS=',' read -r -a items <<< "$csv"
  for item in "${items[@]}"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

phase_enabled() {
  local phase="$1"
  if [[ -n "$ONLY_PHASES" ]] && ! contains_csv "$ONLY_PHASES" "$phase"; then
    return 1
  fi
  if [[ -n "$SKIP_PHASES" ]] && contains_csv "$SKIP_PHASES" "$phase"; then
    return 1
  fi
  return 0
}

run_phase() {
  local phase="$1"
  shift
  if phase_enabled "$phase"; then
    printf '\n==> %s\n' "$phase"
    "$@"
  else
    printf '\n==> %s skipped\n' "$phase"
  fi
}

while (($#)); do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --only)
      shift
      ONLY_PHASES="${1:-}"
      [[ -n "$ONLY_PHASES" ]] || { echo "--only expects a comma-separated phase list." >&2; exit 2; }
      ;;
    --skip)
      shift
      SKIP_PHASES="${1:-}"
      [[ -n "$SKIP_PHASES" ]] || { echo "--skip expects a comma-separated phase list." >&2; exit 2; }
      ;;
    --no-upgrade) UPGRADE_SYSTEM=0 ;;
    --no-services) CONFIGURE_SERVICES=0 ;;
    --no-vscode-extensions) INSTALL_VSCODE_EXTENSIONS=0 ;;
    --list-phases)
      list_phases
      exit 0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

mkdir -p "$DOTFILES_DIR/backup" "$STATE_DIR" "$HOME/.cache/zsh" "$HOME/Pictures/Screenshots" "$HOME/.local/bin"
exec > >(tee -a "$LOG_FILE") 2>&1
printf 'Log file: %s\n' "$LOG_FILE"

load_profile() {
  local profile_file="$DOTFILES_DIR/profiles/$DOTFILES_PROFILE.conf"
  local local_profile_file="$DOTFILES_DIR/profiles/$DOTFILES_PROFILE.local.conf"

  if [[ -f "$profile_file" ]]; then
    # shellcheck disable=SC1090
    source "$profile_file"
  else
    printf 'Profile %s not found at %s; using portable defaults.\n' "$DOTFILES_PROFILE" "$profile_file"
  fi

  if [[ -f "$local_profile_file" ]]; then
    # shellcheck disable=SC1090
    source "$local_profile_file"
  fi
}

run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

read_list() {
  local file="$1"
  [[ -f "$file" ]] || { printf 'Required list file not found: %s\n' "$file" >&2; exit 1; }
  awk '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    { print $1 }
  ' "$file"
}

read_stow_modules() {
  local file="$DOTFILES_DIR/packages/stow.txt"
  if [[ -f "$file" ]]; then
    read_list "$file"
  else
    printf '%s\n' \
      i3 polybar rofi picom dunst alacritty tmux zsh git nvim btop fastfetch \
      ranger yazi gtk qt profile xresources xsettingsd scripts browser systemd \
      autorandr wallpaper wireplumber portal
  fi
}

validate_stow_modules() {
  local module missing=0
  while IFS= read -r module; do
    [[ -d "$DOTFILES_DIR/$module" ]] && continue
    printf 'Stow module listed but missing: %s\n' "$module" >&2
    missing=1
  done < <(read_stow_modules)

  ((missing == 0)) || exit 1
}

require_arch() {
  [[ -f /etc/arch-release ]] || { echo "This installer expects Arch Linux."; exit 1; }
}

install_pacman_packages() {
  local packages_file="$DOTFILES_DIR/packages/arch.txt"
  local packages=()
  mapfile -t packages < <(read_list "$packages_file")
  ((${#packages[@]} > 0)) || return 0

  if [[ "$UPGRADE_SYSTEM" == 1 ]]; then
    run sudo pacman -Syu --needed --noconfirm "${packages[@]}"
  else
    run sudo pacman -S --needed --noconfirm "${packages[@]}"
  fi
}

ensure_yay() {
  command -v yay >/dev/null 2>&1 && return 0
  local build_dir="$HOME/.cache/yay-build"
  run rm -rf "$build_dir"
  run git clone https://aur.archlinux.org/yay.git "$build_dir"
  (cd "$build_dir" && run makepkg -si --noconfirm)
}

install_aur_packages() {
  local packages_file="$DOTFILES_DIR/packages/aur.txt"
  local packages=()
  mapfile -t packages < <(read_list "$packages_file")
  ((${#packages[@]} > 0)) || return 0
  ensure_yay
  run yay -S --needed --noconfirm "${packages[@]}"
}

clone_if_missing() {
  local url="$1" dest="$2"
  [[ -d "$dest" ]] && return 0
  run git clone --depth=1 "$url" "$dest"
}

resolve_login_shell() {
  local candidate
  while IFS= read -r candidate; do
    [[ -n "$candidate" ]] || continue
    [[ "$candidate" =~ ^# ]] && continue
    [[ -x "$candidate" ]] || continue
    if [[ "$(basename "$candidate")" == "zsh" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done < /etc/shells

  return 1
}

setup_shell_tools() {
  clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  clone_if_missing https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  clone_if_missing https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

  local zsh_path
  zsh_path="$(resolve_login_shell || true)"
  if [[ -n "$zsh_path" && "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
    run sudo chsh -s "$zsh_path" "$USER"
  fi
}

setup_development_environment() {
  local zshenv="$HOME/.config/zsh/dev-tools.zsh"
  run mkdir -p "$(dirname "$zshenv")"

  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] write $zshenv"
  else
    cat > "$zshenv" <<'EOF'
# Development toolchain environment
export NVM_DIR="$HOME/.nvm"
[[ -s /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
[[ -d "$ANDROID_HOME/emulator" ]] && export PATH="$ANDROID_HOME/emulator:$PATH"
[[ -d "$ANDROID_HOME/platform-tools" ]] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
[[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

export CHROME_EXECUTABLE="${CHROME_EXECUTABLE:-/usr/bin/chromium}"
EOF
  fi

  local zshrc="$HOME/.zshrc"
  # shellcheck disable=SC2016
  local source_line='[[ -r "$HOME/.config/zsh/dev-tools.zsh" ]] && source "$HOME/.config/zsh/dev-tools.zsh"'
  if [[ -f "$zshrc" ]] && ! grep -Fq "$source_line" "$zshrc"; then
    if [[ "$DRY_RUN" == 1 ]]; then
      echo "[dry-run] append dev-tools source line to $zshrc"
    else
      printf '\n%s\n' "$source_line" >> "$zshrc"
    fi
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
    local rel="${src#"$package_dir"/}"
    local target="$target_root/$rel"
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
        continue
      fi
      backup_conflict "$target" "$backup_root"
    fi
  done < <(find "$package_dir" -type f -print0)
}

ensure_materialized_dir() {
  local dir="$1"
  if [[ -L "$dir" ]]; then
    run rm "$dir"
  fi
  run mkdir -p "$dir"
}

stow_home() {
  local backup_root
  backup_root="$DOTFILES_DIR/backup/$(date +%Y%m%d-%H%M%S)"
  validate_stow_modules
  ensure_materialized_dir "$HOME/.config/systemd"
  ensure_materialized_dir "$HOME/.config/systemd/user"
  ensure_materialized_dir "$HOME/.config/systemd/user/default.target.wants"
  ensure_materialized_dir "$HOME/.config/systemd/user/timers.target.wants"
  ensure_materialized_dir "$HOME/.local/share/applications"

  local packages=()
  mapfile -t packages < <(read_stow_modules)

  for pkg in "${packages[@]}"; do
    backup_package_targets "$pkg" "$HOME" "$backup_root"
    run stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  done
}

install_system_configs() {
  local backup_root
  backup_root="$DOTFILES_DIR/backup/system-$(date +%Y%m%d-%H%M%S)"
  local pairs=(
    "$DOTFILES_DIR/ly/etc/ly/config.ini:/etc/ly/config.ini"
  )

  if [[ "$ENABLE_THINKPAD_STACK" == 1 ]]; then
    pairs+=(
      "$DOTFILES_DIR/tlp/etc/tlp.d/01-thinkpad-e14-amd.conf:/etc/tlp.d/01-thinkpad-e14-amd.conf"
      "$DOTFILES_DIR/thinkfan/etc/thinkfan.yaml:/etc/thinkfan.yaml"
      "$DOTFILES_DIR/thinkfan/etc/modprobe.d/99-thinkfan.conf:/etc/modprobe.d/99-thinkfan.conf"
      "$DOTFILES_DIR/lm_sensors/etc/conf.d/lm_sensors:/etc/conf.d/lm_sensors"
      "$DOTFILES_DIR/lm_sensors/etc/sensors.d/thinkpad-e14-ddr5.conf:/etc/sensors.d/thinkpad-e14-ddr5.conf"
      "$DOTFILES_DIR/lm_sensors/etc/sensors.d/thinkpad-isa.conf:/etc/sensors.d/thinkpad-isa.conf"
    )
  fi

  if [[ "$ENABLE_BLUETOOTH" == 1 ]]; then
    pairs+=("$DOTFILES_DIR/bluetooth/etc/bluetooth/main.conf:/etc/bluetooth/main.conf")
  fi

  if [[ "$ENABLE_ZRAM" == 1 ]]; then
    pairs+=("$DOTFILES_DIR/zram/etc/systemd/zram-generator.conf:/etc/systemd/zram-generator.conf")
  fi

  if [[ "$ENABLE_DISPLAYLINK" == 1 ]]; then
    pairs+=("$DOTFILES_DIR/displaylink/etc/udev/rules.d/40-monitor-hotplug.rules:/etc/udev/rules.d/40-monitor-hotplug.rules")
  fi

  for pair in "${pairs[@]}"; do
    local src="${pair%%:*}"
    local dst="${pair#*:}"
    if [[ -e "$dst" || -L "$dst" ]]; then
      if cmp -s "$src" "$dst"; then
        printf 'unchanged %s\n' "$dst"
        continue
      fi
      run sudo mkdir -p "$backup_root/$(dirname "${dst#/}")"
      run sudo mv "$dst" "$backup_root/${dst#/}"
    fi
    run sudo install -Dm644 "$src" "$dst"
  done
}

install_grub_theme() {
  [[ "$ENABLE_GRUB_THEME" == 1 ]] || return 0

  local theme_name="$GRUB_THEME_NAME"
  local theme_src="$DOTFILES_DIR/grub/usr/share/grub/themes/$theme_name"
  local theme_dst="/usr/share/grub/themes/$theme_name"
  local theme_line="GRUB_THEME=\"$theme_dst/theme.txt\""
  local kernel_flags="$GRUB_KERNEL_FLAGS"

  [[ -d "$theme_src" ]] || return 0

  run sudo mkdir -p /usr/share/grub/themes
  run sudo cp -a "$theme_src" /usr/share/grub/themes/

  if [[ -f /etc/default/grub ]]; then
    if grep -q '^GRUB_THEME=' /etc/default/grub; then
      run sudo sed -i "s|^GRUB_THEME=.*|$theme_line|" /etc/default/grub
    else
      run sudo sh -c "printf '\\n%s\\n' '$theme_line' >> /etc/default/grub"
    fi

    if [[ -n "$kernel_flags" ]]; then
      if grep -q '^GRUB_CMDLINE_LINUX=' /etc/default/grub; then
        if ! grep -q "$kernel_flags" /etc/default/grub; then
          run sudo sed -i "/^GRUB_CMDLINE_LINUX=/ s|\"$| $kernel_flags\"|" /etc/default/grub
        fi
      else
        run sudo sh -c "printf 'GRUB_CMDLINE_LINUX=\"%s\"\\n' '$kernel_flags' >> /etc/default/grub"
      fi
    fi
  fi

  if command -v grub-mkconfig >/dev/null 2>&1 && [[ -d /boot/grub ]]; then
    run sudo grub-mkconfig -o /boot/grub/grub.cfg
  fi
}

enable_services() {
  run sudo systemctl enable NetworkManager.service
  run sudo systemctl disable NetworkManager-wait-online.service || true
  if [[ "$DISABLE_POWER_PROFILES_DAEMON" == 1 ]]; then
    run sudo systemctl disable --now power-profiles-daemon.service || true
    run sudo systemctl mask power-profiles-daemon.service || true
  fi
  if [[ "$ENABLE_BLUETOOTH" == 1 ]]; then
    run sudo systemctl enable bluetooth.service
  fi
  run sudo systemctl enable systemd-resolved.service
  if [[ "$ENABLE_SYSTEMD_HOMED" == 1 ]]; then
    run sudo systemctl enable systemd-homed.service
  fi
  if [[ "$ENABLE_THINKPAD_STACK" == 1 ]]; then
    run sudo systemctl enable tlp.service
  fi
  if [[ "$ENABLE_UFW" == 1 ]]; then
    run sudo systemctl enable ufw.service
    run sudo ufw --force enable
    run sudo ufw logging off
  fi
  run sudo systemctl enable fstrim.timer
  if [[ "$ENABLE_THINKPAD_STACK" == 1 ]]; then
    run sudo systemctl enable lm_sensors.service
    run sudo systemctl enable thinkfan.service thinkfan-sleep.service thinkfan-wakeup.service
  fi
  if [[ "$ENABLE_DOCKER" == 1 ]]; then
    run sudo usermod -aG docker "$USER"
    run sudo systemctl enable docker.service
  fi
  if [[ "$ENABLE_DISPLAYLINK" == 1 ]] && systemctl list-unit-files displaylink.service >/dev/null 2>&1; then
    run sudo systemctl enable displaylink.service
  fi
  for dm in gdm.service sddm.service lightdm.service; do
    if systemctl list-unit-files "$dm" >/dev/null 2>&1; then
      run sudo systemctl disable "$dm" || true
    fi
  done
  run sudo systemctl enable "ly@$LY_TTY.service"
}

configure_dev_services() {
  [[ "$CONFIGURE_SERVICES" == 1 ]] || return 0

  if [[ ! -d /var/lib/postgres/data/base ]]; then
    run sudo -iu postgres initdb -D /var/lib/postgres/data
  fi
  run sudo systemctl disable postgresql.service

  if [[ ! -d /var/lib/mysql/mysql ]]; then
    run sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
  fi
  run sudo systemctl disable mariadb.service

  for service in mongodb.service mongod.service ollama.service; do
    if systemctl list-unit-files "$service" >/dev/null 2>&1; then
      run sudo systemctl disable "$service"
    fi
  done
}

enable_user_services() {
  if [[ -f "$HOME/.config/systemd/user/xsettingsd.service" ]]; then
    run systemctl --user daemon-reload
    run systemctl --user enable --now xsettingsd.service || true
  fi
  if [[ -f "$HOME/.config/systemd/user/dotfiles-maintenance.timer" ]]; then
    run systemctl --user daemon-reload
    run systemctl --user enable --now dotfiles-maintenance.timer || true
  fi
}

install_vscode_extensions() {
  [[ "$INSTALL_VSCODE_EXTENSIONS" == 1 ]] || return 0
  [[ "$DRY_RUN" == 1 ]] || command -v code >/dev/null 2>&1 || {
    echo "VS Code command 'code' not found; skipping extensions."
    return 0
  }

  local extensions=()
  mapfile -t extensions < <(read_list "$DOTFILES_DIR/vscode/extensions.txt")
  local ext
  for ext in "${extensions[@]}"; do
    run code --install-extension "$ext"
  done
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
  run gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark || true
  run gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark || true
  run gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic || true
  run gsettings set org.gnome.desktop.interface color-scheme prefer-dark || true
  command -v update-desktop-database >/dev/null 2>&1 && run update-desktop-database "$HOME/.local/share/applications" || true
}

refresh_package_lists() {
  command -v pacman >/dev/null 2>&1 || return 0
  run mkdir -p "$DOTFILES_DIR/backup"
  if [[ "$DRY_RUN" == 1 ]]; then
    echo "[dry-run] refresh backup/pkglist.txt and backup/aur-pkglist.txt"
  else
    pacman -Qqe | sort > "$DOTFILES_DIR/backup/pkglist.txt"
    pacman -Qqm | sort > "$DOTFILES_DIR/backup/aur-pkglist.txt"
  fi
}

verify_installation() {
  bash -n "$DOTFILES_DIR/install.sh"
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "$DOTFILES_DIR/install.sh" || true
  fi
  if [[ -x "$DOTFILES_DIR/scripts/.local/bin/dotfiles-secret-scan" ]]; then
    "$DOTFILES_DIR/scripts/.local/bin/dotfiles-secret-scan" "$DOTFILES_DIR"
  fi
  if [[ -x "$DOTFILES_DIR/scripts/.local/bin/dotfiles-doctor" ]]; then
    "$DOTFILES_DIR/scripts/.local/bin/dotfiles-doctor"
  fi
  if [[ -x "$DOTFILES_DIR/scripts/.local/bin/dock-health" ]]; then
    "$DOTFILES_DIR/scripts/.local/bin/dock-health" || true
  fi
  if [[ -x "$DOTFILES_DIR/scripts/.local/bin/performance-health" ]]; then
    "$DOTFILES_DIR/scripts/.local/bin/performance-health" || true
  fi
  systemctl --failed --no-pager || true
  dkms status || true
}

print_next_steps() {
  cat <<'EOF'

Installation finished.

Recommended checks after opening a new terminal:
- nvm --version
- pyenv --version
- mise --version
- docker version
- flutter doctor

Development services are installed for on-demand use through system-control-center.
Reboot to load boot, display manager, kernel, DKMS and power-management changes cleanly.
EOF
}

main() {
  require_arch
  load_profile
  printf 'Using profile: %s (%s)\n' "$DOTFILES_PROFILE_NAME" "$DOTFILES_PROFILE_DESCRIPTION"
  run_phase packages install_pacman_packages
  run_phase aur install_aur_packages
  run_phase shell setup_shell_tools
  run_phase dev setup_development_environment
  run_phase stow stow_home
  run_phase system-configs install_system_configs
  run_phase grub install_grub_theme
  run_phase services enable_services
  run_phase dev-services configure_dev_services
  run_phase user-services enable_user_services
  run_phase vscode install_vscode_extensions
  run_phase browser apply_browser_preferences
  run_phase theme apply_user_settings
  run_phase package-lists refresh_package_lists
  run_phase verify verify_installation
  print_next_steps
}

main
