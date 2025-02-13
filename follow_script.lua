local player = game.Players.LocalPlayer

local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local ButtonFollow = Instance.new("TextButton")
    local ButtonStop = Instance.new("TextButton")

    ScreenGui.Parent = game.CoreGui
    Frame.Parent = ScreenGui
    TextBox.Parent = Frame
    ButtonFollow.Parent = Frame
    ButtonStop.Parent = Frame

    -- GUI Properties
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    TextBox.Size = UDim2.new(1, 0, 0.5, 0)
    TextBox.Position = UDim2.new(0, 0, 0, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.PlaceholderText = "Enter Player Name"

    ButtonFollow.Size = UDim2.new(1, 0, 0.25, 0)
    ButtonFollow.Position = UDim2.new(0, 0, 0.5, 0)
    ButtonFollow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ButtonFollow.Text = "Follow"

    ButtonStop.Size = UDim2.new(1, 0, 0.25, 0)
    ButtonStop.Position = UDim2.new(0, 0, 0.75, 0)
    ButtonStop.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ButtonStop.Text = "Stop Following"

    -- Function to make the executor follow the target player
    local function followPlayer(targetPlayer)
        local targetCharacter = targetPlayer.Character
        if not targetCharacter then return end

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        local humanoid = character:WaitForChild("Humanoid")
        local targetHumanoid = targetCharacter:WaitForChild("Humanoid")

        local previousPosition = targetRootPart.Position

        -- Loop to follow the target player
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart do
            local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
            local distance = (targetRootPart.Position - humanoidRootPart.Position).magnitude

            if distance > 2 then
                humanoid:MoveTo(targetRootPart.Position)
                previousPosition = targetRootPart.Position
            else
                if (targetRootPart.Position - previousPosition).magnitude > 0.1 then
                    humanoid:MoveTo(targetRootPart.Position)
                    previousPosition = targetRootPart.Position
                else
                    wait(0.5)
                end
            end
            wait(0.1)
        end
    end

    -- Button functionality to start following the player
    ButtonFollow.MouseButton1Click:Connect(function()
        local targetName = TextBox.Text
        local targetPlayer = game.Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer ~= player then
            followPlayer(targetPlayer)
        else
            warn("Player not found or invalid")
        end
    end)

    -- Button functionality to stop following the player
    ButtonStop.MouseButton1Click:Connect(function()
        -- Stop following logic
        character:FindFirstChild("Humanoid"):MoveTo(character.HumanoidRootPart.Position)
        print("Stopped following")
    end)

    -- Ensure the script gets destroyed upon player reset/death
    character:WaitForChild("Humanoid").Died:Connect(function()
        ScreenGui:Destroy()
    end)

    ScreenGui.Enabled = true
end

createFollowScript()

player.CharacterAdded:Connect(function()
    wait(1)
    createFollowScript()
end)
