--- @type LazySpec
return {
  {
    "LiadOz/nvim-dap-repl-highlights", -- The REPL highlights plugin
    dependencies = { "mfussenegger/nvim-dap" }, -- Ensure this is loaded after nvim-dap
    config = function() 
      require("nvim-dap-repl-highlights").setup()
    end,
    before = "nvim-treesitter/nvim-treesitter", -- Ensure this is loaded before Treesitter
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        queries = {
          python = [[
            (module
              (string) @docstring)
          ]],
        },
      })
    end
  }
}

-- ---@type LazySpec
-- return {
--   "nvim-treesitter/nvim-treesitter",
--   opts = {
--     ensure_installed = {
--       "lua",
--       "vim",
--       "typescript",
--       "javascript",
--       "tsx",
--       "json",
--       "html",
--       "css",
--       "scss",
--       "yaml",
--       "python",
--       "rust",
--       "c",
--       "cpp",
--       "java",
--       "toml",
--       "ini",
--     },
--   },

-- }
