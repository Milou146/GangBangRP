AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/scale.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.coolDown = CurTime() + 1
	self:SetCurrentBag(nil)
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:StartTouch(bag)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if (bag:GetClass() != "uweed_bud") and (bag:GetClass() != "uweed_bag") then return end
	if bag == self:GetCurrentBag() then return end

	self:SetCurrentBag(bag)
end

function ENT:EndTouch(bag)
	if (bag:GetClass() != "uweed_bud") and (bag:GetClass() != "uweed_bag") then return end
	if bag != self:GetCurrentBag() then return end

	self:SetCurrentBag(nil)
end

function ENT:OnTakeDamage(dmg)
	self.health = (self.health) - dmg:GetDamage()
	if self.health <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end