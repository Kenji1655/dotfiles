# Development Environment

This setup is based on the current workstation goal:

- Fullstack and mobile development.
- JavaScript/TypeScript, Java, Rust, C, C#, Python and Go.
- React, Next.js and Angular.
- LazyVim and VS Code.
- NVM, pyenv and mise.
- PostgreSQL, MongoDB and MySQL/MariaDB.
- DBeaver, Postman, Insomnia, GIMP, Figma.
- Ollama and LM Studio.
- Docker/Podman basics for local database containers.
- No Kubernetes, cloud CLI or VPN for now.

## Install

Base development tools only:

```bash
install-dev-environment
```

Recommended workstation pass:

```bash
install-dev-environment --desktop-apps --databases --vscode-extensions
```

Complete pass, including mobile and local AI:

```bash
install-dev-environment --all --services --vscode-extensions
```

Preview commands without changing the system:

```bash
install-dev-environment --all --services --vscode-extensions --dry-run
```

## Package Groups

Base dev:

- `base-devel`, `cmake`, `ninja`, `bear`, `clang`, `lldb`, `gdb`, `valgrind`
- `nodejs`, `npm`, `nvm`, `pnpm`, `yarn`
- `python`, `python-pip`, `python-pipx`, `pyenv`, `mise`
- `rust`, `cargo`, `rust-analyzer`, `go`
- `jdk21-openjdk`, `maven`, `gradle`
- `dotnet-sdk`, `aspnet-runtime`, `mono`
- `lazygit`, `yazi`, `zoxide`, `atuin`, `direnv`
- `podman`, `docker`, `docker-compose`
- language servers and formatters for VS Code

Databases:

- `postgresql`
- `mariadb`
- `mongodb70-bin`
- `mongodb-compass-bin`
- `dbeaver`

Desktop apps:

- `visual-studio-code-bin`
- `postman-bin`
- `insomnia-bin`
- `figma-linux`
- `gimp`

Mobile:

- `android-studio`
- `flutter`
- `android-tools`
- `android-udev`
- `qemu-full`
- `edk2-ovmf`

Local AI:

- `ollama`
- `lmstudio-bin`

## Notes

- Kubernetes and cloud tools are intentionally excluded.
- Database/Ollama system services are kept on demand instead of enabled at boot.
- Use `dev-services-manager` for system services and `dev-db` for container databases.
- LazyVim is left for manual configuration inside Neovim.
- VS Code extensions are installed by the script when `--vscode-extensions` is used.
