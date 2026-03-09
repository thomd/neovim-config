return {
  {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          local pos = vim.api.nvim_win_get_cursor(0)
          require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
            if not err then
              vim.notify('File formatted', vim.log.levels.INFO)
            else
              -- Fallback to Vim's native = formatting
              vim.cmd('silent! normal! gg=G')
              pcall(vim.api.nvim_win_set_cursor, 0, pos)
              vim.notify('Formatted with native Vim =', vim.log.levels.INFO)
            end
          end)
        end,
        desc = 'format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        bash = { 'shfmt' },
        css = { 'prettier' },
        fish = { 'fish_indent' },
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
        toml = { 'taplo' },
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
