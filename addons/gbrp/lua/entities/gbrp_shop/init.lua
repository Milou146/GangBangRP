AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.model = "models/humans/group01/male_01.mdl"

function ENT:Initialize()
    self:SetModel(self.model)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:Use(ply, caller, useType, value)
    net.Start("GBRP::shopreception")
    net.WriteEntity(self)
    net.Send(ply)
end

ENT.money = {}
ENT.launderedMoney = {}
ENT.lastTime = 0

function ENT:addLaunderedMoney(amount)
    self:SetLaunderedMoney(self:GetLaunderedMoney() + amount)
end

function ENT:laundering(i,amount)
    if self.money[i].wallet >= self.launderingAmount then
        self.money[i].wallet = self.money[1].wallet - self.launderingAmount
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = self.launderingAmount})
        self:addLaunderedMoney(self.launderingAmount)
        if self.money[i].wallet == 0 then
            table.remove(self.money,i)
        end
    else
        amount = amount - self.money[i].wallet
        table.insert(self.launderedMoney,{gangster = self.money[i].gangster,amount = self.money[i].wallet})
        self:addLaunderedMoney(self.money[i].wallet)
        table.remove(self.money,i)
        if self.money[i] then --s'il y a encore de l'argent à blanchir
            self:laundering(i,amount)
        end
    end
end


function ENT:Think()
    if #self.money >= 1 and CurTime() > self.lastTime + self.launderingTime then
        self.lastTime = CurTime()
        print("hello")
        self:laundering(1,self.launderingAmount)
    end
end