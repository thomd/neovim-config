return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
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
      format_on_save = function(bufnr)
        -- Only format if a .prettierrc exists in cwd (or use for all formatters)
        local prettier_fts = {
          css = true, html = true, javascript = true, javascriptreact = true,
          json = true, jsonc = true, less = true, markdown = true,
          scss = true, typescript = true, yaml = true,
        }
        local ft = vim.bo[bufnr].filetype
        if prettier_fts[ft] and vim.fn.filereadable('.prettierrc') == 0 then
          return
        end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
      end,
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
