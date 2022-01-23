AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/weedplant.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.coolDown = CurTime() + 1

	self:SetStage(0)
	-- 8 stages, stage 0 is empty, stage 7 is full
	self:SetNBodygroup(0)
	self:SetBodygroup(2, 0)
	self:SetBudCount(0)
	self:SetLightLevel(50)
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:Use(ply)
	if self:GetStage() == 3 then self:ResetProcess() return end
	if self:GetStage() != 2 then return end

	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 3
	self:EmitSound("uweed/scizzors.mp3",55,255,1,CHAN_AUTO )
	timer.Simple(2, function()
		if !IsValid(self) then return end

		local budcount = self:GetBudCount()
		self:SetBudCount(budcount - 1)

		local bud = ents.Create("uweed_bud")
		bud:SetPos(self:GetPos()+Vector(0, 0, math.random(25, 35)))
		bud:CPPISetOwner(self:Getowning_ent())
		bud:Spawn()
		bud:SetBudCounter(math.random(1, UWeed.Pot.MaxBudGram))
		bud:SetModel(bud.stageModel[bud:GetBudCounter()])

		local chance = math.random(1, UWeed.Pot.SeedDropChance)
		if chance == 10 then 
			local seed = ents.Create("uweed_seed")
			seed:SetPos(self:GetPos()+Vector(0, 0, math.random(25, 35)))
			seed:CPPISetOwner(self:Getowning_ent())
			seed:Spawn()
		end
	
		if budcount <= 1 then self:ResetProcess() return end
	end)
end

function ENT:ResetProcess()
	self:SetBudCount(0)
	self:SetNBodygroup(0)
	self:SetBodygroup(2, 0)
	self:SetStage(0)
	self:SetLightLevel(50)
end

function ENT:StartTouch(seed)
	if self:GetStage() != 0 then return end
	if seed:GetClass() != "uweed_seed" then return end
	if seed.dead then return end

	self:SetStage(1)
	self:StartGrow()
	seed.dead = true
	seed:Remove()
end

function ENT:StartGrow()
	if self:GetStage() == 3 then return end
	self:ProgressGrow()
	self:SetLightLevel(50)
	timer.Simple(1, function()
		if !IsValid(self) then return end
		self:ProgressLight()
	end)
end

function ENT:ProgressGrow()
	timer.Simple(UWeed.Pot.GrowthRate, function()
		if !IsValid(self) then return end
		if self:GetStage() == 3 then return end
		if self:GetNBodygroup() == 7 then self:SetStage(2) end
		if self:GetStage() == 2 then
			self:FinishGrow()
			return
		end
		self:ProgressBodygroup()
		self:ProgressGrow()
	end)
end

function ENT:ProgressLight()
	if self:GetStage() != 1 then return end
	local lvl = self:GetLightLevel()
	if lvl <= 0 or lvl >= 100 then
		self:SetStage(3)
		return
	end

	self:SetLightLevel(lvl - UWeed.Pot.LightDeplenishrate)
	if self:GetStage() == 1 then
		timer.Simple(1, function()
			if !IsValid(self) then return end
			self:ProgressLight()
		end)
	end
end

function ENT:IncreaseLight()
	if self:GetStage() != 1 then return end
	local lvl = self:GetLightLevel()
	if lvl >= 100 then
		self:SetStage(3)
		return
	end

	local addValue = UWeed.Light.IncreaseRate
	if lvl >= (100-addValue) then
		addValue = 100 - lvl
	end

	self:SetLightLevel(lvl + addValue)
end

function ENT:ProgressBodygroup()
	if self:GetStage() == 0 then
		self:ResetProcess()
	end
	local pos = self:GetNBodygroup()
	if pos == 7 then return end

	self:SetNBodygroup(pos+1)
	self:SetBodygroup(2, pos+1)
end

function ENT:FinishGrow()
	self:SetBudCount(math.random(UWeed.Pot.MinBuds, UWeed.Pot.MaxBuds))
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