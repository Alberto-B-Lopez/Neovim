return {
  "folke/trouble.nvim",
  opt = {
    use_diagnostic_signs = true
  },
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<leader>tt", "<cmd>lua require('trouble').open()<CR>", { desc = "Toggles trouble"})

  end,
}
