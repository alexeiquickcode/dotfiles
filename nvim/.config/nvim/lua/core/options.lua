vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set the font in Neovide
vim.opt.guifont = "CaskaydiaCove Nerd Font Propo:h10"

-- Get rid of that swap file
vim.opt.swapfile = false

-- Set tab size for JavaScript files to 4 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "json" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true -- Use spaces instead of tabs
  end,
})

-- Set tab size for Lua files to 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true -- Use spaces instead of tabs
  end,
})

-- Set python 3 host program
local handle = io.popen "pyenv global"
local python_version = handle:read("*a"):gsub("%s+", "")
handle:close()
local base_dir = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1 and vim.env.USERPROFILE or vim.env.HOME
if vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1 then
  vim.g.python3_host_prog = base_dir .. "/.pyenv/pyenv-win/versions/" .. python_version .. "/python.exe"
else
  vim.g.python3_host_prog = base_dir .. "/.pyenv/versions/" .. python_version .. "/bin/python"
end

-- Use terminal colours
vim.opt.termguicolors = true
