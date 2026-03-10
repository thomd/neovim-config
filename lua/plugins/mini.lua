-- https://github.com/nvim-mini/mini.nvim
return {
  {
    'nvim-mini/mini.icons',
    version = false,
    lazy = false,
    opts = {},
  },
  {
    'nvim-mini/mini-git',
    version = false,
    main = 'mini.git',
    event = 'BufReadPost',
    opts = {},
  },
  {
    'nvim-mini/mini.move',
    version = false,
    event = 'BufReadPost',
    opts = {
      mappings = {
        up = '_',
        down = '-',
        line_up = '_',
        line_down = '-',
        left = '',
        right = '',
        line_left = '',
        line_right = '',
      },
    },
  },
  {
    'nvim-mini/mini.statusline',
    version = false,
    event = 'UIEnter',
    opts = {
      use_icons = true,
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          -- Custom location section with lualine-style formatting
          local location = (function()
            if MiniStatusline.is_truncated(75) then
              return '%l│%2v'
            end
            return '%P %l│%2v'
          end)()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, lsp } },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=',
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    },
  },
}
