local player = game.Players.LocalPlayer

-- Function to create the follow script
local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local pathfindingService = game:GetService("PathfindingService")

    -- Variables for tracking
    local isFollowing = false
    local targetPlayer = nil
    local followCoroutine = nil

    -- Function to make the executor follow the target player with pathfinding
    local function followPlayer(targetPlayer)
        print("Attempting to follow player...")

        local targetCharacter = targetPlayer.Character
        if not targetCharacter then
            print("Target player character not found!")
            return
        end

        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        -- Create a path for the character to follow the target
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

    -- Function to start following the target player
    local function startFollowing(targetName)
        targetPlayer = game.Players:FindFirstChild(targetName)

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
    end

    -- Function to stop following the target player
    local function stopFollowing()
        print("Stop following button clicked!")
        isFollowing = false
    end

    -- Input for target player name
    local targetName = "TargetPlayerName"  -- Replace with dynamic input value in your executor
    print("Enter player name: " .. targetName)

    -- Call start following to begin the action
    startFollowing(targetName)

    -- After some time, you can stop following (simulating button press)
    wait(10)  -- Example time to follow before stopping
    stopFollowing()

    -- Handle character respawn and rebind the follow script
    player.CharacterAdded:Connect(function()
        print("Player respawned! Re-creating follow script...")
        wait(1)

        -- Restart the follow script if the player was previously following
        if isFollowing and followCoroutine then
            coroutine.resume(followCoroutine)
        end
    end)
end

-- Run the function to create the follow script
createFollowScript()
