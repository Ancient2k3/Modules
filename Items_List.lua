local core = game:GetService("CoreGui")

for _, item in next, core:GetChildren() do
  if item:IsA("ScreenGui") and item.Name == "_Acy:Items_List_Module" then
    item:Destroy()
  end
end

local ui_t = {}
ui_t.screen = Instance.new("ScreenGui", core)
ui_t.screen.Name = "_Acy:Items_List_Module"
ui_t.scroll = Instance.new("ScrollingFrame", ui_t.screen)
ui_t.toggle = Instance.new("TextButton", ui_t.screen)
ui_t.add_corner = function(t, r)
  Instance.new("UICorner", t).CornerRadius = UDim.new(r, 0)
end

local x = ui_t.scroll
x.Name = "Items_List#" .. tostring(math.random(2000, 8000))
x.BackgroundTransparency = 0.5
x.BackgroundColor3 = Color3.new(0, 0, 0)
x.Position = UDim2.new(0.4, 0, 0.25, 0)
x.Size = UDim2.new(0.2, 0, 0.4, 0)
x.CanvasSize = UDim2.new(0, 0, 0, 0)
x.ScrollBarThickness = 0.01
x.Visible = false
x.ZIndex = 1
ui_t.add_corner(x, 0.005)

ui_t.show_list = false

local z = ui_t.toggle
z.Name = "Items_List_T#" .. tostring(math.random(9000, 18000))
z.BackgroundTransparency = 0.5
z.BackgroundColor3 = Color3.new(0, 0, 0)
z.Position = UDim2.new(0.005, 0, 0.175, 0)
z.Size = UDim2.new(0.038, 0, 0.06, 0)
z.TextScaled = true
z.TextSize = 12
z.TextColor3 = Color3.new(1, 1, 1)
z.Font = Enum.Font.Code
z.Text = "+"
z.Visible = true
z.ZIndex = 1
ui_t.add_corner(z, 0.2)

ui_t.canvas = 0
ui_t.height = 10
ui_t.padding = 2
ui_t.count = 0

function add_button(txt, func)
  if txt and func and type(txt) == "string" and type(func) == "function" then
    local btn = Instance.new("TextButton", x)
    ui_t.count = ui_t.count + 1
    btn.Name = "BTN:" .. txt .. "_#" .. tostring(ui_t.count)
    btn.BackgroundTransparency = 0.5
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.Position = UDim2.new(0.02, 0, 0, ui_t.canvas + ui_t.padding)
    btn.Size = UDim2.new(0.96, 0, 0, ui_t.height)
    btn.TextScaled = true
    btn.TextSize = 12
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.Text = txt
    btn.Visible = true
    btn.MouseButton1Click:Connect(func)
    ui_t.canvas = ui_t.canvas + ui_t.height + ui_t.padding
    x.CanvasSize = UDim2.new(0, 0, 0, ui_t.canvas)
  else
    return "arg #1 must be a string and arg #2 must be a function"
  end
end

z.MouseButton1Click:Connect(function()
  if not ui_t.show_list then ui_t.show_list = true
    z.Text = "-"
    x.Visible = true
  else ui_t.show_list = false
    z.Text = "+"
    x.Visible = false
  end
end)

return add_button
