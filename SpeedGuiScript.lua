-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local TextInput = Instance.new("TextBox")
local TitleLabel = Instance.new("TextLabel")

-- Parent GUI to PlayerGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "SpeedGui"

-- Frame Settings
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.8, 0, 0.1, 0)
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

-- Minimized Frame Settings
MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizedFrame.Position = Frame.Position
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

-- Toggle Button for Minimized Frame
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = "S"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleButton.Parent = MinimizedFrame

-- Toggle Visibility
local function toggleVisibility()
    if Frame.Visible then
        Frame.Visible = false
        MinimizedFrame.Visible = true
    else
        Frame.Visible = true
        MinimizedFrame.Visible = false
    end
end

ToggleButton.MouseButton1Click:Connect(toggleVisibility)

-- Dragging Feature for Minimized Box
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MinimizedFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MinimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MinimizedFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MinimizedFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Speed Update Function
TextInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(TextInput.Text)
        if speed and speed > 0 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
end)
