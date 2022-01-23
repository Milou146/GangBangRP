--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("tdui.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local meta = FindMetaTable("Player")
util.AddNetworkString("shelf_update")
util.AddNetworkString("shelf_buyItem")
util.AddNetworkString("shelf_clearItem")
util.AddNetworkString("shelf_subPrice")
util.AddNetworkString("shelf_addPrice")
util.AddNetworkString("shelf_setPrice")
util.AddNetworkString("shelf_editToggle")
util.AddNetworkString("shelf_clientInt")
util.AddNetworkString("shelf_shelfInt")
util.AddNetworkString("shelf_notify")
local _P = FindMetaTable("Player")
function _P:ShelfNotify(message)
	net.Start("shelf_notify")
	net.WriteString(message)
	net.Send(self)

end

function ENT:Initialize()
	self:SetModel(self.WorldModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self.ShelfSlots = {

		--{item = false, edit = false, itemClass = "", price = 0, amount = 0, perm = false, offset = function(shelf) return shelf:GetAngles():Up() * 8 end, pos = Vector(0,0,0), ang = Angle(0,0,0) },
		--{item = false, edit = false, itemClass = "",  price = 0, amount = 0, perm = false, offset = function(shelf) return shelf:GetAngles():Up() * 33 end, pos = Vector(0,0,0), ang = Angle(0,0,0)},
		--{item = false, edit = false, itemClass = "", price = 0, amount = 0, perm = false, offset = function(shelf) return shelf:GetAngles():Up() * 59 end, pos = Vector(0,0,0), ang = Angle(0,0,0)},
		{item = false, edit = false, itemClass = "", price = 0, amount = 0, perm = false, pos = Vector(0,0,0), ang = Angle(0,0,0)},
		{item = false, edit = false, itemClass = "", price = 0, amount = 0, perm = false, pos = Vector(0,0,0), ang = Angle(0,0,0)},
		{item = false, edit = false, itemClass = "", price = 0, amount = 0, perm = false, pos = Vector(0,0,0), ang = Angle(0,0,0)},
	}
	self.items = {}
	self:CPPISetOwner(self:Getowning_ent())

end

local offsetCalc = {
	[1] = function(shelf) return shelf:GetAngles():Up() * 8 end,
	[2] = function(shelf) return shelf:GetAngles():Up() * 33 end,
	[3] = function(shelf) return shelf:GetAngles():Up() * 59 end,
}

function ENT:AddShelfItem(class, amount, model)
	amount = amount or 1
	for i = 1, #self.ShelfSlots do

		if self.ShelfSlots[i].itemClass == class then
			self.ShelfSlots[i].amount = self.ShelfSlots[i].amount + amount
			self:UpdateShelfSlot(i)
			return
		end

	end

	for i = 1, #self.ShelfSlots do
		if not self.ShelfSlots[i].item then
			local SpawnPos = self:GetPos()
			local ang = self:GetAngles()
			local wep = weapons.GetStored(class)
			self.item = ents.Create("base_anim")
			if wep then
				self.item:SetModel(wep.WorldModel)
			else
				self.item:SetModel(model)
				self.ShelfSlots[i].isHL2 = true
			end
			self.item:SetParent(self)
			self.item:SetPos( SpawnPos + offsetCalc[i](self) )
			self.item:SetAngles(Angle(ang.x, ang.y - 60, ang.z))
			self.items[i] = self.item
			self.ShelfSlots[i].item = true
			self.ShelfSlots[i].itemClass = class
			self.ShelfSlots[i].price = 0
			self.ShelfSlots[i].amount = amount
			self:UpdateShelfSlot(i)
			return
		end
	end

end

function ENT:CanAddItem(class)
	local foundSpot = false
	for i = 1, #self.ShelfSlots do
		if self.ShelfSlots[i].item == false or self.ShelfSlots[i].itemClass == class then
			foundSpot = true
		end
	end
	return foundSpot
end

local function GetShelfAmount(ent)
	local count = 0
	for k,v in pairs(ent.ShelfSlots) do
		if v.itemClass and v.itemClass != "" then
			count = count + 1
		end
	end
	return count
end


function ENT:PhysicsCollide( data, collider )

	local weapon = data.HitEntity
	weapon.addedToShelf = weapon.addedToShelf or false
	if not table.HasValue(self.ItemBlacklist, weapon:GetClass() ) then
		if weapon.delayTime and CurTime() < weapon.delayTime then return end
		local class, amount
		if weapon:GetClass() == "spawned_shipment" then
			amount = weapon:Getcount()
			class = CustomShipments[weapon:Getcontents()].entity
		end
		if weapon:GetClass() == "spawned_weapon" then
			class = weapon:GetWeaponClass()
			amount = weapon:Getamount() or 1
		elseif weapon:IsWeapon() then
			class = weapon:GetClass()
			amount = 1
		end
		if not weapon.addedToShelf and class and amount and self:CanAddItem(class) then
			weapon.addedToShelf = true
			self:AddShelfItem(class, amount, weapon:GetModel())
			timer.Simple(0, function()
				if not IsValid(weapon) then return end
				weapon:Remove()
			end)
		end
	end


end

local ply = FindMetaTable("Player")

net.Receive("shelf_shelfInt", function(len, ply)

	local shelf = net.ReadEntity()
	if not IsValid(shelf) or shelf:GetClass() != "weapon_shelf" then return end
	for i = 1, 3 do

		shelf:UpdateShelfSlot(i)

	end

end)

hook.Add("OnEntityCreated", "PrecacheWeaponShelves", function(ent)
	if ent:GetClass() == "weapon_shelf" then
		DANS_SHELVES.EntCache[ent] = true
	end
end)

hook.Add("EntityRemoved", "PrecacheWeaponShelves", function(ent)
	if ent:GetClass() == "weapon_shelf" then
		DANS_SHELVES.EntCache[ent] = nil
	end
end)


function ply:GetAllShelfData()

	for shelf,_ in pairs(DANS_SHELVES.EntCache) do
		net.Start("shelf_clientInt")
		net.WriteEntity(shelf)
		net.WriteTable(shelf.ShelfSlots)
		net.Send(self)
	end

end

local function ShelfPickup( ply, ent )
	if ent:GetClass() == "weapon_shelf" then
		return true
	end
end

hook.Add( "PhysgunPickup", "ShelfPickup", ShelfPickup )

function ENT:UpdateShelfSlot(slot)

	net.Start("shelf_update")
	net.WriteInt(slot, 8)
	net.WriteEntity(self)
	net.WriteTable(self.ShelfSlots[slot])
	net.Broadcast()

end


local interactDist = 200^2
net.Receive("shelf_buyItem", function(len, ply)

	local id = net.ReadInt(8)
	local shelf = net.ReadEntity()
	if not IsValid(shelf) or not shelf.ShelfSlots or not shelf.ShelfSlots[id] or not shelf.ShelfSlots[id].item then print(ply:Name() .. " is sending an id for a shelf item that doesn't exist! They maybe attempting to crash the server.") return end

	if timer.Exists(tostring(ply) .. "shelf_buy_attempt") then
		ply:ShelfNotify("Please wait before attempting to purchase another item.")
		return
	end
	timer.Create(tostring(ply) .. "shelf_buy_attempt", DANS_SHELVES.BuyDelay, 1, function() end)
	local price = shelf.ShelfSlots[id].price
	local class = shelf.ShelfSlots[id].itemClass

	if ply:GetPos():DistToSqr(shelf:GetPos()) > interactDist then
		return
	end
	if not shelf.SelfSupply and IsValid(shelf:Getowning_ent()) and shelf:Getowning_ent() == ply then
		ply:ShelfNotify("Shelf Purchase Fail: You can't purchase a weapon from your own shelf.")
		return
	end
	if IsValid(shelf:Getowning_ent()) and shelf.ShelfSlots[id].edit then
		shelf:Getowning_ent():ShelfNotify("Shelf Purchase Fail: Someone attempted to buy your item, but you were editting it.")
	end

	if ply:canAfford(price) and not ply:HasWeapon(class) and price > 0 and not shelf.ShelfSlots[id].edit then

		ply:setDarkRPVar("money", ply:getDarkRPVar("money") - price)
		DarkRP.storeMoney(ply, ply:getDarkRPVar("money"))
		ply:Give(class)

		if IsValid(shelf:Getowning_ent()) then
			shelf:Getowning_ent():setDarkRPVar("money", shelf:Getowning_ent():getDarkRPVar("money") + price)
			shelf:Getowning_ent():ShelfNotify("You've sold an item from your shelf!")
		end

		if not shelf.ShelfSlots[id].perm then
			shelf.ShelfSlots[id].amount = shelf.ShelfSlots[id].amount - 1
			if shelf.ShelfSlots[id].amount <= 0 then
				shelf.items[id]:Remove()
				shelf.ShelfSlots[id].item = false
				shelf.ShelfSlots[id].price = 0
				shelf.ShelfSlots[id].itemClass = ""
			end
			shelf:UpdateShelfSlot(id)
		end

	elseif not ply:canAfford(price) then
		ply:ShelfNotify("You can't afford this item!")
	elseif ply:HasWeapon(class) then
		ply:ShelfNotify("You already have this weapon!")
	elseif price == 0 then
		ply:ShelfNotify("You can't buy a free weapon!")
	elseif shelf.ShelfSlots[id].edit then
		ply:ShelfNotify("The owner is currently editting this item, it can't be purchased!")
	end

end)

net.Receive("shelf_setPrice", function(len,ply)

	local shelf = net.ReadEntity()
	local id = net.ReadInt(8)
	local newPrice = net.ReadUInt(32)
	if not IsValid(shelf) or not shelf.AdminAccess[ply:GetUserGroup()] and ply != shelf:Getowning_ent() or not shelf.ShelfSlots[id].edit then return end

	if ply:GetPos():DistToSqr(shelf:GetPos()) > interactDist then return end

	priceChange = math.Clamp(newPrice, 0, shelf.MaxPrice)
	shelf.ShelfSlots[id].price = newPrice
	shelf:UpdateShelfSlot(id)

end)

net.Receive("shelf_subPrice", function(len,ply)

	local id = net.ReadInt(8)
	local priceChange = net.ReadInt(32)
	local shelf = net.ReadEntity()
	if not IsValid(shelf) or not shelf.AdminAccess[ply:GetUserGroup()] and ply != shelf:Getowning_ent() or not shelf.ShelfSlots[id].edit then return end

	if ply:GetPos():DistToSqr(shelf:GetPos()) > interactDist then return end

	priceChange = math.Clamp(priceChange, 0, shelf.MaxPrice)
	shelf.ShelfSlots[id].price = shelf.ShelfSlots[id].price - priceChange
	if shelf.ShelfSlots[id].price < 0 then
		shelf.ShelfSlots[id].price = 0
	end
	shelf:UpdateShelfSlot(id)

end)

net.Receive("shelf_addPrice", function(len,ply)

	local id = net.ReadInt(8)
	local priceChange = net.ReadInt(32)
	local shelf = net.ReadEntity()
	if not shelf.AdminAccess[ply:GetUserGroup()] and ply != shelf:Getowning_ent() or not shelf.ShelfSlots[id].edit then return end

	if ply:GetPos():DistToSqr(shelf:GetPos()) > interactDist then return end
	priceChange = math.Clamp(priceChange, 0, shelf.MaxPrice)
	shelf.ShelfSlots[id].price = shelf.ShelfSlots[id].price + priceChange
	if shelf.ShelfSlots[id].price > shelf.MaxPrice then
		shelf.ShelfSlots[id].price = shelf.MaxPrice
	end
	shelf:UpdateShelfSlot(id)
end)

net.Receive("shelf_editToggle", function(len, ply)

	local shelf = net.ReadEntity()
	local id = net.ReadInt(8)
	local toggle = net.ReadBool()
	if not IsValid(shelf) or not shelf.ShelfSlots then return end

	if ply:GetPos():DistToSqr(shelf:GetPos()) > interactDist then return end

	if shelf:Getowning_ent() == ply or shelf.AdminAccess[ply:GetUserGroup()] then

		shelf.ShelfSlots[id].edit = toggle

		if toggle then
			for i = 1, #shelf.ShelfSlots do

				if i != id then

					shelf.ShelfSlots[i].edit = false

				end

			end
		end

	end


end)

net.Receive("shelf_clearItem", function(len, ply)

	local shelf = net.ReadEntity()
	local id = net.ReadInt(8)
	local price = shelf.ShelfSlots[id].price
	local class = shelf.ShelfSlots[id].itemClass
	if ply == shelf:Getowning_ent() then
		local weapon = ents.Create("spawned_weapon")
		weapon:SetPos(shelf:GetPos() + shelf:GetAngles():Forward() * 25 + Vector(0,0,5))
		weapon:SetWeaponClass(class)
		weapon:SetModel(weapons.GetStored(class).WorldModel)
		weapon:Spawn()
		weapon.delayTime = CurTime() + 3
		weapon:Setamount(shelf.ShelfSlots[id].amount or 1)
		shelf.items[id]:Remove()
		shelf.ShelfSlots[id].item = false
		shelf.ShelfSlots[id].price = 0
		shelf.ShelfSlots[id].itemClass = ""
		shelf.ShelfSlots[id].amount = 0
		shelf:UpdateShelfSlot(id)
	elseif ply != shelf:Getowning_ent() then
		ply:ShelfNotify("You aren't the owner of this shelf! Can't clear slot!")
	end

end)
local function GetShelfDir()

	return "shelf_data/shelves"

end

local function GetShelfFile()
	return GetShelfDir() .. "/shelf.txt"
end

function SaveShelves()
	PermanentShelves = {}
	PermanentShelvesID = 1
	for k,v in pairs(ents.FindByClass("weapon_shelf")) do

		for i = 1, 3 do
			if v.ShelfSlots[i].perm then
				v.ShelfSlots[i].pos = v:GetPos()
				v.ShelfSlots[i].ang = v:GetAngles()
				PermanentShelves[PermanentShelvesID] = v.ShelfSlots
				PermanentShelvesID = PermanentShelvesID + 1
				break
			end
		end

	end
	if not file.Exists(GetShelfDir(), "DATA") then
		file.CreateDir(GetShelfDir(), "DATA")
	end
	local storageData = util.TableToJSON(PermanentShelves)
	file.Write(GetShelfFile(), storageData)
end

function LoadShelves()

	local dataStorage = file.Read(GetShelfFile(), "DATA")
	local datatbl = util.JSONToTable(dataStorage)
	PermanentShelves = datatbl

	for k, v in pairs(PermanentShelves) do

		local shelf = ents.Create("weapon_shelf")
		shelf:SetPos(PermanentShelves[k][1].pos)
		shelf:SetAngles(PermanentShelves[k][1].ang)
		shelf:Spawn()
		local phys = shelf:GetPhysicsObject()
		phys:EnableMotion(false)
		for i = 1, 3 do
			local wep = weapons.GetStored(PermanentShelves[k][i].itemClass)
			if not wep then continue end

			shelf.ShelfSlots[i].item = PermanentShelves[k][i].item
			shelf.ShelfSlots[i].itemClass = PermanentShelves[k][i].itemClass
			shelf.ShelfSlots[i].price = PermanentShelves[k][i].price
			shelf.ShelfSlots[i].perm = true
			local SpawnPos = shelf:GetPos()
			local ang = shelf:GetAngles()
			shelf.item = ents.Create("base_anim")
			shelf.item:SetModel(wep.WorldModel)
			shelf.item:SetParent(shelf)
			shelf.item:SetPos( SpawnPos + offsetCalc[i](shelf) )
			shelf.item:SetAngles(Angle(ang.x, ang.y - 75, ang.z))
			shelf.items[i] = shelf.item
			timer.Simple(3, function()
				shelf:UpdateShelfSlot(i)
			end)
		end
	end

end

local function ShelfPickup( ply, ent )
	if ent:GetClass() == "weapon_shelf" and ent.PhysgunPickupEnabled and IsValid(ent:Getowning_ent()) and ent:Getowning_ent() == ply then
		return true
	end
end
hook.Add( "PhysgunPickup", "ShelfPickup", ShelfPickup )




local function CreateShelfDir()

	file.CreateDir("shelf_data/shelves")
end



hook.Add("InitPostEntity", "Shelf_LoadShelves", function()

	if not file.Exists(GetShelfFile(), "DATA") then
		CreateShelfDir()
		PermanentShelves = {}
		PermanentShelvesID = 1
	elseif file.Exists(GetShelfFile(), "DATA") then
		timer.Simple(3, function()
			LoadShelves()
			PermanentShelvesID = #PermanentShelves
		end)

	end

end)

hook.Add("PlayerSay", "Shelf_SavePos", function(ply, text, teamChat)

	local ent = ply:GetEyeTrace().Entity

	if text == "!permshelf" and IsValid(ent) and ent:GetClass() == "weapon_shelf"  and ent.AdminAccess[ply:GetUserGroup()] then

		for i = 1, #ent.ShelfSlots do

			ent.ShelfSlots[i].perm = true
			ent.ShelfSlots[i].edit = false
			ent.ShelfSlots[i].pos = ent:GetPos()
			ent.ShelfSlots[i].ang = ent:GetAngles()

		end

		ply:ShelfNotify("Shelf is now permanent!")

	end

	if text == "!saveshelves" and ent.AdminAccess[ply:GetUserGroup()] then
		SaveShelves()
		ply:ShelfNotify("SHELVES HAVE BEEN SAVED.")
	end

	if text == "!clearshelfdata" and ply:IsSuperAdmin() then
		file.Delete(GetShelfFile())
		PermanentShelves = {}
		PermanentShelvesID = 1
		ply:ShelfNotify("SHELF DATA HAS BEEN CLEARED")
	end

end)

hook.Add("PostCleanupMap", "RespawnPermShelves", function()

	LoadShelves()

end)
