return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>a", group = "ai" },
        { "<leader>D", group = "database" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test" },
        { "<leader>w", group = "write" },
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          preset = "telescope",
        },
      },
      notifier = {
        timeout = 3000,
      },
      terminal = {
        win = {
          border = "rounded",
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = "F ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "T ", color = "info" },
        HACK = { icon = "H ", color = "warning" },
        WARN = { icon = "W ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "P ", color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "N ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "✓ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
}
