local opt = vim.opt
local o = vim.o

o.backup = false
o.clipboard = ''
o.cmdheight = 2
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.mouse = 'a'
o.number = true
o.numberwidth = 4
o.pumheight = 10
o.relativenumber = true
o.scrolloff = 8
o.shiftwidth = 2
o.showmode = false
o.sidescrolloff = 8
o.signcolumn = 'auto:1'
o.smartcase = true
o.smartindent = true
o.smoothscroll = true
o.softtabstop = 2
o.splitbelow = true
o.splitright = true
o.statuscolumn = '%s%{%v:relnum?"%= %{&relativenumber?v:relnum:v:lnum} ":"%- %{v:lnum} "%}'
o.synmaxcol = 2048
o.tabstop = 8
o.textwidth = 110
o.timeoutlen = 500
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000
o.updatetime = 250
opt.whichwrap:append('<,>,h,l,[,]')
o.wrap = false
o.writebackup = false
opt.iskeyword:append('-')

-- Cursor appearance and blinking
o.guicursor = table.concat({
  'a:ver25', -- All modes: vertical bar cursor
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Whitespace characters
o.list = true
opt.listchars = { tab = '  ', trail = ' ', nbsp = ' ' }

-- Fill chars
opt.fillchars:append({
  diff = '░',
  eob = '~',
  fold = '⋯',
  foldopen = '▼',
  foldclose = '▶',
  foldsep = '┊',
  msgsep = '━',
})

-- Floating window border (Neovim 0.11+)
o.winborder = 'single'

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

-- Spelling
o.spelllang = 'en_gb'
o.spellsuggest = 'best,20' -- Limits to 20 suggestions

-- Colorscheme (termguicolors is auto-detected since Neovim 0.10+)
