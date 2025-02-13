local player, following = game.Players.LocalPlayer, false
local savedText = ""  -- Variable to store last entered text

local function createFollowScript()
    local character, ScreenGui, Frame, TextBox, Button, StopButton = player.Character or player.CharacterAdded:Wait(), Instance.new("ScreenGui"), Instance.new("Frame"), Instance.new("TextBox"), Instance.new("TextButton"), Instance.new("TextButton")
    ScreenGui.Parent, Frame.Parent, TextBox.Parent, Button.Parent, StopButton.Parent = game.CoreGui, ScreenGui, Frame, Frame, Frame

    -- GUI properties
    Frame.Size, Frame.Position, Frame.BackgroundColor3 = UDim2.new(0, 200, 0, 200), UDim2.new(0, 0, 1, -200), Color3.fromRGB(50, 50, 50)  -- Positioned at bottom left
    TextBox.Size, TextBox.Position, TextBox.PlaceholderText = UDim2.new(1, 0, 0.25, 0), UDim2.new(0, 0, 0, 0), "Enter Player Name"
    Button.Size, Button.Position, Button.BackgroundColor3, Button.Text = UDim2.new(1, 0, 0.25, 0), UDim2.new(0, 0, 0.25, 0), Color3.fromRGB(100, 100, 100), "Follow"
    StopButton.Size, StopButton.Position, StopButton.BackgroundColor3, StopButton.Text = UDim2.new(1, 0, 0.25, 0), UDim2.new(0, 0, 0.5, 0), Color3.fromRGB(200, 100, 100), "Stop Following"

    -- Set last saved text in TextBox if any
    TextBox.Text = savedText

    -- Follow logic
    local function followPlayer(targetPlayer)
        local targetCharacter, humanoidRootPart, targetRootPart = targetPlayer.Character, character:WaitForChild("HumanoidRootPart"), targetPlayer.Character:WaitForChild("HumanoidRootPart")
        if not targetCharacter then return end
        local humanoid, previousPosition = character:WaitForChild("Humanoid"), targetRootPart.Position

        while targetCharacter and targetCharacter.Parent and humanoidRootPart and targetRootPart and following do
            local direction = (targetRootPart.Position - humanoidRootPart.Position).unit
            local distance = (targetRootPart.Position - humanoidRootPart.Position).magnitude

            -- Keep player a few studs behind the target
            if distance > 6 then
                humanoid:MoveTo(targetRootPart.Position)
            elseif distance > 4 then
                humanoid:MoveTo(targetRootPart.Position)
            else
                -- Align player right behind the target
                local gap = 4
                local behindPosition = targetRootPart.Position - direction * gap  -- Move behind the target
                humanoid:MoveTo(behindPosition)
            end

            wait(0.1)
        end
    end

    -- Button functions
    Button.MouseButton1Click:Connect(function()
        savedText = TextBox.Text  -- Save the current text in the TextBox
        local targetPlayer = game.Players:FindFirstChild(savedText)
        if targetPlayer and targetPlayer ~= player then following = true followPlayer(targetPlayer) else warn("Player not found or invalid") end
    end)

    StopButton.MouseButton1Click:Connect(function() following = false end)

    -- Cleanup on death
    character:WaitForChild("Humanoid").Died:Connect(function()
        ScreenGui:Destroy()  -- Destroy GUI when player dies
    end)
end

createFollowScript()

-- Recreate the script and load saved text upon respawn
player.CharacterAdded:Connect(function()
    wait(1)  -- Wait for character to fully load
    createFollowScript() 
    local character = player.Character or player.CharacterAdded:Wait()
    local textBox = game.CoreGui:WaitForChild(player.Name):WaitForChild("ScreenGui"):WaitForChild("Frame"):WaitForChild("TextBox")
    textBox.Text = savedText  -- Reload the last saved text
end)
