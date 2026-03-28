local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Return to last edit position
local exclude_ft = { gitcommit = true, gitrebase = true, help = true }
autocmd('BufReadPost', {
  group = augroup('restore_cursor', { clear = true }),
  callback = function(event)
    if exclude_ft[vim.bo[event.buf].filetype] then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits on window resize
autocmd('VimResized', {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close certain filetypes with q
-- Note: 'man' is excluded because Neovim has built-in q handling for man pages
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = {
    'checkhealth',
    'git',
    'help',
    'lspinfo',
    'notify',
    'qf',
    'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', function()
      local ok = pcall(vim.cmd.bdelete, { bang = true })
      if not ok then
        vim.cmd.quit()
      end
    end, { buffer = event.buf, silent = true, desc = 'Close buffer' })
  end,
})

-- Auto create parent directories when saving
autocmd('BufWritePre', {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Check if file changed outside of vim
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime', { clear = true }),
  callback = function()
    if vim.bo.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Auto-trim trailing whitespace on save (skip markdown)
autocmd('BufWritePre', {
  group = augroup('trim_whitespace', { clear = true }),
  callback = function()
    if not vim.bo.modifiable or vim.bo.buftype ~= '' then return end
    if vim.bo.filetype ~= 'markdown' then
      local save_cursor = vim.fn.getpos('.')
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for i, line in ipairs(lines) do
        lines[i] = line:gsub('%s+$', '')
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.fn.setpos('.', save_cursor)
    end
  end,
})

-- :q closes buffer instead of quitting when multiple buffers are open
vim.api.nvim_create_user_command('Q', function(opts)
  local listed_bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #listed_bufs > 1 and #vim.api.nvim_list_wins() == 1 then
    if opts.bang then
      vim.cmd('BufferClose!')
    else
      vim.cmd('BufferClose')
    end
  else
    vim.cmd(opts.bang and 'quit!' or 'quit')
  end
end, { bang = true })
vim.cmd('cabbrev <expr> q getcmdtype() == ":" && getcmdline() ==# "q" ? "Q" : "q"')
vim.cmd('cabbrev <expr> q! getcmdtype() == ":" && getcmdline() ==# "q!" ? "Q!" : "q!"')

-- Hide cursor in NvimTree
autocmd('FileType', {
  group = augroup('nvimtree_cursor', { clear = true }),
  pattern = 'NvimTree',
  callback = function()
    local saved = vim.o.guicursor
    vim.api.nvim_set_hl(0, 'NvimTreeHiddenCursor', { blend = 100, nocombine = true })
    vim.o.guicursor = 'a:NvimTreeHiddenCursor'
    autocmd('BufLeave', {
      buffer = 0,
      once = true,
      callback = function()
        vim.o.guicursor = saved
      end,
    })
  end,
})

-- Disable statuscolumn for specific filetypes/buftypes
local dominated_filetypes = { help = true, lazy = true, mason = true, NvimTree = true, oil = true, trouble = true }
autocmd('BufWinEnter', {
  group = augroup('statuscolumn_exclusions', { clear = true }),
  callback = function(event)
    if dominated_filetypes[vim.bo[event.buf].filetype] then
      vim.wo.statuscolumn = ''
      vim.wo.signcolumn = 'no'
    end
  end,
})

autocmd('OptionSet', {
  group = augroup('statuscolumn_exclusions', { clear = false }),
  pattern = 'buftype',
  callback = function()
    local buftype = vim.v.option_new
    if buftype == 'nofile' or buftype == 'terminal' then
      vim.wo.statuscolumn = ''
      vim.wo.signcolumn = 'no'
    end
  end,
})
