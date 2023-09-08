vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>r', [[:!python3 %<CR>]], { noremap = true, silent = true })

local keymap = vim.keymap -- for conciseness

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

