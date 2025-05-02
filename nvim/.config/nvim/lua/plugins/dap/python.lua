local dap = require "dap"
local utils = require "utils"

local is_windows = utils.is_windows

local enrich_config = function(finalConfig, on_config)
  local final_config = vim.deepcopy(finalConfig)

  -- Placeholder expansion for launch directives
  local placeholders = {
    ["${file}"] = function(_)
      return vim.fn.expand("%:p")
    end,
    ["${fileBasename}"] = function(_)
      return vim.fn.expand("%:t")
    end,
    ["${fileBasenameNoExtension}"] = function(_)
      return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
    end,
    ["${fileDirname}"] = function(_)
      return vim.fn.expand("%:p:h")
    end,
    ["${fileExtname}"] = function(_)
      return vim.fn.expand("%:e")
    end,
    ["${relativeFile}"] = function(_)
      return vim.fn.expand("%:.")
    end,
    ["${relativeFileDirname}"] = function(_)
      return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
    end,
    ["${workspaceFolder}"] = function(_)
      return vim.fn.getcwd()
    end,
    ["${workspaceFolderBasename}"] = function(_)
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    ["${env:([%w_]+)}"] = function(match)
      return os.getenv(match) or ""
    end,
  }

  if final_config.envFile then
    local filePath = final_config.envFile
    for key, fn in pairs(placeholders) do
      filePath = filePath:gsub(key, fn)
    end

    for line in io.lines(filePath) do
      if not line:match("^%s*#") and line:match("=") then
        local key, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
        if key and value then
          final_config.env = final_config.env or {}
          final_config.env[key] = value
        end
      end
    end
  end
  on_config(final_config)
end


local function get_module_from_current_file()
  local file_path = vim.fn.expand("%:p") -- full path of current file
  local cwd = vim.fn.getcwd()
  if not file_path:match("%.py$") then
    return nil
  end

  -- Trim off the current working directory and .py extension
  local relative_path = file_path:gsub("^" .. cwd .. "/", ""):gsub("%.py$", "")

  -- Replace / with . to convert to Python module path
  local module_name = relative_path:gsub("/", ".")

  -- Sanity check
  if module_name == "" then
    return nil
  end

  print("Running module with debugpy:", module_name)
  return module_name
end
--------------------------------------------------------------------------------
---- Python configuration ------------------------------------------------------
--------------------------------------------------------------------------------

-- Define some logs
dap.set_log_level "DEBUG"
vim.fn.setenv("NVIM_DAP_LOG_FILE", vim.fn.stdpath "data" .. "/dap.log")

if is_windows then
  dap.adapters.python = {
    type = "executable",
    command = os.getenv "USERPROFILE" .. "\\.virtualenvs\\debugpy\\Scripts\\python.exe",
    args = { "-m", "debugpy.adapter" },
  }
else
  dap.adapters.python = {
    type = "executable",
    command = os.getenv "HOME" .. "/.virtualenvs/debugpy/bin/python",
    -- command = vim.fn.getcwd() .. "/.venv/bin/python",
    args = { "-m", "debugpy.adapter" },
    enrich_config = enrich_config,
  }

  -- NOTE: For Docker contaienrs
  -- dap.adapters.python = {
  --   type = "server",
  --   host = "0.0.0.0",
  --   port = 5678,
  -- }
end


dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = "python",
    request = "launch",
    name = "Launch file",
    console = "integratedTerminal",
    justMyCode = false,
    cwd = vim.fn.getcwd(),

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}",
    pythonPath = function() return utils.get_python_executable() end,
  },
  {
    type = "python",
    request = "launch",
    name = "RUN Current Module (UAT)",
    console = "integratedTerminal",
    module = function() return get_module_from_current_file() end,
    cwd = "${workspaceFolder}",
    justMyCode = true,
    envFile = "${workspaceFolder}/environment/.env.uat",
    pythonPath = function() return utils.get_python_executable() end,
  },
  {
    name = "UAT: FastAPI (Port 8000)",
    type = "python",
    request = "launch",
    module = "uvicorn",
    args = {
      "main:app",
      "--access-log",
      "--host",
      "0.0.0.0",
      "--port",
      "8000",
    },
    jinja = true,
    justMyCode = true,
    env = {
      ENVIRONMENT = "uat",
    },
    console = "integratedTerminal",
    logToFile = true,
    pythonPath = function() return utils.get_python_executable() end,
  },
  {
    name = "UAT: FastAPI (Port 8001)",
    type = "python",
    request = "launch",
    module = "uvicorn",
    args = {
      "main:app",
      "--access-log",
      "--host",
      "0.0.0.0",
      "--port",
      "8001",
    },
    jinja = true,
    justMyCode = true,
    env = {
      ENVIRONMENT = "uat",
    },
    console = "integratedTerminal",
    logToFile = true,
    pythonPath = function() return utils.get_python_executable() end,
  },
  {
    type = "python",
    request = "attach",
    name = "Attach to Docker",
    connect = {
      port = 5678,
      host = "0.0.0.0",
    },
    pathMappings = {
      {
        localRoot = "put fp here",
        -- localRoot = get_project_root(), WARN: This is not currently working without full FP
        remoteRoot = "/var/task",
      },
      -- beforeLaunch = run_sam_build_and_invoke,
    },
  },
  {
    name = "MONOREPO : FastAPI",
    type = "python",
    request = "launch",
    module = "uvicorn",
    args = {
      "--app-dir",
      "./fastapi_app",
      "main:app",
      "--access-log",
      "--host",
      "0.0.0.0",
      "--port",
      "8001",
    },
    jinja = true,
    justMyCode = true,
    env = {
      ENVIRONMENT = "prod",
    },
    console = "externalTerminal",
    logToFile = true,
    cwd = "${workspaceFolder}/fastapi_app",
    pythonPath = "${workspaceFolder}/fastapi_app/.venv/bin/python",
  },
  {
    name = "Production: FastAPI (Port: 8000)",
    type = "python",
    request = "launch",
    module = "uvicorn",
    args = {
      "main:app",
      "--access-log",
      "--host",
      "0.0.0.0",
      "--port",
      "8000",
    },
    jinja = true,
    justMyCode = true,
    env = {
      ENVIRONMENT = "production",
    },
    console = "integratedTerminal",
    logToFile = true,
    pythonPath = function() return utils.get_python_executable() end,
  },
  {
    name = "Production: FastAPI (Port: 8001)",
    type = "python",
    request = "launch",
    module = "uvicorn",
    args = {
      "main:app",
      "--access-log",
      "--host",
      "0.0.0.0",
      "--port",
      "8001",
    },
    jinja = true,
    justMyCode = true,
    env = {
      ENVIRONMENT = "production",
    },
    console = "integratedTerminal",
    logToFile = true,
    pythonPath = function() return utils.get_python_executable() end,
  },
}
