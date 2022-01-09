AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:AddMoney(amount)
	self:SetBalance(self:GetBalance() + amount)
end