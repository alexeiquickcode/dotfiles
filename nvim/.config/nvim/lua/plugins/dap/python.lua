local dap = require "dap"
local utils = require "plugins.dap.utils"

-- Conditional hook based on adapter name
dap.listeners.after.event_initialized["run_pandas_init"] = function(session)
  if session.config.type == "python" then utils.initialize_python_repl_silently() end
end

local function get_python_executable()
  local cwd = vim.fn.getcwd()
  local is_windows = vim.loop.os_uname().version:match "Windows"
  local user_home = is_windows and vim.env.USERPROFILE or vim.env.HOME
  local windows_venv_path = cwd .. "\\.venv\\Scripts\\python.exe"
  local unix_venv_path = cwd .. "/.venv/bin/python"

  -- Check for virtual environment first
  if is_windows and vim.fn.executable(windows_venv_path) == 1 then
    return windows_venv_path
  elseif vim.fn.executable(unix_venv_path) == 1 then
    return unix_venv_path
  end

  -- Use pyenv to find the currently active Python executable
  local handle = io.popen "pyenv which python"
  local result = handle:read "*a"
  handle:close()

  -- Trim any trailing whitespace/newlines from the result
  result = result:gsub("%s+$", "")

  -- Fallback if pyenv is not available or fails
  if result and result ~= "" then
    return result
  elseif is_windows then
    return user_home .. "\\.pyenv\\pyenv-win\\shims\\python"
  else
    return user_home .. "/.pyenv/shims/python"
  end
end

--------------------------------------------------------------------------------
---- Python configuration ------------------------------------------------------
--------------------------------------------------------------------------------

-- Define some logs
dap.set_log_level "DEBUG"
vim.fn.setenv("NVIM_DAP_LOG_FILE", vim.fn.stdpath "data" .. "/dap.log")

if vim.loop.os_uname().sysname == "Windows_NT" then
  -- Windows config
  dap.adapters.python = {
    type = "executable",
    command = os.getenv "USERPROFILE" .. "\\.virtualenvs\\debugpy\\Scripts\\python.exe",
    args = { "-m", "debugpy.adapter" },
  }
else
  -- linux config
  dap.adapters.python = {
    type = "executable",
    command = os.getenv "HOME" .. "/.virtualenvs/debugpy/bin/python",
    args = { "-m", "debugpy.adapter" },
  }

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

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}",
    pythonPath = function() return get_python_executable() end,
  },
  {
    type = "python",
    request = "launch",
    name = "RUN X Module (UAT)",
    console = "integratedTerminal",
    module = "XXXXXXXXX",
    -- module = "${relativeFile}", -- WARN: This doesn't work
    cwd = "${workspaceFolder}/gpu_jobs",
    justMyCode = true,
    env = {
      ENV = "uat",
      -- NOTE: envFile:   This is only a property in vscode's version of debugpy (so for nvim we have to pass it as an env var)
      envFile = "${workspaceFolder}/environment/.env.uat",
    },
    pythonPath = function() return get_python_executable() end,
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
    console = "integratedTerminal", -- Use the integrated terminal to see output logs
    logToFile = true,
    pythonPath = function() return get_python_executable() end,
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
    pythonPath = function() return get_python_executable() end,
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
    pythonPath = function() return get_python_executable() end,
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
    pythonPath = function() return get_python_executable() end,
  },
}
