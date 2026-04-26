<div align="center">

# Kenji Dotfiles

**Arch Linux &middot; i3wm &middot; Gruvbox Dark Hard &middot; ThinkPad &middot; DisplayLink Dock**

A fullstack and mobile development workstation, tuned end to end.

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/i3wm-52BE80?style=for-the-badge&logo=i3&logoColor=white)
![Gruvbox](https://img.shields.io/badge/Gruvbox-D79921?style=for-the-badge&logoColor=white)
![ThinkPad](https://img.shields.io/badge/ThinkPad-E34234?style=for-the-badge&logo=lenovo&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Zsh-1A1A1A?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

[Install](#quick-install) &middot; [Commands](#daily-commands) &middot; [Keybindings](#keybindings) &middot; [Theme](#theme) &middot; [Recovery](RECOVERY.md)

</div>

---

## Table of Contents

- [Highlights](#highlights)
- [Quick Install](#quick-install)
- [Repository Layout](#repository-layout)
- [Portability Model](#portability-model)
- [Daily Commands](#daily-commands)
- [Keybindings](#keybindings)
- [Monitor Profiles](#monitor-profiles)
- [Development](#development)
- [Maintenance](#maintenance)
- [Control Center](#control-center)
- [Theme](#theme)
- [GRUB Theme](#grub-theme)
- [Pushing To GitHub](#pushing-to-github)
- [Notes](#notes)

---

## Highlights

- **i3wm** with dynamic workspaces, gaps, autotiling (fibonacci-style) and cream focus borders.
- **Polybar** with monitor-aware launch, battery and power indicators, notifications, network, CPU and temperature.
- **Rofi** menus for apps, power, wallpapers, recording and the central control center.
- **Picom, Dunst, Alacritty, tmux, Yazi, btop, fastfetch, LazyVim** on a consistent Gruvbox dark palette.
- **GRUB ThinkPad EFI 2x** dark theme.
- **TLP, thinkfan, DisplayLink, sensors, TRIM, maintenance timers** and automatic AC/BAT power profiles.

---

## Quick Install

**Fresh Arch Linux**

```bash
sudo pacman -Syu --needed git
git clone https://github.com/Kenji1655/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
sudo reboot
```

**Preview without changing the system**

```bash
cd ~/.dotfiles && ./install.sh --dry-run
```

**Run one phase only**

```bash
./install.sh --only verify
./install.sh --only packages,aur --no-upgrade
./install.sh --skip vscode,grub
```

**Run a health check**

```bash
cd ~/.dotfiles && ./doctor.sh
```

---

## Repository Layout

```text
.dotfiles/
  i3, polybar, rofi, picom, dunst      desktop environment
  alacritty, tmux, yazi, nvim          terminal and editor
  zsh, git, btop, fastfetch, ranger    shell and CLI
  gtk, qt, xresources, xsettingsd      theming
  tlp, thinkfan, systemd, ly           system services
  autorandr, wireplumber, bluetooth    hardware
  browser, portal, profile             desktop integration
  grub                                 bootloader theme
  packages, vscode                     declarative install lists
  profiles                             machine profiles and local overrides
  scripts                              ~/.local/bin helpers
  backup, system-notes                 package lists and notes
  install.sh                           single full installer
  doctor.sh                            health check
  README, RECOVERY, REINSTALL, DEV_ENVIRONMENT
```

---

## Portability Model

The repository is split into portable defaults and explicit machine profiles.
The default profile is `thinkpad-e14-amd`, selected through:

```bash
DOTFILES_PROFILE=thinkpad-e14-amd ./install.sh
```

For a generic Arch+i3 install without ThinkPad, DisplayLink or GRUB hardware
tuning:

```bash
DOTFILES_PROFILE=portable ./install.sh
```

Profile files live in:

```text
profiles/<name>.conf
profiles/<name>.local.conf
```

Versioned profile files describe hardware and service policy: ThinkPad fan
control, TLP, zram, DisplayLink, GRUB theme, Docker, UFW and the Ly TTY.
Local overrides use `profiles/*.local.conf`, are ignored by git, and should
contain host-only preferences only. Do not store secrets there.

Home-level Stow modules are declared in:

```text
packages/stow.txt
```

System-level files are intentionally installed by `install.sh` instead of Stow
because they require root ownership and should be gated by the active profile.

---

## Daily Commands

### System

| Command | Purpose |
| --- | --- |
| `system-control-center` | Categorized Rofi control panel |
| `system-health` | Health check alias for `dotfiles-doctor` |
| `dotfiles-doctor` | Commands, symlinks, services, display, power, GRUB and git state |
| `dotfiles-inventory` | Read-only inventory of profile, package lists, Stow modules and local commands |
| `boot-analysis` | Boot time, slow units and critical chain |
| `dock-health` | DisplayLink, EVDI, monitors, autorandr and Polybar |
| `performance-health` | CPU, TLP, zram, swap, storage, boot, heavy processes and containers |
| `system-mode` | Toggle Work, Battery, Dock, Focus, Dev and Normal |
| `system-maintenance` | Clean build caches, prune pacman cache, drop debug orphans |

### Backup and Security

| Command | Purpose |
| --- | --- |
| `backup-dotfiles` | Update package lists and commit a snapshot |
| `backup-real` | Run Restic or Borg backup after configuring a repository |
| `browser-state` | Show browser profiles, critical state files and backup readiness |
| `snapshot-manager` | Create Timeshift or Snapper checkpoints |
| `security-check` | Firewall, SSH, listening ports, audit tools |
| `security-baseline` | Apply a conservative UFW firewall baseline |
| `dotfiles-secret-scan` | Scan the repo for obvious secrets |

### Development

| Command | Purpose |
| --- | --- |
| `dev-services-manager` | Start or stop PostgreSQL, MariaDB, MongoDB, Ollama on demand |
| `dev-stack-manager` | Stack checks and setup notes |
| `dev-db` | Launch Postgres, Mongo or MySQL via Podman or Docker |

### Display and Audio

| Command | Purpose |
| --- | --- |
| `monitor-manager` | Load or save autorandr profiles and restart Polybar |
| `audio-switcher` | Rofi output switcher for PipeWire/PulseAudio |
| `presentation-mode` | No-lock, no-notifications, no-DPMS |
| `apply-theme gruvbox` | Reapply GTK, Xresources and i3 Gruvbox settings |

---

## Keybindings

### Launch and Navigation

| Binding | Action |
| --- | --- |
| `Super + Return` | Open Alacritty |
| `Super + d` | App launcher |
| `Super + Tab` | Window switcher |
| `Super + /` | Keybind cheatsheet |
| `Super + Ctrl + Space` | Toggle floating |
| `Super + Escape` | Lock screen |

### Menus

| Binding | Action |
| --- | --- |
| `Super + Shift + Space` | System control center |
| `Super + Shift + e` | Power menu |
| `Super + Shift + w` | Wallpaper picker |
| `Super + Shift + f` | Yazi TUI file manager |
| `Super + Shift + m` | Presentation mode |
| `Super + Shift + p` | Toggle touchpad |

### Capture

| Binding | Action |
| --- | --- |
| `Super + Shift + s` | Screenshot area |
| `Super + Shift + r` | Screen recording menu |
| `Print` | Flameshot area screenshot |
| `Shift + Print` | Full screenshot to clipboard |
| `Super + Print` | Full screenshot to `~/Pictures/Screenshots` |

---

## Monitor Profiles

Manage displays with `monitor-manager` or through the control center.
Automatic autorandr hotplug is disabled because DisplayLink/EVDI can emit
unstable DRM events while a dock is still enumerating. Apply profiles manually
after connecting the dock.

Recommended profile names: `notebook`, `dock-dual`, `dock-single`, `presentation`.

```bash
monitor-manager save notebook      # save current layout
monitor-manager save dock-dual
monitor-manager dock-dual          # apply a saved profile
monitor-manager detect             # auto-detect and apply
```

---

## Development

Development setup is part of the single `./install.sh` flow and is documented in [`DEV_ENVIRONMENT.md`](DEV_ENVIRONMENT.md).

**Languages and Frameworks**

- JavaScript, TypeScript, React, Next.js, Angular
- Python, Java, Rust, Go, C, C#, SQL

**Editors and Tooling**

- LazyVim — see [`nvim/README.md`](nvim/README.md)
- VS Code

**Databases**

- PostgreSQL, MongoDB, MySQL/MariaDB
- DBeaver, Postman, Insomnia

**AI**

- Ollama, LM Studio

Heavy development services are intentionally **on demand** instead of starting at boot:

```bash
dev-services-manager
```

Also available from `system-control-center` as `Dev Services`.

**Container databases**

```bash
dev-db postgres start
dev-db mongo start
dev-db mysql start
```

**Stack checks**

```bash
dev-stack-manager
```

---

## Maintenance

The Arch installer enables:

- `fstrim.timer` for weekly SSD/NVMe TRIM
- `dotfiles-maintenance.timer` for weekly user build-cache cleanup
- `NetworkManager-wait-online.service` **disabled** to avoid delaying desktop boot

**Manual run**

```bash
system-maintenance all
```

**Inventory before reinstall or larger refactors**

```bash
dotfiles-inventory
```

Also exposed in the control center as `System Maintenance`.

**Before risky changes** — create a checkpoint:

```bash
snapshot-manager "before kernel/displaylink update"
```

**Personal data backup** — configure Restic or Borg first, then:

```bash
install -Dm600 ~/.dotfiles/backup/backup-real.env.example ~/.config/backup/backup-real.env
nvim ~/.config/backup/backup-real.env
backup-real
```

`backup-real` includes browser profile state that must not be committed to git:
Firefox, Zen, Chromium-compatible profiles, browser password databases, session
state and desktop keyrings. It excludes browser caches and crash/cache folders.

**Browser state check**

```bash
browser-state
```

Recovery steps live in [`RECOVERY.md`](RECOVERY.md).

**Performance check**

```bash
performance-health
```

---

## Control Center

`system-control-center` is organized into categories:

```text
System       Development   Display       Audio        Power
Appearance   Maintenance   Security      Dotfiles
```

---

## Theme

Gruvbox Dark Hard coverage:

| Category | Apps |
| --- | --- |
| WM and panel | i3, Polybar, Rofi, Dunst |
| Terminal | Alacritty, tmux, Yazi |
| Editor | LazyVim |
| Toolkit | GTK, Qt |
| Browser | Firefox, Zen user preferences |
| Bootloader | GRUB |
| Monitors | btop, fastfetch |

**Reapply the theme**

```bash
apply-theme gruvbox
```

---

## GRUB Theme

The ThinkPad GRUB theme is versioned in:

```text
grub/usr/share/grub/themes/lenovo-thinkpad-efi
```

The Arch installer copies it to `/usr/share/grub/themes/lenovo-thinkpad-efi`, sets `GRUB_THEME`, and runs:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Pushing To GitHub

Before pushing:

```bash
dotfiles-secret-scan
system-health
git -C ~/.dotfiles status
```

If the remote is not configured yet:

```bash
cd ~/.dotfiles
github-remote-setup git@github.com:Kenji1655/dotfiles.git
git push -u origin main
```

---

## Notes

- **Firefox and Zen** profiles must exist before browser preferences apply. Open each browser once, then rerun `./install.sh`.
- **Browser profile data** is intentionally not stored in git. Use `backup-real` with Restic or Borg to preserve extensions, bookmarks, sessions, cookies and saved browser state.
- **DisplayLink** is intentionally conservative: automatic autorandr hotplug is disabled, dock profiles use 60 Hz, and monitor layouts should be applied manually after the dock settles.
- **Docker and Podman** are both installed. Docker is for compatibility with mainstream dev tooling; Podman is preferred for rootless local database containers through `dev-db`.
- **Installer phases** are listed with `./install.sh --list-phases`.
- **tmux** plugins install with `Ctrl+a` then `I`.
- **Wallpapers** live wherever you want; the picker defaults to common image folders and uses `feh`.
- **Local backups and package lists** live under `backup/`.

---

<div align="center">

Built on a ThinkPad, tuned for long dev sessions and a zero-lag desktop.

</div>
