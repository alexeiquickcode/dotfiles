---@type LazySpec
return {

  -- CMP plugin (for automated code completetion)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = {
          ["<Tab>"] = nil, -- Disable Tab for CMP
          ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
  },

  { -- TODO: Replace with Snacks.nvim
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local is_windows = vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1
      require("toggleterm").setup {
        shell = is_windows and "powershell -NoLogo" or "zsh", -- PowerShell on Windows, zsh on Linux/Ubuntu
        open_mapping = [[<c-\>]],
        direction = "float",
        size = 20,
        border = "curved", -- You can use 'single', 'double', 'shadow', etc.
        winblend = 15,
        on_open = function(term)
          vim.cmd "startinsert!"
          -- Use vim.api.nvim_chan_send to send the tmux command directly
          -- vim.api.nvim_chan_send(term.job_id, "tmux\n")
        end,
      }
      -- vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      scratch = { enabled = true },
      terminal = { enabled = true },
      dashboard = { example = "doom" },
      lazygit = {},
    },
    keys = {
      { "<leader>.", function() Snacks.scratch() end,        desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        ollama_local = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'ollama_local',
            env = {
              -- url = 'http://127.0.0.1:11434',
              url = 'http://10.43.64.218:80',
              -- api_key = 'YOUR_OLLAMA_API_KEY', -- Set this if your server requires an API key
            },
            -- headers = {
            --   ['Content-Type'] = 'application/json',
            --   ['Authorization'] = 'Bearer ${api_key}', -- Include this if an API key is required
            -- },
            parameters = {
              sync = true,
            },
            schema = {
              model = {
                default = 'tinyllama',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'ollama_local',
          inline = 'ollama_local',
        },
      },
      display = {
        diff = {
          enabled = true,
          close_chat_at = 240,
          layout = 'vertical',
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          provider = 'default',
        },
      },
      opts = {
        log_level = 'DEBUG',
      },
    }
  }
}
