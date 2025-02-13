local player = game.Players.LocalPlayer

local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()
    local ScreenGui, Frame, TextBox, ButtonFollow, ButtonStop = Instance.new("ScreenGui"), Instance.new("Frame"), Instance.new("TextBox"), Instance.new("TextButton"), Instance.new("TextButton")
    ScreenGui.Parent, Frame.Parent = game.CoreGui, ScreenGui
    TextBox.Parent, ButtonFollow.Parent, ButtonStop.Parent = Frame, Frame, Frame

    Frame.Size, Frame.Position, Frame.BackgroundColor3 = UDim2.new(0, 200, 0, 150), UDim2.new(0.5, -100, 0.1, 0), Color3.fromRGB(50, 50, 50)
    TextBox.Size, TextBox.Position, TextBox.BackgroundColor3, TextBox.PlaceholderText = UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(200, 200, 200), "Enter Player Name"
    ButtonFollow.Size, ButtonFollow.Position, ButtonFollow.BackgroundColor3, ButtonFollow.Text = UDim2.new(1, 0, 0.25, 0), UDim2.new(0, 0, 0.5, 0), Color3.fromRGB(100, 100, 100), "Follow"
    ButtonStop.Size, ButtonStop.Position, ButtonStop.BackgroundColor3, ButtonStop.Text = UDim2.new(1, 0, 0.25, 0), UDim2.new(0, 0, 0.75, 0), Color3.fromRGB(255, 0, 0), "Stop Following"

    local function followPlayer(targetPlayer)
        local targetCharacter, humanoidRootPart, targetRootPart = targetPlayer.Character, character:WaitForChild("HumanoidRootPart"), targetPlayer.Character:WaitForChild("HumanoidRootPart")
        local humanoid, previousPosition = character:WaitForChild("Humanoid"), targetRootPart.Position
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart do
            if (targetRootPart.Position - humanoidRootPart.Position).magnitude > 2 then humanoid:MoveTo(targetRootPart.Position) end
            wait(0.1)
        end
    end

    ButtonFollow.MouseButton1Click:Connect(function()
        local targetPlayer = game.Players:FindFirstChild(TextBox.Text)
        if targetPlayer and targetPlayer ~= player then followPlayer(targetPlayer) end
    end)

    ButtonStop.MouseButton1Click:Connect(function() character:FindFirstChild("Humanoid"):MoveTo(character.HumanoidRootPart.Position) end)

    character:WaitForChild("Humanoid").Died:Connect(function() ScreenGui:Destroy() end)
    ScreenGui.Enabled = true
end

createFollowScript()

player.CharacterAdded:Connect(function() wait(1) createFollowScript() end)

