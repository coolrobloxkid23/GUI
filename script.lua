-- UI Library (custom implementation)
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
frame.Size = UDim2.new(0, 420, 0, 300)
frame.Position = UDim2.new(0.5, -210, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(26, 8, 58)
frame.BorderColor3 = Color3.fromRGB(120, 0, 180)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Exit Button
local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 30, 0, 30)
exitBtn.Position = UDim2.new(1, -35, 0, 5)
exitBtn.Text = "X"
exitBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 18
exitBtn.Parent = frame
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tabs
local tabPlayers = Instance.new("TextButton")
tabPlayers.Text = "Players"
tabPlayers.Size = UDim2.new(0, 100, 0, 25)
tabPlayers.Position = UDim2.new(0, 5, 0, 5)
tabPlayers.BackgroundColor3 = Color3.fromRGB(40, 10, 70)
tabPlayers.TextColor3 = Color3.fromRGB(255, 255, 255)
tabPlayers.Font = Enum.Font.Code
tabPlayers.TextSize = 16
tabPlayers.Parent = frame

local tabSettings = tabPlayers:Clone()
tabSettings.Text = "Settings"
tabSettings.Position = UDim2.new(0, 110, 0, 5)
tabSettings.Parent = frame

-- Left Panel (Enemies)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 200, 0, 220)
leftPanel.Position = UDim2.new(0, 10, 0, 40)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = frame

local function createCheckbox(labelText, color)
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(1, 0, 0, 20)
    checkbox.BackgroundColor3 = Color3.fromRGB(15, 0, 20)
    checkbox.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    checkbox.Font = Enum.Font.Code
    checkbox.TextSize = 14
    checkbox.TextXAlignment = Enum.TextXAlignment.Left
    checkbox.Text = "[ ] " .. labelText
    checkbox.MouseButton1Click:Connect(function()
        checkbox.Text = checkbox.Text:match("%[X%]") and "[ ] " .. labelText or "[X] " .. labelText
    end)
    return checkbox
end

local labels = {
    {"Enabled"}, {"Name", Color3.fromRGB(255,255,255)}, {"Bounding Box", Color3.fromRGB(200, 100, 255)},
    {"Health Bar", Color3.fromRGB(0, 255, 0)}, {"Distance", Color3.fromRGB(255,255,255)}, {"Weapon", Color3.fromRGB(255,255,255)}
}

for i, data in ipairs(labels) do
    local checkbox = createCheckbox(unpack(data))
    checkbox.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    checkbox.Parent = leftPanel
end

-- Right Panel (Functionality)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0, 180, 0, 220)
rightPanel.Position = UDim2.new(0, 230, 0, 40)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = frame

local speed = 0
local flying = false
local noclipping = false
local godmode = false

-- Slider Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.Text = "Slider Test\n0/200"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Code
speedLabel.TextSize = 14
speedLabel.Parent = rightPanel

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, 0, 0, 25)
speedButton.Position = UDim2.new(0, 0, 0, 40)
speedButton.Text = "Adjust Speed"
speedButton.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Code
speedButton.TextSize = 14
speedButton.Parent = rightPanel
speedButton.MouseButton1Click:Connect(function()
    speed = (speed + 25) % 225
    speedLabel.Text = "Slider Test\n" .. tostring(speed) .. "/200"
end)

-- Fly Button
local flyBtn = speedButton:Clone()
flyBtn.Position = UDim2.new(0, 0, 0, 70)
flyBtn.Text = "Fly"
flyBtn.Parent = rightPanel
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "Fly [ON]" or "Fly"
end)

-- Noclip Button
local noclipBtn = flyBtn:Clone()
noclipBtn.Position = UDim2.new(0, 0, 0, 100)
noclipBtn.Text = "Noclip"
noclipBtn.Parent = rightPanel
noclipBtn.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    noclipBtn.Text = noclipping and "Noclip [ON]" or "Noclip"
end)

-- God Mode
local godBtn = flyBtn:Clone()
godBtn.Position = UDim2.new(0, 0, 0, 130)
godBtn.Text = "God Mode"
godBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
godBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
godBtn.Parent = rightPanel
godBtn.MouseButton1Click:Connect(function()
    godmode = not godmode
    godBtn.Text = godmode and "God Mode [ON]" or "God Mode"
end)

-- Teleport to First Player
local tpBtn = flyBtn:Clone()
tpBtn.Position = UDim2.new(0, 0, 0, 160)
tpBtn.Text = "Teleport to First Player"
tpBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
tpBtn.Parent = rightPanel
tpBtn.MouseButton1Click:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            break
        end
    end
end)

-- Runtime Behavior
RunService.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += workspace.CurrentCamera.CFrame.RightVector end
        if moveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(moveDirection.Unit * (speed / 60))
        end
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

print("Styled GUI Loaded")
