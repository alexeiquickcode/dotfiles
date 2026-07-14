---@type LazySpec
return {

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "folke/snacks.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = { "venv", ".venv" },
      auto_refresh = true,
      auto_activate = true,
      notify_on_update = false,
      auto_select = { ".venv" },
      options = {
        picker = "snacks",
        picker_options = {
          snacks = {
            layout = {
              preset = "default",
              layout = {
                width = 0.9,
                height = 0.8,
              },
            },
          },
        },
      },
    },
    lazy = false,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

}
