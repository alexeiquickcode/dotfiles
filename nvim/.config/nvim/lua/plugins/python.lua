---@type LazySpec
return {

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      -- Your options go here
      name = { "venv", ".venv" },
      auto_refresh = true,
      auto_activate = true,
      notify_on_update = false,  -- Add this line to disable update notifications
      auto_select = { ".venv" }, -- Add this line to automatically select a venv if found
    },
    -- event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

  {
    "benlubas/molten-nvim",
  }

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

