-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AdminPanel"

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.Active = true
Frame.Draggable = true

local Close = Instance.new("TextButton", Frame)
Close.Text = "X"
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local Minimize = Instance.new("TextButton", Frame)
Minimize.Text = "-"
Minimize.Size = UDim2.new(0, 25, 0, 25)
Minimize.Position = UDim2.new(1, -60, 0, 5)
Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 50)
local minimized = false
Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(Frame:GetChildren()) do
		if child ~= Close and child ~= Minimize then
			child.Visible = not minimized
		end
	end
	Frame.Size = minimized and UDim2.new(0, 400, 0, 35) or UDim2.new(0, 400, 0, 300)
end)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Welcome Back, " .. LocalPlayer.Name
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Info Text
local Info = Instance.new("TextLabel", Frame)
Info.Size = UDim2.new(1, 0, 0, 100)
Info.Position = UDim2.new(0, 0, 0, 40)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.Gotham
Info.TextSize = 14
Info.TextWrapped = true
Info.Text = "Players: Loading...\nFavorites: Loading...\nServer Age: Loading..."

-- Update Info
task.spawn(function()
	while true do
		local favorites = "Unavailable"
		local success, result = pcall(function()
			local response = HttpService:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId)
			local data = HttpService:JSONDecode(response)
			return data.data[1].favoritedCount
		end)
		if success then
			favorites = result
		end

		Info.Text = string.format("Players: %d\nFavorites: %s\nServer Age: %d mins",
			#Players:GetPlayers(),
			favorites,
			math.floor(workspace.DistributedGameTime / 60)
		)
		task.wait(5)
	end
end)

-- Feature Functions
local function toggleFly()
	-- Implement fly functionality here
end

local function clickTeleport()
	-- Implement click teleport functionality here
end

local function toggleGodMode()
	-- Implement god mode functionality here
end

local function toggleNoclip()
	-- Implement noclip functionality here
end

local function toggleSpeed()
	-- Implement speed functionality here
end

-- Buttons and Hotkeys
local features = {
	{ name = "Fly", func = toggleFly, key = Enum.KeyCode.F },
	{ name = "Click Teleport", func = clickTeleport, key = Enum.KeyCode.T },
	{ name = "God Mode", func = toggleGodMode, key = Enum.KeyCode.G },
	{ name = "Noclip", func = toggleNoclip, key = Enum.KeyCode.N },
	{ name = "Speed 50", func = toggleSpeed, key = Enum.KeyCode.H },
}

local yPos = 150
for _, feature in ipairs(features) do
	local button = Instance.new("TextButton", Frame)
	button.Text = feature.name
	button.Size = UDim2.new(0, 120, 0, 25)
	button.Position = UDim2.new(0, 10, 0, yPos)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.MouseButton1Click:Connect(feature.func)
	yPos = yPos + 30

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == feature.key then
			feature.func()
		end
	end)
end

-- UI Toggle
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		uiVisible = not uiVisible
		ScreenGui.Enabled = uiVisible
	end
end)
