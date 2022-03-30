local plyMeta = FindMetaTable("Player")
function plyMeta:IsGangLeader()
    return self:getJobTable().class == "leader"
end
function plyMeta:GetGBRPClass()
    return self:getJobTable().class
end
function plyMeta:GetGang()
    return self:getJobTable().gang;
end
function plyMeta:GetBalance()
    return self:GetNWInt("GBRP::balance")
end
function plyMeta:CanAfford(amount)
    return self:GetBalance() - amount >= 0;
end
if CLIENT then
    function plyMeta:BuyShop(shop)
        local gang = self:GetGang()
        if shop:GetGang() and shop:GetGang() ~= gang then
            GAMEMODE:AddNotify("Ce magasin appartient à un autre gang.",1,2)
        elseif shop:GetGang() == gang then
            GAMEMODE:AddNotify("Votre gang possède déjà le magasin.",0,2)
        elseif not self:IsGangLeader() then
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        elseif not gang:CanAfford(shop.price) then
            GAMEMODE:AddNotify("Solde insuffisant.",1,2)
        elseif #gang:GetShops() >= 4 then
            GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de magasins en sa possession.",1,2)
        else
            net.Start("GBRP::buyshop")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/buy_sell.mp3")
            GAMEMODE:AddNotify("Vous avez acheté le magasin.",0,2)
        end
    end
    function plyMeta:SellShop(shop)
        if self:IsGangLeader() then
            net.Start("GBRP::sellshop")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/buy_sell.mp3")
            GAMEMODE:AddNotify("Vous avez vendu le magasin.",0,2)
        else
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        end
    end
    function plyMeta:WithdrawLaunderedMoney(shop)
        if self:IsGangLeader() then
            net.Start("GBRP::shopwithdraw")
            net.WriteEntity(shop)
            net.SendToServer()
            surface.PlaySound("gui/gbrp/withdraw.wav")
            GAMEMODE:AddNotify("Vous avez retiré l'argent blanchis du magasin.",0,2)
        else
            GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
        end
    end
    function plyMeta:DropCash(frame)
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry:RequestFocus()
        textEntry.OnEnter = function()
            local amount = tonumber(textEntry:GetValue())
            if amount > 0 and self:getDarkRPVar("money") - amount > 4 then
                net.Start("GBRP::shopdeposit")
                net.WriteUInt(amount,32)
                net.WriteEntity(frame.shop)
                net.SendToServer()
                surface.PlaySound("gui/gbrp/dropcash.wav")
                GAMEMODE:AddNotify("Vous avez déposé " .. DarkRP.formatMoney( amount ) .. ".",0,2)
            elseif amount <= 4 then
                GAMEMODE:AddNotify("Veuillez mettre au moins $5",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
            textEntry:Remove()
        end
    end
end
if SERVER then
    function plyMeta:AddLaunderedMoney(amount)
        self:SetNWInt("GBRP::launderedmoney", self:GetNWInt("GBRP::launderedmoney") + amount)
    end
    function plyMeta:Cash(pay)
        self:SetNWInt("GBRP::balance",self:GetBalance() + pay);
        sql.Query("update gbrp set balance = " .. self:GetNWInt("GBRP::balance") .. " where steamid64 = " .. self:SteamID64() .. ";");
    end
    function plyMeta:Pay(amount)
        self:SetNWInt("GBRP::balance",self:GetBalance() - amount);
        sql.Query("update gbrp set balance = " .. self:GetNWInt("GBRP::balance") .. " where steamid64 = " .. self:SteamID64() .. ";");
    end
    function plyMeta:SetupHands(ply)
        ply = ply or self
        local model = self:GetModel()
        local hands = self:GetHands()
        hands = ents.Create( "gmod_hands" )
        hands:DoSetup(self, ply)
        if gbrp.c_arms[model] then
            for k,v in pairs(gbrp.c_arms[model]) do
                hands:SetBodygroup(v.bgid, v.bodygroups[self:GetBodygroup(k)])
                if v.skins then
                    hands:SetSkin(v.skins[self:GetBodygroup(k)])
                end
            end
        end
        hands:Spawn()
    end
end