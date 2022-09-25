local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This extension requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local Path = require "plenary.path"
local scan = require "plenary.scandir"

local finder = function(opts)
  opts = opts or {}
  local dirs = scan.scan_dir(opts.root_dir or vim.loop.os_homedir(), {
    hidden = true,
    only_dirs = true,
    search_pattern = "%.git$",
    depth = 5
  })
  for i, v in ipairs(dirs) do
    dirs[i] = Path:new(v):parent():absolute()
  end
  return finders.new_table {
    results = dirs
  }
end

local picker = function(opts)
  opts = opts or {}
  opts.finder = finder(opts)
  pickers.new(opts, {
    prompt_title = "REpository/PROJect/SESSION picker",
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        telescope.extensions.file_browser.file_browser({ path = selection[1], initial_mode = 'normal' })
      end)
      map("i", "<C-o>", function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local notify = require 'notify'
        vim.api.nvim_set_current_dir(selection[1])
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension {
  setup = function(ext_config, config)

  end,
  exports = {
    reprosjession = picker,
  }
}
