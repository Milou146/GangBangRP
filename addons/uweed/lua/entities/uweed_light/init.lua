AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/base/lamp1.mdl")
	-- Basic physics and functionality
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self:SetOn(false)
	self.health = 100

	self.coolDown = CurTime() + 1

	if !self:GetFirstSpawn() then
		self:SetBattery(100)
		self:SetFirstSpawn(true)
	end

	self.sound = CreateSound(self, Sound("uweed/lampsound_loop.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:Stop()
	self:CPPISetOwner(self:Getowning_ent())
end

function ENT:OnTakeDamage(dmg)
	self.health = (self.health) - dmg:GetDamage()
	if self.health <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:DecayBattery()
	if !self:GetOn() then return end
	local bat = self:GetBattery()
	if bat <= 0 then
		self:SetOn(false)
		return
	end

	self:SetBattery(bat - 1)
	timer.Simple(UWeed.Light.BatteryDecay, function()
		if !IsValid(self) then return end
		self:DecayBattery()
	end)
end

function ENT:Use()
	if self:GetBattery() <= 0 then return end
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	self:SetOn(!self:GetOn())
	if self:GetOn() then
		if UWeed.Light.Batery then
			self:DecayBattery()
		end
		self:SetBodygroup(3, 1)
		self.sound:PlayEx(0.7, 100)
	else
		self:SetBodygroup(3, 0)
		self.sound:Stop()
	end
	self:EmitSound("uweed/lampsound_toggle.mp3",75,100,1,CHAN_AUTO )
end

function ENT:StartTouch(bat)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if self:GetBattery() >= 100 then return end

	if bat:GetClass() != "uweed_battery" then return end

	self:SetBattery(100)
	bat:Remove()
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:Think()
	if self:GetOn() then
		local tbl = ents.FindInCone(self:GetPos(), self:GetUp()*-1 + self:GetRight()*45, 70, -90)

		local curTime = CurTime()
		for k, v in pairs(tbl) do
			if v:GetClass() == "uweed_plant" then
				if !v.pushLight then v.pushLight = curTime end
				if v.pushLight <= curTime then
					v.pushLight = curTime + 1

					v:IncreaseLight()
				end
			end
		end
	end
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end