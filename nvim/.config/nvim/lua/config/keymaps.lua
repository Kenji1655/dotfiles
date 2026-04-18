local map = vim.keymap.set

local function open_cli(name, command)
	if vim.fn.executable(command) ~= 1 then
		vim.notify(name .. " nao esta instalado ou nao esta no PATH", vim.log.levels.WARN)
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
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "LazyGit" })

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
