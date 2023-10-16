return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local cat = require("catppuccin")
		cat.setup({
			term_colors = true,
			transparent_background = true,
		})
		vim.cmd([[colorscheme catppuccin-mocha]])
	end,
}
