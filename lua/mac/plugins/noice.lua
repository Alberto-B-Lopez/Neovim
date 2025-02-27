return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			long_message_to_split = true,
			bottom_search = true,
			command_palette = true,
		},
		messages = {
			enabled = false,
		},
		popupmenu = {
			enabled = true,
			backend = "nui",
		},
		notify = {
			enabled = false,
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
