local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/mikavilpas/yazi.nvim' }
  require('yazi').setup {}

  vim.keymap.set({ 'n', 'v' }, '\\f', '<Cmd>Yazi<CR>', { desc = 'open yazi at file' })
  vim.keymap.set({ 'n', 'v' }, '\\d', '<Cmd>Yazi cwd<CR>', { desc = 'open yazi at cwd' })
  vim.keymap.set({ 'n', 'v' }, '\\\\', '<Cmd>Yazi toggle<CR>', { desc = 'open last yazi session' })
end

return M
