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

    -- Function to make the executor follow the target player
    local function followPlayer(targetPlayer)
        local targetCharacter = targetPlayer.Character
        if not targetCharacter then return end

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        local humanoid = character:WaitForChild("Humanoid")

        -- Continuous loop to follow the target player
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart do
            -- Calculate the direction to move in
            local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
            local distance = (targetRootPart.Position - humanoidRootPart.Position).magnitude

            -- Make the executor's humanoid walk towards the target
            humanoid:MoveTo(targetRootPart.Position)

            -- Stop the loop if the target is close enough (within 5 studs)
            if distance < 5 then
                humanoid:MoveTo(humanoidRootPart.Position)  -- Stop the movement if near
                break
            end

            wait(0.1) -- Adjust the delay if necessary
        end
    end

    -- Button functionality to start following the player
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

