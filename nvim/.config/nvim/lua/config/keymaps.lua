local map = vim.keymap.set

local function open_cli(name, command)
	if vim.fn.executable(command) ~= 1 then
		vim.notify(name .. " is not installed or is not in PATH", vim.log.levels.WARN)
		return
	end

	Snacks.terminal({ command }, {
		cwd = LazyVim.root(),
		win = {
			border = "rounded",
			title = " " .. name .. " ",
			title_pos = "center",
		},
	})
end

map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>wW", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>%bdelete|edit #|normal `\"<cr>", { desc = "Delete other buffers" })
map("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "LazyGit" })

map("n", "<leader>ff", function()
	Snacks.picker.files({ cwd = LazyVim.root() })
end, { desc = "Find files in project" })

map("n", "<leader>fF", function()
	Snacks.picker.files()
end, { desc = "Find files in cwd" })

map("n", "<leader>sg", function()
	Snacks.picker.grep({ cwd = LazyVim.root() })
end, { desc = "Grep project" })

map("n", "<leader>sG", function()
	Snacks.picker.grep()
end, { desc = "Grep cwd" })

map("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Workspace diagnostics" })

map("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })

map("n", "<leader>tt", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test file" })

map("n", "<leader>tr", function()
	require("neotest").run.run()
end, { desc = "Test nearest" })

map("n", "<leader>tT", function()
	require("neotest").run.run(LazyVim.root())
end, { desc = "Test project" })

map("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

map("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

map("n", "<leader>to", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Open test output" })

map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

map("n", "<leader>dR", function()
	require("dap").repl.toggle()
end, { desc = "Toggle DAP REPL" })

map("n", "<leader>dx", function()
	require("dap").terminate()
end, { desc = "Terminate debug session" })

map("n", "<leader>cx", function()
	vim.cmd("LazyExtras")
end, { desc = "LazyVim extras" })

map("n", "<leader>ac", function()
	open_cli("Codex", "codex")
end, { desc = "Codex CLI" })

map("n", "<leader>aC", function()
	open_cli("Claude Code", "claude")
end, { desc = "Claude Code CLI" })

map("n", "<leader>as", function()
	Snacks.terminal(nil, {
		cwd = LazyVim.root(),
		win = {
			border = "rounded",
			title = " Shell ",
			title_pos = "center",
		},
	})
end, { desc = "Shell terminal" })

vim.api.nvim_create_user_command("Codex", function()
	open_cli("Codex", "codex")
end, {})

vim.api.nvim_create_user_command("Claude", function()
	open_cli("Claude Code", "claude")
end, {})
