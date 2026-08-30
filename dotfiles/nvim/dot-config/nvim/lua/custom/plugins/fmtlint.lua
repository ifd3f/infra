-- Formatting and linting plugins.
local M = {}

function M.setup()
  do
    -- [[ Formatting ]]
    vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
    require('conform').setup {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- You can specify filetypes to autoformat on save here:
        local enabled_filetypes = {
          -- lua = true,
          -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        else
          return nil
        end
      end,
      default_format_opts = {
        lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
      },
      -- You can also specify external formatters in here.
      formatters_by_ft = {
        nix = { 'nixfmt' },
        rust = { 'rustfmt' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
  end

  -- Automatic linting on enter, save, and edit.
  --
  -- This plugin basically seems to spawn an external linting program to do what it needs to do.
  do
    vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

    local lint = require 'lint'

    -- disable that shit
    lint.linters_by_ft['markdown'] = nil

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then lint.try_lint() end
      end,
    })
  end
end

return M
