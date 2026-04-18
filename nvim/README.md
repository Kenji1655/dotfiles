# LazyVim setup

Config principal em `.config/nvim`, com LazyVim, Gruvbox, LSP, formatacao, lint,
testes, debug, Git, banco de dados e terminais de IA.

## Atalhos principais

### IA e terminal

- `<leader>ac`: abrir Codex CLI no terminal flutuante
- `<leader>aC`: abrir Claude Code CLI no terminal flutuante
- `<leader>as`: abrir shell no terminal flutuante
- `:Codex`: abrir Codex CLI
- `:Claude`: abrir Claude Code CLI

### Debug

- `<leader>db`: alternar breakpoint
- `<leader>dB`: breakpoint condicional
- `<leader>dc`: iniciar/continuar
- `<leader>da`: iniciar com argumentos
- `<leader>dO`: step over
- `<leader>di`: step into
- `<leader>do`: step out
- `<leader>du`: abrir/fechar DAP UI
- `<leader>dt`: terminar sessao

Debug nativo usa `lldb-dap` para C, C++ e Rust.

### Testes

- `<leader>tr`: rodar teste mais proximo
- `<leader>tt`: rodar testes do arquivo
- `<leader>tT`: rodar todos os testes do projeto
- `<leader>td`: debugar teste mais proximo
- `<leader>to`: abrir output
- `<leader>tO`: alternar painel de output
- `<leader>ts`: alternar resumo
- `<leader>tw`: watch do arquivo atual

Adaptadores configurados: Jest, Vitest, Python, Rust, Go e .NET/VSTest.

### Git

- `<leader>gg`: LazyGit na raiz do repo
- `<leader>gd`: abrir Diffview
- `<leader>gD`: fechar Diffview
- `<leader>ghf`: historico do arquivo
- `<leader>gH`: historico do repo
- `<leader>ghs`: stage hunk
- `<leader>ghR`: reset hunk
- `<leader>ghp`: preview hunk
- `<leader>gb`: blame da linha
- `<leader>gbt`: blame inline on/off

### Banco de dados

- `<leader>Db`: abrir/fechar Dadbod UI
- `<leader>Da`: adicionar conexao
- `<leader>Df`: encontrar buffer de banco
- `<leader>Dq`: info da ultima query

Use variaveis de ambiente para conexoes sensiveis, por exemplo:

```sh
export DATABASE_URL='postgres://user:pass@localhost:5432/db'
```

Depois use `:DB $DATABASE_URL`.

### Sessoes

- `<leader>qs`: restaurar sessao do projeto
- `<leader>qS`: selecionar sessao
- `<leader>ql`: restaurar ultima sessao
- `<leader>qd`: parar de salvar sessao atual

## Ferramentas externas esperadas

- `codex`
- `claude`
- `lldb-dap`
- `lazygit`
- `npm`, `pnpm` ou `yarn` para projetos JS/TS
- `cargo` para Rust
- `go` para Go
- `dotnet` para C#
- `python` e `pytest` para Python
