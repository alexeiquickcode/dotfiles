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
      picker = { enabled = true },
      lazygit = {
        enabled = true,
        configure = true,
        theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
        config = {
          gui = { nerdFontsVersion = "3" },
        },
        win = {
          style = "lazygit",
        }
      },
    },
    keys = {
      { "<leader>.", function() Snacks.scratch() end,        desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
  },

  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = { 'DistantConnect', 'DistantLaunch', 'DistantOpen' },
    keys = {
      {
        '<leader>ds',
        function()
          -- Edit this list to match your ~/.ssh/config hosts (or full ssh://user@host URIs)
          local hosts = {
            { name = 'aq-main', destination = 'ssh://sagemaker-user@aq-main' },
            { name = 'aq-gpu',  destination = 'ssh://sagemaker-user@aq-gpu' },
          }

          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'

          pickers.new({}, {
            prompt_title = 'Distant: connect',
            finder = finders.new_table {
              results = hosts,
              entry_maker = function(h)
                return {
                  value = h,
                  display = string.format('%-24s %s', h.name, h.destination),
                  ordinal = h.name .. ' ' .. h.destination,
                }
              end,
            },
            sorter = conf.generic_sorter {},
            attach_mappings = function(bufnr, _)
              actions.select_default:replace(function()
                local sel = action_state.get_selected_entry()
                actions.close(bufnr)
                if not sel then return end
                require('distant'):connect({
                  destination = sel.value.destination,
                  -- Remote doesn't have distant on non-interactive SSH PATH; give absolute path.
                  options = 'distant.bin="/home/sagemaker-user/.local/bin/distant"',
                }, function(err, client)
                  vim.schedule(function()
                    if err then
                      vim.notify('Distant connect failed: ' .. tostring(err), vim.log.levels.ERROR)
                      return
                    end
                    vim.notify('Distant connected to ' .. sel.value.destination)
                  end)
                end)
              end)
              return true
            end,
          }):find()
        end,
        desc = 'Distant: select SSH host',
      },
    },
    config = function()
      require('distant'):setup()
    end,
  },

  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup({
        -- Terminal window settings
        window = {
          split_ratio = 0.3,
          position = "float",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,

          -- Floating window configuration
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },
        -- File refresh settings
        refresh = {
          enable = true,
          updatetime = 100,
          timer_interval = 1000,
          show_notifications = true,
        },
        -- Git project settings
        git = {
          use_git_root = true,
        },
        -- Shell-specific settings
        shell = {
          separator = '&&',
          pushd_cmd = 'pushd',
          popd_cmd = 'popd',
        },
        -- Command settings
        command = "claude",
        -- Command variants
        command_variants = {
          continue = "--continue",
          resume = "--resume",
          verbose = "--verbose",
        },
        -- Keymaps
        keymaps = {
          toggle = {
            normal = "<leader>cc",
            terminal = "<C-,>",
            variants = {
              continue = "<leader>cC",
              verbose = "<leader>cV",
            },
          },
          window_navigation = true,
          scrolling = true,
        }
      })
    end
  },

}
