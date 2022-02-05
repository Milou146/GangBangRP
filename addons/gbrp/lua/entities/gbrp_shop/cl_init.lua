include("shared.lua")

ENT.Category = "GangBangRP"
ENT.PrintName = "Shop"
ENT.AutomaticFrameAdvance = true

function ENT:Draw()
    self:DrawModel()
end

function ENT:GetBought(ply)
    local gang = ply:GetGang()
    if self:GetGang() and self:GetGang() ~= gang then
        GAMEMODE:AddNotify("Ce magasin appartient à un autre gang.",1,2)
    elseif self:GetGang() == gang then
        GAMEMODE:AddNotify("Votre gang possède déjà le magasin.",0,2)
    elseif not ply:IsGangLeader() then
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    elseif not gang:CanAfford(self.price) then
        GAMEMODE:AddNotify("Solde insuffisant.",1,2)
    elseif #gang:GetShops() >= 5 then
        GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de magasins en sa possession.",1,2)
    else
        net.Start("GBRP::buyshop")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez acheté le magasin.",0,2)
    end
end

function ENT:Withdraw(ply)
    if ply:IsGangLeader() then
        net.Start("GBRP::shopwithdraw")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez retiré l'argent blanchis du magasin.",0,2)
    else
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    end
end

function ENT:Collect(ply,panel)
    panel:SetKeyboardInputEnabled(true)
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
            GAMEMODE:AddNotify("Vous avez déposé " .. DarkRP.formatMoney( amount ) .. ".",0,2)
        elseif amount <= 0 then
            GAMEMODE:AddNotify("Valeur non valide.",1,2)
        else
            GAMEMODE:AddNotify("Solde insuffisant.",1,2)
        end
        panel:SetKeyboardInputEnabled(false)
        textEntry:Remove()
    end
end

function ENT:GetSelled(ply)
    if ply:IsGangLeader() then
        net.Start("GBRP::sellshop")
        net.WriteEntity(self)
        net.SendToServer()
        GAMEMODE:AddNotify("Vous avez vendu le magasin.",0,2)
    else
        GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
    end
end