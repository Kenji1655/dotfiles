return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			opts.automatic_installation = false
			opts.ensure_installed = vim.tbl_filter(function(adapter)
				return adapter ~= "codelldb"
			end, opts.ensure_installed or {})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			local lldb_dap = vim.fn.exepath("lldb-dap")

			if lldb_dap ~= "" then
				local function split_args()
					local args = vim.fn.input("Args: ")
					return args ~= "" and vim.split(args, " ", { trimempty = true }) or {}
				end

				local function executable_input()
					return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
				end

				local function make_and_pick_executable()
					if vim.fn.filereadable("Makefile") == 1 or vim.fn.filereadable("makefile") == 1 then
						vim.notify("Running make before debug...")
						vim.fn.system({ "make" })
						if vim.v.shell_error ~= 0 then
							vim.notify("make failed. Check build output before debugging.", vim.log.levels.ERROR)
						end
					end
					return executable_input()
				end

				local function cargo_build_binary()
					if vim.fn.filereadable("Cargo.toml") == 0 then
						return executable_input()
					end

					vim.notify("Running cargo build before debug...")
					vim.fn.system({ "cargo", "build" })
					if vim.v.shell_error ~= 0 then
						vim.notify("cargo build failed. Check build output before debugging.", vim.log.levels.ERROR)
						return executable_input()
					end

					local metadata = vim.fn.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" })
					if vim.v.shell_error ~= 0 then
						return executable_input()
					end

					local ok, decoded = pcall(vim.json.decode, metadata)
					local package = ok and decoded.packages and decoded.packages[1] or nil
					local binary = package and package.name or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					return vim.fn.getcwd() .. "/target/debug/" .. binary
				end

				dap.adapters.lldb = {
					type = "executable",
					command = lldb_dap,
					name = "lldb",
				}

				local native_launch = {
					name = "Launch native executable",
					type = "lldb",
					request = "launch",
					program = executable_input,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = split_args,
				}

				local native_make_launch = {
					name = "Build with make and launch",
					type = "lldb",
					request = "launch",
					program = make_and_pick_executable,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = split_args,
				}

				local cargo_launch = {
					name = "Cargo build and launch",
					type = "lldb",
					request = "launch",
					program = cargo_build_binary,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = split_args,
				}

				local native_attach = {
					name = "Attach to native process",
					type = "lldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				}

				dap.configurations.c = { native_launch, native_make_launch, native_attach }
				dap.configurations.cpp = dap.configurations.c
				dap.configurations.rust = { cargo_launch, native_launch, native_attach }
			end
		end,
	},
}
