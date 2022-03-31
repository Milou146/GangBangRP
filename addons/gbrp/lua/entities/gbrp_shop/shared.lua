ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Spawnable = true

ENT.price = 100000
ENT.value = 90000
ENT.launderingAmount = 1000
ENT.launderingTime = 1
ENT.launderingRatio = 0.5
ENT.robbery = {
    lt = 0,
    time = 300, --time needed to completely rob the shop
    radius = 330,
    delay = 10
}
ENT.minimumOperatingCost = 1000 -- the minimum amount the gang pay everytime
ENT.startingOperatingCostTime = 1800 -- after how much time the gang start paying operating cost
ENT.operatingCostSpeed = 600 -- after how much time the gang pay operating cost

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Balance")
    self:NetworkVar("Int", 1, "DirtyMoney")
    self:NetworkVar("Int", 2, "RobberyTime")
    self:NetworkVar("String", 0, "ShopName")
    self:NetworkVar("String", 1, "GangName")
   	self:NetworkVar("Bool", 0, "BeingRobbed")
end

function ENT:GetPrice()
    return self.price + self.price * gbrp.GetPropertyTax() / 100
end

function ENT:GetGang()
    if self:GetGangName() == "" then
        return nil
    else
   	    return gbrp.gangs[self:GetGangName()]
    end
end