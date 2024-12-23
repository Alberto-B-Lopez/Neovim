return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		-- Angular
		local ok, mason_registry = pcall(require, "mason-registry")
		if not ok then
			vim.notify("Mason registry not found", vim.log.levels.ERROR)
			return
		end

		local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

		local lsp_location = table.concat({
			angularls_path,
			vim.fn.getcwd(),
		}, ",")

		local ngls_cmd = {
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			lsp_location,
			"--ngProbeLocations",
			lsp_location,
			"--includeCompletionsWithSnippetText",
			"--includeAutomaticOptionalChainCompletions",
			"--logToConsole",
		}

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- custom format for templ files
		local custom_format = function()
			if vim.bo.filetype == "templ" then
				local bufnr = vim.api.nvim_get_current_buf()
				local filename = vim.api.nvim_buf_get_name(bufnr)
				local cmd = "templ fmt " .. vim.fn.shellescape(filename)

				vim.fn.jobstart(cmd, {
					on_exit = function()
						-- Reload the buffer only if it's still the current buffer
						if vim.api.nvim_get_current_buf() == bufnr then
							vim.cmd("e!")
						end
					end,
				})
			else
				vim.lsp.buf.format()
			end
		end

		-- make sure on save it auto imports for go

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- add templ filetype
		vim.filetype.add({ extension = { templ = "templ" } })

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "templ" },
		})

		lspconfig["templ"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = custom_format }),
		})

		lspconfig["eslint_d"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "javascript" },
		})
		-- Angular Language Server
		lspconfig["angularls"].setup({
			cmd = ngls_cmd,
			capabilities = capabilities,
			on_attach = on_attach,
			on_new_config = function(new_config, _)
				new_config.cmd = ngls_cmd
			end,
			filetypes = { "html" },
		})

		-- configure typescript server with plugin
		lspconfig["tsserver"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "typescriptreact", "typescript", "javascript" },
			initializationOptions = {
				preferences = {
					importModuleSpecifierPreference = "non-relative",
				},
			},
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
				desc = "TS_add_missing_imports",
				pattern = { "*.js", "*.ts", "*.tsx" },
				callback = function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.addMissingImports.ts" },
						},
					})
					vim.cmd("write")
				end,
			}),
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "templ", "typescriptreact" },
			init_options = { userLanguages = { templ = "html" } },
		})

		lspconfig["sqlls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "sql", "sas" },
		})

		-- configure svelte server
		lspconfig["svelte"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						if client.name == "svelte" then
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
						end
					end,
				})
			end,
		})

		-- configure prisma orm server
		lspconfig["prismals"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- configure emmet language server
		-- lspconfig["emmet_ls"].setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- 	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		-- })

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- your shared on_attach logic
				on_attach(client, bufnr)

				-- Auto-organize imports (add missing + remove unused) and then format on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						-- first organize imports
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" } },
							apply = true,
						})
						-- then format
						vim.lsp.buf.format({ async = false })
					end,
				})
			end,
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})

		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				pyright = { autoImportCompletion = true },
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
						typeCheckingMode = "off",
					},
				},
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
}
