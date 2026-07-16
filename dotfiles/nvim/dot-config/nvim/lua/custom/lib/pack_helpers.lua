local function run_build_command(plugin_name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(plugin_name, output), vim.log.levels.ERROR)
  end
end

-- This autocommand runs after a plugin is installed or updated and
--  runs the appropriate build command for that plugin if necessary.
--
-- See `:help vim.pack-events`
-- vim.api.nvim_create_autocmd('PackChanged', {
--   callback = function(ev)
--     local name = ev.data.spec.name
--     local kind = ev.data.kind
--     if kind ~= 'install' and kind ~= 'update' then return end
-- 
--     if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
--       run_build_command(name, { 'make' }, ev.data.path)
--       return
--     end
-- 
--     if name == 'LuaSnip' then
--       if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build_command(name, { 'make', 'install_jsregexp' }, ev.data.path) end
--       return
--     end
-- 
--     if name == 'nvim-treesitter' then
--       if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
--       vim.cmd 'TSUpdate'
--       return
--     end
--   end,
-- })

return {
  run_build_command = run_build_command,
}

