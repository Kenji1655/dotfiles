return {
	{
		"tpope/vim-dadbod",
		cmd = {
			"DB",
			"DBUI",
			"DBUIAddConnection",
			"DBUIFindBuffer",
			"DBUILastQueryInfo",
			"DBUIRenameBuffer",
			"DBUIToggle",
		},
		dependencies = {
			{
				"kristijanhusak/vim-dadbod-ui",
				init = function()
					vim.g.db_ui_use_nerd_fonts = 1
					vim.g.db_ui_show_database_icon = 1
					vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod"
				end,
			},
			"kristijanhusak/vim-dadbod-completion",
		},
		keys = {
			{ "<leader>Db", "<cmd>DBUIToggle<cr>", desc = "Database UI" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add database connection" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find database buffer" },
			{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename database buffer" },
			{ "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
		},
	},
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, { name = "vim-dadbod-completion" })
		end,
	},
}
