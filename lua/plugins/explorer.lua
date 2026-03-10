return {
  {
    'nvim-tree/nvim-tree.lua',
    keys = {
      { '<leader>n', '<cmd>NvimTreeToggle<cr>', desc = 'toggle file tree' },
    },
    opts = {
      hijack_directories = {
        enable = false,
      },
      update_focused_file = {
        enable = true,
      },
      view = {
        side = 'left',
        width = 40,
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
            folder_arrow = false,
            git = false,
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
    },
  },
}
