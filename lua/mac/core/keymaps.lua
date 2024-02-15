vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>rp", [[:w<CR>:!python3 %<CR>]], { noremap = true, silent = true })

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Opens up LazyGit" })
keymap.set("n", "<leader>a", "ggVG", { desc = "Select all" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("i", "<C-f>", "<Right>", { desc = "Moves right in insert mode" })
keymap.set("i", "<C-b>", "<Left>", { desc = "Moves left in insert mode" })
keymap.set("n", "<C-_>", function()
	require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true })

-- Remap keys for moving between windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
