local state_file = vim.fn.stdpath('data') .. '/copilot_enabled'

local function copilot_load_state()
  local f = io.open(state_file, 'r')
  if f then
    local val = f:read('*l')
    f:close()
    return val == 'true'
  end
  return true -- enabled by default
end

local function copilot_save_state(enabled)
  local f = io.open(state_file, 'w')
  if f then
    f:write(enabled and 'true' or 'false')
    f:close()
  end
end

return {
  {
    "github/copilot.vim",
    lazy = false,
    init = function()
      vim.g.copilot_filetypes = { markdown = false }
      if not copilot_load_state() then
        vim.g.copilot_enabled = false
      end
    end,
    keys = {
      { '<S-Right>', '<Plug>(copilot-next)', desc = 'next copilot suggestion', mode = 'i' },
      { '<S-Left>', '<Plug>(copilot-previous)', desc = 'previous copilot suggestion', mode = 'i' },
      {
        '<leader>a',
        function()
          if vim.fn['copilot#Enabled']() == 1 then
            vim.cmd('Copilot disable')
            copilot_save_state(false)
          else
            vim.cmd('Copilot enable')
            copilot_save_state(true)
          end
          vim.cmd('redrawstatus')
        end,
        desc = 'toggle copilot',
      },
    },
  },
}
