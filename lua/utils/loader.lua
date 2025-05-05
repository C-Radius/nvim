local M = {}

function M.require_all_from(dir)
  local scan = require("plenary.scandir")
  local modules = scan.scan_dir(vim.fn.stdpath("config") .. "/lua/" .. dir:gsub("%.", "/"), {
    depth = 1,
    add_dirs = false,
  })

  if vim.tbl_isempty(modules) then
    vim.notify("No modules found in " .. dir, vim.log.levels.DEBUG)
    return
  end

  for _, file in ipairs(modules) do
    local module = file:match(".+/([%w_]+)%.lua$")
    if module and module ~= "init" then
      require(dir .. "." .. module)
    end
  end
end

return M

