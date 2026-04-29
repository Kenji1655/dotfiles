# Repository Structure

This repository intentionally uses one top-level directory per Stow module.
That creates more folders at the root, but keeps installation predictable:
each module mirrors the target filesystem layout.

## Public-Facing Groups

| Group | Directories | Purpose |
| --- | --- | --- |
| Desktop | `i3`, `polybar`, `rofi`, `picom`, `dunst` | Window manager, panel, launcher and notifications |
| Terminal | `alacritty`, `tmux`, `zsh`, `yazi`, `ranger` | Shell, terminal and TUI workflow |
| Editor | `nvim`, `vscode` | LazyVim and VS Code setup |
| Theme | `gtk`, `qt`, `xresources`, `xsettingsd`, `wallpaper`, `grub` | Gruvbox desktop and boot theme |
| Hardware | `tlp`, `thinkfan`, `lm_sensors`, `zram`, `displaylink`, `autorandr`, `wireplumber`, `bluetooth` | Laptop, audio and display integration |
| Automation | `scripts`, `systemd`, `packages`, `profiles`, `examples` | Install, health checks, services and safe templates |

## Stow Modules

Home-level modules are declared in:

```text
packages/stow.txt
```

Each module is installed with:

```bash
stow -d ~/.dotfiles -t "$HOME" <module>
```

System-level files are not installed through Stow. They are copied by
`install.sh` because they require root ownership and profile gating.

## Local-Only State

The repository intentionally ignores local runtime state:

```text
.local-backups/
backup/
profiles/*.local.conf
packages/installed-*.txt
```

Use `examples/` for safe templates and `profiles/*.local.conf` for private
machine overrides.
