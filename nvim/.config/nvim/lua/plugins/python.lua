---@type LazySpec
return {

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = { "venv", ".venv" },
      auto_refresh = true,
      auto_activate = true,
      notify_on_update = false,
      auto_select = { ".venv" },
    },
    -- event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    lazy = false,
    branch = "regexp", -- NOTE: New version
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

  -- {
  --   "Willem-J-an/visidata.nvim",
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --     "rcarriga/nvim-dap-ui",
  --   },
  --   config = function()
  --     local dap = require "dap"
  --     local sysname = vim.loop.os_uname().sysname
  --     local command_path

  --     if sysname == "Windows_NT" then
  --       command_path = "powershell" -- Adjust this path as necessary
  --     else
  --       command_path = "/snap/bin/alacritty" -- Default path for Linux
  --     end

  --     dap.defaults.fallback.external_terminal = {
  --       command = command_path,
  --       args = { "--hold", "--command" },
  --     }
  --     vim.keymap.set("v", "<f4>", require("visidata").visualize_pandas_df, { desc = "[v]isualize [p]andas df" })
  --   end,
  -- },
}
