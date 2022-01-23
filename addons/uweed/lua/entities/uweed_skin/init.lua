AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/bluntroll.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.health = 100
	self.coolDown = CurTime() + 1

	if !self:GetFirstSpawn() then
		self:SetStage(0)
		self:SetProgress(0)
		self:SetFirstSpawn(true)
		self.rolling = false
	elseif self:GetStage() == 2 then
		self:SetStage(1)
		self.rolling = false
	end


	self.rollStages = {}
	self.rollStages[1] = function(ent)
		ent:SetBodygroup(2, 1)
	end
	self.rollStages[2] = function(ent)
		ent:SetBodygroup(2, 2)
	end
	self.rollStages[3] = function(ent)
		ent:SetBodygroup(2, 3)
	end
	self.rollStages[4] = function(ent)
		ent:SetBodygroup(2, 4)
	end
	self.rollStages[5] = function(ent)
		ent:SetModel("models/base/bluntroll2.mdl")
		ent:SetBodygroup(2, 0)
	end
	self.rollStages[6] = function(ent)
		ent:SetBodygroup(2, 1)
	end
	self.rollStages[7] = function(ent)
		ent:SetModel("models/base/bluntroll3.mdl")
	end
	self.rollStages[8] = function(ent)
		ent:SetModel("models/base/bluntroll4.mdl")
		ent:SetBodygroup(1, 0)
		ent:SetBodygroup(2, 0)
	end
	self.rollStages[9] = function(ent)
		ent:SetBodygroup(2, 1)
	end

	self.rollSounds = {}
	self.rollSounds[1] = {
		sound = "uweed/paperrolling.mp3",
		length = 4
	}
	self.rollSounds[2] = {
		sound = "uweed/paperrolling2.mp3",
		length = 3
	}
	self.rollSounds[3] = {
		sound = "uweed/paperrolling3.mp3",
		length = 5
	}
end

function ENT:Use(ply)
	if self:GetStage() == 1 then
		if self.rolling then return end
		self.rolling = true
		self:SetStage(2)
		--9 stages
		local stage = 0
		timer.Create(self:GetCreationID().."_rolling_timer", 1, 9, function()
			if !IsValid(self) then return end
			if !self.rolling then return end
			if self:GetPos():Distance(ply:GetPos()) > 100 then
				self:Stoprolling()
				return
			end
			if ply:KeyDown(IN_USE) then
				stage = stage + 1
				self.rollStages[stage](self)
				if stage == 9 then
					self:SetStage(3)
				end
			else
				self:Stoprolling()
				return
			end

			if !timer.Exists(self:GetCreationID().."_rolling_sound") then
				local ranSound = self.rollSounds[math.random(#self.rollSounds)]

				self:EmitSound(ranSound.sound,75,100,1,CHAN_AUTO )
				timer.Create(self:GetCreationID().."_rolling_sound", ranSound.length, 1, function() end)	
			end
		end)
	elseif self:GetStage() == 3 then
		ply:Give("uweed_joint")
		local counter = ply:GetNWInt("uWeed_Gram_Counter") or 0 
		ply:SetNWInt("uWeed_Gram_Counter", counter + UWeed.Config.RollAmount) 
		self:Remove()
	end
end

function ENT:Stoprolling()
	self.rolling = false
	self:SetStage(1)
	self:SetModel("models/base/bluntroll.mdl")
	self:SetBodygroup(2, 0)
	self:SetBodygroup(3, 0)
	timer.Remove(self:GetCreationID().."_rolling_timer")
end

function ENT:StartTouch(weed)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if self:GetStage() != 0 then return end

	if weed:GetClass() != "uweed_bud" then return end
	local budCount = weed:GetBudCounter()

	if budCount > 1 then
		weed:SetBudCounter(budCount - 1)
		weed:SetModel(weed.stageModel[budCount-1])
	else
		weed:Remove()
	end

	self:SetStage(1)
	self:SetBodygroup(1, 1)
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