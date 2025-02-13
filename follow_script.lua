local player, following, savedText = game.Players.LocalPlayer, false, ""
local function createFollowScript()
    local character, ScreenGui, Frame, TextBox, Button, StopButton = player.Character or player.CharacterAdded:Wait(), Instance.new("ScreenGui"), Instance.new("Frame"), Instance.new("TextBox"), Instance.new("TextButton"), Instance.new("TextButton")
    ScreenGui.Parent, Frame.Parent, TextBox.Parent, Button.Parent, StopButton.Parent = game.CoreGui, ScreenGui, Frame, Frame, Frame

    -- GUI styling
    Frame.Size, Frame.Position = UDim2.new(0, 200, 0, 200), UDim2.new(0, 0, 1, -200)
    Frame.BackgroundColor3, Frame.BorderColor3, Frame.BorderSizePixel = Color3.fromRGB(75, 0, 130), Color3.fromRGB(0, 0, 0), 4
    TextBox.Size, TextBox.Position, TextBox.PlaceholderText = UDim2.new(0.8, 0, 0.25, 0), UDim2.new(0.1, 0, 0, 0), "Enter Player Name"
    TextBox.BackgroundColor3, TextBox.TextColor3, TextBox.TextSize, TextBox.Font = Color3.fromRGB(50, 50, 50), Color3.fromRGB(0, 0, 0), 16, Enum.Font.SourceSansBold
    Button.Size, Button.Position, Button.BackgroundColor3, Button.Text = UDim2.new(0.8, 0, 0.25, 0), UDim2.new(0.1, 0, 0.25, 0), Color3.fromRGB(100, 100, 100), "Follow"
    Button.TextColor3, Button.Font, Button.TextSize = Color3.fromRGB(0, 0, 0), Enum.Font.SourceSansBold, 16
    StopButton.Size, StopButton.Position, StopButton.BackgroundColor3, StopButton.Text = UDim2.new(0.8, 0, 0.25, 0), UDim2.new(0.1, 0, 0.5, 0), Color3.fromRGB(255, 0, 0), "Stop Following"
    StopButton.TextColor3, StopButton.Font, StopButton.TextSize = Color3.fromRGB(0, 0, 0), Enum.Font.SourceSansBold, 16

    TextBox.Text = savedText

    -- Follow function
    local function followPlayer(targetPlayer)
        local humanoidRootPart, targetRootPart = character:WaitForChild("HumanoidRootPart"), targetPlayer.Character:WaitForChild("HumanoidRootPart")
        while targetPlayer.Character and humanoidRootPart and targetRootPart and following do
            local dir, dist = (targetRootPart.Position - humanoidRootPart.Position).unit, (targetRootPart.Position - humanoidRootPart.Position).magnitude
            if dist > 6 then humanoidRootPart.Parent.Humanoid:MoveTo(targetRootPart.Position)
            elseif dist > 4 then humanoidRootPart.Parent.Humanoid:MoveTo(targetRootPart.Position)
            else humanoidRootPart.Parent.Humanoid:MoveTo(targetRootPart.Position - dir * 4) end
            wait(0.1)
        end
    end

    -- Button connections
    Button.MouseButton1Click:Connect(function()
        savedText = TextBox.Text
        local targetPlayer = game.Players:FindFirstChild(savedText)
        if targetPlayer and targetPlayer ~= player then following = true followPlayer(targetPlayer) end
    end)
    StopButton.MouseButton1Click:Connect(function() following = false end)

    -- Cleanup on death
    character:WaitForChild("Humanoid").Died:Connect(function() ScreenGui:Destroy() end)
end

createFollowScript()

-- Recreate and load saved text on respawn
player.CharacterAdded:Connect(function()
    wait(1)
    createFollowScript()
    local textBox = game.CoreGui:WaitForChild(player.Name):WaitForChild("ScreenGui"):WaitForChild("Frame"):WaitForChild("TextBox")
    textBox.Text = savedText
end)
