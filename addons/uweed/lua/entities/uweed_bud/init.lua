AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if UWeed.Config.UseSmallGram then
		self:SetModel("models/gram.mdl")
		self.stageModel = {}
		self.stageModel[1] = "models/gram.mdl"
		self.stageModel[2] = "models/gram2.mdl"
		self.stageModel[3] = "models/gram3.mdl"
		self.stageModel[4] = "models/gram4.mdl"
		self.stageModel[5] = "models/gram5.mdl"
		self.stageModel[6] = "models/gram6.mdl"
		self.stageModel[7] = "models/gram7.mdl"
		self.stageModel[8] = "models/gram8.mdl"
	else
		self:SetModel("models/base/gram.mdl")
		self.stageModel = {}
		self.stageModel[1] = "models/base/gram.mdl"
		self.stageModel[2] = "models/base/gram2.mdl"
		self.stageModel[3] = "models/base/gram3.mdl"
		self.stageModel[4] = "models/base/gram4.mdl"
		self.stageModel[5] = "models/base/gram5.mdl"
		self.stageModel[6] = "models/base/gram6.mdl"
		self.stageModel[7] = "models/base/gram7.mdl"
		self.stageModel[8] = "models/base/gram8.mdl"
	end
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self:SetBudCounter(1)
	self:SetEstimateHigher(math.random(0,2))
	self:SetEstimateLower(math.random(1,2))
	self.coolDown = CurTime() + 1


	self.health = 100
end

function ENT:Use(ply)
	if (ply:GetActiveWeapon():GetClass() != "uweed_joint") and (ply:GetActiveWeapon():GetClass() != "uweed_bowl") then return end
	local counter = ply:GetNWInt("uWeed_Gram_Counter") or 0 
	ply:SetNWInt("uWeed_Gram_Counter", counter + self:GetBudCounter())

	self:Remove()
end

function ENT:StartTouch(bud)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if bud:GetClass() != "uweed_bud" then return end
	local budCount = self:GetBudCounter()
	local otherBudCount = bud:GetBudCounter()
	self:SetEstimateHigher(math.random(0,2))
	self:SetEstimateLower(math.random(1,2))
	bud:SetEstimateHigher(math.random(0,2))
	bud:SetEstimateLower(math.random(1,2))

	if budCount + otherBudCount > 8 then
		local leftover = (budCount + otherBudCount) - 8
		bud:SetBudCounter(8)
		self:SetBudCounter(leftover)
		bud:SetModel(self.stageModel[8])
		self:SetModel(bud.stageModel[leftover])
	else
		self:SetBudCounter(budCount + otherBudCount)
		bud:Remove()
		self:SetModel(self.stageModel[budCount+otherBudCount])
	end
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