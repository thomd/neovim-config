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
        local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
        local fill = bg and string.format('#%06x', bg) or 'NONE'
        vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = fill })

        local is_dark = vim.o.background == 'dark'
        if is_dark then
          local inactive = { bg = '#1a1a1a', fg = '#888888' }
          vim.api.nvim_set_hl(0, 'BufferInactive', inactive)
          vim.api.nvim_set_hl(0, 'BufferInactiveMod', inactive)
          vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = '#1a1a1a', fg = '#1a1a1a' })
          vim.api.nvim_set_hl(0, 'BufferInactiveModBtn', { bg = '#1a1a1a', fg = '#ffaf00' })
          local current = { bg = '#3a3a3a', fg = '#ffffff', bold = true }
          vim.api.nvim_set_hl(0, 'BufferCurrent', current)
          vim.api.nvim_set_hl(0, 'BufferCurrentMod', current)
          vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = '#3a3a3a', fg = '#3a3a3a' })
          vim.api.nvim_set_hl(0, 'BufferCurrentModBtn', { bg = '#3a3a3a', fg = '#ffaf00' })
        else
          local inactive = { bg = '#e4e4e4', fg = '#888888' }
          vim.api.nvim_set_hl(0, 'BufferInactive', inactive)
          vim.api.nvim_set_hl(0, 'BufferInactiveMod', inactive)
          vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = '#e4e4e4', fg = '#e4e4e4' })
          vim.api.nvim_set_hl(0, 'BufferInactiveModBtn', { bg = '#e4e4e4', fg = '#ffaf00' })
          local current = { bg = '#d0d0d0', fg = '#000000', bold = true }
          vim.api.nvim_set_hl(0, 'BufferCurrent', current)
          vim.api.nvim_set_hl(0, 'BufferCurrentMod', current)
          vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = '#d0d0d0', fg = '#d0d0d0' })
          vim.api.nvim_set_hl(0, 'BufferCurrentModBtn', { bg = '#d0d0d0', fg = '#ffaf00' })
        end
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
        separator = { left = '▎', right = '' },
        modified = { button = '●' },
        pinned = { button = '', filename = true },
      },
    },
  },
}
