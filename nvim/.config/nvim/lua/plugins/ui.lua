---@type LazySpec
return {

  {
    "AstroNvim/astrotheme",
    config = function()
      local colors = {
        red = "#ff5638",
        pink = "#FF838B",
        blue = "#5EB7FF",
        orange = "#DFAB25",
        cyan = "#4AC2B8",
        purple = "#DD97F1",
      }

      require("astrotheme").setup {
        palette = { "astrodark" },
        highlights = {
          astrodark = {
            ["DiagnosticError"] = { fg = colors.red, bg = "NONE", bold = true },

            -- Javascript
            ["@lsp.typemod.variable.local.javascript"] = { fg = colors.pink, bg = "NONE" },
            ["@lsp.mod.async.javascript"] = { fg = colors.blue, bg = "NONE" },
            ["@lsp.typemod.member.async.javascript"] = { fg = colors.blue, bg = "NONE" },
            ["@lsp.type.class.javascript"] = { fg = colors.orange, bg = "NONE" },
            ["@keyword.type.javascript"] = { fg = colors.purple, bg = "NONE" },
            ["@lsp.typemod.member.defaultLibrary.javascript"] = { fg = colors.blue, bg = "NONE" },

            -- Python
            ["@keyword.type.python"] = { fg = colors.purple, bg = "NONE" },
            ["@type.python"] = { fg = colors.orange, bg = "NONE" },
            ["@constructor.python"] = { fg = colors.cyan, bg = "NONE" },
            ["@variable.member.python"] = { fg = "NONE", bg = "NONE" },
            ["@lsp.type.class.python"] = { fg = colors.orange, bg = "NONE" },
            ["@lsp.type.namespace.python"] = { fg = colors.cyan, bg = "NONE" },
            ["@lsp.typemod.method.definition.python"] = { fg = colors.cyan, bg = "NONE" },
            ["@lsp.type.variable.python"] = { fg = colors.pink, bg = "NONE" },
            ["@lsp.type.type.python"] = { fg = colors.orange, bg = "NONE" },
            ["@f_string_prefix.python"] = { fg = colors.purple, bg = "NONE" },
          },
        },
      }
    end,
  },
  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup {
        virtcolumn = "80,100,120",
      }
    end,
  },

  {
    "yamatsum/nvim-cursorline",
    after = "nvim-treesitter",
    config = function()
      require("nvim-cursorline").setup {
        cursorline = {
          enable = true,
          timeout = 1000,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local bufferline = require('bufferline')

      bufferline.setup {
        options = {
          mode = "buffers",                               -- set to "tabs" to only show tabpages instead
          style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
          themable = true,                                -- allows highlight groups to be overriden i.e. sets highlights as default
          -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            -- style = 'underline', -- WARN: Seems to only be underlining the icon...
          },
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              -- text_align = "left" | "center" | "right",
              text_align = "left",
              separator = true
            }
          },
          color_icons = true,              -- whether or not to add the filetype icon highlights
          duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
          persist_buffer_sort = true,      -- whether or not custom sorted buffers should persist
          move_wraps_at_ends = false,      -- whether or not the move command "wraps" at the first or last position
          -- can also be a table containing 2 custom separators
          -- [focused and unfocused]. eg: { '|', '|' }
          -- separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          auto_toggle_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
          },
          sort_by = 'extension',
          -- sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(
          --     buffer_a, buffer_b)
          --   -- add custom logic
          --   local modified_a = vim.fn.getftime(buffer_a.path)
          --   local modified_b = vim.fn.getftime(buffer_b.path)
          --   return modified_a > modified_b
          --end
        }
      }
    end,
  },

  {
    "dstein64/nvim-scrollview",
    config = function() require("scrollview").setup() end,
  },

  -- Shows what VIM mode you are in
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup() end,
  },
}
