local map = vim.keymap.set

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
