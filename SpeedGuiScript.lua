-- Create GUI (same code, but we'll ensure the script persists)
local function createSpeedGui()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local MinimizedFrame = Instance.new("Frame")
    local TextInput = Instance.new("TextBox")
    local TitleLabel = Instance.new("TextLabel")
    local DashButton = Instance.new("TextButton")
    local PlusButton = Instance.new("TextButton")

    -- Parent GUI to PlayerGui
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "SpeedGui"

    -- Frame Settings
    Frame.Size = UDim2.new(0, 120, 0, 100)
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    -- Title Label
    TitleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Speed:"
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Parent = Frame

    -- Text Input
    TextInput.Size = UDim2.new(0.8, 0, 0.3, 0)
    TextInput.Position = UDim2.new(0.1, 0, 0.5, 0)
    TextInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    TextInput.TextColor3 = Color3.new(1, 1, 1)
    TextInput.PlaceholderText = "Enter Speed"
    TextInput.Parent = Frame

    -- Dash Button for Minimize
    DashButton.Size = UDim2.new(0, 30, 0, 30)
    DashButton.Position = UDim2.new(1, -30, 0, 0)
    DashButton.Text = "—"
    DashButton.TextColor3 = Color3.new(1, 1, 1)
    DashButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    DashButton.Parent = Frame

    -- Plus Button for Minimized Frame Reopen
    PlusButton.Size = UDim2.new(0, 50, 0, 50)
    PlusButton.Position = UDim2.new(0, 0, 0, 0)
    PlusButton.Text = "+"
    PlusButton.TextColor3 = Color3.new(1, 1, 1)
    PlusButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    PlusButton.Parent = MinimizedFrame

    -- Minimized Frame Settings
    MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
    MinimizedFrame.Position = Frame.Position
    MinimizedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui

    -- Toggle Button for Minimized Frame
    local isMinimized = false
    local function toggleMinimize()
        if isMinimized then
            Frame.Visible = true
            MinimizedFrame.Visible = false
            isMinimized = false
        else
            Frame.Visible = false
            MinimizedFrame.Visible = true
            isMinimized = true
        end
    end

    DashButton.MouseButton1Click:Connect(toggleMinimize)

    -- Plus Button to Reopen Minimized Frame
    PlusButton.MouseButton1Click:Connect(function()
        toggleMinimize()
        setSpeed()
    end)

    -- Minimized Frame to Reopen
    MinimizedFrame.MouseButton1Click:Connect(function()
        toggleMinimize()
        setSpeed()
    end)

    -- Dragging Feature for Minimized and Normal GUI
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        if Frame.Visible then
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif MinimizedFrame.Visible then
            MinimizedFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = (Frame.Visible and Frame.Position) or MinimizedFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            update(input)
        end
    end

    Frame.InputBegan:Connect(onInputBegan)
    MinimizedFrame.InputBegan:Connect(onInputBegan)
    game:GetService("UserInputService").InputChanged:Connect(onInputChanged)

    -- Speed Update Function
    local function setSpeed()
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:WaitForChild("Humanoid")
        local speedValue = tonumber(TextInput.Text)
        if speedValue and speedValue > 0 then
            humanoid.WalkSpeed = speedValue
        else
            humanoid.WalkSpeed = 16
        end
    end

    -- Update speed when the text input is lost or enter is pressed
    TextInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            setSpeed()
        end
    end)

    -- Create GUI at start and persist
    if not game.Players.LocalPlayer:FindFirstChild("SpeedGui") then
        createSpeedGui()
    end

    -- Persist GUI after reset or respawn
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        if not ScreenGui.Parent then
            ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end)
end

createSpeedGui()

