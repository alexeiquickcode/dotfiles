-- Highlight groups for LSP
vim.cmd [[
  highlight DiagnosticUnderlineError cterm=underline gui=underline guisp=#ff5638
  highlight DiagnosticUnderlineWarn gui=underline
  highlight NvimDapVirtualText guifg=white gui=italic
]]

-- Bufferline HL groups
vim.cmd [[
  highlight BufferLineBufferSelected guifg=#ffffff gui=bold,italic
  highlight BufferLineSelectedIcon guifg=#ffffff
  ]]

-- Current line number yellow
vim.cmd [[highlight CursorLineNr guifg=#FFFF00]]

-- Command line HL group
vim.cmd [[highlight Cmdline guifg=#ffffff guibg=#000000]]

-- Remove lsp symbols on line numbers
vim.cmd [[
  sign define DiagnosticSignError text= texthl=TextError linehl= numhl=
  sign define DiagnosticSignWarn  text= texthl=TextWarn  linehl= numhl=
  sign define DiagnosticSignInfo  text= texthl=TextInfo  linehl= numhl=
  sign define DiagnosticSignHint  text= texthl=TextHint  linehl= numhl=
]]

-- Remove the LSP diagnostics ?
vim.diagnostic.config {
  signs = false,
}

-- vim.cmd [[
--   syn region pythonDocString start=+^\s*"""+ end=+"""+ keepend contains=...
--   HiLink pythonDocString        Comment
-- ]]

-- Normal mode cursor color
vim.cmd "highlight Cursor guifg=NONE guibg=#77fc03"

-- Visual mode cursor color
-- vim.cmd('highlight Visual guifg=NONE guibg=#FF0000')

-- Insert mode cursor colora
vim.cmd "highlight iCursor guifg=NONE guibg=#77fc03"
vim.cmd "set guicursor=n-v-c:block-Cursor"
vim.cmd "set guicursor+=i:ver25-iCursor"

-- Define a highlight group for the yank highlight
vim.cmd [[highlight YankHighlight cterm=reverse gui=reverse]]

-- Autocommand to flash the area where text was yanked
vim.api.nvim_create_augroup("YankHighlight", { clear = true }) -- NEED TO PICK A COLOR HERE FOR THE HIGHLIGHT
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  pattern = "*",
  callback = function() vim.highlight.on_yank { higroup = "YankHighlight", timeout = 200 } end,
})

-- Make DAP BREAKPOINTS more visible
-- Define a custom highlight group for DAP breakpoint marker text
vim.api.nvim_set_hl(0, "DapUIBreakpoints", { fg = "#5EB7FF", bold = true })

-- Custom highlight group
vim.api.nvim_set_hl(0, "DapCurrentLine", { bg = "#FFF9C4", bold = false })

-- Ensure dap uses the custom highlight group
vim.fn.sign_define(
  "DapStopped",
  { text = "", texthl = "DapCurrentLine", linehl = "DapCurrentLine", numhl = "DapCurrentLine" }
)

-- Define the DAP breakpoint sign and link it to the custom highlight group
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapUIBreakpoints", linehl = "", numhl = "" })
