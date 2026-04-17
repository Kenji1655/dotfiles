return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "hard",
      overrides = {
        Normal = { bg = "#1d2021" },
        NormalFloat = { bg = "#282828" },
        SignColumn = { bg = "#1d2021" },
        FloatBorder = { fg = "#fabd2f", bg = "#282828" },
      },
      dim_inactive = false,
      transparent_mode = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
}
