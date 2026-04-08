local map = vim.keymap.set
local t = function(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end

-- Tab: accept copilot suggestion > navigate popup > buffer completion > literal tab
map('i', '<Tab>', function()
  local suggestion = vim.fn['copilot#GetDisplayedSuggestion']()
  if suggestion and suggestion.text ~= '' then
    return vim.fn['copilot#Accept']('')
  elseif vim.fn.pumvisible() == 1 then
    return t('<C-n>')
  end
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return t('<Tab>')
  end
  return t('<C-n>')
end, { expr = true, silent = true, replace_keycodes = false, desc = 'tab complete' })
map('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, desc = 'tab complete prev' })

-- Better escape
map('i', 'jk', '<Esc>', { desc = 'escape' })
map('i', 'jj', '<Esc>', { desc = 'escape' })

-- Swap v and CTRL-V: block mode is more useful than visual mode
map('n', 'v', '<C-V>', { desc = 'block visual' })
map('n', '<C-V>', 'v', { desc = 'visual' })
map('v', 'v', '<C-V>', { desc = 'block visual' })
map('v', '<C-V>', 'v', { desc = 'visual' })

-- Better movement
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'up' })

-- Buffers (barbar)
map('n', '<S-Left>', '<cmd>BufferPrevious<cr>', { desc = 'previous buffer' })
map('n', '<S-Right>', '<cmd>BufferNext<cr>', { desc = 'next buffer' })

-- Windows
map('n', '<C-h>', '<C-w>h', { desc = 'go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'go to right window' })
map('n', '<leader>ww', '<C-w>p', { desc = 'other window' })
map('n', '<leader>wd', '<C-w>c', { desc = 'delete window' })
map('n', '<leader>ws', '<C-w>s', { desc = 'split window below' })
map('n', '<leader>wv', '<C-w>v', { desc = 'split window right' })
map('n', '<leader>w=', '<C-w>=', { desc = 'equalize windows' })

-- Resize windows
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'increase window width' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'clear search highlight' })

-- Better indenting
map('v', '<', '<gv', { desc = 'indent left' })
map('v', '>', '>gv', { desc = 'indent right' })

-- Save
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'save file' })

-- Better paste
map('x', 'p', '"_dP', { desc = 'paste without yanking' })

-- Add blank lines
map('n', ']<space>', 'o<esc>k', { desc = 'add blank line below' })
map('n', '[<space>', 'O<esc>j', { desc = 'add blank line above' })

-- Quickfix
map('n', '<leader>xn', '<cmd>cnext<cr>', { desc = 'next quickfix' })
map('n', '<leader>xp', '<cmd>cprev<cr>', { desc = 'previous quickfix' })

-- Code
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'line diagnostics' })
map('n', '<leader>cw', function()
  local save_cursor = vim.fn.getpos('.')
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('%s+$', '')
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.fn.setpos('.', save_cursor)
end, { desc = 'trim whitespace' })

-- Spell toggle
map('n', '<leader>s', '<cmd>set spell!<cr>', { desc = 'toggle spell' })

-- Toggle options
local toggles = {
  { 'w', 'wrap', 'wrap' },
  { 'c', 'cursorline', 'cursorline' },
  { 'h', 'list', 'hidden chars' },
}
map('n', '<leader>l', function() vim.wo.relativenumber = not vim.wo.relativenumber end, { desc = 'relative numbers', nowait = true })
for _, t in ipairs(toggles) do
  map('n', '<leader>t' .. t[1], function()
    vim.wo[t[2]] = not vim.wo[t[2]]
  end, { desc = t[3] })
end
map('n', '<leader>d', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'toggle diagnostics' })
map('n', '<leader>tl', function()
  local config = vim.diagnostic.config() or {}
  local new_value = not config.virtual_lines
  vim.diagnostic.config({ virtual_lines = new_value })
end, { desc = 'diagnostic lines' })
map('n', '<leader>ta', function()
  if vim.b.completion == false then
    vim.b.completion = true
    vim.notify('Completion enabled', vim.log.levels.INFO)
  else
    vim.b.completion = false
    vim.notify('Completion disabled', vim.log.levels.INFO)
  end
end, { desc = 'auto-completion' })

map('n', '<leader>i', '<cmd>IBLToggle<cr>', { desc = 'indent lines' })

map('n', '<leader>tL', function()
  vim.g.disable_auto_lint = not vim.g.disable_auto_lint
  if vim.g.disable_auto_lint then
    vim.diagnostic.enable(false, { bufnr = 0 })
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      client:stop()
    end
    vim.notify('LSP & Linter disabled', vim.log.levels.INFO)
  else
    vim.diagnostic.enable(true, { bufnr = 0 })
    vim.cmd('LspStart')
    local ok, lint = pcall(require, 'lint')
    if ok then
      lint.try_lint()
    end
    vim.notify('LSP & Linter enabled', vim.log.levels.INFO)
  end
end, { desc = 'LSP & linter' })
