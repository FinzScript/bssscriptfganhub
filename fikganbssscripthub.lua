-- Ultimate Fikri Ganteng Hub
if not game:IsLoaded() then game.Loaded:Wait() end

-- Services & Player
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

-- Anti-Kick & Anti-AFK Protection
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then return end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
for _, conn in pairs(getconnections(lp.Idled)) do conn:Disable() end
lp.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FikriGantengHub"
ScreenGui.Parent = gethui and gethui() or game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 600)
Frame.Position = UDim2.new(0.5, -150, 0.5, -300)
Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Frame.BorderColor3 = Color3.fromRGB(0, 127, 255)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Fikri Ganteng Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper Functions
local function safeTeleport(pos)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.AnchorPoint = Vector2.new(0.5, 0)
    btn.Position = UDim2.new(0.5, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 127, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.LayoutOrder = 1
    btn.MouseButton1Click:Connect(function() pcall(callback, btn) end)
    return btn
end

-- Feature: Auto Collect Tokens
local autoTokens = false
createButton("Auto Collect Tokens", function(btn)
    autoTokens = not autoTokens
    btn.Text = autoTokens and "Tokens: ON" or "Tokens: OFF"
    if autoTokens then
        task.spawn(function()
            while autoTokens do
                local col = workspace:FindFirstChild("Collectibles")
                if col then
                    for _, v in ipairs(col:GetChildren()) do
                        if v:IsA("BasePart") then
                            safeTeleport(v.CFrame.p + Vector3.new(0, 3, 0))
                        end
                    end
                end
                task.wait(0.8)
            end
        end)
    end
end)

-- Item Positions
local itemPositions = {
    RoyalJelly = {Vector3.new(129, 65, 245), Vector3.new(10, 42, 314), Vector3.new(286, 123, 177)},
    StarJelly = {Vector3.new(165, 80, 280)},
    AllEggs = {Vector3.new(278, 90, 235), Vector3.new(194, 50, 220), Vector3.new(350, 120, 290)},
}

local function teleportTo(name, extraPos)
    local list = itemPositions[name] or {}
    if extraPos then table.insert(list, extraPos) end
    for _, pos in ipairs(list) do
        safeTeleport(pos + Vector3.new(0, 5, 0))
        task.wait(1)
    end
end

createButton("Teleport: Royal Jelly", function() teleportTo("RoyalJelly") end)
createButton("Teleport: Star Jelly", function() teleportTo("StarJelly") end)
createButton("Teleport: All Eggs", function() teleportTo("AllEggs") end)
createButton("Teleport: Hive", function()
    local hiveFolder = workspace:FindFirstChild("Hives")
    if hiveFolder then
        local myHive = hiveFolder:FindFirstChild(lp.Name .. "'s Hive")
        if myHive and myHive.PrimaryPart then
            teleportTo(nil, myHive.PrimaryPart.Position)
        end
    end
end)
createButton("Teleport: Wind Shrine", function()
    local ws = workspace:FindFirstChild("WindShrine")
    if ws and ws.PrimaryPart then teleportTo(nil, ws.PrimaryPart.Position) end
end)

-- Feature: Auto Puffshroom
local autoPuffs = false
createButton("Auto Puffshroom", function(btn)
    autoPuffs = not autoPuffs
    btn.Text = autoPuffs and "Puff: ON" or "Puff: OFF"
    if autoPuffs then
        task.spawn(function()
            while autoPuffs do
                local puffs = workspace:FindFirstChild("Puffshrooms")
                if puffs then
                    for _, v in ipairs(puffs:GetDescendants()) do
                        if v:IsA("BasePart") then safeTeleport(v.CFrame.p + Vector3.new(0, 5, 0)) end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Feature: Auto Sprout Collector
local autoSprouts = false
createButton("Auto Sprout Collector", function(btn)
    autoSprouts = not autoSprouts
    btn.Text = autoSprouts and "Sprout: ON" or "Sprout: OFF"
    if autoSprouts then
        task.spawn(function()
            while autoSprouts do
                local sprouts = workspace:FindFirstChild("Sprouts")
                if sprouts then
                    for _, m in ipairs(sprouts:GetChildren()) do
                        if m.PrimaryPart then safeTeleport(m.PrimaryPart.Position + Vector3.new(0, 5, 0)) end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Feature: Use All Dispensers
createButton("Use All Dispensers", function()
    for _, d in ipairs(workspace:GetDescendants()) do
        if d.Name:match("Dispenser") and d.PrimaryPart then
            safeTeleport(d.PrimaryPart.Position + Vector3.new(0, 5, 0))
            task.wait(1)
        end
    end
end)

-- Feature: Auto Convert Honey
local autoConvert = false
createButton("Auto Convert Honey", function(btn)
    autoConvert = not autoConvert
    btn.Text = autoConvert and "Convert: ON" or "Convert: OFF"
    if autoConvert then
        task.spawn(function()
            while autoConvert do
                local conv = workspace:FindFirstChild("Dispenser")
                if conv and conv.PrimaryPart then safeTeleport(conv.PrimaryPart.Position + Vector3.new(0, 5, 0)) end
                task.wait(1)
            end
        end)
    end
end)

-- Feature: Lag Reducer
createButton("Lag Reducer", function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

-- Feature: Hide Name Tag
createButton("Hide Name Tag", function()
    if lp.Character then
        for _, g in ipairs(lp.Character:GetDescendants()) do
            if g:IsA("BillboardGui") then g:Destroy() end
        end
    end
end)

-- Feature: Ping Display
local pingLabel = Instance.new("TextLabel", Frame)
pingLabel.Size = UDim2.new(1, 0, 0, 20)
pingLabel.TextSize = 14
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
pingLabel.Font = Enum.Font.Gotham
pingLabel.LayoutOrder = 999
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pingLabel.Text = "Ping: "..ping.." ms"
        task.wait(2)
    end
end)

-- Close Button
createButton("Close UI", function()
    ScreenGui:Destroy()
end)
