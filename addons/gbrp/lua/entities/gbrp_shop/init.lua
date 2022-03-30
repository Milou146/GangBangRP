AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

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

function ENT:launder(i,amount)
    if self.money[i].wallet >= self.launderingAmount then
        self.money[i].wallet = self.money[1].wallet - self.launderingAmount
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = self.launderingAmount})
        self:SetBalance(self:GetBalance() + self.launderingAmount * self.launderingRatio - self.launderingAmount * self.launderingRatio * gbrp.GetVAT() / 100)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.launderingAmount)
        if self.money[i].wallet == 0 then
            table.remove(self.money,i)
        end
    else
        amount = amount - self.money[i].wallet
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = self.money[i].wallet})
        self:SetBalance(self:GetBalance() + self.money[i].wallet * self.launderingRatio - self.money[i].wallet * self.launderingRatio * gbrp.GetVAT() / 100)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.money[i].wallet)
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
    end
end

function ENT:SetGang(gang)
    if gang then
        self:SetGangName(gang.name)
    else
        self:SetGangName("")
    end
end