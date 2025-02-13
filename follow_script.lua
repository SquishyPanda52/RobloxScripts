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
    local followCoroutine = nil  -- Store the coroutine to restart it if needed

    -- Function to make the executor follow the target player with pathfinding
    local function followPlayer(targetPlayer)
        print("Attempting to follow player...")

        local targetCharacter = targetPlayer.Character
        if not targetCharacter then
            print("Target player character not found!")
            return
        end

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        local humanoid = character:WaitForChild("Humanoid")
        local targetHumanoid = targetCharacter:WaitForChild("Humanoid")

        local pathfindingService = game:GetService("PathfindingService")
        local path = pathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
            AgentJumpHeight = humanoid.JumpHeight,
            AgentMaxSlope = 45
        })

        -- Continuous follow loop
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart and isFollowing do
            print("Following target...")

            -- Calculate a path to the target
            path:ComputeAsync(humanoidRootPart.Position, targetRootPart.Position)

            -- Wait until path is computed and check if it was successful
            path:MoveTo(humanoidRootPart)

            if path.Status == Enum.PathStatus.Complete then
                print("Path complete. Moving humanoid.")
                humanoid:MoveTo(path.Status)
            else
                print("Path incomplete. Retrying...")
                path:ComputeAsync(humanoidRootPart.Position, targetRootPart.Position)
            end

            -- Wait for a short time before checking again
            wait(0.1)
        end
    end

    -- Button functionality to start following the player
    Button.MouseButton1Click:Connect(function()
        print("Follow button clicked!")

        local targetName = TextBox.Text
        local targetPlayer = game.Players:FindFirstChild(targetName)

        if targetPlayer and targetPlayer ~= player then
            print("Following player: " .. targetName)
            isFollowing = true

            -- Stop any previous follow coroutine before starting a new one
            if followCoroutine then
                print("Stopping previous follow coroutine...")
                coroutine.close(followCoroutine)
            end

            followCoroutine = coroutine.create(function()
                followPlayer(targetPlayer)
            end)

            -- Start the follow coroutine
            coroutine.resume(followCoroutine)
        else
            print("Player not found or invalid!")
        end
    end)

    -- Stop Button functionality to stop following the player
    StopButton.MouseButton1Click:Connect(function()
        print("Stop following button clicked!")
        isFollowing = false
    end)

    -- Ensure the script gets destroyed upon player reset/death
    local function onDeath()
        print("Player died! Destroying GUI...")
        ScreenGui:Destroy() -- Destroy GUI and related elements when the player dies
    end

    character:WaitForChild("Humanoid").Died:Connect(onDeath)

    -- Handle character respawn and rebind the follow script
    player.CharacterAdded:Connect(function()
        print("Player respawned! Re-creating follow script...")
        -- Wait a bit for the character to fully load before creating the script
        wait(1)

        -- Restart the follow script if the player was previously following
        if isFollowing and followCoroutine then
            coroutine.resume(followCoroutine)
        end
    end)
end

-- Run the function to create the follow script
createFollowScript()

-- Recreate the follow script if the character resets or dies
player.CharacterAdded:Connect(function()
    print("Player character added, re-initializing script...")
    -- Wait a bit for the character to fully load before creating the script
    wait(1)
    createFollowScript()
end)
