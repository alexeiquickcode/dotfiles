-- utils.lua
local dap = require "dap"
local fzf = require "fzf-lua"
local M = {}

--------------------------------------------------------------------------------
---- Buffer Utility Fns --------------------------------------------------------
--------------------------------------------------------------------------------

function M.open_floating_window(buf)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  vim.api.nvim_open_win(buf, true, opts)
end

function M.create_buffer()
  -- Create a new buffer and return its ID
  local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  if buf == 0 then error "Buffer creation failed" end
  return buf
end

--------------------------------------------------------------------------------
---- Python Display Helpers ----------------------------------------------------
--------------------------------------------------------------------------------

function M.initialize_python_repl_silently()
  local initialization_commands = [[
      try:
          import pandas as pd
          pd.set_option('display.width', 250)      # Set display width (characters)
          pd.set_option('display.max_colwidth', 20)
          pd.set_option('display.max_columns', 12) # Set max number of columns
          pd.set_option('colheader_justify', 'left')
          pd.set_option('display.min_rows', 50)    # Set min number of rows
          pd.set_option('display.max_rows', 80)    # Set max number of rows

      except ImportError:
          print('Pandas is not installed.')
      except Exception as e:
          print(f'An error occurred: {e}')
  ]]
  dap.repl.execute(initialization_commands)
end

-- Pandas (DataFramer) Viewer
function M.print_var_under_cursor_python()
  local var_name = vim.fn.expand "<cword>"
  local buf = M.create_buffer()

  dap.repl.execute("print(" .. var_name .. ")")

  -- Capture DAP REPL output and write to the buffer
  dap.listeners.after.event_output["print_var_under_cursor"] = function(_, body)
    if body.category == "stdout" or body.category == "stderr" then
      local lines = vim.split(body.output, "\n")
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)

      -- Apply header highlight for the first three lines (the header)
      for i = 1, 2 do
        if #lines >= i then
          vim.api.nvim_buf_add_highlight(buf, -1, "DataFrameHeader", i - 1, 0, -1) -- Header gets its own color
        end
      end

      -- Apply alternating row highlights starting from the fourth line (the data)
      for i = 3, #lines + 1 do
        local highlight_group = (i % 2 == 0) and "StripedLine2" or "StripedLine1"
        vim.api.nvim_buf_add_highlight(buf, -1, highlight_group, i - 1, 0, -1)
      end
    end
  end
  M.open_floating_window(buf)
end

--------------------------------------------------------------------------------
---- Javascript Display Helpers ------------------------------------------------
--------------------------------------------------------------------------------

function M.print_var_under_cursor_nodejs()
  local var_name = vim.fn.expand "<cword>"
  local buf = M.create_buffer()
  local command = "console.table(" .. var_name .. ")"
  dap.repl.execute(command)

  -- Capture DAP REPL output and write to the buffer
  dap.listeners.after.event_output["print_nodejs_variable"] = function(_, body)
    if body.category == "stdout" or body.category == "stderr" then
      local lines = vim.split(body.output, "\n")
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)

      -- Apply header highlight for the first three lines (the header)
      -- for i = 1, 2 do
      --   if #lines >= i then
      --     vim.api.nvim_buf_add_highlight(buf, -1, "DataFrameHeader", i - 1, 0, -1) -- Header gets its own color
      --   end
      -- end
      --
      -- -- Apply alternating row highlights starting from the fourth line (the data)
      -- for i = 3, #lines + 1 do
      --   local highlight_group = (i % 2 == 0) and "StripedLine2" or "StripedLine1"
      --   vim.api.nvim_buf_add_highlight(buf, -1, highlight_group, i - 1, 0, -1)
      -- end
    end
  end
  M.open_floating_window(buf)
end

--------------------------------------------------------------------------------
---- Multiline execute ---------------------------------------------------------
--------------------------------------------------------------------------------

-- For printing multiple lines of code
function M.print_selection()
  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- Handle single line selection
  if start_line == end_line then
    -- Get the selected text within the same line
    local line = vim.fn.getline(start_line)
    local start_col = math.min(start_pos[3], end_pos[3])
    local end_col = math.max(start_pos[3], end_pos[3])

    -- Extract the selected text and trim whitespace
    local selected_text = vim.fn.trim(line:sub(start_col, end_col))

    -- Execute the trimmed text in DAP REPL
    require("dap.repl").execute(selected_text)
  else
    -- Handle multi-line selection
    -- Get the lines in the selected region
    local lines = vim.fn.getline(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])

    -- Strip leading/trailing whitespace from each line and concatenate them into a single line
    local trimmed_lines = {}
    for _, line in ipairs(lines) do
      table.insert(trimmed_lines, vim.fn.trim(line))
    end

    -- Concatenate all the trimmed lines into a single string
    local command = table.concat(trimmed_lines, " ")

    -- Execute the command in the DAP REPL
    require("dap.repl").execute(command)
  end
end

--------------------------------------------------------------------------------
---- Other debugger utility funcs ----------------------------------------------
--------------------------------------------------------------------------------

function M.continue_and_toggle_neotree_if_dap_active()
  if dap.session() then
    dap.continue()
  else
    require("neo-tree.command").execute { action = "close" }
    dap.continue()
  end
end

return M
