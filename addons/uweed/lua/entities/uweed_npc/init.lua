AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Sets the players modela and basic physics ect..
function ENT:Initialize()
	self:SetModel(UWeed.Config.NPCModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetTrigger(true)

	self.coolDown = 0
	self:SetSellPrice(math.random(UWeed.Config.MinSell, UWeed.Config.MaxSell))
end

function ENT:OnTakeDamage()        
	return 0    
end

function ENT:StartTouch(ent)
	if self.coolDown > CurTime() then return end
	self.coolDown = CurTime() + 1

	if ent:GetClass() == "uweed_bag" then
		if ent:GetBudCounter() < 1 then return end
		self:SetHolding(self:GetHolding() + ent:GetBudCounter())
		ent:SetBudCounter(0)
	elseif ent:GetClass() == "uweed_bud" then
		if ent:GetBudCounter() < 1 then return end
		self:SetHolding(self:GetHolding() + ent:GetBudCounter())
		ent:Remove()
	end
end

function ENT:AcceptInput(name, activator, caller)
	if self:GetHolding() < 1 then return end 
	-- Basic checks
	if activator:IsPlayer() == false then return end
	if activator:GetPos():Distance( self:GetPos() ) > 100 then return end

	activator:addMoney(self:GetHolding()*self:GetSellPrice())
	if UWeed.Config.SellChatMessage then
		net.Start("uweed_msg")
			net.WriteString(string.format(UWeed.Translation.NPC.SellMessage, self:GetHolding().."g", DarkRP.formatMoney(self:GetHolding()*self:GetSellPrice())))
		net.Send(activator)
	end
	self:SetSellPrice(math.random(UWeed.Config.MinSell, UWeed.Config.MaxSell))
	self:SetHolding(0)
end