AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local ft1 = CurTime()
local ft2 = 0

function ENT:Initialize()
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    self:SetGang(nil)
end

function ENT:Use(ply, caller, useType, value)
    local shopGang = self:GetGang()
    if shopGang and ply:GetGang() and ply:GetGang() != shopGang and CurTime() - self.robbery.lt > self.robbery.delay then
        net.Start("GBRP::robberyPanel")
        net.WriteEntity(self)
        net.Send(ply)
    elseif shopGang and ply:GetGang() and ply:GetGang() != shopGang and not self:GetBeingRobbed() and CurTime() - self.robbery.lt < self.robbery.delay then
        ply:ChatPrint("Patientez " .. tostring(math.Round(self.robbery.delay - CurTime() + self.robbery.lt)) .. " secondes pour braquer de nouveau le commerce.")
    else
        net.Start("GBRP::" .. self:GetShopName() .. "Reception")
        net.WriteEntity(self)
        net.Send(ply)
    end
end

ENT.money = {}
ENT.launderedMoney = {}
ENT.lastTime = 0
ENT.operatingCostMoney = 0 -- money used to pay operating costs

function ENT:launder(i,amount)
    local amountAfterVAT
    if self.money[i].wallet >= amount then
        self.money[i].wallet = self.money[1].wallet - amount
        amountAfterVAT = amount - amount * gbrp.GetVAT() / 100
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = amountAfterVAT})
        self:SetBalance(self:GetBalance() + amountAfterVAT * self.launderingRatio)
        self:SetDirtyMoney(self:GetDirtyMoney() - amount)
        self.operatingCostMoney = self.operatingCostMoney + amountAfterVAT * (1 - self.launderingRatio)
        if self.money[i].wallet == 0 then
            table.remove(self.money,i)
        end
    else
        amount = amount - self.money[i].wallet
        amountAfterVAT = self.money[i].wallet - self.money[i].wallet * gbrp.GetVAT() / 100
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = amountAfterVAT})
        self:SetBalance(self:GetBalance() + amountAfterVAT * self.launderingRatio)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.money[i].wallet)
        self.operatingCostMoney = self.operatingCostMoney + amountAfterVAT * (1 - self.launderingRatio)
        table.remove(self.money,i)
        if self.money[i] then --s'il y a encore de l'argent à blanchir
            self:launder(i,amount)
        end
    end
end

function ENT:StartRobbery(gang)
    self:SetBeingRobbed(true)
    self.robbery.startingAmount = self:GetBalance() + self:GetDirtyMoney()
    self.robbery.startingBalance = self:GetBalance()
    self.robbery.startingDirtyMoney = self:GetDirtyMoney()
    self.robbery.gang = gang
    self:SetRobberyTime(0)
end

function ENT:StopRobbery()
    self:SetBeingRobbed(false)
    self.robbery.elapsedTime = 0
    self.robbery.lt = CurTime()
end

function ENT:EndRobbery()
    self:StopRobbery()
    local leader = self:GetGang():GetLeader()
    if leader then
        net.Start("GBRP::bankruptMessage")
        net.WriteEntity(self)
        net.WriteInt(self.robbery.startingAmount,32)
        net.WriteString(self.niceName)
        net.Send(leader)
    end
end


function ENT:Think()
    if #self.money >= 1 and CurTime() > self.lastTime + self.launderingTime and not self:GetBeingRobbed() then
        self.lastTime = CurTime()
        self:launder(1,self.launderingAmount)
    elseif CurTime() > self.lastTime + 1 and self:GetBeingRobbed() and self:GetRobberyTime() < self.robbery.time then
        self.lastTime = CurTime()
        local receivers = {}
        for _,pl in pairs(player.GetAll()) do
            if pl:GetPos():Distance(self:GetPos()) < self.robbery.radius and pl:GetGang() == self.robbery.gang then
                table.insert(receivers,pl)
            end
        end
        local reward = self.robbery.startingAmount / (#receivers * self.robbery.time)
        for _,receiver in pairs(receivers) do
            receiver:addMoney(reward)
        end
        if table.IsEmpty(receivers) then
            self:StopRobbery()
        end
        self:SetBalance(self:GetBalance() - self.robbery.startingBalance / self.robbery.time)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.robbery.startingDirtyMoney / self.robbery.time)
        self:SetRobberyTime(self:GetRobberyTime() + 1)
    elseif self:GetRobberyTime() == self.robbery.time then
        self:EndRobbery()
    elseif self:GetGang() and (CurTime() > ft1 + self.startingOperatingCostTime or self.operatingCostMoney >= self.operatingCostStartingAmount) and CurTime() > ft2 + self.operatingCostSpeed then
        ft2 = CurTime()
        self.operatingCostMoney = self.operatingCostMoney - self.minimumOperatingCost
        if self.operatingCostMoney < 0 then
            self:GetGang():Pay(-self.operatingCostMoney)
            DarkRP.notify(self:GetGang():GetLeader(), 1, 4, "Votre gang paye les frais de fonctionnement de " .. self.niceName .. " : " .. gbrp.formatMoney(-self.operatingCostMoney))
            self.operatingCostMoney = 0
        else
            DarkRP.notify(self:GetGang():GetLeader(), 0, 2, "Votre " .. self.niceName .. " a payé ses frais de fonctionnement.")
            self.operatingCostMoney = 0
        end
    end
end

function ENT:SetGang(gang)
    if gang then
        self:SetGangName(gang.name)
    else
        self:SetGangName("")
    end
end