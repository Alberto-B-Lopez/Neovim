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

-- Oil Normal Mode
keymap.set("n", "<leader>ee", "<CMD>Oil<CR>", { desc = "Open Oil" })

-- Visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Remap keys for moving between windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- VISUAL mode keymaps
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- keymap.set("v", "<C-j", ":m.1<CR>")
-- keymap.set("v", "<C-k", ":m.-2<CR>")

-- Zoxide
local function zoxide_explore(directory)
	local dir = vim.fn.trim(vim.fn.system("zoxide query " .. (directory or "")))
	vim.cmd("Oil" .. dir)
end

vim.keymap.set("n", "<leader>z", function()
	vim.ui.input({ prompt = "Enter directory to explore: " }, function(input)
		if input then
			zoxide_explore(input)
		end
	end)
end, { desc = "Explore directory from zoxide" })
