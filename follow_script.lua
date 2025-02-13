local player = game.Players.LocalPlayer
local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local Button = Instance.new("TextButton")

    ScreenGui.Parent = game.CoreGui
    Frame.Parent = ScreenGui
    TextBox.Parent = Frame
    Button.Parent = Frame

    -- GUI Properties
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    TextBox.Size = UDim2.new(1, 0, 0.5, 0)
    TextBox.Position = UDim2.new(0, 0, 0, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.PlaceholderText = "Enter Player Name"

    Button.Size = UDim2.new(1, 0, 0.5, 0)
    Button.Position = UDim2.new(0, 0, 0.5, 0)
    Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Button.Text = "Follow"

    local function followPlayer(targetPlayer)
        local targetCharacter = targetPlayer.Character
        if not targetCharacter then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart or not targetRootPart then return end

        local humanoid = character:FindFirstChild("Humanoid")

        while targetCharacter and targetCharacter.Parent do
            if not targetRootPart then break end

            -- Calculate direction to target
            local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
            local moveDirection = direction * humanoid.WalkSpeed

            -- Move towards target using a gradual approach (walking)
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * 0.1

            -- Mimic jump
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            if targetHumanoid and targetHumanoid.Jump then
                humanoid.Jump = true
            end

            wait(0.1) -- Adjust the delay if necessary
        end
    end

    Button.MouseButton1Click:Connect(function()
        local targetName = TextBox.Text
        local targetPlayer = game.Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer ~= player then
            followPlayer(targetPlayer)
        else
            warn("Player not found or invalid")
        end
    end)

    -- Ensure the script gets destroyed upon player reset/death
    character:WaitForChild("Humanoid").Died:Connect(function()
        ScreenGui:Destroy() -- Destroy GUI and related elements when the player dies
    end)
end

-- Run the function to create the follow script
createFollowScript()

-- Recreate the follow script if the character resets or dies
player.CharacterAdded:Connect(function()
    -- Wait a bit for the character to fully load before creating the script
    wait(1)
    createFollowScript()
end)
