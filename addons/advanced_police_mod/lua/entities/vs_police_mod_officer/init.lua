AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if not KVS then
		self:Remove()
		return
	end
	
	self:SetModel("models/Barney.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self:SetMaxYawSpeed(90) 
end

function ENT:AcceptInput(strName, _, pPlayer)
	if pPlayer:IsPlayer() && strName == "Use" then
		for k, v in pairs(VS_PoliceMod.BailsList) do
			if not IsValid(Player(k)) then table.remove(VS_PoliceMod.BailsList, k) continue end
		end

		VS_PoliceMod:NetStart("OnUseNPCOfficer", {bails = VS_PoliceMod.BailsList, npc = self:EntIndex()}, pPlayer)
	end
end

function ENT:OnTakeDamage()
    return 0
end
