# LazyVim setup

Main config lives in `.config/nvim`, with LazyVim, Gruvbox, LSP, formatting, linting,
testing, debugging, Git, database tooling, and AI terminals.

## Main Keybindings

### AI And Terminal

- `<leader>ac`: open Codex CLI in a floating terminal
- `<leader>aC`: open Claude Code CLI in a floating terminal
- `<leader>as`: open a shell in a floating terminal
- `:Codex`: open Codex CLI
- `:Claude`: open Claude Code CLI

### Debug

- `<leader>db`: toggle breakpoint
- `<leader>dB`: conditional breakpoint
- `<leader>dc`: start/continue
- `<leader>da`: start with arguments
- `<leader>dO`: step over
- `<leader>di`: step into
- `<leader>do`: step out
- `<leader>du`: open/close DAP UI
- `<leader>dt`: terminate session

Native debugging uses `lldb-dap` for C, C++ and Rust.

### Tests

- `<leader>tr`: run nearest test
- `<leader>tt`: run file tests
- `<leader>tT`: run all project tests
- `<leader>td`: debug nearest test
- `<leader>to`: open output
- `<leader>tO`: toggle output panel
- `<leader>ts`: toggle summary
- `<leader>tw`: watch current file

Configured adapters: Jest, Vitest, Python, Rust, Go and .NET/VSTest.

### Git

- `<leader>gg`: open LazyGit at the repo root
- `<leader>gd`: open Diffview
- `<leader>gD`: close Diffview
- `<leader>ghf`: file history
- `<leader>gH`: repo history
- `<leader>ghs`: stage hunk
- `<leader>ghR`: reset hunk
- `<leader>ghp`: preview hunk
- `<leader>gb`: line blame
- `<leader>gbt`: blame inline on/off

### Databases

- `<leader>Db`: open/close Dadbod UI
- `<leader>Da`: add connection
- `<leader>Df`: find database buffer
- `<leader>Dq`: last query info

Use environment variables for sensitive connections, for example:

```sh
export DATABASE_URL='postgres://user:pass@localhost:5432/db'
```

Then use `:DB $DATABASE_URL`.

### Sessions

- `<leader>qs`: restore project session
- `<leader>qS`: select session
- `<leader>ql`: restore last session
- `<leader>qd`: stop saving the current session

## Expected External Tools

- `codex`
- `claude`
- `lldb-dap`
- `lazygit`
- `npm`, `pnpm` ou `yarn` para projetos JS/TS
- `cargo` para Rust
- `go` para Go
- `dotnet` para C#
- `python` e `pytest` para Python
