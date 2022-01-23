AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/frontwoods.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.coolDown = CurTime() + 1

	if !self:GetFirstSpawn() then
		self:SetPaperCounter(3)
		self:SetFirstSpawn(true)
	end
	
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:Use(ply)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1
	
	local papercount = self:GetPaperCounter()
	if papercount <= 0 then return end
	self:SetPaperCounter(papercount - 1)

	local paper = ents.Create("uweed_skin")
	paper:SetPos(self:GetPos() + Vector(0, 0, 15))
	paper:Spawn()

	self:EmitSound("uweed/frontwoods.wav",75,100,1,CHAN_AUTO )
end

function ENT:StartTouch(paper)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if paper:GetClass() != "uweed_skin" then return end
	local papercount = self:GetPaperCounter()
	if papercount >= 3 then return end

	self:SetPaperCounter(papercount + 1)
	paper:Remove()
	
	self:EmitSound("uweed/frontwoods.wav",75,100,1,CHAN_AUTO )
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