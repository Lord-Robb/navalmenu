util.AddNetworkString("OpenNavalMenu")
util.AddNetworkString("Robb_SpawnVehicle")

local SpawnLocations = {}

--[[
	ADD NEW SPAWN LOCATIONS BELOW
--]]
SpawnLocations["MainHangarBay1"] = Vector(-71.784798, 198.642700, -1.468781)

--[[
	NO TOUCH
--]]
hook.Add("PlayerSay", "NetTestHook", function(ply, txt) 
	if string.lower(txt) == "!navalmenu" then
		net.Start("OpenNavalMenu")
		net.Send(ply)
	end
end)

--[[`
	NET MESSAGES
--]]

net.Receive("Robb_SpawnVehicle", function()
	local ent = net.ReadString()
	local loc = string.Replace(net.ReadString(), " ", "")
	local veh = ents.Create(ent)
	veh:SetPos(SpawnLocations.MainHangarBay1)
	veh:Spawn()
end)
