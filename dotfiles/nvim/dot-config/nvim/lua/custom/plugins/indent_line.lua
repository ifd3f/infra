-- Add indentation guides even on blank lines

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`

return function()
  vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
  require('ibl').setup {}
end
