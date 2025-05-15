
if not game:IsLoaded() then game.Loaded:Wait() end

-- Bypass Anti Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game.Players.LocalPlayer then
        warn("[ANTI KICK] Kick attempt blocked!")
        return nil
    end
    return oldNamecall(self, ...)
end)
game.Players.LocalPlayer.Kick = function()
    warn("[ANTI KICK] Direct kick attempt blocked!")
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local Mouse = lp:GetMouse()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
ScreenGui.Name = "FikriGantengHub"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 460)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Frame.BorderColor3 = Color3.fromRGB(0, 127, 255)
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Fikri Ganteng Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextWrapped = true
Title.LayoutOrder = 0

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Make GUI Draggable
Frame.Active = true
Frame.Draggable = true

-- Button Creator
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 36)
    btn.Position = UDim2.new(0.5, -120, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 127, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.TextSize = 14
    btn.Parent = Frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- Auto Token Collect
local autoToken = false
createButton("Auto Collect Tokens", function(button)
    autoToken = not autoToken
    button.Text = autoToken and "Tokens: ON" or "Tokens: OFF"
    if autoToken then
        task.spawn(function()
            while autoToken and task.wait(0.5) do
                local col = workspace:FindFirstChild("Collectibles")
                if col then
                    for _, token in ipairs(col:GetChildren()) do
                        if token:IsA("Part") then
                            lp.Character.HumanoidRootPart.CFrame = token.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end)
    end
end)

-- Teleport Data
local itemPositions = {
    ["Royal Jelly"] = {
        Vector3.new(129, 65, 245),
        Vector3.new(10, 42, 314),
        Vector3.new(286, 123, 177)
    },
    ["Star Jelly"] = {
        Vector3.new(165, 80, 280)
    },
    ["All Eggs"] = {
        Vector3.new(278, 90, 235),
        Vector3.new(194, 50, 220),
        Vector3.new(350, 120, 290)
    }
}

local function teleportToItems(name)
    for _, pos in ipairs(itemPositions[name]) do
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        task.wait(1.3)
    end
end

-- Teleport Buttons
createButton("Teleport: Royal Jelly", function() teleportToItems("Royal Jelly") end)
createButton("Teleport: Star Jelly", function() teleportToItems("Star Jelly") end)
createButton("Teleport: All Eggs", function() teleportToItems("All Eggs") end)

-- Teleport to Hive
createButton("Teleport to Hive", function()
    local hives = workspace:FindFirstChild("Hives")
    if hives then
        local myHive = hives:FindFirstChild(lp.Name .. "'s Hive")
        if myHive then
            lp.Character.HumanoidRootPart.CFrame = myHive.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- Auto Dispenser
createButton("Use All Dispensers", function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "Dispenser" and v:FindFirstChild("TouchInterest") then
            lp.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
            task.wait(1.3)
        end
    end
end)

-- Anti AFK
createButton("Enable Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    lp.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Close GUI Button
createButton("Close GUI", function()
    ScreenGui:Destroy()
end)
