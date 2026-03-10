return {
  -- Comment.nvim (nerdcommenter equivalent)
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    opts = {},
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
    event = 'BufReadPost',
    opts = {},
  },

  -- Highlight word under cursor
  {
    'ya2s/nvim-cursorline',
    event = 'BufReadPost',
    opts = {},
  },
}
