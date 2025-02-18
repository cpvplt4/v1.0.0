-- BLOX FRUITS AUTO SCRIPT (DELTA SUPPORTED GUI)
-- Fully compatible with Delta Executor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Load Delta UI Library (More Reliable Loading Method)
local DeltaUILib
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaHubOfficial/Delta/main/UILibrary.lua"))()
end)
if success then
    DeltaUILib = result
else
    warn("Failed to load Delta UI Library")
    return
end

local Window = DeltaUILib:CreateWindow("Blox Fruits Script")

-- CONFIGURATION SETTINGS (Persistent)
local settingsFile = "BloxFruitsSettings.json"
local settings = {
    autoFarm = false,
    autoFruitSniper = false,
    autoBossFinder = false,
    autoKillAura = false,
    autoChestCollector = false,
    autoPVP = false,
    autoAttackEquipped = false,
}

-- Function to Save Settings
local function saveSettings()
    writefile(settingsFile, HttpService:JSONEncode(settings))
end

-- Function to Load Settings
local function loadSettings()
    if isfile(settingsFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(settingsFile))
        end)
        if success and type(data) == "table" then
            settings = data
        end
    end
end

-- Load Settings on Script Execution
loadSettings()

-- GUI TOGGLE BUTTONS
Window:CreateToggle("Auto Farm", settings.autoFarm, function(value)
    settings.autoFarm = value
    saveSettings()
end)
Window:CreateToggle("Auto Fruit Sniper", settings.autoFruitSniper, function(value)
    settings.autoFruitSniper = value
    saveSettings()
end)
Window:CreateToggle("Auto Boss Finder", settings.autoBossFinder, function(value)
    settings.autoBossFinder = value
    saveSettings()
end)
Window:CreateToggle("Kill Aura", settings.autoKillAura, function(value)
    settings.autoKillAura = value
    saveSettings()
end)
Window:CreateToggle("Auto Chest Collector", settings.autoChestCollector, function(value)
    settings.autoChestCollector = value
    saveSettings()
end)
Window:CreateToggle("Auto PVP", settings.autoPVP, function(value)
    settings.autoPVP = value
    saveSettings()
end)
Window:CreateToggle("Auto Attack Equipped Item", settings.autoAttackEquipped, function(value)
    settings.autoAttackEquipped = value
    saveSettings()
end)

-- FUNCTION TO ATTACK NPC
local function attackNPC(npc)
    if npc and npc:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        task.wait(0.2)
        ReplicatedStorage.Remotes.Combat:FireServer("Melee") -- Alternative attack method
    end
end

-- FUNCTION TO GET NPC BASED ON LEVEL
local function getNPCForLevel(level)
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local npcLevel = npc:GetAttribute("Level")
            if npcLevel and math.abs(npcLevel - level) <= 100 then
                return npc
            end
        end
    end
    return nil
end

-- AUTO FARM BASED ON LEVEL
local function autoFarm()
    while settings.autoFarm do
        task.wait()
        local myLevel = LocalPlayer.Data.Level.Value
        local targetNPC = getNPCForLevel(myLevel)
        if targetNPC then
            attackNPC(targetNPC)
        end
    end
end

-- AUTO FRUIT SNIPER
local function autoFruitSniper()
    while settings.autoFruitSniper do
        task.wait()
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Fruit") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Fruit.CFrame
                task.wait(0.2)
                ReplicatedStorage.Remotes.Interact:InvokeServer(v.Fruit) -- Alternative pickup method
            end
        end
    end
end

-- AUTO BOSS FINDER & KILLER
local function autoBossFinder()
    while settings.autoBossFinder do
        task.wait()
        for _, boss in pairs(workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("Humanoid") and boss:GetAttribute("Boss") then
                attackNPC(boss)
            end
        end
    end
end

-- KILL AURA (AUTO ATTACK NEARBY ENEMIES)
local function killAura()
    while settings.autoKillAura do
        task.wait()
        for _, enemy in pairs(workspace:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                attackNPC(enemy)
            end
        end
    end
end

-- AUTO CHEST COLLECTOR
local function autoChestCollector()
    while settings.autoChestCollector do
        task.wait()
        for _, chest in pairs(workspace:GetChildren()) do
            if chest:IsA("Model") and chest:FindFirstChild("Chest") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = chest.Chest.CFrame
                task.wait(0.2)
                ReplicatedStorage.Remotes.Interact:InvokeServer(chest.Chest) -- Alternative method
            end
        end
    end
end

-- AUTO PVP ENABLE ON DEATH
LocalPlayer.CharacterAdded:Connect(function()
    if settings.autoPVP then
        task.wait(1)
        ReplicatedStorage.Remotes.TogglePVP:FireServer(true)
    end
end)

-- AUTO ATTACK WHEN ITEM EQUIPPED
LocalPlayer.Character.ChildAdded:Connect(function(child)
    if settings.autoAttackEquipped and (child:IsA("Tool") or child:IsA("HopperBin")) then
        while settings.autoAttackEquipped and child.Parent == LocalPlayer.Character do
            task.wait(0.2)
            ReplicatedStorage.Remotes.Combat:FireServer("Melee")
        end
    end
end)

-- STARTING THE SCRIPTS
spawn(autoFarm)
spawn(autoFruitSniper)
spawn(autoBossFinder)
spawn(killAura)
spawn(autoChestCollector)
