ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Spawnable = true

ENT.price = 100000
ENT.value = 90000
ENT.launderingAmount = 1000
ENT.launderingTime = 1
ENT.launderingRatio = 0.5

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Balance" )
	self:NetworkVar( "Int", 1, "DirtyMoney" )
	self:NetworkVar( "String", 0, "Gang" )
end