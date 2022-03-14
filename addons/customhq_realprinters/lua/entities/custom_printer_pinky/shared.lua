ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer - Pink"
ENT.Author = "CustomHQ"
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true 
if SERVER then include("sv_init.lua"); include("realprinters_config.lua") end
AddCSLuaFile "cl_init.lua"
AddCSLuaFile("shared.lua")
ENT.PMoney = 0
ENT.PPower = 50 	
ENT.PTemp = 6 
ENT.PEnable = true
ENT.PCoolerState = "dis"
ENT.PTime = 0
ENT.PPaper = 0
ENT.PColors = 0
local cfg = hqprinter2
function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
end
ENT.EatMore = true
ENT.IsCustomHQ = true
ENT.RenderGroup = RENDERGROUP_BOTH
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		if not PrintersEnabledAzae then return end
		local pos = self:CalculateRenderPos()
		local ang = self:CalculateRenderAng()
		local w, h = self.Width2D, self.Height2D
		local x, y = self:CalculateCursorPos()
		cam.Start3D2D(pos, ang, self.Scale)
			self:Paint(w, h, x, y,1)
		cam.End3D2D()
		ang:RotateAroundAxis(ang:Forward(), -5)
		pos:Add(self:GetForward() * 1.192)
		cam.Start3D2D(pos, ang, self.Scale)
			self:Paint(w, h, x, y,2)
		cam.End3D2D()
		local pos = self:CalculateRenderPos2()
		local ang = self:CalculateRenderAng2()
		cam.Start3D2D(pos, ang, self.Scale)
			self:Paint(w, h, x, y,3)
		cam.End3D2D()
	end
end
function ENT:Initialize()
	self.Scale = 0.1
	if CLIENT then
		self.Mins = self:OBBMins()
		self.Maxs = self:OBBMaxs()
		self.Width2D, self.Height2D = (self.Maxs.y - self.Mins.y) / self.Scale , (self.Maxs.z - self.Mins.z) / self.Scale
	end
	if SERVER then	
		self:SetModel("models/custom/rprinter.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		phys:Wake()
		phys:SetMass(100)
		self.damage = 100
		self:SetColor(cfg["PrinterColor"])
		self:SetUseType(SIMPLE_USE)
		self:SetAngles(self:GetAngles()+Angle(0,180,0))
		self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
		self.sound:SetSoundLevel(52)
		self.sound:PlayEx(1, 100) 
		timer.Simple(cfg["HeatSpeed"],function() if IsValid(self) then self:HeatMore() end end)
		timer.Create(tostring(self:EntIndex()).."printingae",cfg["PrintTimeMin"],1, function() if IsValid(self) then self:PrintMore() end end)
		self.PTime = CurTime() + cfg["PrintTimeMin"]
		self:UpdateVars()
		if not cfg["AllowCooler"] then
			self.PCap = ents.Create('prop_dynamic')
			self.PCap:SetModel('models/custom/printercap.mdl')
			self.PCap:SetPos(self:GetPos())
			self.PCap:SetAngles	(self:GetAngles())
			self.PCap:SetSolid(0)
			self.PCap:Spawn()
			self.PCap:SetParent(self)
		end
	end
end
function ENT:Use(activator)
	if CLIENT then return end
	if self.AlreadyUsed then return end
	if not IsValid(self.lock) then return end
	local id = self:LookupSequence("open")
	self:ResetSequence(id)
	self.lock:SetParent(nil)
	self:EmitSound(Sound("doors/door1_move.wav"))
		self.lock:PhysicsInit(SOLID_VPHYSICS)
		self.lock:SetMoveType(MOVETYPE_VPHYSICS)
		self.lock:SetSolid(SOLID_VPHYSICS)
		self.lock:GetPhysicsObject():SetVelocity(Vector(0,0,-1))
		timer.Simple(3,function() if IsValid(self.lock) then self.lock:Remove() end end)
	if IsValid(self.ply) and activator!=self.ply and not UniqueRewards.CanStoleReward then return end
	timer.Simple(5,function() if IsValid(self) then self:Remove() end end)
	self.AlreadyUsed = true
	timer.Simple(0.5,function()
		local enta = ents.Create('reward_present')
		enta:SetPos(self:GetPos()+self:GetForward()*13 + Vector(0,0,25))
		enta.ply = self.ply
		enta.Progress = self.Progress
		enta:Spawn()
		
	end)
end
function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
	if self.PCooler and self.PCooler.sound then
		self.PCooler.sound:Stop()
	end
end