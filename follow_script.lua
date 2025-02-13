local player = game.Players.LocalPlayer

local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()

    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local Button = Instance.new("TextButton")
    local StopButton = Instance.new("TextButton")  -- Stop button

    ScreenGui.Parent = game.CoreGui
    Frame.Parent = ScreenGui
    TextBox.Parent = Frame
    Button.Parent = Frame
    StopButton.Parent = Frame

    -- GUI Properties
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    TextBox.Size = UDim2.new(1, 0, 0.3, 0)
    TextBox.Position = UDim2.new(0, 0, 0, 0)
    TextBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.PlaceholderText = "Enter Player Name"

    Button.Size = UDim2.new(1, 0, 0.3, 0)
    Button.Position = UDim2.new(0, 0, 0.3, 0)
    Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Button.Text = "Follow"

    StopButton.Size = UDim2.new(1, 0, 0.3, 0)
    StopButton.Position = UDim2.new(0, 0, 0.6, 0)
    StopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StopButton.Text = "Stop Following"

    local isFollowing = false  -- Flag to track if following is active

    -- Function to make the executor follow the target player
    local function followPlayer(targetPlayer)
        local targetCharacter = targetPlayer.Character
        if not targetCharacter then return end

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        local humanoid = character:WaitForChild("Humanoid")
        local targetHumanoid = targetCharacter:WaitForChild("Humanoid")
        
        -- Continuous follow loop
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart and isFollowing do
            local targetPosition = targetRootPart.Position
            local distance = (targetPosition - humanoidRootPart.Position).magnitude
            
            -- Mimic movement
            humanoid.WalkSpeed = targetHumanoid.WalkSpeed
            humanoid.JumpHeight = targetHumanoid.JumpHeight
            humanoid.PlatformStand = targetHumanoid.PlatformStand

            -- Handle Jumping
            if targetHumanoid:GetState() == Enum.HumanoidStateType.Seated then
                humanoid:ChangeState(Enum.HumanoidStateType.Seated)
            elseif targetHumanoid:GetState() == Enum.HumanoidStateType.Physics and targetHumanoid.MoveDirection.magnitude > 0 then
                if targetHumanoid.Jump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    humanoid.Jump = true
                else
                    humanoid.Jump = false
                end
            end

            -- If the target is within 5 studs, stop moving
            if distance < 5 then
                humanoid:MoveTo(humanoidRootPart.Position)  -- Stop moving if near the target
            else
                -- Move the executor's humanoid towards the target position
                humanoid:MoveTo(targetPosition)
            end

            -- Wait for a small time before updating the position again
            wait(0.1)
        end
    end

    -- Button functionality to start following the player
    Button.MouseButton1Click:Connect(function()
        local targetName = TextBox.Text
        local targetPlayer = game.Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer ~= player then
            isFollowing = true
            followPlayer(targetPlayer)
        else
            warn("Player not found or invalid")
        end
    end)

    -- Stop Button functionality to stop following the player
    StopButton.MouseButton1Click:Connect(function()
        isFollowing = false
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

