return{
  'ThePrimeagen/git-worktree.nvim',

  config = function ()
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>cw", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { desc = "Creates a new worktree"})
    keymap.set("n", "<leader>ot", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { desc = "Open worktrees"})
  end,
}
