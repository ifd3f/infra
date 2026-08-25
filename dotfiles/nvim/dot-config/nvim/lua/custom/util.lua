-- Shared helpers.

local M = {}

-- Where meta.nvim gets symlinked, per its README. The plugin itself lives in
-- /usr/share/fb-editor-support/nvim, but the symlink is what we control, so a
-- dangling or absent one correctly reads as "not installed".
M.meta_nvim_path = vim.fn.stdpath 'data' .. '/site/pack/meta/start/meta.nvim'

--- Whether meta.nvim (Neovim@Meta) is installed on this machine.
---@return boolean
function M.is_meta() return vim.uv.fs_stat(M.meta_nvim_path) ~= nil end

--- `require` that yields nil when the module is absent. A module that exists
--- but fails to load still raises, so broken installs stay loud.
---@param modname string
---@return any|nil
function M.require_if_present(modname)
  local ok, mod = pcall(require, modname)
  if ok then return mod end
  -- Match only this module's own name: a nested "not found" means a missing
  -- dependency, which is a real failure rather than an absent module.
  if type(mod) == 'string' and mod:find("module '" .. modname .. "' not found", 1, true) then return nil end
  error(mod, 0)
end

return M
