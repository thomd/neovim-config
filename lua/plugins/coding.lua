return {
  -- Comment.nvim (nerdcommenter equivalent)
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    opts = {
      toggler = { line = '<leader>c' },
      opleader = { line = '<leader>c' },
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
