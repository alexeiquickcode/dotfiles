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
            visible = true, -- Show hidden files
            hide_by_name = {
              "__pycache__"
            },
            never_show = {
              "__pycache__"
            }
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
      }

      -- Need to load this after telescope.setup()
      telescope.load_extension "dap"

      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>fo", function()
        require('telescope.builtin').oldfiles({ cwd = vim.fn.getcwd() })
      end, { desc = "Find old files in cwd" })
      vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>", { desc = "Find word" })
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffer" })
      vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find project" })
      vim.keymap.set("n", "<leader>la", ":CodeActionMenu<CR>", { desc = "LSP Code Action" })
      vim.keymap.set("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>", { desc = "LSP Format" })
      vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { desc = "LSP Rename" })
    end,
  },

}
