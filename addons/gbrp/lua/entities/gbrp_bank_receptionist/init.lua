AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.model = "models/humans/group01/female_01.mdl"
ENT.gender = "female"

function ENT:Initialize()
    self:SetModel(self.model)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:Use(ply, caller, useType, value)
    net.Start("GBRP::bankreception")
    net.WriteEntity(self)
    net.WriteString(self.gender)
    net.Send(ply)
end