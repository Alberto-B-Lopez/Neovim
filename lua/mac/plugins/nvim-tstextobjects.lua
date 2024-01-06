return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	after = "nvim-treesitter",
	requires = "nvim-treesitter/nvim-treesitter",
	config = function()
		local ts = require("nvim-treesitter.configs")
		ts.setup({
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["at"] = "@comment.outer",
					},
				},
			},
		})
	end,
}
