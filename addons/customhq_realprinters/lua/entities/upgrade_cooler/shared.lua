ENT.Type 		= "anim"

ENT.PrintName	= "Upgrade Cooler"
ENT.Author		= "CustomHQ"
ENT.Contact		= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.upgrade = ""
if SERVER then
ENT.health = 100
function ENT:OnTakeDamage(dmg)
	self.health = self.health - dmg:GetDamage()
	if self.health <= 0 then self:Remove() end
end
end