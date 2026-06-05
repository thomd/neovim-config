return {
  -- Comment.nvim (nerdcommenter equivalent)
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    opts = {
      toggler = { line = '<leader>c' },
      opleader = { line = '<leader>c' },
      pre_hook = function()
        if vim.bo.filetype == 'sh' or vim.bo.filetype == 'css' then
          return vim.bo.commentstring
        end
      end,
    },
  },

  -- Auto-close brackets/quotes (delimitMate equivalent)
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
    },
  },

  -- Surround (vim-surround equivalent)
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'BufReadPost',
    opts = {},
  },

  -- Multiple cursors
  {
    'brenton-leighton/multiple-cursors.nvim',
    version = '*',
    keys = {
      { '<C-n>', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'x' }, desc = 'Select all matches' },
      { '<M-j>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor down' },
      { '<M-k>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor up' },
      { '<C-LeftMouse>', '<Cmd>MultipleCursorsMouseAddDelete<CR>', mode = { 'n', 'i' }, desc = 'Add/remove cursor' },
      { '<leader>m', '<Cmd>MultipleCursorsAddVisualArea<CR>', mode = 'x', desc = 'Add cursors to lines' },
    },
    config = function()
      require('multiple-cursors').setup()

      local function mc_active()
        local ns = vim.api.nvim_get_namespaces()['multiple-cursors']
        return ns ~= nil and #vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {}) > 0
      end

      -- only actual cursor marks have priority 9999
      local function get_cursor_marks(ns)
        local all = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true })
        local out = {}
        for _, m in ipairs(all) do
          if m[4] and m[4].priority == 9999 then
            table.insert(out, m)
          end
        end
        return out
      end

      local function mc_next_pos(ns, cur_line, cur_col)
        local marks = get_cursor_marks(ns)
        if #marks == 0 then return nil end
        table.sort(marks, function(a, b)
          return a[2] < b[2] or (a[2] == b[2] and a[3] < b[3])
        end)
        for _, m in ipairs(marks) do
          local ml, mc = m[2] + 1, m[3] + 1
          if ml > cur_line or (ml == cur_line and mc > cur_col) then
            return { ml, mc }
          end
        end
        return { marks[1][2] + 1, marks[1][3] + 1 } -- wrap around
      end

      -- n: find target first, then pin current, then jump
      vim.keymap.set('n', 'n', function()
        if not mc_active() then
          vim.cmd('normal! n')
          return
        end
        local ns = vim.api.nvim_get_namespaces()['multiple-cursors']
        local target = mc_next_pos(ns, vim.fn.line('.'), vim.fn.col('.'))
        if not target then return end
        local pos = vim.fn.getcurpos()
        require('multiple-cursors.virtual_cursors').add(pos[2], pos[3], pos[5], true)
        vim.fn.cursor(target[1], target[2])
      end, { desc = 'next search / next cursor' })

      -- q: find target first, then jump without pinning (skip)
      vim.keymap.set('n', 'q', function()
        if not mc_active() then
          local reg = vim.fn.nr2char(vim.fn.getchar())
          vim.cmd('normal! q' .. reg)
          return
        end
        local ns = vim.api.nvim_get_namespaces()['multiple-cursors']
        local target = mc_next_pos(ns, vim.fn.line('.'), vim.fn.col('.'))
        if not target then return end
        vim.fn.cursor(target[1], target[2])
      end, { desc = 'skip selection / record macro' })
    end,
  },

  -- Snippet engine
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    event = 'InsertEnter',
    keys = {
      {
        '<C-k>',
        function()
          local ls = require('luasnip')
          if ls.expand_or_jumpable() then ls.expand_or_jump() end
        end,
        mode = { 'i', 's' },
        desc = 'expand snippet / jump forward',
      },
      {
        '<C-j>',
        function()
          local ls = require('luasnip')
          if ls.jumpable(-1) then ls.jump(-1) end
        end,
        mode = { 'i', 's' },
        desc = 'jump backward in snippet',
      },
      {
        '<C-l>',
        function()
          local ls = require('luasnip')
          if ls.choice_active() then ls.change_choice(1) end
        end,
        mode = { 'i', 's' },
        desc = 'next snippet choice',
      },
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load({
        paths = { vim.fn.stdpath('config') .. '/snippets' },
      }) -- own snippets only
    end,
  },

  -- Completion popup engine
  {
    'saghen/blink.cmp',
    version = '*', -- use a release tag (ships a prebuilt fuzzy-matcher binary)
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      -- respects the existing <leader>ta toggle (vim.b.completion)
      enabled = function()
        return vim.b.completion ~= false
      end,
      keymap = {
        preset = 'default', -- <C-y> accept, <C-n>/<C-p> select, <C-space> open, <C-e> hide
        ['<C-k>'] = {}, -- free <C-k> for LuaSnip (default preset binds it to signature)
        -- <Enter>: accept the selected item, otherwise insert a normal newline.
        -- <Tab> is intentionally left to copilot (see keymaps.lua).
        ['<CR>'] = { 'accept', 'fallback' },
      },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        -- 'solid' = invisible, background-colored frame -> padding without a border line
        menu = {
          -- Don't auto-pop the menu: it would hide copilot's ghost text and break
          -- the <Tab>-accepts-copilot mapping (see keymaps.lua). Open with <C-Space>.
          auto_show = false,
          border = 'solid',
          draw = { padding = { 1, 1 } }, -- horizontal padding around each item {left, right}
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = 'solid' },
        },
        ghost_text = { enabled = false }, -- copilot.vim already provides ghost text
      },
      signature = { enabled = true, window = { border = 'solid' } },
      appearance = { nerd_font_variant = 'normal' },
    },
    opts_extend = { 'sources.default' },
    config = function(_, opts)
      require('blink.cmp').setup(opts)

      -- Make the popup background lighter than the current colorscheme's popup bg.
      local function lighten(dec, amount)
        local r = math.floor(dec / 65536) % 256
        local g = math.floor(dec / 256) % 256
        local b = dec % 256
        r = math.min(255, math.floor(r + (255 - r) * amount))
        g = math.min(255, math.floor(g + (255 - g) * amount))
        b = math.min(255, math.floor(b + (255 - b) * amount))
        return string.format('#%02x%02x%02x', r, g, b)
      end

      local function set_blink_colors()
        local hl = vim.api.nvim_get_hl
        local base = (hl(0, { name = 'Pmenu' }).bg)
          or (hl(0, { name = 'NormalFloat' }).bg)
          or (hl(0, { name = 'Normal' }).bg)
        if not base then return end
        local bg = lighten(base, 0.15) -- 15% toward white; bump for more contrast
        -- include the *Border groups because the windows use the 'solid' border
        for _, group in ipairs({
          'BlinkCmpMenu', 'BlinkCmpMenuBorder',
          'BlinkCmpDoc', 'BlinkCmpDocBorder', 'BlinkCmpDocSeparator',
          'BlinkCmpSignatureHelp', 'BlinkCmpSignatureHelpBorder',
        }) do
          vim.api.nvim_set_hl(0, group, { bg = bg })
        end
      end

      set_blink_colors()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('blink_colors', { clear = true }),
        callback = set_blink_colors,
      })
    end,
  },

  -- Highlight word under cursor
  {
    'ya2s/nvim-cursorline',
    event = 'BufReadPost',
    opts = {
      cursorline = {
        enable = true,
        timeout = 0,
      },
    },
  },
}
