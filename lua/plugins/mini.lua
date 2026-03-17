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
    config = function()
      -- Powerlineish theme colors (matching vim-airline powerlineish)
      local function set_powerlineish_colors()
        local is_dark = vim.o.background == 'dark'
        if is_dark then
          -- Section B/Y: gray on dark gray
          vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = '#9e9e9e', bg = '#303030' })
          -- Section C/X: white on very dark
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#ffffff', bg = '#121212' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = '#9e9e9e', bg = '#303030' })
          -- Mode colors (section A/Z)
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#005f00', bg = '#afd700', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#ffffff', bg = '#0089ff', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#080808', bg = '#ffaf00', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = '#ffffff', bg = '#d70000', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = '#005f00', bg = '#afd700', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = '#e4e4e4', bg = '#585858', bold = true })
          -- Inactive statusline
          vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#9e9e9e', bg = '#121212' })
          -- Orange accent for modified indicator and copilot
          vim.api.nvim_set_hl(0, 'StatusLineModified', { fg = '#ffaf00', bg = '#121212', bold = true })
          vim.api.nvim_set_hl(0, 'StatusLineCopilot', { fg = '#ffaf00', bg = '#303030' })
          -- Command line area: black/transparent background
          vim.api.nvim_set_hl(0, 'MsgArea', { fg = '#e4e4e4', bg = '#000000' })
        else
          vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = '#444444', bg = '#d0d0d0' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#444444', bg = '#e4e4e4' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = '#444444', bg = '#d0d0d0' })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#005f00', bg = '#afd700', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#ffffff', bg = '#0089ff', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#080808', bg = '#ffaf00', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = '#ffffff', bg = '#d70000', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = '#005f00', bg = '#afd700', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = '#e4e4e4', bg = '#585858', bold = true })
          vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#444444', bg = '#e4e4e4' })
          vim.api.nvim_set_hl(0, 'StatusLineModified', { fg = '#ff8700', bg = '#e4e4e4', bold = true })
          vim.api.nvim_set_hl(0, 'StatusLineCopilot', { fg = '#ff8700', bg = '#d0d0d0' })
          vim.api.nvim_set_hl(0, 'MsgArea', { fg = '#444444', bg = '#ffffff' })
        end
      end

      set_powerlineish_colors()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('powerlineish_statusline', { clear = true }),
        callback = set_powerlineish_colors,
      })

      require('mini.statusline').setup({
        use_icons = false,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            -- Branch name only (no diff summary)
            local git = ''
            if vim.b.minigit_summary then
              local branch = vim.b.minigit_summary.head_name
              if branch then git = '⎇ ' .. branch end
            end

            -- Filename with orange * for modified (like airline)
            local filename = '%f'
            local modified = vim.bo.modified and '%#StatusLineModified# *%#MiniStatuslineFilename#' or ''

            -- File type
            local filetype = vim.bo.filetype ~= '' and vim.bo.filetype or ''

            -- Encoding and file format (like airline section Y)
            local encoding = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
            local fileformat = vim.bo.fileformat
            local enc_fmt = ''
            if not MiniStatusline.is_truncated(120) then
              enc_fmt = encoding .. '[' .. fileformat .. ']'
            end

            -- Location: percentage, then line:column
            local location = '%p%%   %l:%v'

            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })

            local ok, enabled = pcall(vim.fn['copilot#Enabled'])
            local copilot = (ok and enabled == 1) and '%#StatusLineCopilot#[copilot]%#MiniStatuslineDevinfo#' or ''

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, copilot, diagnostics } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = { filename .. modified } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { filetype } },
              { hl = 'MiniStatuslineDevinfo', strings = { enc_fmt } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })
    end,
  },
}
