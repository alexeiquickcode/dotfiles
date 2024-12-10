---@type LazySpec
return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup {
        close_if_last_window = true,
        window = {
          mappings = {
            ["R"] = "set_root",
            ["U"] = "navigate_up",
          },
        },
        filesystem = {
          filtered_items = {
            visible = true, -- set to true to show hidden files
          },
          follow_current_file = {
            enable = true, -- to automatically reveal the file in the tree when switching buffers
          },
        },
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<esc>"] = actions.close,
            },
          },
        },
        -- extensions = { -- WARN: THIS DOESN'T SEEM TO WORK
        --   dap = {
        --     layout_config = {
        --       width = 0.5,  -- Adjust the width (50% of the screen)
        --       height = 0.4, -- Adjust the height (40% of the screen)
        --       preview_cutoff = 40, -- Define when to remove the preview pane
        --       prompt_position = "top",
        --     },
        --     layout_strategy = "horizontal", -- Set layout to horizontal or vertical
        --   },
        -- },
      }

      -- Need to load this after telescope.setup()
      telescope.load_extension "dap"

      -- AstroVim keymaps using Telescope commands
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<CR>", { desc = "Find old files" })
      vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>", { desc = "Find word" })
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffer" })
      vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find project" })
      -- vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Git commits" }) -- These conflict with other bindings
      -- vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git status" })
      -- vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Git branches" })
      vim.keymap.set("n", "<leader>la", ":CodeActionMenu<CR>", { desc = "LSP Code Action" })
      vim.keymap.set("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>", { desc = "LSP Format" })
      vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { desc = "LSP Rename" })
    end,
  },

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

  -- Plugin for multi line cursors
  { "mg979/vim-visual-multi" },

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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- TODO comments and notes
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        TODO = {
          icon = " ",
          color = "#a020f0", -- Purple
          alt = { "TASK", "TBD" }, -- alternative keywords mapping to TODO
          signs = true,
        },
      },
      highlight = {
        before = "", -- do not highlight before the keyword
        keyword = "wide", -- highlight only the keyword (no spaces around it)
        after = "fg", -- do not highlight after the keyword
      },
    },
  },

  -- VIM extension to close buffers
  {
    "moll/vim-bbye",
    event = "BufRead",
  },

  -- VIM extension to surround text with quotes, brackets, etc. (keymap = visual mode S')
  {
    "tpope/vim-surround",
  },

  -- VIM extension (for searching)
  {
    "ibhagwan/fzf-lua",
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true },

  -- {
  --   "github/copilot.vim",
  --   config = function()
  --     local copilot_enabled = false
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>cp",
  --       ":lua ToggleCopilot()<CR>",
  --       { noremap = true, silent = true, desc = "Toggle Copilot" }
  --     )
  --
  --     function ToggleCopilot()
  --       if copilot_enabled then
  --         vim.cmd "Copilot disable"
  --         copilot_enabled = false
  --         print "Copilot Disabled"
  --       else
  --         vim.cmd "Copilot enable"
  --         copilot_enabled = true
  --         print "Copilot Enabled"
  --       end
  --     end
  --   end,
  -- },
  --
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      scratch = { enabled = true },
      terminal = { enabled = true },
      dashboard = { example = "pokemon" },
      lazygit = {},
    },
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },
  },
}
