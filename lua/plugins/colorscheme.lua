return {
  {
    'thomd/wasabi.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('wasabi').setup({
        transparent = false,
        italic_comment = false,
      })
      vim.cmd.colorscheme('wasabi')
    end,
  },
}
