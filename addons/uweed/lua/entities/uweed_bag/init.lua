AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/weedbag.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	if !self:GetFirstSpawn() then
		self:SetBudCounter(0)
		self:SetFirstSpawn(true)
	end

	self.health = 100
	self.coolDown = CurTime() + 1
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:StartTouch(bud)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if bud:GetClass() != "uweed_bud" then return end
	if bud.dead then return end
	local budCount = self:GetBudCounter()
	local otherBudCount = bud:GetBudCounter()

	if budCount >= UWeed.WeedBag.Capacity then return end

	if budCount+otherBudCount > UWeed.WeedBag.Capacity then
		local leftover = (budCount + otherBudCount) - UWeed.WeedBag.Capacity
		bud:SetBudCounter(leftover)
		bud:SetModel(bud.stageModel[leftover])
		self:SetBudCounter(UWeed.WeedBag.Capacity)
	else
		self:SetBudCounter(budCount + otherBudCount)
		bud.dead = true
		bud:Remove()
	end
end

function ENT:Use(ply)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1
	
	local budCount = self:GetBudCounter()
	if budCount <= 0 then return end
	self:SetBudCounter(budCount - 1)

	local bud = ents.Create("uweed_bud")
	bud:SetPos(self:GetPos() + Vector(0, 0, 15))
	bud:CPPISetOwner(self:Getowning_ent())
	bud:Spawn()
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