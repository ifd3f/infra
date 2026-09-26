local M = {}

M.path = '~/n'

function M.setup()
  vim.pack.add { { src = 'https://github.com/epwalsh/obsidian.nvim', version = 'v3.9.0' } }
  vim.opt.conceallevel = 2

  require('obsidian').setup {
    workspaces = {
      {
        name = 'personal',
        path = M.path,
      },
    },
    ui = {
      enable = true,
    },

    callbacks = {
      -- set conceallevel only for obsidian notes
      enter_note = function(client, note)
        vim.api.nvim_buf_call(note.bufnr, function() vim.opt_local.conceallevel = 2 end)
      end,
    },

    --completion = {
    --  nvim_cmp = true,
    --  min_chars = 2,
    --},
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },
    daily_notes = {
      folder = 'journal',
      date_format = '%Y/%m/%d/%Y-%m-%d-%a',
      --alias_format = '%Y-%m-%d %A',
      --default_tags = { 'day' },
      template = 'templates/day-note-template',
    },
    picker = {
      name = 'telescope.nvim',
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
      },
    },
  }
end

return M
