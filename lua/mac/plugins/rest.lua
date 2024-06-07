return {
	"rest-nvim/rest.nvim",
	ft = "http",
	dependencies = { "luarocks.nvim" },
	config = function()
		require("rest-nvim").setup()
	end,
	vim.keymap.set("n", "<leader>rr", "<Cmd>Rest run<CR>", { desc = "Run the request" }),
}
