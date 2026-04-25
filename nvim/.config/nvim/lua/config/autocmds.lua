local group = vim.api.nvim_create_augroup("kenji_lazyvim", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 180 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "json", "jsonc", "yaml", "typescript", "typescriptreact", "javascript", "javascriptreact", "lua", "python", "go", "rust" },
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params(0, "utf-16")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
        end
      end
    end
  end,
})
