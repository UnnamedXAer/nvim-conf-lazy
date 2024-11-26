local M = {
  _os_full_name = nil,
}

M.printTable = function(t)
  if type(t) ~= "table" then
    print(tostring(t))
  end

  local s = ""

  for k, v in pairs(t) do
    s = s .. k .. ":" .. tostring(v) .. "\n" -- concatenate key/value pairs, with a newline in-between
  end

  print(s)
end

---@return string
M.get_os_full_name = function()
  if not M.os_full_name then
    local exec_get_os_name = function()
      local handle, err = assert(io.popen("uname -a"))
      if err then
        print("os_full_name: err: " .. tostring(err))
        return "err: " .. tostring(err)
      end

      if not handle then
        print("os_full_name: no handle")
        return "no_handle"
      end

      local result = handle:read("*a")
      handle:close()
      if not result or string.len(result) == 0 then
        if jit and jit.os then
          return jit.os
        end

        return "Windows:maybe" -- probably windows, because the "uname" command does not yield anything useful
      end

      return result
    end

    M._os_full_name = exec_get_os_name()
  end

  -- print("os: " .. M._os_full_name)

  return M._os_full_name
end

---@param cb fun()
M.save_before_action = function(cb)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    -- print("modified: " .. tostring(modified))
    if modified then
      print("‼️modified")
    end

    local modified2 = vim.bo[bufnr].modified
    if modified ~= modified2 then
      print("get opt modified: " .. tostring(modified) .. ", vim.bo[bn].modified: " .. tostring(modified2))
    end

    cb()
  end
end

return M
