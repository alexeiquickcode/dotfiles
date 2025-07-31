local dap = require "dap"
local dapui = require "dapui"

-- Virtual text (this packages shows inline variables in the debugger)
require("nvim-dap-virtual-text").setup {
  virt_text_pos = "eol",
}

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Dap UI
dapui.setup {
  controls = {
    element = "repl", -- The REPL element in the floating window
    enabled = true,   -- Enables controls
  },
  floating = {
    border = "rounded", -- Rounded borders for the floating window
    max_height = nil,   -- No maximum height
    max_width = nil,    -- No maximum width
  },
  element_mappings = {
    stacks = {
      open = "<CR>",
      expand = "o",
    },
  },
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 0.25,
      position = "right",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25,
      position = "bottom",
    },
  },
}

-- Other options are 'tabnew', 'belowright new'
dap.defaults.python.terminal_win_cmd = "tabnew"
dap.defaults.javascript.terminal_win_cmd = "tabnew"
dap.defaults.typescript.terminal_win_cmd = "tabnew"
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
dap.defaults["pwa-node"].terminal_win_cmd = "tabnew"

vim.keymap.set(
  "n",
  "<leader>du",
  function() dapui.toggle() end,
  { noremap = true, silent = true, desc = "Toggle DAP UI" }
)
