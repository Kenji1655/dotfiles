# Security Policy

These dotfiles are public by design, but they are still a workstation
configuration. Treat them as reference material, not as a generic hardening
baseline.

## Public Data Policy

The repository should not contain:

- Access tokens, API keys, passwords or private keys.
- Browser profiles, cookies, saved sessions or local keyrings.
- Real Restic/Borg repositories, passphrases or backup credentials.
- Machine-local overrides from `profiles/*.local.conf`.
- Runtime logs, local package snapshots or installer backups.

Local-only state belongs in ignored paths such as:

```text
.local-backups/
backup/
profiles/*.local.conf
packages/installed-*.txt
```

## Before Pushing

Run:

```bash
dotfiles check
dotfiles-secret-scan
git -C ~/.dotfiles status --short
```

The GitHub workflow also runs Bash syntax checks, ShellCheck, inventory and a
basic secret scan on every push and pull request.

## Reporting

If you notice a leaked secret or unsafe default, open a private channel with
the repository owner first. Do not publish the secret in an issue.
