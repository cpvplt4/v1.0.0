-- BLOX FRUITS AUTO SCRIPT (DELTA SUPPORTED GUI)
-- Fully compatible with Delta Executor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Load Delta UI Library
local success, DeltaUILib = pcall(loadstring, game:HttpGet("https://raw.githubusercontent.com/DeltaHubOfficial/Delta/main/UILibrary.lua"))
if not success then
    warn("Failed to load Delta UI Library")
    return
end

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
    if npc and npc:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        wait(0.2)
        VirtualInputManager:SendKeyEvent(true, "E", false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "E", false, game)
    end
end

-- FUNCTION TO GET NPC BASED ON LEVEL
local function getNPCForLevel(level)
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local npcLevel = tonumber(npc:GetAttribute("Level"))
            if npcLevel and math.abs(npcLevel - level) <= 100 then
                return npc
            end
        end
    end
    return nil
end

-- AUTO FARM BASED ON LEVEL
local function autoFarm()
    while settings.autoFarm and RunService.RenderStepped:Wait() do
        local myLevel = LocalPlayer.Data.Level.Value
        local targetNPC = getNPCForLevel(myLevel)
        if targetNPC then
            attackNPC(targetNPC)
        end
    end
end

-- AUTO FRUIT SNIPER
local function autoFruitSniper()
    while settings.autoFruitSniper and RunService.RenderStepped:Wait() do
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Fruit.CFrame
                fireclickdetector(v.Fruit.ClickDetector)
            end
        end
    end
end

-- AUTO BOSS FINDER & KILLER
local function autoBossFinder()
    while settings.autoBossFinder and RunService.RenderStepped:Wait() do
        for _, boss in pairs(workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("Humanoid") and boss:FindFirstChild("Boss") then
                attackNPC(boss)
            end
        end
    end
end

-- KILL AURA (AUTO ATTACK NEARBY ENEMIES)
local function killAura()
    while settings.autoKillAura and RunService.RenderStepped:Wait() do
        for _, enemy in pairs(workspace:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                attackNPC(enemy)
            end
        end
    end
end

-- AUTO CHEST COLLECTOR
local function autoChestCollector()
    while settings.autoChestCollector and RunService.RenderStepped:Wait() do
        for _, chest in pairs(workspace:GetChildren()) do
            if chest:IsA("Model") and chest:FindFirstChild("Chest") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = chest.Chest.CFrame
                fireclickdetector(chest.Chest.ClickDetector)
            end
        end
    end
end

-- STARTING THE SCRIPTS
spawn(autoFarm)
spawn(autoFruitSniper)
spawn(autoBossFinder)
spawn(killAura)
spawn(autoChestCollector)
