# Kenji Dotfiles

Arch Linux + i3/Xorg workstation tuned for a ThinkPad, DisplayLink dock, Gruvbox Dark Hard and a fullstack/mobile development workflow.

## Desktop

- i3wm with dynamic workspaces, gaps, autotiling and cream focused borders.
- Polybar with monitor-aware launch, battery/power indicators, notifications, network, CPU and temperature.
- Rofi menus for apps, power, wallpapers, recording and the central control center.
- Picom, Dunst, Alacritty, tmux, Yazi, btop, fastfetch and LazyVim using a consistent Gruvbox/dark palette.
- GRUB ThinkPad EFI 2x dark theme.
- TLP, thinkfan, DisplayLink, sensors and power profile helpers.

## Quick Install

Fresh Arch install:

```bash
sudo pacman -Syu --needed git
git clone git@github.com:YOUR_USER/YOUR_REPO.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
sudo reboot
```

Ubuntu 24.04.x:

```bash
sudo apt update
sudo apt install -y git
git clone git@github.com:YOUR_USER/YOUR_REPO.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
sudo reboot
```

Restore only the dotfiles without reinstalling packages:

```bash
cd ~/.dotfiles
./restore.sh
```

Check the system:

```bash
cd ~/.dotfiles
./doctor.sh
```

## Daily Commands

| Command | Purpose |
| --- | --- |
| `system-control-center` | Main Rofi control panel |
| `system-health` | Health check alias for `dotfiles-doctor` |
| `boot-analysis` | Show boot time, slow units and critical chain |
| `dotfiles-doctor` | Check commands, symlinks, services, display, power, GRUB and git state |
| `backup-dotfiles` | Update package lists and create a git snapshot |
| `dotfiles-secret-scan` | Scan the repo for obvious secrets before pushing |
| `security-baseline` | Enable a conservative UFW firewall baseline |
| `restore.sh` | Re-stow user dotfiles and reapply theme |
| `apply-theme gruvbox` | Reapply GTK/Xresources/i3 Gruvbox dark settings |
| `monitor-manager` | Load/save autorandr profiles and restart Polybar |
| `audio-switcher` | Rofi output switcher for PipeWire/PulseAudio |
| `presentation-mode` | Toggle no-lock/no-notifications/no-DPMS mode |

## Keybindings

| Binding | Action |
| --- | --- |
| `Super + Return` | Open Alacritty |
| `Super + d` | App launcher |
| `Super + Tab` | Window switcher |
| `Super + Shift + Space` | System control center |
| `Super + Shift + e` | Power menu |
| `Super + Shift + w` | Wallpaper picker |
| `Super + Shift + f` | Yazi TUI file manager |
| `Super + Shift + s` | Screenshot area |
| `Super + Shift + r` | Screen recording menu |
| `Super + Shift + m` | Presentation mode |
| `Super + Shift + p` | Toggle touchpad |
| `Super + /` | Keybind cheatsheet |
| `Super + Ctrl + Space` | Toggle floating |
| `Super + Escape` | Lock screen |
| `Print` | Flameshot area screenshot |
| `Shift + Print` | Full screenshot to clipboard |
| `Super + Print` | Full screenshot to `~/Pictures/Screenshots` |

## Monitor Profiles

Use `monitor-manager` or the control center to manage displays.

Recommended autorandr profile names:

- `notebook`
- `dock-dual`
- `dock-single`
- `presentation`

Examples:

```bash
monitor-manager save notebook
monitor-manager save dock-dual
monitor-manager dock-dual
monitor-manager detect
```

## Development

Development setup lives in `install-dev-environment` and is documented in `DEV_ENVIRONMENT.md`.

Main stack:

- JavaScript/TypeScript, React, Next.js, Angular
- Python, Java, Rust, Go, C, C#, SQL
- LazyVim and VS Code
- PostgreSQL, MongoDB, MySQL/MariaDB
- DBeaver, Postman, Insomnia
- Ollama and LM Studio

LazyVim details are in `nvim/README.md`.

## Theme

Gruvbox/dark coverage:

- i3
- Polybar
- Rofi
- Dunst
- Alacritty
- tmux
- Yazi
- LazyVim
- GTK/Qt
- Firefox/Zen user preferences
- GRUB
- btop/fastfetch

Reapply the theme:

```bash
apply-theme gruvbox
```

## GRUB Theme

The ThinkPad GRUB theme is versioned in:

```text
grub/usr/share/grub/themes/lenovo-thinkpad-efi
```

The Arch installer copies it to `/usr/share/grub/themes/lenovo-thinkpad-efi`, sets `GRUB_THEME`, and runs:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Before Pushing To GitHub

Run:

```bash
dotfiles-secret-scan
system-health
git -C ~/.dotfiles status
```

Then add a remote and push:

```bash
cd ~/.dotfiles
git remote add origin git@github.com:YOUR_USER/YOUR_REPO.git
git push -u origin main
```

## Notes

- Firefox and Zen profiles must exist before browser preferences can be applied. Open each browser once, then rerun `./restore.sh` or `./install.sh`.
- DisplayLink usually needs a reboot after DKMS/EVDI updates.
- tmux plugins install with `Ctrl+a` then `I`.
- Wallpapers live wherever you want, but the wallpaper picker defaults to common image folders and uses `feh`.
- Local backups and package lists live under `backup/`.
