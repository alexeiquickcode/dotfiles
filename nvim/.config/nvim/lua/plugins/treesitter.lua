--- @type LazySpec
return {
  {
    "LiadOz/nvim-dap-repl-highlights",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function() require("nvim-dap-repl-highlights").setup() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      vim.filetype.add({
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
          ["Jenkinsfile%..*"] = "groovy",
        },
        filename = {
          ["Jenkinsfile"] = "groovy",
          ["BUILD"] = "starlark",
          ["BUILD.pants"] = "starlark",
        },
        extension = {
          ["star"] = "starlark",
        },
      })

      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = { enable = true },
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
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
          "groovy",
          "terraform",
          "hcl",
        },
      })

      vim.treesitter.language.register("python", "starlark")
    end,
  },
}
