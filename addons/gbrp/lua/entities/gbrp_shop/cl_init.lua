include("shared.lua")

ENT.Category = "GangBangRP"
ENT.PrintName = "Shop"
ENT.AutomaticFrameAdvance = true

function ENT:Draw()
    self:DrawModel()
end