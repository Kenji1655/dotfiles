# Reinstall

This repository is intended for an Arch Linux install using i3, Gruvbox, Polybar, TLP, thinkfan and DisplayLink.
Machine-specific behavior is selected through `DOTFILES_PROFILE`; the default
profile is `thinkpad-e14-amd`.

## Fresh System

Install base Arch first, boot into the new user, then run:

```bash
sudo pacman -Syu --needed git
git clone https://github.com/YOUR_USER/YOUR_REPO.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

To use a different machine profile:

```bash
DOTFILES_PROFILE=<profile-name> ./install.sh
```

Local profile overrides belong in `profiles/<profile-name>.local.conf`. Those
files are ignored by git and should not contain secrets.

For a safer rerun without upgrading the whole system:

```bash
./install.sh --no-upgrade
```

Run a single phase:

```bash
./install.sh --only verify
./install.sh --only packages,aur --no-upgrade
```

Reboot after the installer finishes:

```bash
sudo reboot
```

## What The Installer Does

- Installs i3, Polybar, Rofi, Picom, Dunst, Alacritty, Thunar, Firefox, fonts, GTK/Qt theme tools, TLP, thinkfan and common desktop utilities.
- Installs development tooling for JS/TS, Python, Rust, Go, Java, .NET, C/C++, Docker/Podman, databases, Android/Flutter, cloud CLIs and Kubernetes.
- Installs AUR packages through `yay`, including Gruvbox GTK, Bibata cursor, Zen Browser, DisplayLink, EVDI, VS Code, Postman, Android Studio, Flutter, MongoDB and LM Studio.
- Reads package lists from `packages/arch.txt`, `packages/aur.txt` and `vscode/extensions.txt`.
- Stows home config packages into `~`.
- Installs system configs for TLP, thinkfan, bluetooth and Ly.
- Enables system services.
- Enables the user `xsettingsd` service for GTK theme propagation.
- Applies Firefox/Zen `user.js` preferences to detected profiles.
- Applies Gruvbox/dark theme preferences for GTK, Qt and browsers.
- Restores portable browser preferences from git; complete browser state must
  come from `backup-real` because it contains secrets and sessions.

## Important Notes

- DisplayLink usually needs a reboot after install because of DKMS/EVDI.
- Firefox and Zen need to be opened once before browser profiles exist. Run `./install.sh` again after first opening them if the `user.js` preferences were not applied.
- To preserve browser extensions, bookmarks, sessions, cookies and saved state,
  restore `backup-real` data before first browser use and verify with
  `browser-state`.
- Wallpapers live in `~/.config/wallpaper` and are managed by `Super + Shift + W`.
- Run `backup-dotfiles` before big changes to create a local git snapshot and update package lists.
- Run `dotfiles-secret-scan` before pushing to GitHub.
- Run `system-health` after restoring to verify services, symlinks, displays, sensors and GRUB theme.

## Useful Commands

Update dotfiles snapshot:

```bash
backup-dotfiles
```

Reapply packages, system configs and dotfiles:

```bash
cd ~/.dotfiles
./install.sh
```

Run the system doctor:

```bash
system-health
```

Open the control center:

```bash
system-control-center
```

Check for secrets before pushing:

```bash
dotfiles-secret-scan
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
