local M = {}

function M.setup()
  vim.pack.add {
    'https://github.com/akinsho/toggleterm.nvim',
  }
  require('toggleterm').setup {
    open_mapping = '<C-;>',
  }

  vim.keymap.set('n', '<C-Return>', '<Cmd>TermNew<CR>', { desc = 'New ToggleTerm', silent = true })
end

return M
