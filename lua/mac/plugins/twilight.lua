return {
	"folke/twilight.nvim",
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>tw", "<cmd>Twilight<CR>", { desc = "Activated and Deactivated Twilight" })
	end,
}
