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
    if shopGang and ply:GetGang() and ply:GetGang() != shopGang then
        net.Start("GBRP::robberyPanel")
        net.WriteEntity(self)
        net.Send(ply)
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
        self:SetBalance(self:GetBalance() + self.launderingAmount * self.launderingRatio)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.launderingAmount)
        if self.money[i].wallet == 0 then
            table.remove(self.money,i)
        end
    else
        amount = amount - self.money[i].wallet
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = self.money[i].wallet})
        self:SetBalance(self:GetBalance() + self.money[i].wallet * self.launderingRatio)
        self:SetDirtyMoney(self:GetDirtyMoney() - self.money[i].wallet)
        table.remove(self.money,i)
        if self.money[i] then --s'il y a encore de l'argent à blanchir
            self:launder(i,amount)
        end
    end
end


function ENT:Think()
    if #self.money >= 1 and CurTime() > self.lastTime + self.launderingTime then
        self.lastTime = CurTime()
        self:launder(1,self.launderingAmount)
    end
end

function ENT:SetGang(gang)
    if gang then
        self:SetGangName(gang.name)
    else
        self:SetGangName("")
    end
end