-- Roblox Scripting: Useful functions module --
local funcs = {}

funcs.is_type = function(...)
  local x = {...}
  if #x > 0 then
    for i = 1, #x do
      if i ~= #x then
        if type(x[i]) ~= x[#x] then
          warn("[ALL ARGUMENT MUST BE " .. x[#x]:upper() .. "]")
          return false
        end
      end
    end return true
  end return nil
end

funcs.not_lower = function(t, v)
  if t and v and funcs.is_type(t, v, "number") then
    if t < v then return v end return t
  end
end

return funcs
