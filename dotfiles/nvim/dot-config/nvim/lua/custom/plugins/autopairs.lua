-- autopairs, for automatically pairing up parens and other stuff
-- https://github.com/windwp/nvim-autopairs

local M = {}

function M.setup()
  vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
  require('nvim-autopairs').setup {}
end

return M
