ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName = "Officer NPC"
ENT.Category = "Advanced Police Mod"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end