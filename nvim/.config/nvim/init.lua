local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load first
require "utils"

-- Set python interpreter
vim.g.python3_host_prog = require("utils").get_python_executable()
require "core.options"
require("lazy").setup "plugins"

-- Set the theme and highlight groups. TODO: Maybe move this to UI
vim.cmd "colorscheme astrodark"
require "core.ui-options" -- Import this after setting the colorscheme to override
require "core.keymaps"
