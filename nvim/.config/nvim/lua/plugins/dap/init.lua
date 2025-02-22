return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    "theHamsta/nvim-dap-virtual-text",
    "rcarriga/cmp-dap",
    "nvim-neotest/nvim-nio",

    -- lazy spec to build "microsoft/vscode-js-debug" from source
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = function()
        if require("utils").is_windows then
          vim.fn.system "npm install && npm run compile vsDebugServerBundle && move dist out"
        else
          vim.fn.system "npm install && npm run compile vsDebugServerBundle && mv dist out"
        end
      end,
    },
  },
  config = function()
    local dap = require "dap"
    local utils = require "plugins.dap.utils"
    local dap_repl = require "dap.repl"
    require "plugins.dap.ui"
    require "plugins.dap.python"
    require "plugins.dap.javascript"

    -- Other dap plugins
    local cmp = require "cmp"
    cmp.setup {
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
      end,
    }
    cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
      sources = {
        { name = "dap" },
      },
    })

    -- DAP Keymaps
    vim.keymap.set(
      "x",
      "<leader>ps",
      utils.print_selection,
      { noremap = true, silent = true, desc = "Print Selection" }
    )
    vim.keymap.set(
      "n",
      "<leader>pv",
      utils.open_vd_under_cursor,
      { noremap = true, silent = true, desc = "Print Variable" }
    )
    vim.keymap.set(
      "n",
      "<leader>pt",
      utils.describe_python_types_in_df_in_vd,
      { noremap = true, silent = true, desc = "Describe Pandas DataFrame Types" }
    )
    vim.keymap.set(
      "n",
      "<leader>pd",
      utils.summarise_python_types_in_df_in_vd,
      { noremap = true, silent = true, desc = "Summarise Pandas DataFrame Types" }
    )

    vim.keymap.set("n", "<F5>", utils.continue_and_toggle_neotree_if_dap_active)
    vim.keymap.set("n", "<S-F5>", function() dap.terminate() end)
    vim.keymap.set(
      "n",
      "<leader>dt",
      function() dap.terminate() end, -- Shift f5 not working in Kitty
      { noremap = true, silent = true, desc = "Dap Terminal" }
    )

    vim.keymap.set("n", "<F10>", function() dap.step_over() end)
    vim.keymap.set("n", "<F11>", function() dap.step_into() end)
    vim.keymap.set("n", "<F12>", function() dap.step_out() end)
    vim.keymap.set(
      "n",
      "<leader>b",
      function() dap.toggle_breakpoint() end,
      { noremap = true, silent = true, desc = "Set Breakpoint" }
    )
    vim.keymap.set(
      "n",
      "<leader>B",
      function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
      { noremap = true, silent = true, desc = "Set Conditional Breakpoint" }
    )
    vim.keymap.set("n", "<leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end)
    vim.keymap.set(
      "n",
      "<leader>dr",
      function() dap.repl.open() end,
      { noremap = true, silent = true, desc = "Open REPL" }
    )
    vim.keymap.set(
      "n",
      "<leader>dl",
      function() dap.run_last() end,
      { noremap = true, silent = true, desc = "Run LAST debug configuration" }
    )
    vim.keymap.set(
      "n",
      "<leader>dk",
      function() dap.up() end,
      { noremap = true, silent = true, desc = "Jump UP the callstack" }
    )
    vim.keymap.set(
      "n",
      "<leader>dj",
      function() dap.down() end,
      { noremap = true, silent = true, desc = "Jump DOWN the callstack" }
    )

    dap_repl.commands = vim.tbl_extend("force", dap_repl.commands, {
      p = "<Cmd>lua require('dap.repl').paste()<CR>",
    })
  end,
}
