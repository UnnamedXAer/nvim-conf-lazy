local M = {}

M.printTable = function(t)
  local s = ""

  for k, v in pairs(t) do
    s = s .. k .. ":" .. v .. "\n" -- concatenate key/value pairs, with a newline in-between
  end

  print(s)
end

return M
