include("shared.lua")

ENT.Category = "GangBangRP"
ENT.PrintName = "Shop"
ENT.AutomaticFrameAdvance = true

function ENT:Draw()
    self:DrawModel()
end

function ENT:GetBought(ply)
    local gang = ply:GetGang()
    if self:GetGang() == gang then
        GAMEMODE:AddNotify("Votre gang possède déjà le magasin.",0,2)
    elseif not ply:IsGangChief() then
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    elseif GetGlobalInt(gang .. "Balance") - self.price >= 0 then
        net.Start("GBRP::buyshop")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez acheté le magasin.",0,2)
    else
        GAMEMODE:AddNotify("Solde insuffisant.",1,2)
    end
end

function ENT:Withdraw(ply)
    if ply:IsGangChief() then
        net.Start("GBRP::shopwithdraw")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez retiré l'argent blanchis du magasin.",0,2)
    else
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    end
end

function ENT:Collect(ply,panel)
    local textEntry = vgui.Create("DTextEntry",panel)
    textEntry:SetSize(200,25)
    textEntry:SetPlaceholderText("ex: 500")
    textEntry:Center()
    textEntry:RequestFocus()
    textEntry.OnEnter = function()
        local amount = tonumber(textEntry:GetValue())
        if amount > 0 and ply:getDarkRPVar("money") - amount >= 0 then
            net.Start("GBRP::shopdeposit")
            net.WriteUInt(amount,32)
            net.WriteEntity(self)
            net.SendToServer()
            GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
        elseif amount <= 0 then
            GAMEMODE:AddNotify("Valeur non valide.",1,2)
        else
            GAMEMODE:AddNotify("Solde insuffisant.",1,2)
        end
        textEntry:Remove()
    end
end

function ENT:GetSelled(ply)
    if ply:IsGangChief() then
        net.Start("GBRP::sellshop")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez vendu le magasin.",0,2)
    else
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    end
end