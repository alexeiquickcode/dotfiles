return {
  {
    -- TODO: Clean this shit up
    --
    -- LSP Configuration
    -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      -- LSP Management
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "js-debug-adapters",
          },
        },
      },
      { "williamboman/mason-lspconfig.nvim" },

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim",                opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      { "folke/neodev.nvim" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "bashls", -- (uses npm)
          "cssls",  -- (uses npm)
          "html",   -- (uses npm)
          "lua_ls",
          "jsonls", -- (uses npm)
          "lemminx",
          "marksman",
          "quick_lint_js",
          "ts_ls",  -- (uses npm)
          "yamlls", -- (uses npm)
          -- 'basedpyright' -- (installed using pip)
          "rust_analyzer",
          "dockerls",
          "terraformls",
        },
      }

      local lspconfig = require "lspconfig"
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_attach = function(client, bufnr)
        -- Create your keybindings here...
      end

      -- Call setup on each LSP server
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          }
        end,
        -- Terraform LSP with custom root pattern
        terraformls = function()
          local terraform_capabilities = vim.deepcopy(lsp_capabilities)
          -- Disable semantic tokens to let Treesitter handle syntax highlighting
          terraform_capabilities.textDocument.semanticTokens = vim.NIL

          lspconfig.terraformls.setup {
            on_attach = lsp_attach,
            capabilities = terraform_capabilities,
            root_dir = lspconfig.util.root_pattern(".terraform", ".git", "*.tf"),
          }
        end,
      }

      -- Lua LSP settings
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
          },
        },
      }

      -- BasedPyright LSP
      lspconfig.basedpyright.setup {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            typeCheckingMode = "standard",
            reportUnusedImport = "none",
            reportDuplicateVariableDefinition = "none",
          },
        },
      }

      -- Pyright LSP
      -- lspconfig.pyright.setup {
      --   capabilities = capabilities,
      --   settings = {
      --     pyright = {
      --       typeCheckingMode = "standard",
      --       reportDuplicateVariable = "none",
      --       reportUnusedImport = "none",
      --     },
      --   },
      -- }

      -- Angular LSP
      lspconfig.angularls.setup {
        cmd = {
          "ngserver",
          "--stdio",
          -- "--tsProbeLocations", vim.fn.expand("~/.nvm/versions/node/v18.20.4/lib/node_modules"),
          -- "--ngProbeLocations", vim.fn.expand("~/.nvm/versions/node/v18.20.4/lib/node_modules")
          "--tsProbeLocations",
          vim.fn.getcwd() .. "/node_modules",
          "--ngProbeLocations",
          vim.fn.getcwd() .. "/node_modules",
        },
        on_new_config = function(new_config, new_root_dir)
          new_config.cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations",
            new_root_dir .. "/node_modules",
            "--ngProbeLocations",
            new_root_dir .. "/node_modules",
          }
        end,
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("angular.json", ".git"),
      }

      -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
      local open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded" -- Set border to rounded
        return open_floating_preview(contents, syntax, opts, ...)
      end
    end,
  },

  -- Formatter Configuration
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "yapf" },
          rust = { "rustfmt", lsp_format = "fallback" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = {
          timeout_ms = 2500,
          lsp_format = "fallback",
        },
      }
    end,
  },

  -- Dap Treesitter Parser
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python",
        "javascript",
      },
    },
  },
}
