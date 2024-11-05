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
        return ""
      end

      if not handle then
        print("os_full_name: no handle")
        return ""
      end

      local result = handle:read("*a")
      handle:close()
      if not result then
        if jit then
          return jit.os
        end

        return "Windows:maybe" -- probably windows, because id doesn't have "uname" command
      end

      return result
    end

    M._os_full_name = exec_get_os_name()
  end

  print("os: " .. M._os_full_name)

  return M._os_full_name
end

return M
