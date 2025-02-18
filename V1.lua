-- BLOX FRUITS AUTO SCRIPT (DELTA SUPPORTED GUI)
-- Fully compatible with Delta Executor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Load Delta UI Library
local DeltaUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaHubOfficial/Delta/main/UILibrary.lua"))()
local Window = DeltaUILib:Window("Blox Fruits Script")

-- CONFIGURATION SETTINGS
local settings = {
    autoFarm = false,
    autoFruitSniper = false,
    autoBossFinder = false,
    autoKillAura = false,
    autoChestCollector = false,
}

-- GUI TOGGLE BUTTONS
Window:Toggle("Auto Farm", false, function(value) settings.autoFarm = value end)
Window:Toggle("Auto Fruit Sniper", false, function(value) settings.autoFruitSniper = value end)
Window:Toggle("Auto Boss Finder", false, function(value) settings.autoBossFinder = value end)
Window:Toggle("Kill Aura", false, function(value) settings.autoKillAura = value end)
Window:Toggle("Auto Chest Collector", false, function(value) settings.autoChestCollector = value end)

-- FUNCTION TO ATTACK NPC
local function attackNPC(npc)
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
        wait(0.2)
        -- Simulate attack
        VirtualInputManager:SendKeyEvent(true, "E", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "E", false, game)
    end
end

-- AUTO FARM BASED ON LEVEL
local function autoFarm()
    while settings.autoFarm do
        local myLevel = LocalPlayer.Data.Level.Value
        local targetNPC = getNPCForLevel(myLevel)  -- Function to get NPC based on level
        if targetNPC then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetNPC.HumanoidRootPart.CFrame
            attackNPC(targetNPC)
        end
        wait(1)
    end
end

-- AUTO FRUIT SNIPER
local function autoFruitSniper()
    while settings.autoFruitSniper do
        for i, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Fruit.CFrame
                fireclickdetector(v.Fruit.ClickDetector)
            end
        end
        wait(2)
    end
end

-- AUTO BOSS FINDER & KILLER
local function autoBossFinder()
    while settings.autoBossFinder do
        for _, boss in pairs(workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("Humanoid") and boss:FindFirstChild("Boss") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
                attackNPC(boss)
            end
        end
        wait(5)
    end
end

-- KILL AURA (AUTO ATTACK NEARBY ENEMIES)
local function killAura()
    while settings.autoKillAura do
        for _, enemy in pairs(workspace:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                attackNPC(enemy)
            end
        end
        wait(0.5)
    end
end

-- AUTO CHEST COLLECTOR
local function autoChestCollector()
    while settings.autoChestCollector do
        for _, chest in pairs(workspace:GetChildren()) do
            if chest:IsA("Model") and chest:FindFirstChild("Chest") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = chest.Chest.CFrame
                fireclickdetector(chest.Chest.ClickDetector)
            end
        end
        wait(2)
    end
end

-- STARTING THE SCRIPTS
spawn(function() while wait() do if settings.autoFarm then autoFarm() end end end)
spawn(function() while wait() do if settings.autoFruitSniper then autoFruitSniper() end end end)
spawn(function() while wait() do if settings.autoBossFinder then autoBossFinder() end end end)
spawn(function() while wait() do if settings.autoKillAura then killAura() end end end)
spawn(function() while wait() do if settings.autoChestCollector then autoChestCollector() end end end)
