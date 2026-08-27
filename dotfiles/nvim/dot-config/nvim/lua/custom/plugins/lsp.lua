-- LSP configuration.

local util = require 'custom.util'

local M = {}

local function setup_other_meta_lsps()
  require 'meta.lsp'

  vim.lsp.enable {
    'thriftlsp@meta', -- for Thrift
    'cppls@meta', -- for C++
    'buckls@meta', -- for Buck
    'buck2@meta', -- new LS for Buck/Starlark
    'hhvm', -- for Hack
    'linttool@meta', -- for linting and formatting
    'relay@meta', -- for GraphQL/relay
    'ids@meta', -- Meta task info (hover + hint diagnostics on T-numbers)
  }
end

local function setup_python()
  if util.is_meta() then
    vim.lsp.enable 'pyrefly@meta'
  else
    -- TODO: python
  end
end

local function setup_rust()
  if util.is_meta() then
    vim.lsp.enable 'rust-analyzer@meta'
  else
    vim.lsp.enable 'rust_analyzer'
  end
end

local function setup_lua()
  -- Used to format Lua code
  vim.lsp.config('stylua', {})

  -- Special Lua Config, as recommended by neovim help docs
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  })

  vim.lsp.enable { 'lua_ls', 'stylua' }
end

local function lsp_attach_callback(event)
  -- Helper function for creating LSP keymaps that apply only to the buffer.
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Now enable client-specific things
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    vim.notify('No LSP client was found', vim.log.levels.INFO)
    return
  end

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  if client:supports_method('textDocument/documentHighlight', event.buf) then
    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  -- Toggle inlay hints, if supported
  if client:supports_method('textDocument/inlayHint', event.buf) then
    map('grh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay [H]ints')
  end
end

function M.setup()
  -- Fidget adds notifications and LSP progress messages.
  vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
  require('fidget').setup {}

  -- This function gets run when an LSP attaches to a particular buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = lsp_attach_callback,
  })

  -- Mason automatically installs LSPs and related tools to stdpath for Neovim.
  vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  -- Mason tool installer performs LSP installation
  local servers = { 'rust_analyzer', 'stylua', 'lua_ls' }
  local ensure_installed = vim.list_extend(vim.deepcopy(servers), {
    -- You can add other tools here that you want Mason to install
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  setup_rust()
  setup_python()
  setup_lua()

  if util.is_meta() then setup_other_meta_lsps() end
end

return M
