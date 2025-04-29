-- Автоматический реконнект с защитой от ошибки 264
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local MAX_RETRY_DELAY = 60  -- Максимальная задержка между попытками
local INITIAL_DELAY = 2     -- Начальная задержка
local currentDelay = INITIAL_DELAY

local function SafeTeleport()
    pcall(function()
        -- Используем резервный сервер для телепортации
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Players.LocalPlayer,
            TeleportService:GetTeleportSetting()
        )
    end)
end

local function HandleError()
    -- Экспоненциальная задержка с ограничением
    currentDelay = math.min(currentDelay * 2, MAX_RETRY_DELAY)
    task.wait(currentDelay)
end

local function AutoReconnect()
    local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
    
    promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            currentDelay = INITIAL_DELAY  -- Сброс задержки
            
            local connection
            connection = RunService.Heartbeat:Connect(function()
                connection:Disconnect()
                
                local success, err = pcall(SafeTeleport)
                if not success then
                    warn("Ошибка телепортации:", err)
                    HandleError()
                end
            end)
        end
    end)
end

-- Инициализация
if not game:IsLoaded() then game.Loaded:Wait() end
Players.LocalPlayer.OnTeleport:Connect(AutoReconnect)
AutoReconnect()

-- Резервная система через HTTP запросы
local HttpService = game:GetService("HttpService")
local lastPing = os.time()

game:GetService("NetworkClient").ChildRemoved:Connect(function()
    if os.time() - lastPing > 10 then
        SafeTeleport()
    end
    lastPing = os.time()
end)
