-- https://github.com/OopssSorry/LuaU-Free-Key-System-UI/

local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/OopssSorry/LuaU-Free-Key-System-UI/main/source.lua"))()
local KeyValid = false
local response = KeySystem:Init({
	Debug=false, -- <bool> Prints some output in console when true
	Title="CPVP HUB | Key System", -- <string or nil> Title of key system
	Description=nil, -- <string or nil> Description of key system
	Link="https://loot-link.com/s?FmpHRMH9", -- <string> String to get key
	Discord="https://loot-link.com/s?FmpHRMH9", -- <string or nil> Button to join your discord server
	SaveKey=true, -- <bool or nil> Just auto save key
	Verify=function(key) -- <function> Verify is key valid
		if key=="CPVPHUB1234" then
      KeyValid=true
			return true
		else
			return false
		end
	end,
	GuiParent = game.CoreGui, -- <object or nil> :3
})

if not response or not KeyValid then return end
loadstring(game.HttpGet(game,'https://raw.githubusercontent.com/Yumiara/Python/refs/heads/main/BloxFruit-XYZ.lua'))()
