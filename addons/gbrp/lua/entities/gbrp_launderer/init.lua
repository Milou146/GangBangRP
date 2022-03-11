AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.cash = {}
ENT.money = {}
ENT.gainRate = .2
ENT.moneyRate = 1000
ENT.timeRate = 1
local ft = CurTime()
local laundered

function ENT:Initialize()
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:Think()
    if CurTime() - ft > self.timeRate then
        for k,v in pairs(self.cash) do
            if self.cash[k] > 0 then
                laundered = self.cash[k] * self.gainRate
                self.cash[k] = math.Clamp(self.cash[k] - self.moneyRate,0,1000000000000000000000000000)
                if self.cash[k] ~= 0 then
                    laundered = self.moneyRate * self.gainRate
                end
                if self.money[k] then
                    self.money[k] = self.money[k] + laundered
                else
                    self.money[k] = laundered
                end
            end
        end
    end
end

function ENT:Use(ply, caller, useType, value)
    if self.money[ply] and self.money[ply] > 0 then
        ply:ChatPrint("Vous récupérez " .. gbrp.formatMoney(self.money[ply]) .. " à encaisser à la banque.")
        ply:SetNWInt("GBRP::personnalLaunderedMoney",ply:GetNWInt("GBRP::personnalLaunderedMoney") + self.money[ply])
        self.money[ply] = 0
    else
        net.Start("GBRP::laundererReception")
        net.WriteEntity(self)
        net.Send(ply)
    end
end