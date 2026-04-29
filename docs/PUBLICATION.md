# Public Repository Checklist

Use this checklist before pinning the repository on a GitHub profile.

## Presentation

- README explains what the workstation is and how to install it.
- The license file exists and matches the README badge.
- Structure is documented in `docs/STRUCTURE.md`.
- Recovery and reinstall paths are documented.
- Commands are discoverable through `dotfiles help`.

## Safety

- `dotfiles-secret-scan` reports no obvious secrets.
- Browser sessions and keyrings are not tracked.
- Backup credentials are represented only by examples.
- Local backups are ignored by git.
- Machine-specific overrides use ignored `profiles/*.local.conf` files.

## Validation

Run:

```bash
dotfiles check
dotfiles doctor
git -C ~/.dotfiles status --short --branch
```

After pushing, confirm the GitHub Actions workflow is green.
