--// Commands Script by HHxScripts //--
local ws, plrs, rls, tws, tps, rs, starter, core
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
rls = game:GetService("ReplicatedStorage")
tws = game:GetService("TweenService")
tps = game:GetService("TeleportService")
rs = game:GetService("RunService")
starter = game:GetService("StarterGui")
core = game:GetService("CoreGui")
local requirescript = loadstring

if getgenv().memories then
    getgenv().memories.functions.exit_cons()
end

getgenv().memories = getgenv().memories or {}
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
    rev = function(t) return not t end,
    kick = function(m) plr:Kick(m) end
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

--// Functions Section //--
memories.functions = {}
local funcs, connections = memories.functions, {}

funcs.correct_username = function(input)
    for _, user in ipairs(plrs:GetPlayers()) do
        if string.lower(user.Name):sub(1, #input) == string.lower(input) or
        string.lower(user.DisplayName):sub(1, #input) == string.lower(input) then
            return user
        end
    end return nil
end

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
    noobie = {"noobie", "newbie", "new"},
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
        local fullhp_list = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChildOfClass("Humanoid") then
                local h_moid = enm.Character and enm.Character:FindFirstChildOfClass("Humanoid")
                if h_moid.Health >= plr.Character.Humanoid.Health then
                    table.insert(fullhp_list, enm)
                end
            end
        end if #fullhp_list > 0 then
            final_result = fullhp_list[1]
        end
    elseif table.find(slt.weakest, t) then
        local weakest_list = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChildOfClass("Humanoid") then
                local h_moid = enm.Character and enm.Character:FindFirstChildOfClass("Humanoid")
                if h_moid.Health < plr.Character.Humanoid.Health then
                    table.insert(weakest_list, enm)
                end
            end
        end if #weakest_list > 0 then
            final_result = weakest_list[1]
        end
    elseif table.find(slt.noobie, t) then
        local newbie_list = {}
        for _, enm in pairs(plrs:GetPlayers()) do
            if enm ~= plr and enm.Character and enm.Character:FindFirstChild("HumanoidRootPart") then
                if enm.Character.Humanoid.Health <= 100 then
                    table.insert(newbie_list, enm)
                end
            end
        end if #newbie_list > 0 then
            final_result = newbie_list[math.random(1, #newbie_list)]
        end
    elseif table.find(slt.npc, t) then
        local usernames = {}
        for _, user in next, plrs:GetPlayers() do table.insert(usernames, user.Name:lower()) end
        for _, rig_model in pairs(ws:GetDescendants()) do
            if rig_model and rig_model:FindFirstChildOfClass("Humanoid") then
                local rig_name, rig_hmoid = rig_model.Name:lower(), rig_model:FindFirstChildOfClass("Humanoid")
                if rig_hmoid and rig_hmoid.Health > 0 then
                    if not table.find(usernames, rig_name) then
                        local root = rig_model:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dis = (root.Position - plr.Character.HumanoidRootPart.Position).magnitude
                            if dis < mathinf then
                                mathinf = dis
                                final_result = rig_model
                            end
                        end
                    end
                end
            end
        end
    else
        local userfound = funcs.correct_username(t)
        if userfound ~= nil then
            final_result = userfound
        else
            customfuncs.starter_ntf("💠 Notification 💠", "WHO IS " .. tostring(t):upper() .. " IN THE SERVER?", 1.25)
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

funcs.return_obj = function(o, class)
    local store_objects = {}
    for _, object in pairs(ws:GetDescendants()) do
        if object:IsA(class) and object.Name == o then
            table.insert(store_objects, object)
        end
    end return store_objects
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

--// Commands Added Section //--

funcs.addcmd("goto", {"goto", "to"}, "<name or code> <speed>", function(t, s)
    vars.tweening_speed = tonumber(s) or vars.tweening_speed
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if t == "?" or t == "help" then print("[Goto command helper]")
        for key, keycode in pairs(vars.selected_type) do
            print("[goto <" .. key .. " or " .. keycode[math.random(1, #keycode)] .. ">]")
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
    local total_cmds = {}
    for i, v in pairs(memories.cmds) do
        table.insert(total_cmds, i)
        print("[" .. memories.lang.randomstuff[2] .. i .. " ], [" .. v.description .. "]")
    end print("[Total: " .. #total_cmds .. " Commands!]")
end)

funcs.addcmd("runcommand", {"runcommand", "runcmd", "rc"}, "<cmd name> <times>", function(name, times, ...)
    local cmds_stored, args = {}, {...}
    for i, v in pairs(memories.cmds) do
        table.insert(cmds_stored, i)
    end if table.find(cmds_stored, name) then
        local repeat_times = tonumber(times) or 1
        for ins = 1, repeat_times do
            memories.cmds[name].callback_func(unpack(args))
            task.wait(0.2)
        end
    else customfuncs.starter_ntf("💠 Notification 💠", "Command Inserted Does Not Existed!", 1.25)
    end
end)

--// Close Section //--
-- [AC] --
--// Make Connections //--

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

return funcs, vars
--// The End //--
