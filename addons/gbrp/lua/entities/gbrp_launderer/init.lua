AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.hotdogpos = Vector(1985.312012,5540.983398,46.440498)

function ENT:Initialize()
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:Use(ply, caller, useType, value)
    if ply.DarkRPVar["money"] > 0 then
        
    end
end