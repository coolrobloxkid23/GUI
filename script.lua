-- // Roblox Admin Panel UI by coolrobloxkid23-- 


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create the ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CustomExploitGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
frame.BorderColor3 = Color3.fromRGB(120, 0, 180)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Custom GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = frame
-- Variables for states
local flying = false
local noclipping = false
local godmode = false
local speed = 0

-- Fly Button
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(1, -20, 0, 30)
flyToggle.Position = UDim2.new(0, 10, 0, 40)
flyToggle.Text = "Fly"
flyToggle.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Parent = frame

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyToggle.Text = flying and "Fly [ON]" or "Fly"
end)

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.Text = "Speed: 0"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = frame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(1, -20, 0, 20)
speedSlider.Position = UDim2.new(0, 10, 0, 100)
speedSlider.Text = "Adjust Speed"
speedSlider.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Parent = frame

speedSlider.MouseButton1Click:Connect(function()
    speed = (speed + 50) % 250 -- Cycles through 0 → 50 → 100 → 150 → 200 → 0
    speedLabel.Text = "Speed: " .. tostring(speed)
end)

-- Noclip Button
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(1, -20, 0, 30)
noclipToggle.Position = UDim2.new(0, 10, 0, 130)
noclipToggle.Text = "Noclip"
noclipToggle.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.Parent = frame

noclipToggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    noclipToggle.Text = noclipping and "Noclip [ON]" or "Noclip"
end)

-- God Mode Button
local godToggle = Instance.new("TextButton")
godToggle.Size = UDim2.new(1, -20, 0, 30)
godToggle.Position = UDim2.new(0, 10, 0, 170)
godToggle.Text = "God Mode"
godToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
godToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
godToggle.Parent = frame

godToggle.MouseButton1Click:Connect(function()
    godmode = not godmode
    godToggle.Text = godmode and "God Mode [ON]" or "God Mode"
end)

-- Teleport Dropdown
local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(1, -20, 0, 20)
tpLabel.Position = UDim2.new(0, 10, 0, 210)
tpLabel.Text = "Teleport to:"
tpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tpLabel.BackgroundTransparency = 1
tpLabel.TextSize = 16
tpLabel.Font = Enum.Font.SourceSans
tpLabel.Parent = frame

local tpDropdown = Instance.new("TextButton")
tpDropdown.Size = UDim2.new(1, -20, 0, 30)
tpDropdown.Position = UDim2.new(0, 10, 0, 230)
tpDropdown.Text = "Teleport to First Player"
tpDropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpDropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
tpDropdown.Parent = frame

tpDropdown.MouseButton1Click:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            break
        end
    end
end)

-- Logic for fly and noclip movement
RunService.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
        LocalPlayer.Character:TranslateBy(moveDirection.Unit * (speed / 60))
    end

    if noclipping and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if godmode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

print("GUI Loaded with functionality")
