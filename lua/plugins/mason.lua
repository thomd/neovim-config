return {
  -- mason.nvim
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        bash = { 'shfmt' },
        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        less = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        python = { 'ruff_format' },
        scss = { 'prettier' },
        sh = { 'shfmt' },
        terraform = { 'terraform_fmt' },
        typescript = { 'prettier' },
        yaml = { 'prettier' },
      },
      formatters = {
shfmt = {
          prepend_args = { '-i', '2', '-ci' },
        },
      },
    },
  },
}
