# REpository/PROJect/SESSION loader

This is a simple plugin to manage Neovim sessions.
I have previously used [project.nvim](https://github.com/ahmedkhalf/project.nvim), [telescope-repo.nvim](https://github.com/cljoly/telescope-repo.nvim), and various session managers.
However, none of them have on their own covered my needs, and combining them have not been satisfactory.

This plugin takes the base concept of [telescope-repo.nvim](https://github.com/cljoly/telescope-repo.nvim), and utilizes [auto-session](https://github.com/rmagatti/auto-session)"s cwd feature to handle session switching.
As a bonus, it utilizes [file-browser](https://github.com/nvim-telescope/telescope-file-browser.nvim) for non-session functionality.

## Installation

Via packer.nvim:

``` lua
use {
  "MikaelElkiaer/telescope-reprosjession",
  requires = {
    "telescope.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "rmagatti/auto-session"
  },
  config = function()
    require "telescope".load_extension "file_browser"
    require "telescope".load_extension "reprosjession"
    require "auto-session".setup {
      cwd_change_handling = {
        restore_upcoming_session = true
      }
    }
  end
}
```

## Usage

The picker can be activated via `:Telescope reprosjession`, or `lua require"telescope".extensions.reprosjession()`.
Using the defaults, this should list any git repository within the user home directory.

By selecting a repository directory (`<CR>`), the picker will be closed and will instead display the file-browser picker from `nvim-telescope/telescope-file-browser.nvim`.

The secondary action (`<C-o>`) will switch the cwd (via `vim.api.nvim_set_current_dir(path_to_repo)`), utilizing cwd change handling in `auto-session` - i.e. saving the current session, closing buffers, then loading the selected session.

## Configuration

Currently not possible.
There are certain options that I imagine will be configurable.
They are listed here, along with their default value.

- `path`: User's home directory (via `vim.loop.os_homedir()`)
- `search_pattern`: Any directory with a `.git` folder (i. e. `"%.git$"`). The pattern is used to identify a repository by its content, the actual result will be the parent directory of the match.
- `depth`: 5, the max depth from the `path` directory to look for the search pattern - a simple performance optimization. Personally, I have a structure like so: `$HOME/Repositories/{vendor}/{organisation}/{repo}` and no deeper.

## Etymology

Self-explanatory...
