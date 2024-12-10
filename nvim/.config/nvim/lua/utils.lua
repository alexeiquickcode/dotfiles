local M = {}

M.is_windows = vim.uv.os_uname().sysname:lower():find "windows" and true or false

M.user_home = M.is_windows and vim.env.USERPROFILE or vim.env.HOME

function M.get_temp_path()
  if M.is_windows then
    return os.getenv "TEMP" or os.getenv "TMP" or "C:\\Temp"
  else
    return os.getenv "TMPDIR" or "/tmp"
  end
end

function M.get_python_executable()
  local cwd = vim.fn.getcwd()
  local windows_venv_path = cwd .. "\\.venv\\Scripts\\python.exe"
  local unix_venv_path = cwd .. "/.venv/bin/python"

  -- 1. Check for virtual environment
  if M.is_windows and vim.fn.executable(windows_venv_path) == 1 then
    return windows_venv_path
  elseif vim.fn.executable(unix_venv_path) == 1 then
    return unix_venv_path
  end

  -- 2. Use pyenv to find the currently active Python executable
  local handle = io.popen("pyenv which python", "r")
  if handle then
    local python_path = handle:read("*a"):gsub("%s+", "") -- Trim whitespace
    handle:close()
    return python_path
  end

  -- 3. Fallback if pyenv is not available or fails
  if M.is_windows then
    return M.user_home .. "\\.pyenv\\pyenv-win\\shims\\python"
  else
    return M.user_home .. "/.pyenv/shims/python"
  end
end

return M
