# Recovery Guide

Use this when the desktop, boot theme, dock or power stack breaks.

## Basic Checks

```bash
system-health
performance-health
systemctl --failed --no-pager
systemctl --user --failed --no-pager
journalctl -p 3 -b --no-pager
```

## Restore Dotfiles

```bash
cd ~/.dotfiles
./install.sh
i3-msg reload
~/.config/polybar/launch.sh
```

## Recover i3

```bash
i3 -C -c ~/.config/i3/config
i3-msg reload
```

If i3 does not start, switch to a TTY and move the config aside:

```bash
mv ~/.config/i3/config ~/.config/i3/config.broken
```

## Recover Polybar

```bash
pkill -x polybar
~/.config/polybar/launch.sh
pgrep -a polybar
```

## Recover DisplayLink Dock

```bash
dock-health
sudo systemctl restart displaylink.service
monitor-manager detect
~/.config/polybar/launch.sh
```

Automatic autorandr hotplug is intentionally disabled for DisplayLink docks.
Apply monitor profiles manually after the dock has settled.

If EVDI/DKMS broke after a kernel update:

```bash
dkms status
sudo dkms autoinstall
sudo reboot
```

## Recover GRUB Theme

Disable the theme from a TTY or live ISO:

```bash
sudo sed -i 's|^GRUB_THEME=.*|# GRUB_THEME disabled|' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Recover Thinkfan/TLP

```bash
sudo systemctl stop thinkfan.service
sudo systemctl disable thinkfan.service
sudo systemctl restart tlp.service
sensors
```

Re-enable after reviewing `/etc/thinkfan.yaml`:

```bash
sudo systemctl enable --now thinkfan.service
```

## Snapshots

Create a checkpoint before risky changes:

```bash
snapshot-manager "before kernel/displaylink update"
```

## Backups

Git protects dotfiles. Use `backup-real` for personal data after setting a Restic or Borg target.

Restic example:

```bash
export RESTIC_REPOSITORY=/run/media/kenji/Backup/restic
restic init
backup-real
```

For daily use, keep the backup environment in:

```text
~/.config/backup/backup-real.env
```

## Recover Browser Profiles

Browser profiles contain cookies, sessions, extension state, saved logins and
encryption keys. They must be restored from a private encrypted backup, not from
the dotfiles repository.

After a fresh install:

```bash
cd ~/.dotfiles
./install.sh
```

Restore these paths from Restic or Borg before opening the browsers if you want
the exact previous state:

```text
~/.mozilla
~/.config/zen
~/.config/chromium
~/.config/google-chrome
~/.config/BraveSoftware
~/.local/share/keyrings
~/.pki
```

Then log out and back in so the desktop keyring and browser processes start
cleanly.

## Emergency Package List

```bash
pacman -Qqe > pkglist.txt
pacman -Qqm > aur-pkglist.txt
```
