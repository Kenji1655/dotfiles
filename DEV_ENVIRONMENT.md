# Development Environment

The development environment is installed by the single repository installer:

```bash
cd ~/.dotfiles
./install.sh
```

Preview commands without changing the system:

```bash
cd ~/.dotfiles
./install.sh --dry-run
```

Skip optional service initialization or VS Code extensions:

```bash
./install.sh --no-services
./install.sh --no-vscode-extensions
```

Run only verification after making changes:

```bash
./install.sh --only verify
```

## Included Tooling

- JavaScript/TypeScript: `nodejs`, `npm`, `nvm`, `pnpm`, `yarn`, `eslint`, `prettier`, TypeScript language server.
- Python: `python`, `pip`, `pipx`, `pyenv`, `mise`, `ruff`, `black`, `mypy`.
- Systems: `base-devel`, `cmake`, `ninja`, `bear`, `clang`, `lldb`, `gdb`, `valgrind`.
- Rust and Go: `rust`, `rust-analyzer`, `go`.
- Java and .NET: `jdk21-openjdk`, `maven`, `gradle`, `dotnet-sdk`, `aspnet-runtime`, `mono`.
- Containers and databases: `docker`, `docker-compose`, `podman`, `postgresql`, `mariadb`, `mongodb-bin`, `mongodb-compass-bin`.
- Mobile: `android-studio`, `flutter`, `android-tools`, `android-udev`, `qemu-full`, `edk2-ovmf`.
- Cloud and Kubernetes: `github-cli`, `aws-cli-v2`, `azure-cli`, `google-cloud-cli`, `kubectl`, `helm`, `terraform`.
- Desktop dev apps: `visual-studio-code-bin`, `postman-bin`, `insomnia-bin`, `figma-linux`, `dbeaver`, `gimp`.
- Local AI: `ollama`, `lmstudio-bin`.

## Service Policy

Heavy development services are installed for on-demand use. PostgreSQL, MariaDB, MongoDB and Ollama are not enabled at boot by default.

Use Docker Compose, Podman or each service's native `systemctl` unit directly from the project that needs it. Docker is kept enabled for compatibility with common tooling and compose projects. The installer adds the user to the `docker` group; open a new login session before using Docker without sudo.

## Backup Template

`examples/backup-real.env.example` documents the expected Restic/Borg environment variables. Copy the values to a private, git-ignored location before using `backup-real`.

## Shell Environment

`./install.sh` writes `~/.config/zsh/dev-tools.zsh` with NVM, pyenv, mise, zoxide, atuin, direnv and Android SDK paths. Open a new terminal after installation before validating those tools.
