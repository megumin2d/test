-- Автоматический реконнект с защитой от ошибки 277
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Настройки
local MAX_RETRIES = 15                     -- Максимальное количество попыток
local BASE_DELAY = 3                       -- Базовая задержка (сек)
local BACKUP_SERVER_DELAY = 30             -- Ожидание перед сменой сервера

local retryCount = 0
local lastErrorTime = 0

local function SafeRejoin()
    pcall(function()
        -- Попытка телепортации на резервный сервер
        TeleportService:TeleportToPlaceInstanceAsync(
            game.PlaceId,
            game.JobId,
            Players.LocalPlayer
        )
        
        -- Альтернативный метод для ошибки 277
        if not TeleportService:GetTeleportSetting("UseNewTeleportScreen") then
            TeleportService:SetTeleportSetting("UseNewTeleportScreen", true)
        end
    end)
end

local function Handle277Error()
    local currentTime = os.time()
    
    -- Проверка таймаута между ошибками
    if currentTime - lastErrorTime < 10 then
        retryCount += 1
    else
        retryCount = 1
    end
    
    lastErrorTime = currentTime
    
    -- Экспоненциальная задержка
    local delay = math.min(BASE_DELAY * (2 ^ retryCount), BACKUP_SERVER_DELAY)
    task.wait(delay)
end

local function ConnectionMonitor()
    -- Мониторинг состояния сети
    local lastPing = os.time()
    
    game:GetService("NetworkClient").ChildRemoved:Connect(function()
        if os.time() - lastPing > 8 then
            SafeRejoin()
        end
        lastPing = os.time()
    end)
end

local function ErrorHandler()
    -- Обработчик системных ошибок
    local promptGui = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui")
    local promptOverlay = promptGui:WaitForChild("promptOverlay")
    
    promptOverlay.ChildAdded:Connect(function(child)
        if child:IsA("Frame") and child.Name == "ErrorPrompt" then
            local errorCode = child:FindFirstChild("MessageArea"):FindFirstChild("ErrorCode")
            if errorCode and errorCode.Text:match("277") then
                Handle277Error()
                SafeRejoin()
            end
        end
    end)
end

-- Инициализация
if not game:IsLoaded() then game.Loaded:Wait() end

-- Двойная система мониторинга
ConnectionMonitor()
ErrorHandler()

-- Резервный пинг через HTTP
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            HttpService:GetAsync("https://google.com") -- Проверка интернет-соединения
        end)
    end
end)

-- Обработчик телепортации
Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        Handle277Error()
        SafeRejoin()
    end
end)
