local M = {}

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

return M
