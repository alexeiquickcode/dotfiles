---@type LazySpec
return {

  -- For solving merge conflicts
  { "akinsho/git-conflict.nvim", version = "*", config = true },

  -- Plugin for Git blame
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    },
    config = function(_, opts)
      require("gitblame").setup(opts)
      vim.api.nvim_set_keymap("n", "<leader>gb", ":GitBlameToggle<CR>", { noremap = true, silent = true })
    end,
  },


  { 'tpope/vim-fugitive' },
}
