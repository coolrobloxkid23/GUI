-- // Roblox Admin Panel UI by coolrobloxkid23

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local uptime = 0
local flyToggle, noclipToggle, godToggle = false, false, false

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AdminPanel"

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Size = UDim2.new(0,500,0,300)
Frame.Position = UDim2.new(0.3,0,0.3,0)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Close Button
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0,25,0,25)
Close.Position = UDim2.new(1,-30,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(170,0,0)
Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,5,0,5)
Title.Text = "Hello, "..player.Name.."!"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Stats
local Stats = {
	"👥 Players: "..#Players:GetPlayers(),
	"👩‍💻 Scripters: You",
	"⏱️ Uptime: "..uptime.."s",
	"📍 Location: "..game.JobId ~= "" and "Unknown Server" or "Studio"
}

local statLabels = {}
for i,v in pairs(Stats) do
	local Label = Instance.new("TextLabel", Frame)
	Label.Size = UDim2.new(0,220,0,25)
	Label.Position = UDim2.new(0,10,0,30 + (i*30))
	Label.Text = v
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	statLabels[i] = Label
end

-- Commands
local Commands = {
	{"Fly (F)", function()
		flyToggle = not flyToggle
		if flyToggle then
			local bp = Instance.new("BodyPosition", player.Character.HumanoidRootPart)
			bp.Name = "FlyBP"
			bp.MaxForce = Vector3.new(999999,999999,999999)
			RunService.RenderStepped:Connect(function()
				if flyToggle then
					bp.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,2,0)
				end
			end)
		else
			if player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyBP") then
				player.Character.HumanoidRootPart.FlyBP:Destroy()
			end
		end
	end},

	{"Invisible (I)", function()
		player.Character:FindFirstChildWhichIsA("Humanoid").Name = "Invisible"
	end},

	{"Godmode (G)", function()
		godToggle = not godToggle
		if godToggle then
			player.Character.Humanoid.Health = math.huge
		end
	end},

	{"Speed 50 (J)", function()
		player.Character.Humanoid.WalkSpeed = 50
	end},

	{"Jump 100 (K)", function()
		player.Character.Humanoid.JumpPower = 100
	end},
}

for i,v in pairs(Commands) do
	local Btn = Instance.new("TextButton", Frame)
	Btn.Size = UDim2.new(0,220,0,25)
	Btn.Position = UDim2.new(0,260,0,30 + (i*30))
	Btn.Text = v[1]
	Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Btn.TextColor3 = Color3.fromRGB(255,255,255)
	Btn.MouseButton1Click:Connect(v[2])
end

-- Update UI every second
while RunService.RenderStepped:Wait() do
	uptime = uptime + 1
	statLabels[1].Text = "👥 Players: "..#Players:GetPlayers()
	statLabels[3].Text = "⏱️ Uptime: "..uptime.."s"
end

-- Toggle UI with RightShift
mouse.KeyDown:Connect(function(key)
	if key == string.char(29) then -- RightShift
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)
