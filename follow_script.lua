local player = game.Players.LocalPlayer

-- Create GUI components
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Create a frame for the GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

-- Create a TextBox for target player input
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 200, 0, 50)
inputBox.Position = UDim2.new(0.5, -100, 0.2, 0)
inputBox.PlaceholderText = "Enter player name"
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Parent = frame

-- Create a Follow button
local followButton = Instance.new("TextButton")
followButton.Size = UDim2.new(0, 100, 0, 50)
followButton.Position = UDim2.new(0.5, -50, 0.5, 0)
followButton.Text = "Follow"
followButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
followButton.TextColor3 = Color3.fromRGB(255, 255, 255)
followButton.Parent = frame

-- Create a Stop button
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 100, 0, 50)
stopButton.Position = UDim2.new(0.5, -50, 0.8, 0)
stopButton.Text = "Stop"
stopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Parent = frame

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

    -- Handle button click events
    followButton.MouseButton1Click:Connect(function()
        local targetName = inputBox.Text
        if targetName and targetName ~= "" then
            startFollowing(targetName)
        else
            print("Please enter a valid player name.")
        end
    end)

    stopButton.MouseButton1Click:Connect(function()
        stopFollowing()
    end)

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

