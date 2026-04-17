# dotfiles - Arch + i3wm + Gruvbox Dark Hard

GNU Stow dotfiles for an Arch Linux i3/Xorg workstation using the Gruvbox Dark Hard palette.

## Components

- i3wm with gaps, workspace bindings, ThinkPad function keys, scratchpad, lock and screenshots.
- Polybar for internal and external monitors.
- Rofi launcher and power menu.
- Picom compositor, Dunst notifications, Alacritty terminal, tmux, zsh and Powerlevel10k.
- Neovim LazyVim colorscheme, btop, fastfetch, ranger, GTK, Xresources and cursor defaults.
- System packages for ly, TLP and Bluetooth are kept as separate Stow packages targeting `/`.

## Install

```bash
cd ~/.dotfiles
./install.sh
```

The installer backs up conflicting target files to `~/.dotfiles/backup/<timestamp>/` before running Stow.

## Manual Checks

1. Replace `~/.config/wallpaper/wall.png` if you want a different wallpaper.
2. Fill `name` and `email` in `~/.gitconfig`.
3. Run `p10k configure` if you want to tune the prompt interactively.
4. Verify interface names with `ip link`; this repo currently uses `wlp2s0`.
5. Verify display outputs with `xrandr --query`; this repo currently uses `eDP` and `HDMI-A-0`.
6. Verify backlight with `ls /sys/class/backlight`; this repo currently uses `amdgpu_bl1`.
7. Save real autorandr profiles after connecting displays: `autorandr --save mobile` and `autorandr --save docked`.
8. Install tmux plugins with `Ctrl+a` then `I`.
9. Reboot after enabling ly, TLP and Bluetooth.

## Keybindings

| Binding | Action |
| --- | --- |
| Mod+Return | Open Alacritty |
| Mod+d | Rofi app launcher |
| Mod+Tab | Rofi window switcher |
| Mod+Shift+q | Close focused window |
| Mod+Shift+r | Restart i3 |
| Mod+Shift+e | Power menu |
| Mod+h/j/k/l | Focus left/down/up/right |
| Mod+Shift+h/j/k/l | Move window left/down/up/right |
| Mod+f | Toggle fullscreen |
| Mod+v | Split vertical |
| Mod+b | Split horizontal |
| Mod+s | Stacking layout |
| Mod+w | Tabbed layout |
| Mod+e | Toggle split layout |
| Mod+space | Toggle focus between tiling and floating |
| Mod+Shift+space | Toggle floating |
| Mod+r | Resize mode |
| Mod+minus | Show scratchpad |
| Mod+Shift+minus | Move window to scratchpad |
| Mod+p | Move workspace to next output |
| Mod+Escape | Lock screen |
| Print | Flameshot region screenshot |
| Shift+Print | Screenshot full screen to clipboard |
| Mod+Print | Screenshot full screen to `~/Pictures/Screenshots/` |

## Package Table

| Package | Source | Purpose |
| --- | --- | --- |
| i3-wm | pacman | Window manager |
| autotiling-rs | pacman | Fibonacci-style automatic split orientation for i3 |
| polybar | pacman | Status bar |
| rofi | pacman | Launcher and menus |
| picom | pacman | Compositor |
| dunst | pacman | Notifications |
| alacritty | pacman | Terminal |
| zsh | pacman | Shell |
| tmux | pacman | Terminal multiplexer |
| feh | pacman | Wallpaper setter |
| scrot | pacman | Screenshot backend for lock script |
| imagemagick | pacman | Blur processing for lock screen |
| i3lock | pacman | Screen locker |
| xss-lock | pacman | Idle lock integration |
| xdg-utils | pacman | Desktop helpers |
| xdotool | pacman | X11 automation helpers |
| brightnessctl | pacman | Backlight and keyboard light control |
| playerctl | pacman | Media key control |
| pipewire | pacman | Audio server |
| pipewire-pulse | pacman | PulseAudio compatibility |
| pavucontrol | pacman | Audio mixer UI |
| network-manager-applet | pacman | Network tray applet |
| blueman | pacman | Bluetooth tray and manager |
| neovim | pacman | Editor |
| firefox | pacman | Browser |
| thunar | pacman | File manager |
| thunar-archive-plugin | pacman | Archive integration |
| thunar-volman | pacman | Removable media integration |
| tumbler | pacman | Thumbnails |
| ranger | pacman | TUI file manager |
| ueberzug | pacman | Image previews in ranger |
| highlight | pacman | Syntax previews |
| atool | pacman | Archive previews |
| w3m | pacman | HTML/image preview helper |
| btop | pacman | System monitor |
| fastfetch | pacman | System info |
| bat | pacman | Better cat |
| eza | pacman | Better ls |
| fd | pacman | Better find |
| ripgrep | pacman | Fast grep |
| fzf | pacman | Fuzzy finder |
| git-delta | pacman | Git diff pager |
| noto-fonts | pacman | General fonts |
| inter-font | pacman | GTK UI font |
| ttf-jetbrains-mono-nerd | pacman | Terminal and bar font |
| papirus-icon-theme | pacman | Icon theme |
| lxappearance | pacman | GTK theme selector |
| flameshot | pacman | Screenshot tool |
| autorandr | pacman | Display profiles |
| xorg-xrdb | pacman | Xresources loader |
| xclip | pacman | Clipboard integration |
| stow | pacman | Dotfile deployment |
| ly | pacman | TUI display manager |
| tlp | pacman | Power management |
| tlp-rdw | pacman | Radio device wizard for TLP |
| bluez | pacman | Bluetooth stack |
| bluez-utils | pacman | Bluetooth tools |
| vulkan-radeon | pacman | AMD Vulkan driver |
| libva-utils | pacman | VA-API diagnostics |
| sof-firmware | pacman | Audio firmware |
| alsa-utils | pacman | ALSA tools |
| rtkit | pacman | Realtime scheduling for PipeWire |
| wireless-regdb | pacman | Wireless regulatory database |
| xdg-desktop-portal | pacman | Desktop portal backend |
| xdg-desktop-portal-gtk | pacman | GTK portal implementation |
| gvfs | pacman | Thunar mounts and trash integration |
| trash-cli | pacman | Trash command used by ranger |
| file-roller | pacman | Archive manager |
| ffmpegthumbnailer | pacman | Video thumbnails |
| poppler-glib | pacman | PDF thumbnails |
| reflector | pacman | Mirrorlist refresh helper |
| pacman-contrib | pacman | Pacman cache cleanup tools |
| zsh-autosuggestions | pacman | Zsh suggestions |
| zsh-syntax-highlighting | pacman | Zsh syntax highlighting |
| xidlehook | AUR | Idle hooks for i3 |
| bibata-cursor-theme | AUR | Cursor theme |
| gruvbox-dark-gtk | AUR | GTK theme |
| zsh-theme-powerlevel10k-git | AUR | Prompt theme |

## Visual Preview

The desktop uses a dark hard Gruvbox base with warm yellow focused borders, muted gray inactive text and restrained green, aqua and blue accents. The bar is compact and split by function, Rofi opens centered with a dark translucent surface, notifications use clear colored frames, and Alacritty/tmux/Neovim share the same terminal palette.
