-- none-ls shim, required by meta.nvim
-- none-ls exposes non-LSP tooling (linters, formatters, code actions) to
-- Neovim through a language server shim.

local M = {}

function M.setup()
  vim.pack.add {
    -- Note that it depends on plenary.
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvimtools/none-ls.nvim',
  }

  -- TODO: populate with meta stuff
  require('null-ls').setup { sources = {} }
end

return M
