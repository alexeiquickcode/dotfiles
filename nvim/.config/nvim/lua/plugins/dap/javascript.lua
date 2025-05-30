local dap = require "dap"

-- JS Debug Adapter
require("dap-vscode-js").setup {
  -- debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
  debugger_path = "C:\\Users\\alexei.quick\\vscode-js-debug",
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
        NODE_ENV = "uat",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch UAT",
      runtimeExecutable = "nodemon", -- Use nodemon for automatic reloads
      -- runtimeArgs = { "--exec", "NODE_ENV=uat node --require ./fs-test.js" }, TODO: Where should i put this fs test file so its available ???
      runtimeArgs = { "--exec", "NODE_ENV=uat node" },
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
      env = {                    -- doesnt work (this works in vscode)
        NODE_ENV = "uat",
      },
      -- console = "externalTerminal", --breakpoints dont work external terminal
      -- stopOnEntry = true,
      sourceMaps = false,
      args = { "|", "npx", "pino-pretty" },
    },
    -- {
    --   type = "pwa-node",
    --   request = "launch",
    --   name = "UAT: Node.js (Port 8080) CloudRun",
    --   runtimeExecutable = "nodemon",
    --   runtimeArgs = { "--exec", "NODE_ENV=uat node" },
    --   skipFiles = {
    --     "<node_internals>/**",
    --     "${workspaceFolder}/node_modules/**/*.js",
    --   },
    --   cwd = "${workspaceFolder}/jobs/cloudrun/process_images_and_text",
    --   localRoot = "${workspaceFolder}/jobs/cloudrun/process_images_and_text",
    --   program = "app.js",
    --   protocol = "inspector",
    --   restart = true,
    --   console = "integratedTerminal",
    --   outputCapture = "console",
    --   sourceMaps = false,
    --   env = {
    --     NODE_ENV = "uat",
    --   },
    --   args = {},
    -- },
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
