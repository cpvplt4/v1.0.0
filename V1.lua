-- BLOX FRUITS AUTO SCRIPT (GUI Version)
-- Works with Synapse X, KRNL, Script-Ware, Delta

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaHubOfficial/Delta/main/UILibrary.lua"))()

-- GUI SETUP
local Window = Library:CreateWindow("Blox Fruits Script")
local MainTab = Window:CreateTab("Main")

-- CONFIGURATION SETTINGS
local settings = {
    autoFarm = false,
    autoFruitSniper = false,
    autoBossFinder = false,
    autoKillAura = false,
    autoChestCollector = false,
    teleportNPC = "Blox Fruit Dealer",
}

-- GUI TOGGLE BUTTONS
MainTab:CreateToggle("Auto Farm", function(value) settings.autoFarm = value end)
MainTab:CreateToggle("Auto Fruit Sniper", function(value) settings.autoFruitSniper = value end)
MainTab:CreateToggle("Auto Boss Finder", function(value) settings.autoBossFinder = value end)
MainTab:CreateToggle("Kill Aura", function(value) settings.autoKillAura = value end)
MainTab:CreateToggle("Auto Chest Collector", function(value) settings.autoChestCollector = value end)

-- AUTO FARM BASED ON LEVEL
function autoFarm()
    while settings.autoFarm do
        local myLevel = LocalPlayer.Data.Level.Value
        local targetNPC = getNPCForLevel(myLevel)
        if targetNPC then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetNPC.HumanoidRootPart.CFrame
            attackNPC(targetNPC)
        end
        wait(1)
    end
end

-- AUTO FRUIT SNIPER
function autoFruitSniper()
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
function autoBossFinder()
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
function killAura()
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
function autoChestCollector()
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

-- TELEPORT TO SPECIFIC NPC
function teleportToNPC(npcName)
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:IsA("Model") and npc.Name == npcName then
            LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
        end
    end
end

-- STARTING THE SCRIPTS
spawn(function() while wait() do if settings.autoFarm then autoFarm() end end end)
spawn(function() while wait() do if settings.autoFruitSniper then autoFruitSniper() end end end)
spawn(function() while wait() do if settings.autoBossFinder then autoBossFinder() end end end)
spawn(function() while wait() do if settings.autoKillAura then killAura() end end end)
spawn(function() while wait() do if settings.autoChestCollector then autoChestCollector() end end end)
