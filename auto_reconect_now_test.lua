local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local PromptGui = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui")

local function AutoReconnect()
    local promptOverlay = PromptGui:WaitForChild("promptOverlay")
    
    promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local retryDelay = 2
            local maxAttempts = 10
            
            for attempt = 1, maxAttempts do
                task.wait(retryDelay)
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                end)
            end
        end
    end)
end

if not game:IsLoaded() then game.Loaded:Wait() end
Players.LocalPlayer.OnTeleport:Connect(AutoReconnect)
AutoReconnect()
