AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/weedbox.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.coolDown = CurTime() + 1

	local seedCount = UWeed.SeedBox.MaxStorage
	if !self:GetFirstSpawn() then
		self:SetSeedCount(seedCount)
		self:SetFirstSpawn(true)
	end
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:Use(ply)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1
	
	local seedCount = self:GetSeedCount()
	if seedCount <= 0 then return end
	self:SetSeedCount(seedCount - 1)

	local seed = ents.Create("uweed_seed")
	seed:SetPos(self:GetPos() + Vector(0, 0, 15))
	seed:CPPISetOwner(self:Getowning_ent())
	seed:Spawn()

	if seedCount - 1 <= 0 then
		self:Remove()
	end
end

function ENT:StartTouch(seed)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if seed:GetClass() != "uweed_seed" then return end
	local seedCount = self:GetSeedCount()
	if seedCount >= UWeed.SeedBox.MaxStorage then return end

	self:SetSeedCount(seedCount + 1)
	seed:Remove()
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