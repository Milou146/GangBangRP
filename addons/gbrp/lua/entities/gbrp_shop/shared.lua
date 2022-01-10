ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Spawnable = true

ENT.price = 100000
ENT.value = 90000
ENT.launderingAmount = 1000
ENT.launderingTime = 1

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Balance" )
	self:NetworkVar( "Int", 1, "LaunderedMoney" )
	self:NetworkVar( "String", 0, "owner" )
end