local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "FreeMenu"
Gui.Enabled = false

local function createButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = Gui
    return btn
end

local jumpEnabled, pickupEnabled = false, false

local jumpBtn = createButton("Jump Power: OFF", UDim2.new(0, 10, 0, 10))
jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    jumpBtn.Text = jumpEnabled and "Jump Power: ON" or "Jump Power: OFF"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
    end
end)

local pickupBtn = createButton("Fast Pickup: OFF", UDim2.new(0, 10, 0, 60))
pickupBtn.MouseButton1Click:Connect(function()
    pickupEnabled = not pickupEnabled
    pickupBtn.Text = pickupEnabled and "Fast Pickup: ON" or "Fast Pickup: OFF"
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        Gui.Enabled = not Gui.Enabled
    end
end)

local function getClosest()
    local closest, shortest = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not Gui.Enabled then return end
    local target = getClosest()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        -- ถ้ามีระบบยิงของเกมนั้นเองอาจต้องเรียก function ยิงด้วย เช่น:
        -- firebullet(target.Character.Head.Position)
    end
end)
