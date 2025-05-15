if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- GUI Initialization
local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
ScreenGui.Name = "FikriGantengHub"

-- Frame Setup
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 400)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
Frame.BorderColor3 = Color3.fromRGB(0, 127, 255)
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Text = "Fikri Ganteng Hub"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Layout
local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
Title.LayoutOrder = 0

-- Spacer
local function spacer(height)
	local sp = Instance.new("Frame")
	sp.Size = UDim2.new(1, 0, 0, height)
	sp.BackgroundTransparency = 1
	sp.LayoutOrder = 999
	return sp
end

-- Button Function
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 32)
	btn.Position = UDim2.new(0.5, 0, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(0, 127, 255)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.Text = text
	btn.TextSize = 14
	btn.Parent = Frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- AUTO TOKEN COLLECT
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
							task.wait(0.1)
						end
					end
				end
			end
		end)
	end
end)

Frame:AddChild(spacer(6))

-- ITEM TELEPORT DATA
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
		Vector3.new(278, 90, 235),  -- Gold Egg
		Vector3.new(194, 50, 220),  -- Diamond Egg
		Vector3.new(350, 120, 290)  -- Silver Egg
	}
}

-- General Teleport Function
local function teleportToItems(name)
	for _, pos in ipairs(itemPositions[name]) do
		lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
		task.wait(0.5)
	end
end

createButton("Teleport: Royal Jelly", function() teleportToItems("Royal Jelly") end)
createButton("Teleport: Star Jelly", function() teleportToItems("Star Jelly") end)
createButton("Teleport: All Eggs", function() teleportToItems("All Eggs") end)

-- TELEPORT TO HIVE
createButton("Teleport to Hive", function()
	local hives = workspace:FindFirstChild("Hives")
	if hives then
		local myHive = hives:FindFirstChild(lp.Name .. "'s Hive")
		if myHive then
			lp.Character.HumanoidRootPart.CFrame = myHive.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)

-- CLOSE
createButton("Close UI", function()
	ScreenGui:Destroy()
end)
