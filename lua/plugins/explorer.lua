return {
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '<leader>n', '<cmd>NvimTreeToggle<cr>', desc = 'toggle file tree' },
    },
    opts = function(_, opts)
      local api = require('nvim-tree.api')
      opts.on_attach = function(bufnr)
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', '<CR>', function()
          local node = api.tree.get_node_under_cursor()
          if node and (node.type == 'directory' or node.nodes) then
            api.node.open.edit()
          else
            api.node.open.no_window_picker()
            api.tree.close()
          end
        end, { buffer = bufnr, desc = 'toggle folder / open file and close tree' })
        vim.keymap.set('n', 't', function()
          api.node.open.no_window_picker()
          api.tree.focus()
        end, { buffer = bufnr, desc = 'open file and keep focus' })
      end
    end,
    config = function(_, opts)
      require('nvim-tree').setup({
      hijack_directories = {
        enable = false,
      },
      update_focused_file = {
        enable = true,
      },
      view = {
        side = 'left',
        width = 40,
        cursorline = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = 'name',
        highlight_opened_files = 'name',
        highlight_diagnostics = 'name',
        highlight_modified = 'name',
        indent_markers = {
          enable = false,
        },
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = false,
          },
          glyphs = {
            folder = {
              arrow_closed = '▸',
              arrow_open = '▾',
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      modified = {
        enable = true,
      },
      filters = {
        custom = { '^.git$' },
      },
      on_attach = opts.on_attach,
    })
    end,
  },
}
