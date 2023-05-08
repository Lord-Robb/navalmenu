--[[
    CONFIGURATION
--]]
local sw,sh = ScrW(), ScrH()

local deploymentname = "Anaxes"
local colors = {
    um_bg = Color(50,50,50,255),
    um_reqbutton = Color(80,255,80,255),
    um_text = Color(255,255,255),
}



--[[
    FONTS (need to change the font this one is YUCK!)
--]]

surface.CreateFont("Verdana60", {
	font = "Futura Light BT",
	size = ScreenScale(60),
	antialias = true,
	extended = true,
})
surface.CreateFont("Verdana20", {
	font = "Futura Light BT",
	size = ScreenScale(20),
	antialias = true,
	extended = true,
})
surface.CreateFont("Verdana12", {
	font = "Futura Light BT",
	size = ScreenScale(12),
	antialias = true,
	extended = true,
})
surface.CreateFont("Verdana8", {
	font = "Futura Light BT",
	size = ScreenScale(11),
	antialias = true,
	extended = true,
})
surface.CreateFont("Verdana7", {
	font = "Futura Light BT",
	size = ScreenScale(7),
	antialias = true,
	extended = true,
})

--[[
    PANELS
--]]

-- ======================
-- === USER MODE PANEL ==
-- ====================== 

local selection = 1

local USER = {}

function USER:Init()

    self:SetSize(sw/2, sh/2)
    self:Center()
    self:SetTitle("")
    self:MakePopup()

    local uw,uh = self:GetWide(), self:GetTall()

    local vehicleimage = self:Add("DModelPanel")
    vehicleimage:SetPos(uw*.25, uh*.17)
    vehicleimage:SetSize(uw/2, uh*.70)
    vehicleimage:SetModel(VehicleList[selection].mdl)
    vehicleimage:SetFOV(80)
    -- \/\/  Set the camera \/\/
    local mn, mx = vehicleimage.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
	size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
	size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
    vehicleimage:SetCamPos(Vector(size, size, size))

    -- LEFT SELECTOR BUTTON
    local leftsel = self:Add("DButton")
    leftsel:SetPos(0, uh*.12)
    leftsel:SetSize(uw/4, uh*.75)
    leftsel:SetFont("Verdana60")
    leftsel:SetTextColor(Color(255,255,255))
    leftsel:SetText("<")
    leftsel.DoClick = function() -- add a sound when button is clicked
        if selection <= 1 then return 
        else 
            selection = selection-1
            vehicleimage:SetModel(VehicleList[selection].mdl)
        end -- ends the if statement
    end -- ends the DoClick function

    leftsel.Paint = function(self, w, h)
        --draw.RoundedBox(0, 0,0,w,h,Color(255,120,120)) -- check bounds
        if selection <= 1 then
            self:SetTextColor(Color(120,120,120))
        else
            self:SetTextColor(Color(255,255,255))
        end -- ends the if statement
    end -- ends the paint function

    -- RIGHT SELECTOR BUTTON
    local rightsel = self:Add("DButton")
    rightsel:SetPos(uw*.75, uh*.12)
    rightsel:SetSize(uw/4, uh*.75)
    rightsel:SetFont("Verdana60")
    rightsel:SetTextColor(Color(255,255,255))
    rightsel:SetText(">")
    rightsel.DoClick = function() -- add a sound when button is clicked
        if selection >= table.Count(VehicleList) then return 
        else 
            selection = selection+1
            vehicleimage:SetModel(VehicleList[selection].mdl)
        end -- ends the if statement
    end -- ends the DoClick function

    rightsel.Paint = function(self, w, h)
        --draw.RoundedBox(0, 0,0,w,h,Color(120,255,120)) -- check bounds
        if selection >= table.Count(VehicleList) then
            self:SetTextColor(Color(120,120,120))
        else
            self:SetTextColor(Color(255,255,255))
        end -- ends the if statement
    end -- ends the paint function

    -- VEHICLE SELECTOR BUTTON
    local vehiclesel = self:Add("DButton")
    vehiclesel:SetPos(0,uh*.87)
    vehiclesel:SetSize(uw, uh*.14)
    vehiclesel:SetFont("Verdana20")
    vehiclesel:SetTextColor(Color(255,255,255))
    vehiclesel:SetText("Request "..VehicleList[selection].name.." in MHB 1")
    vehiclesel.DoClick = function()
        print(robb_vehiclerequests)
        local hasRequest = false
        for k,v in pairs(robb_vehiclerequests) do
            if v.ply == LocalPlayer():Nick() then 
                hasRequest = true
                chat.AddText(Color(255,50,50), "[!] ", Color(255,255,255), "You have already requested a vehicle.")
            end
        end
        if !hasRequest then
            --robb_vehiclerequests[LocalPlayer():SteamID64()] = {ply = LocalPlayer():Nick(), vehname = VehicleList[selection].name, loc = "Hangar 1"}
            table.insert(robb_vehiclerequests, {ply = LocalPlayer():Nick(), vehname = VehicleList[selection].name, loc = "Main Hangar Bay 1", ent = VehicleList[selection].ent})
            chat.AddText(Color(255,50,50), "[!] ", Color(255,255,255), "Your request for ", Color(255,50,50), VehicleList[selection].name, Color(255,255,255), " has been sent to Naval for approval.")
            Robb_NotifyTeam(1, "There is a new vehicle request.")
        end
    end -- ends the DoClick function

    vehiclesel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(80,255,80))
        self:SetText("Request "..VehicleList[selection].name.." in MHB 1")
    end -- ends the Paint function


end -- ends the USER:Init() function

function USER:Paint(w, h)
    draw.RoundedBox(0,0,0,w,h,colors.um_bg)
    draw.SimpleText(deploymentname.." Vehicle Bay", "Verdana20", w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER)
    draw.SimpleText(VehicleList[selection].name, "Verdana12", w/2, h*.11, Color(255,255,255), TEXT_ALIGN_CENTER)


    --draw.RoundedBox(0,w*.25,h*.17,w/2,h*.70,Color(120,120,255))-- check bounds on mdl
end

derma.DefineControl("Robb User Menu", "User mode for base/venator management menu", USER, "DFrame")

-- =======================
-- === NAVAL MODE PANEL ==
-- =======================

local NAVAL = {}
function NAVAL:Init()
    self:SetSize(800,500)
    self:Center()
    self:SetTitle("")
    self:MakePopup()

    local uw,uh = self:GetWide(), self:GetTall()

    local navalbutton = self:Add("DButton")
    navalbutton:SetPos(0,uh*.17)
    navalbutton:SetSize(uw/4, uh*.05)
    navalbutton:SetFont("Verdana8")
    navalbutton:SetTextColor(Color(255,255,255))
    navalbutton:SetText("Naval")
    navalbutton.Paint = function(me, w, h)

    end -- ends the paint function
    navalbutton.DoClick = function()
        self:ShowNavalMenu()
    end -- ends the paint function

    local staffbutton = self:Add("DButton")
    staffbutton:SetPos(0,uh*.26)
    staffbutton:SetSize(uw/4, uh*.05)
    staffbutton:SetFont("Verdana8")
    staffbutton:SetTextColor(Color(255,255,255))
    staffbutton:SetText("Staff")
    staffbutton.Paint = function(me, w, h)
        
    end -- ends the paint function
end

function NAVAL:Paint(w,h)
    draw.RoundedBox(0,0,0,w,h,colors.um_bg)
    draw.SimpleText(deploymentname.." Management Menu", "Verdana20", w/2, 0, Color(255,255,255), TEXT_ALIGN_CENTER)

    --draw.RoundedBox(0,0,h*.17,w/4,h*.83,Color(120,120,255)) -- LIST BUTTON BOUNDS
    --draw.RoundedBox(0,w*.25,h*.17,w*.75,h*.83,Color(120,255,120)) -- CONTENT BOUNDS

end

function NAVAL:AddVehicleRequest(vehiclename, ply, location, ent)
    local uw,uh = self:GetWide(), self:GetTall()
    local vehname, ply, loc = vehiclename, ply, location

    local reqitem = robb_reqlist:Add("DFrame")
    reqitem:SetSize(uw*.1, uh*.15)
    reqitem:Dock(TOP)
    reqitem:DockMargin(10,0,10,10)
    reqitem:SetDraggable(false)
    reqitem:SetTitle("")
    reqitem:ShowCloseButton(false)
    reqitem.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(255,120,120))
        draw.SimpleText(ply, "Verdana8", w/5, 0, Color(255,255,255), TEXT_ALIGN_LEFT)
        draw.SimpleText(vehname.." in "..loc, "Verdana8", w/5, h*.45, Color(255,255,255), TEXT_ALIGN_LEFT)
    end -- ends the paint function

    local reqitemapp = reqitem:Add("DButton")
    reqitemapp:SetSize(uw*.1, uh*.1)
    reqitemapp:SetPos(uw*.02, uh*.02)
    reqitemapp:SetFont("Verdana7")
    reqitemapp:SetTextColor(Color(255,255,255))
    reqitemapp:SetText("Approve")
    reqitemapp.Paint = function(self, w, h)

    end -- ends the paint function

    reqitemapp.DoClick = function()
        reqitem:Remove()
        Robb_SpawnVehicle(ent, loc)
        table.remove(robb_vehiclerequests, k)
        Robb_NotifyPlayer(ply, "Naval has approved your vehicle request. It should be brought to the hangar shortly.")
    end -- ends the DoClick function

    local reqitemrej = reqitem:Add("DButton")
    reqitemrej:SetSize(uw*.1, uh*.1)
    reqitemrej:SetPos(uw*.61, uh*.02)
    reqitemrej:SetFont("Verdana7")
    reqitemrej:SetTextColor(Color(255,255,255))
    reqitemrej:SetText("Reject")
    reqitemrej.Paint = function(self, w, h)
        
    end -- ends the paint function
    
    reqitemrej.DoClick = function()
        reqitem:Remove()
        Robb_NotifyPlayer(ply, "Naval has denied your vehicle request.")
        table.remove(robb_vehiclerequests, k)
    end -- ends the DoClick function
end

function NAVAL:ShowNavalMenu()
    local uw,uh = self:GetWide(), self:GetTall()

    robb_reqlist = self:Add("DScrollPanel")
    robb_reqlist:SetSize(uw*.75, uh*.83)
    robb_reqlist:SetPos(uw*.25,uh*.17)
    robb_reqlist.Paint = function(self, w, h) end

    for k,v in pairs (robb_vehiclerequests) do
        self:AddVehicleRequest(v.vehname, v.ply, v.loc, v.ent)
    end
end


derma.DefineControl("Robb Naval Menu", "Naval and Staff mode for base/venator management menu", NAVAL, "DFrame")