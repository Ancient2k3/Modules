-- BloxFruits: Commands Script --
--// Script by HoangHien //-- NEW RECREATE FOR SHARING (4F)
local ws, plrs, rls, tws, tps, rs, starter, core
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
rls = game:GetService("ReplicatedStorage")
tws = game:GetService("TweenService")
tps = game:GetService("TeleportService")
rs = game:GetService("RunService")
starter = game:GetService("StarterGui")
core = game:GetService("CoreGui")

if getgenv().memories then
    getgenv().memories.functions.exit_cons()
end

getgenv().memories = {}
local memories = getgenv().memories
local vars = {}
memories.cmds = {}
memories.lang = {}

local plr
plr = plrs.LocalPlayer

local screenui, commands_input, capturefocus, display_in_correct
screenui = Instance.new("ScreenGui", core)
commands_input = Instance.new("TextBox", screenui)
capturefocus = Instance.new("TextButton", commands_input)
display_in_correct = Instance.new("TextLabel", commands_input)

vars.vn_time = os.date("!*t", os.time(os.date("!*t")) + 7 * 3600)
vars.local_time = os.date("*t")
vars.tweening_speed = 250
vars.current_tws = nil

local customfuncs, ui_data = {
    starter_ntf = function(t, m, d) starter:SetCore("SendNotification", {Title = t, Text = m, Duration = d,}) end,
    devconsole = function() starter:SetCore("DevConsoleVisible", true) end,
    addcorner = function(t, r) local ui_corner = Instance.new("UICorner", t) ui_corner.CornerRadius = UDim.new(r, 0) end,
    mb1c = function(t, s) t.MouseButton1Click:Connect(s) end,
    fcl = function(t, s) t.FocusLost:Connect(function(ep) if ep then s() end end) end,
    fcs = function(t, s) t.Focused:Connect(s) end,
    rev = function(t) return not t end
}, {
    anim_slideout = tws:Create(commands_input, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0.1, 0)}),
    anim_slidein = tws:Create(commands_input, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.25, 0, 0.1, 0)}),
    input_onfocused = false, inserted_cmds = false
}

if vars.vn_time ~= vars.local_time then
    memories.lang.cmdbarplaceholder = "What's your command!"
    memories.lang.errtext = "Error: "
    memories.lang.resetui = "AcyCommands_Script: Previous UI Loaded, Has Been Removed!"
    memories.lang.randomstuff = {
        "Commands List:", "Command: "
    }
else
    memories.lang.cmdbarplaceholder = "Lệnh của bạn là gì?"
    memories.lang.errtext = "Lỗi: "
    memories.lang.resetui = "AcyCommands_Script: Giao diện trước đã được tải, đã bị xóa!"
    memories.lang.randomstuff = {
        "Danh sách lệnh:", "Lệnh: "
    }
end

screenui.Name = "_AcyCommands"
commands_input.Name = "_InsertCmds"
capturefocus.Name = "_Options"
display_in_correct.Name = "_ShowInCorrectCmds"

commands_input.BackgroundTransparency = 0.8
commands_input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
commands_input.Position = UDim2.new(-0.25, 0, 0.1, 0)
commands_input.Size = UDim2.new(0.25, 0, 0.065, 0)
commands_input.TextScaled = true
commands_input.TextSize = 9
commands_input.TextColor3 = Color3.fromRGB(0, 255, 0)
commands_input.Font = Enum.Font.Code
commands_input.Text = ""
commands_input.ClearTextOnFocus = true
commands_input.PlaceholderText = memories.lang.cmdbarplaceholder or "I will fixed it soon... maybe!"
commands_input.Visible = true
customfuncs.addcorner(commands_input, 0.2)

capturefocus.BackgroundTransparency = 0.8
capturefocus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
capturefocus.Position = UDim2.new(1.02, 0, 0, 0)
capturefocus.Size = UDim2.new(0.15, 0, 1, 0)
capturefocus.TextScaled = true
capturefocus.TextSize = 9
capturefocus.TextColor3 = Color3.fromRGB(255, 255, 255)
capturefocus.Font = Enum.Font.Code
capturefocus.Text = ">"
capturefocus.Visible = true
customfuncs.addcorner(capturefocus, 0.2)

display_in_correct.BackgroundTransparency = 1
display_in_correct.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
display_in_correct.Position = UDim2.new(0.02, 0, 1.02, 0)
display_in_correct.Size = UDim2.new(0.96, 0, 0.45, 0)
display_in_correct.TextScaled = true
display_in_correct.TextSize = 8.5
display_in_correct.TextColor3 = Color3.fromRGB(255, 255, 255)
display_in_correct.Font = Enum.Font.Code
display_in_correct.Text = "</>"
display_in_correct.Visible = true
customfuncs.addcorner(display_in_correct, 0.2)

memories.functions = {}
local funcs, connections = memories.functions, {}

funcs.checkprop = function(o, prop)
    local success = pcall(function()
        return o[prop]
    end)
    return success
end

funcs.find_hmoid = function(t)
    local hmoid = t.Character and t.Character:FindFirstChildOfClass("Humanoid") or t:FindFirstChildOfClass("Humanoid")
    if hmoid then return hmoid end
    return false
end

funcs.hmoid_setprop = function(t, prop, v)
    local hm = funcs.find_hmoid(t)
    if hm and funcs.checkprop(hm, prop) then
        hm[prop] = v
    end
end

funcs.body_velocity = function(t, method)
    if method == "add" then
        if not t:FindFirstChild("_Float") then
            local insbv = Instance.new("BodyVelocity", t)
            insbv.Name = "_Float"
            insbv.Velocity = Vector3.new(0, 0, 0)
            insbv.MaxForce = Vector3.new(900000, 900000, 900000)
        end
    elseif method == "remove" then
        if t:FindFirstChild("_Float") then
            t:FindFirstChild("_Float"):Destroy()
        end
    end
end

vars.selected_type = {
    nearest = {"nearest", "nearby", "near", "n"},
    farthest = {"farthest", "further", "far", "f"},
    randomizer = {"randomized", "randomize", "random", "r"},
    strongest = {"strongest", "stronger", "strong", "str"},
    weakest = {"weakest", "weaker", "weak", "wk"},
    npc = {"npc", "dummy", "doll"}
} funcs.return_target = function(t)
    local slt = vars.selected_type
    local final_result, mathinf, inrange, maxdis = nil, math.huge, 100000, 0
    if table.find(slt.nearest, t) then
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                local dis = (enm.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
                if dis < mathinf and dis <= inrange then
                    mathinf = dis
                    final_result = enm
                end
            end
        end
    elseif table.find(slt.farthest, t) then
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                local dis = (enm.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
                if dis > maxdis and dis <= inrange then
                    maxdis = dis
                    final_result = enm
                end
            end
        end
    elseif table.find(slt.randomizer, t) then
        local enough_enm = #plrs:GetPlayers()
        if enough_enm > 0 then
            final_result = plrs:GetPlayers()[math.random(1, enough_enm)]
        end
    elseif table.find(slt.strongest, t) then
        local maxlvl_list = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                if plrs[enm.Name].Data.Level.Value >= plr.Data.Level.Value then
                    table.insert(maxlvl_list, enm)
                end
            end
        end if #maxlvl_list > 0 then
            final_result = maxlvl_list[1]
        end
    elseif table.find(slt.weakest, t) then
        local weakestlist = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                if plrs[enm.Name].Data.Level.Value <= plr.Data.Level.Value then
                    table.insert(weakestlist, enm)
                end
            end
        end if #weakestlist > 0 then
            final_result = weakestlist[1]
        end
    elseif table.find(slt.noobie, t) then
        local newbie_list = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                if plrs[enm.Name].Data.Level.Value <= 100 then
                    table.insert(newbie_list, enm)
                end
            end
        end if #newbie_list > 0 then
            final_result = newbie_list[math.random(1, #newbie_list)]
        end
    elseif table.find(slt.npc, t) then
        for _, npc in pairs(ws:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                local checkif = plrs:FindFirstChild(npc.Name)
                local hum = npc:FindFirstChildOfClass("Humanoid")
                if not checkif and hum.Health > 0 then
                    local dis = (npc.HumanoidRootPart.Position - hrp.Position).magnitude
                    if dis < mathinf then
                        mathinf = dis
                        final_result = npc
                    end
                end
            end
        end
    else
        for _, enm in ipairs(plrs:GetPlayers()) do
            if string.lower(enm.Name):sub(1, #t) == string.lower(t) or string.lower(enm.DisplayName):sub(1, #t) == string.lower(t) then
                final_result = enm
            end
        end
    end if final_result and final_result:IsA("Player") then
        if final_result.Character and final_result.Character:FindFirstChildOfClass("Humanoid") and final_result.Character.Humanoid.Health > 0 then
            return final_result
        end
    elseif final_result and final_result:IsA("Model") then
        if final_result:FindFirstChildOfClass("Humanoid") and final_result.Humanoid.Health > 0 then
            return final_result
        end
    end return plr
end

funcs.crt_tween = function(startp, endp)
    if vars.current_tws then vars.current_tws:Cancel() end
    vars.current_tws = tws:Create(startp, TweenInfo.new((endp - startp.Position).magnitude / vars.tweening_speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CFrame.new(endp)})
    vars.current_tws:Play()
    vars.current_tws.Completed:Wait() vars.current_tws = nil
end

funcs.exec_cmd = function()
    local words = tostring(commands_input.Text:lower())
    local args = string.split(words, " ") or {}
    if #args == 0 then return end
    local input_cmd, found_cmd = args[1], nil
    for cmd, cmd_data in pairs(memories.cmds) do
        if input_cmd == cmd or table.find(cmd_data.others_name, input_cmd) then
            found_cmd = cmd
            break
        end
    end if found_cmd and typeof(found_cmd) == "string" then
        table.remove(args, 1)
        local success, err = pcall(function() memories.cmds[found_cmd].callback_func(unpack(args)) end)
        if not success then if typeof(err) == "string" then print("[" .. memories.lang.errtext .. err .. " ]") end end
    else
        display_in_correct.Text = "</>"
    end
end

funcs.correctedcmds = function()
    local words, matching = tostring(commands_input.Text:lower()), nil
    if words ~= "" then
        for cmd, data in pairs(memories.cmds) do
            local aly = data.others_name
            for _, al in ipairs(aly) do
                if al:lower() == words:match("^[%w_]+") then
                    matching = table.concat(aly, ", ")
                    ui_data.inserted_cmds = true break
                end
            end if matching and ui_data.inserted_cmds then
                if words:find(" ") then
                    matching = words:match("^[%w_]+") .. " " .. data.description break
                end
            end
        end
    else
        matching = "</>"
    end display_in_correct.Text = matching or "unfinished..."
end

funcs.addcmd = function(name, aly, desc, func)
    if typeof(func) ~= "function" then return end
    if name and typeof(name) == "string" then
        memories.cmds[name] = {
            others_name = aly,
            description = desc,
            callback_func = func
        }
    end
end

funcs.exit_cons = function()
    for _, con in next, connections do
        con:Disconnect()
        con = nil
    end memories.functions = nil
    connections = nil
    screenui:Destroy()
    warn("[" .. memories.lang.resetui .. "]")
end

-- CALL FUNCS FROM HERE --

vars.origin_walkspeed = characters_folder[plr.Name]:GetAttribute("SpeedMultiplier")
funcs.addcmd("speed", {"speed", "sp"}, "<number or code>", function(method)
    if method == "maxium" then
        characters_folder[plr.Name]:SetAttribute("SpeedMultiplier", 10)
    elseif method == "minium" then
        characters_folder[plr.Name]:SetAttribute("SpeedMultiplier", 4)
    else
        characters_folder[plr.Name]:SetAttribute("SpeedMultiplier", tonumber(method) or vars.origin_walkspeed)
    end customfuncs.starter_ntf("SpeedChanged", "Current Speed: " .. method, 1.25)
end)

vars.origin_dash = characters_folder[plr.Name]:GetAttribute("DashLength")
funcs.addcmd("dash", {"dash", "da"}, "<number or code>", function(method)
    if method == "maxium" then
        characters_folder[plr.Name]:SetAttribute("DashLength", 350)
    elseif method == "minium" then
        characters_folder[plr.Name]:SetAttribute("DashLength", 250)
    else
        characters_folder[plr.Name]:SetAttribute("DashLength", tonumber(method) or vars.origin_dash)
    end customfuncs.starter_ntf("DashModified", "Dash Distance: " .. method, 1.25)
end)

vars.is_icyboots_enabled = false
funcs.addcmd("icyboots", {"icyboots", "fzw"}, "freezing water on touched :0", function()
    if not vars.is_icyboots_enabled then vars.is_icyboots_enabled = true
        characters_folder[plr.Name]:SetAttribute("WaterWalking", true)
    else
        characters_folder[plr.Name]:SetAttribute("WaterWalking", false)
    end customfuncs.starter_ntf("Icy Boots", "Is WEAR: " .. characters_folder[plr.Name]:GetAttribute("WaterWalking"), 1.25)
end)

-- END HERE --

funcs.addcmd("goto", {"goto", "to"}, "<name or code> <speed>", function(t, s)
    vars.tweening_speed = tonumber(s) or vars.tweening_speed
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if t == "?" or t == "help" then print("[Goto command helper]")
        for _, keycode in pairs(vars.selected_type) do
            print("[goto <" .. keycode[math.random(1, #keycode)] .. ">]")
        end return
    end funcs.crt_tween(hrp, funcs.return_target(t).Character:FindFirstChild("HumanoidRootPart").Position)
end)

funcs.addcmd("respawn", {"respawn", "reset", "re"}, "reseting your character", function()
    funcs.hmoid_setprop(plr, "Health", 0)
end)

funcs.addcmd("console", {"console", "co"}, "it's open debug console", function()
    customfuncs.devconsole()
end)

funcs.addcmd("commands", {"commands", "cmds"}, "showing every commands i have rn", function()
    print("[" .. memories.lang.randomstuff[1] .. "]")
    for i, v in pairs(memories.cmds) do
        print("[" .. memories.lang.randomstuff[2] .. i .. " ]")
    end
end)

customfuncs.mb1c(capturefocus, function()
    if capturefocus.Text ~= ">" and commands_input.Position == UDim2.new(0, 0, 0.1, 0) then
        capturefocus.Text = ">"
        ui_data.anim_slidein:Play()
    else
        commands_input:CaptureFocus()
    end
end)

customfuncs.fcl(commands_input, function()
    if ui_data.input_onfocused then ui_data.input_onfocused = false end
    ui_data.anim_slidein:Play()
    capturefocus.Text = ">"
    funcs.exec_cmd()
end)

customfuncs.fcs(commands_input, function()
    if not ui_data.input_onfocused then ui_data.input_onfocused = true end
    ui_data.anim_slideout:Play()
    capturefocus.Text = "<"
end)

connections.updt_aly = rs.RenderStepped:Connect(function()
    if ui_data.input_onfocused then funcs.correctedcmds() end
end)

connections.just_to_makesure = rs.RenderStepped:Connect(function()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local hmoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if hrp and hmoid and hmoid.Health > 0 then
        if vars.current_tws then
            funcs.body_velocity(hrp, "add")
        else
            funcs.body_velocity(hrp, "remove")
        end
    else
        funcs.body_velocity(hrp, "remove")
    end
end)

print("Script Loaded!\nBy: HoangHien (facebook)")
