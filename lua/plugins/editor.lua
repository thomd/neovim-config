return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        include = {
          node_type = {
            bash = { 'if_statement', 'for_statement', 'while_statement', 'case_statement', 'compound_statement' },
            css = { 'rule_set', 'media_statement', 'block' },
            javascript = { 'object', 'array' },
            lua = { 'table_constructor' },
            python = { 'if_statement', 'for_statement', 'while_statement', 'with_statement', 'try_statement' },
            tsx = { 'object', 'array' },
            typescript = { 'object', 'array' },
            xml = { 'element' },
          },
        },
      },
      exclude = {
        filetypes = {
          'lazy',
          'mason',
          'neo-tree',
          'notify',
          'oil',
          'trouble',
        },
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown' },
    keys = {
      {
        '<leader>m',
        function()
          require('render-markdown').toggle()
        end,
        desc = 'markdown render',
      },
    },
    opts = {
      enabled = false,
      heading = { icons = {}, sign = false },
      code = { sign = false, language_name = false, language_icon = false, left_pad = 4 },
      bullet = { icons = { '•', '◦', '▪', '▫' } },
      checkbox = {
        unchecked = { icon = '[ ]' },
        checked = { icon = '[x]' },
        custom = { todo = { raw = '[-]', rendered = '[-]' } },
      },
      quote = { icon = '│' },
      link = { enabled = false },
      pipe_table = { preset = 'round', head = 'RenderMarkdownTableHead', row = 'RenderMarkdownTableRow' },
      latex = { enabled = false },
    },
  },
}
