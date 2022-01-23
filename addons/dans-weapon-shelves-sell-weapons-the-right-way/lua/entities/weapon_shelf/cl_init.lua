 --[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")
local tdui = include("tdui.lua") -- tdui.lua should be in same folder and AddCSLuaFile'd

local p
surface.CreateFont( "weapon_shelf_40", { font = "Arial", size = 40, weight = 600,})
surface.CreateFont( "weapon_shelf_20", { font = "Arial", size = 20, weight = 600,})

local scrw = ScrW()
local scrh = ScrH()
local col = Color(193,179,215,255)
local v = Vector()
local OutlineColor = Color(193,179,215,255)
local ForegroundColor = Color(0,0,0,150)
local affordColor = Color(23, 191, 73, 255)
local nonaffordColor = Color(191, 0, 0, 255)

function ENT:Initialize()

	self.ShelfSlots = {

	{item = false, edit = false, itemClass = "", price = 0},
	{item = false, edit = false, itemClass = "",  price = 0},
	{item = false, edit = false, itemClass = "", price = 0},

	}

	net.Start("shelf_shelfInt")
	net.WriteEntity(self)
	net.SendToServer()

end


local w = 280
local h = 50
local baseColor = Color(255,255,255,255)
local alpha = 150
local function CoolOutlineBox3D( self, xpos, ypos, width, height, color, scale)

	--Top Left Corner
	local ten = 10 / scale
	local twenty = 20 / scale
	local five = 5 / scale
	self.p:Rect(xpos,ypos, width / ten, height / ten, color)
	self.p:Rect(xpos,ypos + (height / five) / 2, width / twenty, (height / five) / 2, color)
	--Bottom Left Corner
	self.p:Rect(xpos,ypos + height - height / ten, width / ten, height / ten, color)
	self.p:Rect(xpos,ypos + height - height / five, width / twenty, (height / five) / 2, color)
	--Top Right Corner
	self.p:Rect(xpos + width - width / ten,ypos, width / ten, height / ten, color)
	self.p:Rect(xpos + width - width / twenty,ypos + (height / five) / 2, width / twenty, (height / five) / 2, color)
	--Bottom Right Corner
	self.p:Rect(xpos + width - width / ten,ypos + height - height / ten, width / ten, height / ten, color)
	self.p:Rect(xpos + width - width / twenty,ypos + height - height / five, width / twenty, (height / five) / 2, color)

end

local function CoolOutlineBox2D( xpos, ypos, width, height, color, scale)
	--Top Left Corner
	local ten = 10 / scale
	local twenty = 20 / scale
	local five = 5 / scale
	surface.SetDrawColor(color)
	surface.DrawRect(xpos,ypos, width / ten, height / ten, color)
	surface.DrawRect(xpos,ypos + (height / five) / 2, width / twenty, (height / five) / 2, color)
	--Bottom Left Corner
	surface.DrawRect(xpos,ypos + height - height / ten, width / ten, height / ten, color)
	surface.DrawRect(xpos,ypos + height - height / five, width / twenty, (height / five) / 2, color)
	--Top Right Corner
	surface.DrawRect(xpos + width - width / ten,ypos, width / ten, height / ten, color)
	surface.DrawRect(xpos + width - width / twenty,ypos + (height / five) / 2, width / twenty, (height / five) / 2, color)
	--Bottom Right Corner
	surface.DrawRect(xpos + width - width / ten,ypos + height - height / ten, width / ten, height / ten, color)
	surface.DrawRect(xpos + width - width / twenty,ypos + height - height / five, width / twenty, (height / five) / 2, color)
end

local function DrawShelfInfo2D(self, xpos, ypos, width, height, id)

	if not self.ShelfSlots[id].item then return end
	local ply = LocalPlayer()

	local slotData = self.ShelfSlots[id]
	local class = self.ShelfSlots[id].itemClass
	local price = DarkRP.formatMoney(self.ShelfSlots[id].price)

	if ply:canAfford(self.ShelfSlots[id].price) then
		baseColor = affordColor
	else
		baseColor = nonaffordColor
	end

	surface.SetDrawColor(Color(0,0,0,alpha))
	surface.DrawRect(xpos, ypos, width, height)
	CoolOutlineBox2D( xpos, ypos, width, height, baseColor, .8)
	local wepData = weapons.GetStored(class)
	local text = wepData and wepData.PrintName or string.upper(string.Replace(class, "weapon_", ""))
	local amount = self.ShelfSlots[id].amount or 0
	local amountText = "(" .. amount .. "Available)"
	if amount < 1 then
		amountText = ""
	end

	draw.SimpleText( text .. " " .. amountText, "weapon_shelf_20", xpos + w / 2, ypos + height / 2, baseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetDrawColor(Color(0,0,0,alpha))
	surface.DrawRect(xpos, ypos + height + 5, width, height)
	CoolOutlineBox2D( xpos, ypos + height + 5, width, height, baseColor, .8)
	draw.SimpleText(price or "$0", "weapon_shelf_20", xpos + width / 2, ypos + height / 2 + height + 5, baseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetDrawColor(Color(0,0,0,alpha))
	surface.DrawRect(xpos, ypos + height * 2 + 10, width, height, Color(0,0,0,alpha))
	CoolOutlineBox2D( xpos, ypos + h * 2 + 10, width, height, baseColor, .8)
	draw.SimpleText("Purchase", "weapon_shelf_20", xpos + width / 2, ypos + height * 2 + height / 2 + 10, baseColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

local function DrawShelfInfo3D(self, xpos, ypos, width, height, id)
	if not self.ShelfSlots[id].item then return end
	local ply = LocalPlayer()

	local class = self.ShelfSlots[id].itemClass
	local price = DarkRP.formatMoney(self.ShelfSlots[id].price)

	if ply:canAfford(self.ShelfSlots[id].price) then
		baseColor = affordColor
	else
		baseColor = nonaffordColor
	end


    if  self.p:Button("Purchase", "weapon_shelf_20", xpos, ypos + height * 2 + 10, width, height, baseColor) then
        net.Start("shelf_buyItem")
		net.WriteInt(id, 8)
		net.WriteEntity(self)
		net.SendToServer()
    end



end

local priceChange = 1

local function ShowPriceInput(shelf, id)

	local scrw, scrh = ScrW(), ScrH()
	if IsValid(DSHELVES_PRICE_INPUT) then
		DKEVLAR.PopupNotice:Remove()
	end
	DSHELVES_PRICE_INPUT = vgui.Create("DFrame")
	local frame = DSHELVES_PRICE_INPUT
	frame:SetSize(scrw * .2, scrh * .07)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(true)
	frame.Paint = function(me,w,h)
		surface.SetDrawColor(0,0,0,240)
		surface.DrawRect(0,0,w,h)
		draw.SimpleText("Please Enter a Price.", "weapon_shelf_20", w / 2, h * .4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end


	surface.SetFont("weapon_shelf_20")
	local textW = surface.GetTextSize("Please Enter a Price.")
	frame:SetWide(textW * 1.2)
	frame:Center()

	local priceEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
	priceEntry:Dock(FILL)
	priceEntry:DockMargin(0,frame:GetTall() * .25, 0, 0)
	priceEntry:SetValue( 0 )
	priceEntry:SetNumeric(true)
	priceEntry.OnEnter = function( self )
		net.Start("shelf_setPrice")
		net.WriteEntity(shelf)
		net.WriteInt(id, 8)
		net.WriteUInt(self:GetValue(), 32)
		net.SendToServer()
		frame:Remove()
	end
end

local function DrawShelfOptions(self, ypos, id)

	if not self.ShelfSlots[id].item then return end

	if self.ShelfSlots[id].edit then
		self.p:Rect(-290, ypos - 150 - 15, 210, 50, Color(0,0,0,alpha))
	    if self.p:Button("Disable Editing", "weapon_shelf_20", -290 , ypos - 150 - 15, 210, 50, color_white) then
			self.ShelfSlots[id].edit = false
			net.Start("shelf_editToggle")
			net.WriteEntity(self)
			net.WriteInt(id, 8)
			net.WriteBool(false)
			net.SendToServer()
	    end

		self.p:Rect(-290, ypos - 100 - 10, 210, 50, Color(0,0,0,alpha))
	    if self.p:Button("Clear Shelf", "weapon_shelf_20", -290 , ypos - 100 - 10, 210, 50, color_white) then
			net.Start("shelf_clearItem")
			net.WriteEntity(self)
			net.WriteInt(id, 8)
			net.SendToServer()
	    end


		self.p:Rect(-290, ypos - 55, 50, 50, Color(0,0,0,alpha))
	    if self.p:Button("<", "weapon_shelf_20", -290, ypos - 55, 50, 50, color_white) then
			priceChange = math.Round(priceChange / 10)
			if priceChange < 1 then
				priceChange = 1
			end
	    end

		self.p:Rect(-290 + 55, ypos - 55, 100, 50, Color(0,0,0,alpha))
		self.p:Text(priceChange, "weapon_shelf_20", -290 + 55 + 50, ypos - 55 + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		self.p:Rect(-290 + 60 + 100, ypos - 55, 50, 50, Color(0,0,0,alpha))

	    if self.p:Button(">", "weapon_shelf_20", -290 + 60 + 100, ypos - 55, 50, 50, color_white) then
			priceChange = priceChange * 10
			if priceChange > self.MaxPrice then
				priceChange = self.MaxPrice
			end
	    end

		self.p:Rect(-290, ypos, 50, 50, Color(0,0,0,alpha))
	    if self.p:Button("<", "weapon_shelf_20", -290, ypos, 50, 50, color_white) then
			net.Start("shelf_subPrice")
			net.WriteInt(id, 8)
			net.WriteInt(priceChange, 32)
			net.WriteEntity(self)
			net.SendToServer()
			self.ShelfSlots[id].price = self.ShelfSlots[id].price - priceChange
			if self.ShelfSlots[id].price < 0 then
				self.ShelfSlots[id].price = 0
			end
	    end

		self.p:Rect(-290 + 55, ypos, 100, 50, Color(0,0,0,alpha))
		--self.p:Text("Set Price", "weapon_shelf_20", -290 + 55 + 50, ypos + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self.p:Button("Set Price", "weapon_shelf_20", -290 + 55 + 25, ypos, 50, 50, color_white) then
			ShowPriceInput(self, id)
		end

		self.p:Rect(-290 + 60 + 100, ypos, 50, 50, Color(0,0,0,alpha))
	    if self.p:Button(">", "weapon_shelf_20", -290 + 60 + 100, ypos, 50, 50, color_white) then
			net.Start("shelf_addPrice")
			net.WriteInt(id, 8)
			net.WriteInt(priceChange, 32)
			net.WriteEntity(self)
			net.SendToServer()
			self.ShelfSlots[id].price = self.ShelfSlots[id].price + priceChange
			if self.ShelfSlots[id].price > self.MaxPrice then
				self.ShelfSlots[id].price = self.MaxPrice
			end
	    end

	else

		self.p:Rect(-290, ypos, 210, 50, Color(0,0,0,alpha))
		CoolOutlineBox3D( self, -290, ypos , 210, 50, color_white, .8)
	    if self.p:Button("Enable Editing", "weapon_shelf_20", -290 , ypos, 210, 50, color_white) then
			self.ShelfSlots[id].edit = true
			net.Start("shelf_editToggle")
			net.WriteEntity(self)
			net.WriteInt(id, 8)
			net.WriteBool(true)
			net.SendToServer()

			for i = 1, #self.ShelfSlots do

				if i != id then
					self.ShelfSlots[i].edit = false
				end

			end

	    end

	end
end

local ypos3 = 720
local ypos2 = 500
local ypos1 = 250
function ENT:Draw()
    self.Entity:DrawModel()
    local ply = LocalPlayer()
    local plyPos = ply:GetPos()
    if self.Hover then
	   v.z = math.sin(CurTime()) * 50
	end
	local dist = plyPos:Distance(self:GetPos())
	if dist < 420 then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(self:GetAngles():Right(), 180)
		ang:RotateAroundAxis(self:GetAngles():Forward(), 180)
		local ang2 = self:GetAngles()
		ang2:RotateAroundAxis(self:GetAngles():Right(), 270)
		ang2:RotateAroundAxis(self:GetAngles():Forward(), 90)
		local z = v.z / 2
		cam.Start3D2D(self:GetPos() - ang:Forward() * 13, Angle(ang2.x, ang2.y, ang2.z), .1)
		DrawShelfInfo2D(self, 0, z - ypos1, w, h, 1)
		DrawShelfInfo2D(self, 0, z - ypos2, w, h, 2)
		DrawShelfInfo2D(self, 0, z - ypos3, w, h, 3)
		cam.End3D2D()
		if dist < 80 then
			if bDrawingDepth then return end
			self.p = self.p or tdui.Create()
			DrawShelfInfo3D(self, 0, z - ypos1, w, h, 1)
			DrawShelfInfo3D(self, 0, z - ypos2, w, h, 2)
			DrawShelfInfo3D(self, 0, z - ypos3, w, h, 3)
			if ply == self:Getowning_ent() or not IsValid(self:Getowning_ent()) and self.AdminAccess[ply:GetUserGroup()] then
				DrawShelfOptions(self, -110, 1)
				DrawShelfOptions(self, -350, 2)
				DrawShelfOptions(self, -600, 3)
			end
			self.p:Cursor()
		   	self.p:Render(self:GetPos() - ang:Forward() * 13, Angle(ang.x, ang.y, ang.z), 0.1)
		end
    end
end



net.Receive("shelf_update", function()

	local slot = net.ReadInt(8)
	local shelf = net.ReadEntity()
	local slotData = net.ReadTable()

	if IsValid(shelf) then
		shelf.ShelfSlots = shelf.ShelfSlots or {}
		if shelf.ShelfSlots[slot] then
			shelf.ShelfSlots[slot] = slotData
		end

	end

end)


net.Receive("shelf_clientInt", function()

	local shelf = net.ReadEntity()
	local shelfData = net.ReadTable()
	shelf.ShelfSlots = net.ReadTable()

end)

net.Receive("shelf_notify", function()
	local msg = net.ReadString()
	chat.AddText(Color(31, 133,222), "[DanFMN's Shelves] ", Color(255,255,255), msg)
end)
