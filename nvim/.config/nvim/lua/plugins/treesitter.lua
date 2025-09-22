--- @type LazySpec
return {
  {
    "LiadOz/nvim-dap-repl-highlights",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function() require("nvim-dap-repl-highlights").setup() end,
    before = "nvim-treesitter/nvim-treesitter", -- Load before treesitter
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require "nvim-treesitter.configs"
      config.setup {
        auto_install = true,
        highlight = { enable = true },
        ensure_installed = {
          "lua",
          "vim",
          "typescript",
          "javascript",
          "tsx",
          "json",
          "html",
          "css",
          "scss",
          "yaml",
          "python",
          "rust",
          "c",
          "cpp",
          "java",
          "toml",
          "ini",
          "regex",
          "bash",
          "markdown",
          "markdown_inline",
          "hyprlang",
          "latex",
          "groovy",
        },
        indent = { enable = true },
        queries = {
          python = [[
            (module
              (string) @docstring)
          ]],
        },
      }

      vim.filetype.add({
        pattern = { 
          [".*/hypr/.*%.conf"] = "hyprlang",
          ["Jenkinsfile%..*"] = "groovy",
        },
        filename = {
          ["Jenkinsfile"] = "groovy",
        },
      })
    end,
  },
}
