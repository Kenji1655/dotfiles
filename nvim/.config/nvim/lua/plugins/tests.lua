return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-python",
			"rouge8/neotest-rust",
			"fredrikaverpil/neotest-golang",
			"nsidorenco/neotest-vstest",
		},
		opts = function(_, opts)
			opts.adapters = vim.tbl_deep_extend("force", opts.adapters or {}, {
				["neotest-jest"] = {
					jestCommand = "npm test --",
					jestConfigFile = function()
						local config = vim.fn.glob("jest.config.*", false, true)[1]
						return config ~= "" and config or nil
					end,
					cwd = function()
						return LazyVim.root()
					end,
				},
				["neotest-vitest"] = {},
				["neotest-python"] = {
					dap = { justMyCode = false },
				},
				["neotest-rust"] = {},
				["neotest-golang"] = {
					go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
					dap_go_enabled = true,
				},
				["neotest-vstest"] = {},
			})
		end,
	},
}
