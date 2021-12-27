AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
    self:SetModel("models/humans/group01/female_01.mdl");
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
	self:SetNPCState( NPC_STATE_SCRIPT );
	self:SetSolid(  SOLID_BBOX );
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD );
	self:SetUseType( SIMPLE_USE );
	self:DropToFloor();
end

function ENT:Use(ply, caller, useType, value)
    net.Start("bankReception");
    net.Send(ply);
end