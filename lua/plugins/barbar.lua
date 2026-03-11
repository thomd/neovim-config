return {
  {
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function(_, opts)
      require('barbar').setup(opts)

      -- Hide tabline when only one buffer is open
      local function update_tabline()
        local bufs = vim.tbl_filter(function(b)
          return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
        end, vim.api.nvim_list_bufs())
        vim.o.showtabline = #bufs > 1 and 2 or 0
      end
      update_tabline()
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufWipeout' }, {
        callback = vim.schedule_wrap(update_tabline),
      })
      local function set_barbar_colors()
        local p = require('wasabi.palette')
        vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = p.tabline_fill })
        local inactive = { bg = p.tabline, fg = p.fg }
        vim.api.nvim_set_hl(0, 'BufferInactive', inactive)
        vim.api.nvim_set_hl(0, 'BufferInactiveMod', inactive)
        vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = p.tabline, fg = p.tabline })
        vim.api.nvim_set_hl(0, 'BufferInactiveModBtn', { bg = p.tabline, fg = p.orange })
        local current = { bg = p.tabline_sel, fg = p.tabline_sel_fg, bold = true }
        vim.api.nvim_set_hl(0, 'BufferCurrent', current)
        vim.api.nvim_set_hl(0, 'BufferCurrentMod', current)
        vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = p.tabline_sel, fg = p.tabline_sel })
        vim.api.nvim_set_hl(0, 'BufferCurrentModBtn', { bg = p.tabline_sel, fg = p.orange })
      end
      set_barbar_colors()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('barbar_colors', { clear = true }),
        callback = set_barbar_colors,
      })
    end,
    opts = {
      animation = false,
      auto_hide = false,
      padding = 0,
      minimum_padding = 0,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        filetype = { enabled = false },
        separator = { left = '', right = '' },
        modified = { button = '●' },
        pinned = { button = '', filename = true },
      },
    },
  },
}
