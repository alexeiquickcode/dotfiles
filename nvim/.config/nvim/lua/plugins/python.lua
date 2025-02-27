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

}
