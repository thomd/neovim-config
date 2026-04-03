return {
	-- mason
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	-- LSP server
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "terraformls" },
			})
			vim.lsp.config("terraformls", {})
			vim.lsp.enable("terraformls")
			vim.lsp.config("tflint", {})
			vim.lsp.enable("tflint")
		end,
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				bash = { "shfmt" },
				css = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				less = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				python = { "ruff_format" },
				scss = { "prettier" },
				sh = { "shfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettier" },
				yaml = { "prettier" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci" },
				},
			},
		},
	},

	-- linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" }, -- Lazy load on file open
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				terraform = { "tflint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					local linters = lint.linters_by_ft[vim.bo.filetype] or {}
					for _, name in ipairs(linters) do
						if vim.fn.executable(name) == 0 then
							vim.notify("Linter not found: " .. name, vim.log.levels.ERROR)
						end
					end
					lint.try_lint()
				end,
			})
		end,
	},
}
