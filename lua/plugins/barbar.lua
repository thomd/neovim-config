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
      local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
      local fill = bg and string.format('#%06x', bg) or 'NONE'

      -- Tabline fill: same as editor background
      vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = fill })

      -- Inactive tabs: darker background
      local inactive = { bg = '#1a1a1a', fg = '#888888' }
      vim.api.nvim_set_hl(0, 'BufferInactive', inactive)
      vim.api.nvim_set_hl(0, 'BufferInactiveMod', inactive)
      vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = '#1a1a1a', fg = '#1a1a1a' })

      -- Current tab: lighter background
      local current = { bg = '#3a3a3a', fg = '#ffffff', bold = true }
      vim.api.nvim_set_hl(0, 'BufferCurrent', current)
      vim.api.nvim_set_hl(0, 'BufferCurrentMod', current)
      vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = '#3a3a3a', fg = '#3a3a3a' })
    end,
    opts = {
      animation = false,
      auto_hide = false,
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
