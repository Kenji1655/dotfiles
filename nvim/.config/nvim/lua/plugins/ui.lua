return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "gruvbox",
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			preset = "modern",
			win = {
				border = "rounded",
			},
		},
	},
}
