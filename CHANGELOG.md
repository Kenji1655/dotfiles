# Changelog

## Unreleased

- Consolidated installation into a single `install.sh` entrypoint.
- Added phased installer execution with `--only`, `--skip`, `--no-upgrade` and verification support.
- Moved Arch, AUR and VS Code dependencies into declarative lists.
- Added explicit machine profiles for portable installs and the ThinkPad E14 AMD setup.
- Moved home Stow module selection into `packages/stow.txt`.
- Made hardware-specific installer steps conditional on profile flags.
- Extended `dotfiles-doctor` with profile and lock/idle checks.
- Documented portable versus machine-specific configuration.
- Disabled automatic autorandr hotplug for DisplayLink/EVDI stability.
- Standardized the DisplayLink dock profile to 60 Hz.
