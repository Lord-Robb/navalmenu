
-- print("hello")
surface.CreateFont("Verdana", {
	font = "Verdana",
	size = 50,
	antialias = true,
	extended = true,
})
surface.CreateFont("VerdanaButton", {
	font = "Verdana",
	size = 20,
	antialias = true,
	extended = true,
})

VehicleList = {
	{name = "Boat", mdl = "models/props_canal/boat002b.mdl", ent = "item_ammo_smg1_large"}, -- name, model path, entity spawn code
	{name = "Chair", mdl = "models/props_c17/chair02a.mdl", ent = "Chair_Wood"},
}
local selection = 1
local NavalTeams = {
	TEAM_UNASSIGNED
}

robb_vehiclerequests = {}

local PANEL = {}


function PANEL:Init()
	local sw = ScrW()
	local sh = ScrH()
	
	self:SetPos(sw/2-400, sh/2-250) -- subject to change
	self:SetSize(800,500) -- subject to change
	self:SetTitle("")

	--[[
		USER MODE
	--]]

	local shipimg = self:Add("DModelPanel")
	shipimg:SetSize(400,300)
	shipimg:SetPos(200, 125)
	shipimg:SetModel(VehicleList[selection].mdl)
	local mn, mx = shipimg.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

	shipimg:SetFOV( 65 )
	shipimg:SetCamPos( Vector( size, size, size ) )

	local leftsel = self:Add("DButton")
	leftsel:SetSize(100,300)
	leftsel:SetPos(0,125)
	leftsel:SetText("")
	leftsel.DoClick = function()
		if selection == 1 then return 
		else
		selection = selection-1
		shipimg:SetModel(VehicleList[selection].mdl)
		end
	end
	leftsel.Paint = function() draw.SimpleText("<", "Verdana", 50, 150, Color(255,255,255), TEXT_ALIGN_CENTER) end

	local rightsel = self:Add("DButton")
	rightsel:SetSize(100,300)
	rightsel:SetPos(700,125)
	rightsel:SetText("")
	rightsel.DoClick = function()
		if selection == table.Count(VehicleList) then return 
		else
		selection = selection+1
		shipimg:SetModel(VehicleList[selection].mdl)
		end
	end
	rightsel.Paint = function() draw.SimpleText(">", "Verdana", 50, 150, Color(255,255,255), TEXT_ALIGN_CENTER) end

	local shipsel = self:Add("DButton")
	shipsel:SetSize(800,50)
	shipsel:SetPos(0,450)
	shipsel:SetText("")
	shipsel.DoClick = function()
		net.Start("Robb_RequestVehicle")
			-- net.WriteEntity(LocalPlayer())
			-- net.WriteString(VehicleList[selection].name)
			-- net.WriteString(VehicleList[selection].ent)
		net.SendToServer()
		
		table.insert(requests, {ply = LocalPlayer():Nick(), name = VehicleList[selection].name, ent = VehicleList[selection].ent, loc = "Hangar 1"})

		chat.AddText(Color(255,255,255), "Your request for ", Color(255,50,50), VehicleList[selection].name, Color(255,255,255), " has been sent to Naval for approval.")
	end
	shipsel.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(50,255,50)) draw.SimpleText("Request "..VehicleList[selection].name, "Verdana", w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER) end
	
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(36,59,74,255)) -- backdrop
	draw.RoundedBox(0, 0, h/8, w, 3, Color(44,62,75,200)) -- top bar
	draw.SimpleText("Anaxes Vehicle Bay", "Verdana", w/2, h*.01, Color(255,255,255), TEXT_ALIGN_CENTER)

	--model
	draw.SimpleText("Main Hangar: Bay 1", "VerdanaButton", w/2, h*.15, Color(255,255,255), TEXT_ALIGN_CENTER)
	draw.SimpleText(VehicleList[selection].name, "VerdanaButton", w/2, h*.2, Color(255,255,255), TEXT_ALIGN_CENTER)
end

-- function PANEL:SBButton(lbl, purp)
-- 	self.sbbutton = self:Add("DButton")
-- 	self.sbbutton:Dock(TOP)
-- 	self.sbbutton:DockMargin(5, 40, 500, 0) -- left top right bottom
-- 	self.sbbutton:SetSize(120,40)
-- 	self.sbbutton:SetFont("VerdanaButton")
-- 	self.sbbutton:SetText(lbl)
-- 	if purp == 1 then
-- 		self.sbutton.DoClick() = function() self:ShowNavalMenu() end
-- 	elseif purp == 2 then
-- 		self.sbutton.DoClick() = function() self:ShowStaffMenu() end
-- 	end
	
-- end
derma.DefineControl("Robb_User Menu", "Naval Menu", PANEL, "DFrame")

local PANEL = {}


function PANEL:Init()
	local sw = ScrW()
	local sh = ScrH()
	
	self:SetPos(sw/2-400, sh/2-250) -- subject to change
	self:SetSize(800,500) -- subject to change
	self:SetTitle("")

	local nb = self:Add("DButton")
	nb:SetPos(0, 75)
	nb:SetSize(150, 60)
	nb:SetText("")
	nb.DoClick = function()
		self:ShowNavalMenu()
	end
	nb.Paint = function() draw.SimpleText("NAVAL", "VerdanaButton", 75, 15, Color(255,255,255), TEXT_ALIGN_CENTER) end

	local nb = self:Add("DButton")
	nb:SetPos(0, 100)
	nb:SetSize(150, 60)
	nb:SetText("")
	nb.DoClick = function()
		
	end
	nb.Paint = function() draw.SimpleText("STAFF", "VerdanaButton", 75, 15, Color(255,255,255), TEXT_ALIGN_CENTER) end

end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(36,59,74,255)) -- backdrop
	draw.RoundedBox(0, 0, h/8, w, 3, Color(44,62,75,200)) -- top bar
	draw.RoundedBox(0, 0, h/8, 150, h, Color(44,62,75,200)) -- Button side bar
	draw.SimpleText("Base Management", "Verdana", w/2, h*.01, Color(255,255,255), TEXT_ALIGN_CENTER)
end

function PANEL:ShowNavalMenu()
	local navmen = self:Add("DScrollPanel")
	navmen:SetSize(650, 500)
	navmen:SetPos(150, 75)
	navmen.Paint = function() end

	for k,v in pairs(requests) do
		local reqitem = self:Add("DFrame")
		reqitem:SetSize(100,75)
		reqitem:Dock(TOP)
		reqitem:DockMargin(10,0,10,10)
		reqitem:SetDraggable(false)
		-- reqitem:DockMargin(125,75,0,0)
		reqitem:SetTitle("")
		reqitem:ShowCloseButton(false)
		reqitem.Paint = function(self,w,h)
			draw.RoundedBox(5, 0, 0, w, h, Color(50,50,255)) 
			draw.SimpleText("ST MED PLT 2ndLT Headshot", "VerdanaButton", 125, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.SimpleText(v.name, "VerdanaButton", 50, 20, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.SimpleText(v.loc, "VerdanaButton", 50, 40, Color(255,255,255), TEXT_ALIGN_CENTER)
			
		end
			local approve = reqitem:Add("DButton", reqitem)
			approve:SetPos(10,15)
			approve:SetSize(50,25)
			approve:SetText("")
			approve.Paint = function(self,w,h)
				draw.RoundedBox(5, 0, 0, w, h, Color(116,255,111))
				draw.SimpleText("Approve", "VerdanaButton", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER)
			end
			approve.DoClick = function()
				print(v.ent.." Ship Approved "..v.loc)
				reqitem:Remove()
				table.remove(requests, k)
				SpawnVehicle(v.ent, v.loc)
			end
	
		navmen:AddItem(reqitem)

		local reject = reqitem:Add("DButton", reqitem)
		reject:SetPos(600,15)
		reject:SetSize(50,25)
		reject:SetText("")
		reject.Paint = function(self,w,h)
			draw.RoundedBox(5, 0, 0, w, h, Color(116,255,111))
			draw.SimpleText("Reject", "VerdanaButton", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER)
		end
		reject.DoClick = function()
			print("Ship Rejected")
			reqitem:Remove()
			table.remove(requests, k)
		end
	end
end

derma.DefineControl("Robb_Util Menu", "Naval Menu", PANEL, "DFrame")

--[[
	NET MESSAGES
--]]

net.Receive("OpenNavalMenu", function(len, ply) 
	local nm = vgui.Create("Robb User Menu")

end)

concommand.Add("op", function() 
	local nm = vgui.Create("Robb Naval Menu")
	--nm:ShowNavalMenu()

end)

function Robb_SpawnVehicle(ent, loc)
	net.Start("Robb_SpawnVehicle")
		net.WriteString(ent)
		net.WriteString(loc)
	net.SendToServer()
end

function Robb_NotifyTeam(teamgroup, msg)
	if teamgroup == 1 then
		for k,ply in pairs(player.GetHumans()) do
			if table.HasValue(NavalTeams, ply:Team()) then
				chat.AddText(Color(255,50,50), "[!] ", Color(255,255,255), msg)
			end
		end
	end
end

function Robb_NotifyPlayer(name, msg)
	for k,ply in pairs(player.GetHumans()) do
		if ply:Nick() == name then
			chat.AddText(Color(255,50,50), "[!] ", Color(255,255,255), msg)
		end
	end
end