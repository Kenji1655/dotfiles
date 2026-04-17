# Reinstall

This repository is intended for an Arch Linux install using i3, Gruvbox, Polybar, TLP, thinkfan and DisplayLink.

## Fresh System

Install base Arch first, boot into the new user, then run:

```bash
sudo pacman -Syu --needed git
git clone https://github.com/YOUR_USER/YOUR_REPO.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Reboot after the installer finishes:

```bash
sudo reboot
```

## What The Installer Does

- Installs i3, Polybar, Rofi, Picom, Dunst, Alacritty, Thunar, Firefox, fonts, GTK/Qt theme tools, TLP, thinkfan and common desktop utilities.
- Installs AUR packages through `yay`, including Gruvbox GTK, Bibata cursor, Zen Browser, thinkfan, DisplayLink and EVDI.
- Stows home config packages into `~`.
- Installs system configs for TLP, thinkfan, bluetooth and Ly.
- Enables system services.
- Enables the user `xsettingsd` service for GTK theme propagation.
- Applies Firefox/Zen `user.js` preferences to detected profiles.
- Applies Gruvbox/dark theme preferences for GTK, Qt and browsers.

## Important Notes

- DisplayLink usually needs a reboot after install because of DKMS/EVDI.
- Firefox and Zen need to be opened once before browser profiles exist. Run `./install.sh` again after first opening them if the `user.js` preferences were not applied.
- Wallpapers live in `~/.config/wallpaper` and are managed by `Super + Shift + W`.
- Run `backup-dotfiles` before big changes to create a local git snapshot and update package lists.

## Useful Commands

Update dotfiles snapshot:

```bash
backup-dotfiles
```

Reapply all dotfiles:

```bash
cd ~/.dotfiles
./install.sh
```

Check changed files:

```bash
git -C ~/.dotfiles status
```

Add a GitHub remote:

```bash
git -C ~/.dotfiles remote add origin git@github.com:YOUR_USER/YOUR_REPO.git
git -C ~/.dotfiles push -u origin main
```
