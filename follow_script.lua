local player = game.Players.LocalPlayer

-- Function to create the follow script
local function createFollowScript()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    -- Variables for tracking
    local isFollowing = false
    local targetPlayer = nil
    local followCoroutine = nil

    -- Function to make the executor follow the target player by moving CFrame
    local function followPlayer(targetPlayer)
        print("Attempting to follow player...")

        local targetCharacter = targetPlayer.Character
        if not targetCharacter then
            print("Target player character not found!")
            return
        end

        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")

        -- Continuous follow loop
        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart and isFollowing do
            print("Following target...")

            -- Move the player's character towards the target's position
            humanoidRootPart.CFrame = CFrame.new(targetRootPart.Position + Vector3.new(0, 0, 2)) -- Adjust distance

            -- Wait before checking again
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

    -- Example input via executor (you can adjust this based on how you're passing the input in the executor)
    print("Enter player name to follow: " .. targetName)

    -- Call start following to begin the action
    startFollowing(targetName)

    -- After some time, you can stop following (simulating button press or executor pause)
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

