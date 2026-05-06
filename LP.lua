function v1(name) return game:GetService(name) end
local ws, plrs
ws = v1"Workspace"
plrs = v1"Players"

local plr
plr = plrs.LocalPlayer

function get_root()
  return plr and plr.Character
  and plr.Character:FindFirstChild("HumanoidRootPart")
end

function is_alive()
  return plr and plr.Character
  and plr.Character:FindFirstChildOfClass("Humanoid")
  and plr.Character.Humanoid.Health > 0
end

local module = {}
