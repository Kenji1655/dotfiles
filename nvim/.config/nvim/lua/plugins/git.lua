return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = false,
			current_line_blame_opts = {
				delay = 250,
			},
		},
		keys = {
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Git blame line",
			},
			{
				"<leader>gbt",
				function()
					require("gitsigns").toggle_current_line_blame()
				end,
				desc = "Toggle git blame",
			},
			{
				"<leader>ghs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Stage hunk",
			},
			{
				"<leader>ghR",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset hunk",
			},
			{
				"<leader>ghp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview hunk",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
			{ "<leader>ghf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
		},
	},
}
