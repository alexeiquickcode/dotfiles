-- Scrolling
vim.keymap.set("n", "<C-j>", "<C-d>", { noremap = true, silent = true, desc = "Scroll down" })
vim.keymap.set("n", "<C-k>", "<C-u>", { noremap = true, silent = true, desc = "Scroll up" })

-- Indentation in visual mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" })
-- vim.keymap.set('v', '<', '<gv=gv', { desc = 'Indent line' })
-- vim.keymap.set('v', '>', '>gv=gv', { desc = 'Indent line' })

-- Moving lines
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move lines down" })
-- vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
-- vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- Duplicating lines or selections
vim.keymap.set("n", "<A-d>", "yyp", { noremap = true, silent = true, desc = "Duplicate line" })
vim.keymap.set("v", "<A-d>", "y`>p", { noremap = true, silent = true, desc = "Duplicate selection" })

-- Navigate buffers
vim.keymap.set("n", "]b", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Navigate tabs
vim.keymap.set("n", "]t", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })
vim.keymap.set("n", "[t", ":tabprevious<CR>", { noremap = true, silent = true, desc = "Previous tab" })

-- Do not copy when using 'x'
vim.keymap.set("n", "x", '"_x', { desc = "Do not copy when using 'x'" })

-- Undo (shift required)
vim.keymap.set("n", "U", "u", { desc = "Undo (shift required)" })

-- Disable 'u' key
vim.keymap.set("n", "u", "<Nop>", { desc = "Disable 'u' key" })

-- Telescope go to definition
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Telescope go to definition" })

-- Do not copy delete to clipboard
vim.keymap.set("n", "d", '"_d', { desc = "Do not copy delete to clipboard" })
vim.keymap.set("v", "d", '"_d', { desc = "Do not copy delete to clipboard" })

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', { desc = "Keep last yanked when pasting" })

-- Close buffer from tabline (NOT SURE THIS WORKS)
vim.keymap.set("n", "<Leader>bd", function()
  require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
end, { desc = "Close buffer from tabline" })

-- Close current buffer (need to install moll/vim-bbye [this is a VIM ext] for this)
vim.keymap.set("n", "<leader>c", ":Bdelete<CR>", { noremap = true, silent = true })

-- Set a keymap for <leader>e to toggle Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Close floating UI window
vim.keymap.set("n", "q", "<cmd>close<CR>", { noremap = true, silent = true })

-- Record macro
vim.keymap.set("n", "Q", "q", { noremap = true, silent = true })

-- Spell check
vim.keymap.set("n", "<leader>ss", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell check" })

-- Terminal mode mappings
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
