---@type LazySpec
return {

  -- Plugin for multi line cursors
  { "mg979/vim-visual-multi" },

  -- VIM extension to close buffers
  {
    "moll/vim-bbye",
    event = "BufRead",
  },

  -- VIM extension to surround text with quotes, brackets, etc. (keymap = visual mode S')
  {
    "tpope/vim-surround",
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  -- Comment stuff out easily
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true, -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
          extra = true, -- Includes `gco`, `gcO`, `gcA`
          extended = false,
        },
        pre_hook = nil,
        post_hook = nil,
        ignore = nil,
        -- This enables treating multiple line comments as a single undo step
        sticky = true,
      }
    end,
    event = "BufRead", -- Load the plugin when a buffer is read
  },

}
