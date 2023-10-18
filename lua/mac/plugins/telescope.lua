return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				file_ignore_pattern = { " git/", "node _modules" },
				layout_config = {
					height = 0.90,
					width = 0.90,
					preview_cutoff = 0,
					horizontal = { preview_width = 0.60 },
					vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
					prompt_position = "top",
				},
				path_display = { "smart" },
				prompt_position = "top",
				prompt_prefix = " ",
				selection_caret = " ",
				sorting_strategy = "ascending",
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--hidden",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim",
				},
			},
			pickers = {
				buffers = {
					prompt_prefix = "󰘓 ",
				},
				commands = {
					prompt_prefix = " ",
					layout_config = {
						height = 0.63,
						width = 0.78,
					},
				},
				command_history = {
					prompt_prefix = " ",
					layout_config = {
						height = 0.63,
						width = 0.58,
					},
				},
				git_files = {
					prompt_prefix = " ",
					show_untracked = true,
				},
				find_files = {
					prompt_prefix = " ",
					find_command = { "fd", "-H" },
				},
				live_grep = {
					prompt_prefix = " ",
				},
				grep_string = {
					prompt_prefix = " ",
				},
			},
			mappings = {
				i = {
					["<C-k>"] = actions.move_selection_previous, -- move to prev result
					["<C-j>"] = actions.move_selection_next, -- move to next result
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("harpoon")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
	end,
}
