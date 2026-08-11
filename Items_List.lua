local core = game:GetService("CoreGui")

local ui_t = {}
ui_t.screen = Instance.new("ScreenGui", core)
ui_t.screen.Name = "Items_List_Module"
ui_t.scroll = Instance.new("ScrollingFrame", ui_t.screen)

local x = ui_t.scroll
x.Name = "Items_List#" .. tostring(math.random(2000, 8000))
x.BackgroundTransparency = 0.5
x.BackgroundColor3 = Color3.new(0, 0, 0)
x.Position = UDim2.new(0.4, 0, 0.25, 0)
x.Size = UDim2.new(0.2, 0, 0.4, 0)
x.CanvasSize = UDim2.new(0, 0, 0, 0)
x.ScrollBarThickness = 0.01
x.Visible = true
x.ZIndex = 2

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

return add_button
