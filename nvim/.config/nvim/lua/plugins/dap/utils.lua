local dap = require "dap"
local utils = require "utils"
Snacks = Snacks or {}
local M = {}

function M.get_default_window_options()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local opts = {
    width = width,
    height = height,
    bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
    minimal = false,
    noautocmd = false,
    zindex = 2,
    wo = { winhighlight = "NormalFloat:Normal" },
    border = "rounded",
    title = "Pandas (VisiData) DataFrame Viewer",
    title_pos = "center",
  }
  return opts
end

--------------------------------------------------------------------------------
---- VisiData Helpers ----------------------------------------------------------
--------------------------------------------------------------------------------

local is_windows = utils.is_windows -- Rename for clarity
local visidata_cli = utils.is_windows and "visidata" or "vd"
local temp_path = utils.get_temp_path()
local opts = M.get_default_window_options()

function M.open_vd_under_cursor()
  local var_name = vim.fn.expand "<cword>"
  local filetype = vim.bo.filetype

  if filetype == "python" then
    local csv_path = temp_path .. (is_windows and "\\debug_df.csv" or "/debug_df.csv")
    local python_cmd = string.format("%s.to_csv(r'%s')", var_name, csv_path)
    dap.repl.execute(python_cmd)

    local terminal_cmd = string.format('%s "%s"', visidata_cli, csv_path)
    Snacks.terminal(terminal_cmd, opts)
  elseif filetype == "javascript" or filetype == "typescript" then
    dap.repl.execute("testFn(" .. var_name .. ")")

    local json_path = temp_path .. (is_windows and "\\debug_obj.json" or "/debug_obj.json")
    local terminal_cmd = string.format('%s "%s"', visidata_cli, json_path)
    Snacks.terminal(terminal_cmd, opts)
  else
    vim.notify("Filetype not supported for Data Viewer", vim.log.levels.ERROR)
  end
end

-- TODO: Extend this to javascript
function M.describe_python_types_in_df_in_vd()
  local var_name = vim.fn.expand "<cword>"
  local py_cmds = {
    "element_types = " .. var_name .. ".applymap(type)",
    "element_types.to_csv('/tmp/debug_df.csv')",
  }
  for _, cmd in ipairs(py_cmds) do
    dap.repl.execute(cmd)
  end

  local csv_path = temp_path .. (is_windows and "\\debug_df.csv" or "/debug_df.csv")
  local terminal_cmd = string.format('%s "%s"', visidata_cli, csv_path)
  Snacks.terminal(terminal_cmd, opts)
end

-- TODO: Extend this to javascript
function M.summarise_python_types_in_df_in_vd()
  local var_name = vim.fn.expand "<cword>"
  local py_cmds = {
    "type_counts = " .. var_name .. ".applymap(type).apply(pd.Series.value_counts)",
    "type_counts.to_csv('/tmp/debug_df.csv')",
  }
  for _, cmd in ipairs(py_cmds) do
    dap.repl.execute(cmd)
  end
  Snacks.terminal("vd /tmp/debug_df.csv", opts)
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
