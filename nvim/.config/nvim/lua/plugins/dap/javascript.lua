local dap = require "dap"

-- JS Debug Adapter
require("dap-vscode-js").setup {
  debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
}

for _, language in ipairs { "typescript", "javascript" } do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      env = {
        NODE_ENV = "development",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch UAT",
      runtimeExecutable = "nodemon", -- Use nodemon for automatic reloads
      runtimeArgs = { "--exec", "NODE_ENV=uat node --require ./fs-test.js" },
      -- runtimeArgs = { "--exec", "cross-env NODE_ENV=uat node" }, -- Use for windows
      skipFiles = {
        "<node_internals>/**",
        "**/async-hooks.js",
        "**/agent.js",
        "${workspaceFolder}/node_modules/**/*.js",
      },
      cwd = "${workspaceFolder}",
      localRoot = "${workspaceFolder}",
      program = "app.js",
      protocol = "inspector",
      restart = false,
      console = "integratedTerminal",
      outputCapture = "console", -- Need this for console.log to print to the REPL
      -- internalConsoleOptions = "neverOpen",
      env = { -- doesnt work (this works in vscode)
        NODE_ENV = "uat",
      },
      -- console = "externalTerminal", --breakpoints dont work external terminal
      -- stopOnEntry = true,
      sourceMaps = false,
      args = { "|", "npx", "pino-pretty" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch DEV",
      runtimeExecutable = "nodemon",
      skipFiles = {
        "<node_internals>/**",
        "**/async-hooks.js",
        "**/agent.js",
        "${workspaceFolder}/node_modules/**/*.js",
      },
      cwd = "${workspaceFolder}",
      program = "app.js",
      env = { NODE_ENV = "development" },
      restart = true,
      console = "externalTerminal",
      internalConsoleOptions = "neverOpen",
      args = { "|", "npx", "pino-pretty" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch PROD",
      runtimeExecutable = "nodemon",
      skipFiles = {
        "<node_internals>/**",
        "**/async-hooks.js",
        "**/agent.js",
        "${workspaceFolder}/node_modules/**/*.js",
      },
      cwd = "${workspaceFolder}",
      program = "app.js",
      env = { NODE_ENV = "production" },
      restart = true,
      console = "externalTerminal",
      internalConsoleOptions = "neverOpen",
      args = { "|", "npx", "pino-pretty" },
    },
  }
end
