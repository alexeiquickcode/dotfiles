local dap = require "dap"
local utils = require "utils"

local is_windows = utils.is_windows

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
    args = { "-m", "debugpy.adapter" },
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

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    program = "${file}",
    pythonPath = function() return utils.get_python_executable() end,
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
