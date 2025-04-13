 
 
 
 
 
local defaultTime = 1190 -- Enter Time
 
 
 
 
 
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
 
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.5, -100, 0.5, -65)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
 
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.3, 0)
label.Text = " - Rejoin Script - "
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.TextSize = 14
label.Parent = frame
 
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0.3, 0)
inputBox.Position = UDim2.new(0.1, 0, 0.35, 0)
inputBox.PlaceholderText = "Enter seconds"
inputBox.Text = tostring(defaultTime)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.BackgroundTransparency = 0.2
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Parent = frame
 
local inputBoxCorner = Instance.new("UICorner")
inputBoxCorner.CornerRadius = UDim.new(0, 8)
inputBoxCorner.Parent = inputBox
 
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.7, 0, 0.2, 0)
button.Position = UDim2.new(0.15, 0, 0.75, 0)
button.Text = "Start Rejoin"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
button.TextSize = 14
button.Parent = frame
 
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button
 
local timerFrame = Instance.new("Frame")
timerFrame.Size = UDim2.new(0, 200, 0, 50)
timerFrame.Position = UDim2.new(1, -210, 1, -60)
timerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
timerFrame.BackgroundTransparency = 0.4
timerFrame.Parent = screenGui
 
local timerFrameCorner = Instance.new("UICorner")
timerFrameCorner.CornerRadius = UDim.new(0, 12)
timerFrameCorner.Parent = timerFrame
 
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 1, 0)
timerLabel.Text = "0:00:00.00"
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.BackgroundTransparency = 1
timerLabel.TextSize = 18
timerLabel.Parent = timerFrame
 
local running = false
local connection
 
local function formatTime(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = math.floor(totalSeconds % 60)
    local milliseconds = math.floor((totalSeconds - math.floor(totalSeconds)) * 100)
    return string.format("%d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds)
end
 
local function toggleRejoin()
    local seconds = tonumber(inputBox.Text)
    if seconds and seconds >= 0 then
        timerLabel.Text = formatTime(seconds)
    end
 
    if not running and seconds and seconds > 0 then
 
        local startTime = os.clock()
        local targetTime = startTime + seconds
        running = true
        button.Text = "Stop Rejoin"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
 
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local timeLeft = math.max(0, targetTime - os.clock())
            timerLabel.Text = formatTime(timeLeft)
 
            if timeLeft <= 0 then
                running = false
                button.Text = "Start Rejoin"
                button.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
                connection:Disconnect()
                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
            end
        end)
    elseif running then
 
        running = false
        button.Text = "Start Rejoin"
        button.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        if connection then
            connection:Disconnect()
        end
        timerLabel.Text = formatTime(seconds or 0)
    end
end
 
button.MouseButton1Click:Connect(toggleRejoin)
 
toggleRejoin()
