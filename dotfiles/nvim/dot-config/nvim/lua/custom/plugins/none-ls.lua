-- none-ls shim, required by meta.nvim
-- none-ls exposes non-LSP tooling (linters, formatters, code actions) to
-- Neovim through a language server shim.
return function()
  vim.pack.add {
    -- Note that it depends on plenary.
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvimtools/none-ls.nvim',
  }

  -- TODO: populate with meta stuff
  require('null-ls').setup { sources = {} }
end
