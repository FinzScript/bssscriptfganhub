-- Fikri Ganteng Hub - Android UI Container (Bee Swarm Simulator)
local player = game.Players.LocalPlayer

-- UI Container
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FikriGantengHub"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 320, 0, 280)
main.Position = UDim2.new(0, 10, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 122, 204)
main.Name = "MainPanel"

-- Judul
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 122, 204)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Text = "Fikri Ganteng Hub"
title.BorderSizePixel = 0

-- Tombol Helper
local function createButton(text, posY, callback)
	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(1, -20, 0, 50)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = text
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(callback)
end

-- TOMBOL 1: AUTO QUEST
local autoQuesting = false
local function autoQuest()
	autoQuesting = not autoQuesting
	if autoQuesting then
		while autoQuesting do
			task.wait(3)
			for _, npc in pairs(workspace.NPCs:GetChildren()) do
				if npc:FindFirstChild("ProximityPrompt") then
					pcall(function()
						fireproximityprompt(npc.ProximityPrompt)
					end)
				end
			end
		end
	end
end

-- TOMBOL 2: AUTO COLLECT HONEY TOKEN
local autoCollecting = false
local function autoCollectTokens()
	autoCollecting = not autoCollecting
	if autoCollecting then
		while autoCollecting do
			task.wait(0.3)
			for _, v in pairs(workspace.Collectibles:GetChildren()) do
				if v.Name == "C" and v:FindFirstChild("FrontDecal") then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						char.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
						task.wait(0.1)
					end
				end
			end
		end
	end
end

-- TOMBOL 3: TELEPORT TO ITEMS
local function teleportToItems()
	local names = {"RoyalJelly", "StarJelly", "DiamondEgg"}
	for _, obj in pairs(workspace:GetDescendants()) do
		for _, name in ipairs(names) do
			if string.find(obj.Name, name) and obj:IsA("BasePart") and obj.Transparency < 1 then
				player.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
				task.wait(1.5)
			end
		end
	end
end

-- Tambah tombol ke panel
createButton("1. Auto Quest", 50, autoQuest)
createButton("2. Auto Collect Honey", 110, autoCollectTokens)
createButton("3. Teleport to Items", 170, teleportToItems)
