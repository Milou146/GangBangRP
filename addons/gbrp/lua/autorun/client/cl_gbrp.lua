-------------------------------
-- M I S C E L L A N E O U S --
-------------------------------

surface.CreateFont("BankLarge",{
    font = "Banks Miles Single Line",
    size = 48
})
surface.CreateFont("Bank",{
    font = "Banks Miles Single Line",
    size = 36
})
surface.CreateFont("BankSmall",{
    font = "Banks Miles Single Line",
    size = 24
})
surface.CreateFont("DermaHuge",{
    font = "Verdana",
    size = 48
})

local ft = 0
local panelOpen = false
local gangPanelOpen = false
local woundedMat = Material("gui/gbrp/wounded.png")
local function FormatNumber(n)
    n = tostring(n)
    if #n < 3 then
        return n
    elseif #n <= 6 then
        return string.Left(n,#n - 3) .. "k"
    elseif #n <= 9 then
        return string.Left(n,#n - 6) .. "M"
    else
        return string.Left(n,#n - 9) .. "Mds"
    end
end

-----------------
-- P A N E L S --
-----------------

local PANEL = {}
function PANEL:OnCursorEntered()
    self:SetImage(string.StripExtension(self:GetImage()) .. "rollover.png")
end
function PANEL:OnCursorExited()
    self:SetImage(string.sub(self:GetImage(),1,#self:GetImage() - 12) .. ".png")
end
vgui.Register("GBRPButton",PANEL,"DImageButton")
PANEL = {}
function PANEL:DoClick()
    LocalPlayer():BuyShop(self:GetParent().shop)
end
vgui.Register("BuyShopButton",PANEL,"GBRPButton")
PANEL = {}
function PANEL:DoClick()
    LocalPlayer():SellShop(self:GetParent().shop)
    self:GetParent():Remove()
    panelOpen = false
end
vgui.Register("SellShopButton",PANEL,"GBRPButton")
PANEL = {}
function PANEL:DoClick()
    LocalPlayer():WithdrawLaunderedMoney(self:GetParent().shop)
end
vgui.Register("WithdrawLaunderedMoneyButton",PANEL,"GBRPButton")
PANEL = {}
function PANEL:DoClick()
    LocalPlayer():DropCash(self:GetParent())
end
vgui.Register("DropCashButton",PANEL,"GBRPButton")
PANEL = {}
function PANEL:DoClick()
    surface.PlaySound("gui/gbrp/remove_customerarea.wav")
    self:GetParent():Remove()
    panelOpen = false
end
vgui.Register("RemoveButton",PANEL,"GBRPButton")

local hide = {
    ["CHudHealth"] = true,
    --["CHudAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudBattery"] = true
}

---------------
-- H O O K S --
---------------

hook.Add("HUDShouldDraw","GBRP::HideHUD",function(name)
    if hide[name] then
        return false
    end
end)
hook.Add("onKeysMenuOpened","GBRP::DoorMenu",function(ent,darkrpframe)
    darkrpframe:Close()
    if panelOpen then return end
    local ply = LocalPlayer()
    if gbrp.doors[ent:EntIndex()] then
        local gang = ply:GetGang()
        if not gbrp.doors[ent:EntIndex()].buyable then
            GAMEMODE:AddNotify("Cette propriété n'est pas à vendre.",1,2)
        elseif not ent:getDoorData().groupOwn and not ent:getDoorData().owner then
            panelOpen = true

            local frame = vgui.Create("EditablePanel",GetHUDPanel())
            frame:SetSize(800,400)
            frame:Center()
            frame:MakePopup()
            frame.mat = Material("gui/gbrp/property/frame.jpg")
            function frame:Paint(w,h)
                surface.SetDrawColor(Color(255,255,255,255))
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetTextPos(275,134)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet24")
                surface.DrawText(gbrp.formatMoney(gbrp.doors[ent:EntIndex()].price))

                surface.SetTextPos(51,362)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Bank")
                surface.DrawText(gbrp.formatMoney(gang:GetBalance()))
            end

            local buy = vgui.Create("GBRPButton",frame)
            buy:SetPos(242,86)
            buy:SetImage("gui/gbrp/property/buy.png")
            buy:SizeToContents()
            function buy:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif not gang:CanAfford(gbrp.doors[ent:EntIndex()].price) then
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                elseif #gang:GetProperties() >= 10 then
                    GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de propriétés en sa possession.",1,2)
                else
                    net.Start("GBRP::buyproperty")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                frame:Remove()
                panelOpen = false
            end

            local remove = vgui.Create("RemoveButton",frame)
            remove:SetImage("gui/gbrp/jewelrystore/remove.png")
            remove:SetPos(766,9)
            remove:SizeToContents()
        elseif ent:getDoorData().groupOwn == gang.name or ent:getDoorData().owner == ply:UserID() then
            panelOpen = true

            local counter = {
                frame = Material("gui/gbrp/property/counter.png"),
                [0] = Material("gui/gbrp/property/0.png"),
                [1] = Material("gui/gbrp/property/1.png"),
                [2] = Material("gui/gbrp/property/2.png")
            }

            local frame = vgui.Create("EditablePanel",GetHUDPanel())
            frame:SetSize(800,400)
            frame:Center()
            frame:MakePopup()
            frame.mat = Material("gui/gbrp/property/frame.jpg")
            function frame:Paint(w,h)
                surface.SetDrawColor(Color(255,255,255,255))
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetTextPos(275,134)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet24")
                surface.DrawText(gbrp.formatMoney(gbrp.doors[ent:EntIndex()].value))

                surface.SetTextPos(51,362)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Bank")
                surface.DrawText(gbrp.formatMoney(gang:GetBalance()))

                surface.SetMaterial(counter.frame)
                surface.DrawTexturedRect(419,45,27,35)

                surface.SetMaterial(counter[gang:GetPrivateDoorsCount()])
                surface.DrawTexturedRect(418,47,15,18)
            end

            local sell = vgui.Create("GBRPButton",frame)
            sell:SetPos(259,86)
            sell:SetImage("gui/gbrp/property/sell.png")
            sell:SizeToContents()
            function sell:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif gbrp.doors[ent:EntIndex()].owner == gang.name then
                    ply:ChatPrint("Vous ne pouvez pas vendre la résidence principale du gang.")
                else
                    net.Start("GBRP::sellproperty")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                frame:Remove()
                panelOpen = false
            end

            local remove = vgui.Create("RemoveButton",frame)
            remove:SetImage("gui/gbrp/jewelrystore/remove.png")
            remove:SetPos(766,9)
            remove:SizeToContents()

            local privatize = vgui.Create("GBRPButton",frame)
            privatize:SetPos(237,45)
            privatize:SetImage("gui/gbrp/property/privatize.png")
            privatize:SizeToContents()
            privatize.DoClick = function()
                RunConsoleCommand("privatizedoor",tostring(ent:EntIndex()))
                privatize:SetEnabled(false)
            end
            privatize:SetEnabled(ent:getDoorData().owner ~= ply:UserID() and gang:GetPrivateDoorsCount() < 2)
        else
            GAMEMODE:AddNotify("Cette propriété a déjà un propriétaire.",1,2)
        end
    end
end)
hook.Add("StartChat","GBRP::StartChat",function()
    gangPanelOpen = true
end)
hook.Add("FinishChat","GBRP::FinishChat",function()
    gangPanelOpen = false
end)
hook.Add("OnSpawnMenuOpen","GBRP::OnSpawnMenuOpen",function()
    gangPanelOpen = true
end)
hook.Add("OnSpawnMenuClose","GBRP::OnSpawnMenuClose",function()
    gangPanelOpen = false
end)
hook.Add("Think","GBRP::GangMenu",function()
    local ply = LocalPlayer()
    if input.IsKeyDown(KEY_M) and not gangPanelOpen and CurTime() - ft > 2 then
        ft = CurTime()
        if not ply:IsGangLeader() then ply:ChatPrint("Ce menu est réservé au chef de gang ;)") return end
        gangPanelOpen = true
        local gang = ply:GetGang()
        local gangproperties = gang:GetProperties()
        local gangshops = gang:GetShops()
        local panelMat = Material("gui/gbrp/gangpanel/panel.png")
        local graduationMat = Material("gui/gbrp/gangpanel/graduation.png")
        local panel = vgui.Create("EditablePanel",GetHUDPanel())
        local membersbarMat = Material("gui/gbrp/gangpanel/membersbar.png")
        local earningsbarMat = Material("gui/gbrp/gangpanel/earningsbar.png")
        local expensesbarMat = Material("gui/gbrp/gangpanel/expensesbar.png")
        panel:SetSize(1080,720)
        panel:Center()
        function panel:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(panelMat)
            surface.DrawTexturedRect(0,0,w,h)
            surface.SetFont("DermaLarge")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(19,25)
            surface.DrawText(string.upper(gang.name))
            surface.SetFont("DermaHuge")
            surface.SetTextColor(250,165,0)
            surface.SetTextPos(336,15)
            surface.DrawText(": " .. gbrp.formatMoney(gang:GetBalance()))
            surface.SetTextPos(127,531)
            surface.DrawText(": " .. tostring(table.Count(gangproperties)))
            surface.SetTextPos(127,365)
            surface.DrawText(": " .. tostring(#gangshops))
            surface.SetTextPos(127,195)
            surface.DrawText(": " .. tostring(gang:GetMembersCount()))
            local i = 0
            local j = 0
            for k,v in pairs(gangproperties) do
                surface.SetMaterial(gbrp.gangpanel.properties[v].mat)
                surface.DrawTexturedRect(319 + gbrp.gangpanel.properties[v].x + i * 72,504 + gbrp.gangpanel.properties[v].y + j * 70,gbrp.gangpanel.properties[v].mat:Width(),gbrp.gangpanel.properties[v].mat:Height())
                i = i + 1
                if i == 5 then i = 0; j = 1 end
            end
            i = 0
            j = 0
            for k,v in pairs(gangshops) do
                surface.SetMaterial(gbrp.gangpanel.shops[v].mat)
                surface.DrawTexturedRect(319 + gbrp.gangpanel.shops[v].x + i * 72,324 + gbrp.gangpanel.shops[v].y + j * 70,gbrp.gangpanel.shops[v].mat:Width(),gbrp.gangpanel.shops[v].mat:Height())
                i = i + 1
                if i == 5 then i = 0; j = 1 end
            end
            GWEN.CreateTextureBorder(0,0,24,275,8,8,8,8,earningsbarMat)(803,364 + 300 * gang:GetExpenses() / (gang:GetEarnings() + gang:GetExpenses()),24,300 - 300 * gang:GetExpenses() / (gang:GetEarnings() + gang:GetExpenses()))
            surface.SetFont("DermaLarge")
            surface.SetTextColor(0,255,0)
            surface.SetTextPos(803,364 + 300 * gang:GetExpenses() / (gang:GetEarnings() + gang:GetExpenses()) - 40)
            surface.DrawText(FormatNumber(gang:GetEarnings()))
            GWEN.CreateTextureBorder(0,0,24,208,8,8,8,8,expensesbarMat)(912,364 + 300 * gang:GetEarnings() / (gang:GetEarnings() + gang:GetExpenses()),24,300 - 300 * gang:GetEarnings() / (gang:GetEarnings() + gang:GetExpenses()))
            surface.SetFont("DermaLarge")
            surface.SetTextColor(255,0,0)
            surface.SetTextPos(912,364 + 300 * gang:GetEarnings() / (gang:GetEarnings() + gang:GetExpenses()) - 40)
            surface.DrawText(FormatNumber(gang:GetExpenses()))
            GWEN.CreateTextureBorder(0,0,155,15,8,8,8,8,membersbarMat)(303,205,16,15)
            GWEN.CreateTextureBorder(0,0,155,15,8,8,8,8,membersbarMat)(318,205,721 * gang:GetMembersCount() / 10,15)
            surface.SetMaterial(graduationMat)
            surface.DrawTexturedRect(388,205,570,75)
        end
        panel:MakePopup()
        local close = vgui.Create("DImageButton",panel)
        close:SetPos(1027,0)
        close:SetSize(53,82)
        function close:DoClick()
            panel:Remove()
            gangPanelOpen = false
        end
    end
end)
hook.Add("HUDPaint","GBRP::HUD",function()
    if LocalPlayer():Health() < 100 then
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(woundedMat)
        surface.DrawTexturedRect(1842,981,46,84)
    end
end)

-----------
-- N E T --
-----------

net.Receive("GBRP::doorsinit",function()
    gbrp.doors = {}
    for k = 1,net.ReadInt(32) do
        gbrp.doors[net.ReadInt(32)] = net.ReadTable()
    end
end)
net.Receive("GBRP::bankreception", function()
    if panelOpen then return end
    panelOpen = true
    local gender = net.ReadString()
    surface.PlaySound(gbrp.voices[gender][math.random(1,#gbrp.voices[gender])])
    local ply = LocalPlayer()
    local SW = ScrW()
    local SH = ScrH()
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1016,550)
    frame:SetPos(SW / 2 -frame:GetWide() / 2, SH)
    frame:MakePopup()
    frame.mat = Material("gui/gbrp/bank/frame.png")
    function frame:Think()
        if self:GetY() ~= SH - 550 then
            self:SetY(self:GetY() - 25)
        end
    end
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetFont("Bank")
        surface.SetTextPos(233,366)
        surface.SetTextColor(0,0,0,255)
        surface.DrawText("SOLDE: " .. gbrp.formatMoney(ply:GetNWInt("GBRP::balance")))
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetImage("gui/gbrp/bank/remove.png")
    remove:SetPos(745,22)
    remove:SizeToContents()

    local depositButton = vgui.Create("GBRPButton",frame)
    depositButton:SetImage("gui/gbrp/bank/deposit.png")
    depositButton:SetPos(288,182)
    depositButton:SetSize(166,65)
    depositButton.DoClick = function()
        local amount = ply:GetNWInt("GBRP::launderedmoney")
        if amount > 0 then
            net.Start("GBRP::bankdeposit")
            net.SendToServer()
            frame:Remove()
            panelOpen = false
            GAMEMODE:AddNotify("Vous avez déposé $" .. amount .. ".",0,2)
            surface.PlaySound("gui/gbrp/bank/deposit.wav")
        else
            GAMEMODE:AddNotify("Vous n'avez pas d'argent blanchi sur vous.",1,2)
        end
    end

    local withdrawButton = vgui.Create("GBRPButton",frame)
    withdrawButton:SetImage("gui/gbrp/bank/withdraw.png")
    withdrawButton:SetPos(569,182)
    withdrawButton:SetSize(166,65)
    withdrawButton.DoClick = function()
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry:RequestFocus()
        textEntry.OnEnter = function(self)
            local amount = tonumber(self:GetValue())
            if amount > 0 and ply:GetNWInt("GBRP::balance") - amount >= 0 then
                net.Start("GBRP::bankwithdraw")
                net.WriteUInt(amount,32)
                net.SendToServer()
                GAMEMODE:AddNotify("Vous avez retiré $" .. amount .. ".",0,2)
                surface.PlaySound("gui/gbrp/bank/withdraw.wav")
            elseif amount <= 0 then
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
            self:Remove()
        end
    end
end)
net.Receive("GBRP::jewelrystoreReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local shopbalMat = Material("gui/gbrp/jewelrystore/shopbal.png")
    local shopvalMat = Material("gui/gbrp/jewelrystore/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:SetPos(371,116)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/jewelrystore/frame.png")
    frame.panelMat = Material("gui/gbrp/jewelrystore/panel.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(self.panelMat)
        surface.DrawTexturedRect(76,99,403,531)
        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(93,644)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("BankSmall")
        surface.SetTextPos(193,322)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
        surface.SetTextPos(193,352)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(643,201)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/jewelrystore/customerarea.png")
    customerArea:SetPos(643,416)
    customerArea:SizeToContents()
    function customerArea:DoClick()
        surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        if shop:GetGang() == gang then
            buy:Remove()
            self:Remove()

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash:SetImage("gui/gbrp/jewelrystore/dropcash.png")
            dropcash:SizeToContents()
            dropcash:SetPos(83,166)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw:SetImage("gui/gbrp/jewelrystore/withdraw.png")
            withdraw:SizeToContents()
            withdraw:SetPos(448,166)

            local sell = vgui.Create("SellShopButton",frame)
            sell:SetImage("gui/gbrp/jewelrystore/sell.png")
            sell:SizeToContents()
            sell:SetPos(816,166)

            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())

                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(93,644)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end

                surface.SetMaterial(shopbalMat)
                surface.DrawTexturedRect(238,489,321,68)

                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)

                surface.SetFont("BankSmall")
                surface.SetTextPos(349,525)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(84,385,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(84,385,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(577,331)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(gbrp.formatMoney(shop.value))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SetPos(1112,48)
    remove:SizeToContents()
end)
net.Receive("GBRP::clubReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local subpanelMat = Material("gui/gbrp/club/subpanel.png")
    local shopbalMat = Material("gui/gbrp/club/shopbal.png")
    local shopvalMat = Material("gui/gbrp/club/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1396,716)
    frame:SetPos(371,116)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/club/frame.png")
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(subpanelMat)
        surface.DrawTexturedRect(149,95,403,531)
        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(166,640)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("BankSmall")
        surface.SetTextPos(266,319)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
        surface.SetTextPos(266,349)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(716,197)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/jewelrystore/customerarea.png")
    customerArea:SetPos(716,412)
    customerArea:SizeToContents()
    function customerArea:DoClick()
        surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        if shop:GetGang() == gang then
            buy:Remove()
            self:Remove()
            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash:SetImage("gui/gbrp/jewelrystore/dropcash.png")
            dropcash:SizeToContents()
            dropcash:SetPos(156,162)

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw:SetImage("gui/gbrp/jewelrystore/withdraw.png")
            withdraw:SizeToContents()
            withdraw:SetPos(521,162)

            local sell = vgui.Create("SellShopButton",frame)
            sell:SetImage("gui/gbrp/jewelrystore/sell.png")
            sell:SizeToContents()
            sell:SetPos(889,162)

            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())

                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(166,640)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end

                surface.SetMaterial(shopbalMat)
                surface.DrawTexturedRect(311,485,321,68)

                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(755,485,321,68)

                surface.SetFont("BankSmall")
                surface.SetTextPos(349,525)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(157,381,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(157,381,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

                surface.SetFont("Bank")
                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(652,332)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(gbrp.formatMoney(shop.value))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SetPos(1189,45)
    remove:SizeToContents()
end)
net.Receive("GBRP::gasstationReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local leftpanelMat = Material("gui/gbrp/gasstation/page1/leftpanel.png")
    local rightpanelMat = Material("gui/gbrp/gasstation/page1/rightpanel.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1376,1005)
    frame:SetPos(287,75)
    frame:MakePopup()
    frame.mat = Material("gui/gbrp/gasstation/frame.png")
    frame.shop = shop
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        -- F R A M E --
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)
        -- L E F T -- P A N E L --
        surface.SetMaterial(leftpanelMat)
        surface.DrawTexturedRect(167,127,465,539)
        -- R I G H T -- P A N E L --
        surface.SetMaterial(rightpanelMat)
        surface.DrawTexturedRect(853,274,382,373)
        -- S O L D E -- D U -- G A N G --
        surface.SetFont("Bank")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(177,681)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        -- V A L E U R --
        surface.SetFont("BankSmall")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(943,280)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
        -- P R I X --
        surface.SetTextColor(255,0,0,255)
        surface.SetTextPos(194,630)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
    end

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SetPos(178,135)
    remove:SizeToContents()

    local function LoadPageThree()
        remove:SetPos(178,135)

        leftpanelMat = Material("gui/gbrp/gasstation/page3/leftpanel.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page3/rightpanel.png")
        local dollar = Material("gui/gbrp/gasstation/page3/dollar.png")
        local bluecard = Material("gui/gbrp/gasstation/page3/bluecard.png")
        local cheque = Material("gui/gbrp/gasstation/page3/cheque.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            -- F R A M E --
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)
            -- L E F T -- P A N E L --
            surface.SetMaterial(leftpanelMat)
            surface.DrawTexturedRect(168,127,464,506)
            -- R I G H T -- P A N E L --
            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(837,256,382,373)

            surface.SetMaterial(dollar)
            surface.DrawTexturedRect(692,306,83,320)

            surface.SetMaterial(bluecard)
            surface.DrawTexturedRect(1030,156,191,69)

            surface.SetMaterial(cheque)
            surface.DrawTexturedRect(837,156,191,69)
            -- S O L D E -- D U -- J O U E U R --
            surface.SetFont("Bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            surface.DrawText("VOTRE SOLDE: " .. gbrp.formatMoney(ply:GetBalance()))
        end
        local food = {
            [1] =   {classname = "eft_food_mre",            y = 195, price = 15},
            [2] =   {classname = "eft_food_beefstew",       y = 236, price = 7},
            [3] =   {classname = "eft_food_beefstew_family",y = 277, price = 10},
            [4] =   {classname = "eft_food_canned_fish",    y = 317, price = 3},
            [5] =   {classname = "eft_food_peas",           y = 357, price = 8},
            [6] =   {classname = "eft_food_squash",         y = 396, price = 9},
            [7] =   {classname = "eft_food_hotrod",         y = 443, price = 12},
            [8] =   {classname = "eft_food_juice",          y = 488, price = 6},
            [9] =   {classname = "eft_food_oatmeal",        y = 531, price = 3},
            [10] =  {classname = "eft_food_water",          y = 574, price = 6}
        }
        local bill = 0
        local pretext = ""
        for k = 1,(10 - #tostring(bill)) do
            pretext = pretext .. " "
        end
        local shoppingBasket = ""
        local billLabel = vgui.Create("DLabel",frame)
        billLabel:SetFont("Bank")
        billLabel:SetText( pretext .. "$" .. tostring(bill))
        billLabel:SetTextColor(Color(0,0,0))
        billLabel:SetPos(1030,258)
        billLabel:SizeToContents()
        for k,v in pairs(food) do
            v.button = vgui.Create("GBRPButton",frame)
            v.button:SetImage("gui/gbrp/gasstation/page3/button.png")
            v.button:SetSize(71,28)
            v.button:SetPos(482,v.y)
            function v.button:DoClick()
                shoppingBasket = v.classname
                bill = v.price
                pretext = ""
                for key = 1,(10 - #tostring(bill)) do
                    pretext = pretext .. " "
                end
                billLabel:SetText( pretext .. "$" .. tostring(bill))
                billLabel:SizeToContents()
            end
            v.priceLabel = vgui.Create("DLabel",frame)
            v.priceLabel:SetText(gbrp.formatMoney(v.price))
            v.priceLabel:SetFont("Trebuchet24")
            v.priceLabel:SizeToContents()
            v.priceLabel:SetPos(518 - v.priceLabel:GetWide() / 2,v.y)
            v.priceLabel:SetColor(Color(0,0,0))
        end

        local confirm = vgui.Create("GBRPButton",frame)
        confirm:SetImage("gui/gbrp/gasstation/page3/confirm.png")
        confirm:SetPos(1094,422)
        confirm:SizeToContents()
        function confirm:DoClick()
            if shoppingBasket == "" then GAMEMODE:AddNotify("Veuillez sélectionner un article.",1,2) return end
            if ply:CanAfford(bill) then
                frame:Remove()
                panelOpen = false
                net.Start("GBRP::buyfood")
                net.WriteString(shoppingBasket)
                net.WriteInt(bill,7)
                net.SendToServer()
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local function LoadPageTwo()
        local dropcash = vgui.Create("DropCashButton",frame)
        dropcash:SetImage("gui/gbrp/jewelrystore/dropcash.png")
        dropcash:SizeToContents()
        dropcash:SetPos(817,181)

        local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
        withdraw:SetImage("gui/gbrp/jewelrystore/withdraw.png")
        withdraw:SizeToContents()
        withdraw:SetPos(817,315)

        local sell = vgui.Create("SellShopButton",frame)
        sell:SetImage("gui/gbrp/jewelrystore/sell.png")
        sell:SizeToContents()
        sell:SetPos(817,447)

        remove:SetPos(786,101)

        local shopaccess = vgui.Create("GBRPButton",frame)
        shopaccess:SetImage("gui/gbrp/gasstation/page2/shopaccess.png")
        shopaccess:SetPos(226,169)
        shopaccess:SizeToContents()
        function shopaccess:DoClick()
            self:Remove()
            dropcash:Remove()
            withdraw:Remove()
            sell:Remove()
            LoadPageThree()
        end
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        local shopbalMat = Material("gui/gbrp/gasstation/page2/shopbal.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page2/rightpanel.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(776,93,465,539)

            surface.SetFont("Bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            if ply:IsGangLeader() then
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
            else
                surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
            end

            surface.SetMaterial(shopbalMat)
            surface.DrawTexturedRect(174,548,321,68)

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(285,587)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(174,637,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(174,637,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

            surface.SetFont("Bank")
            surface.SetTextPos(616,563)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,0,0,255)
            surface.SetTextPos(836,601)
            surface.DrawText(gbrp.formatMoney(shop.value))
        end
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(853,129)

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/gasstation/page1/customerarea.png")
    customerArea:SetPos(670,129)
    customerArea:SizeToContents()
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            LoadPageTwo()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::gunshopReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local panel = Material("gui/gbrp/gunshop/page1/panel.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetPos(376,137)
    frame:SetSize(1220,943)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/gunshop/frame.png")
    function frame:Paint(w,h)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(panel)
        surface.DrawTexturedRect(34,62,1132,608)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(93,670)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(149,210)

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetPos(1119,76)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SizeToContents()

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/jewelrystore/customerarea.png")
    customerArea:SetPos(656,211)
    customerArea:SizeToContents()
    function LoadPageThree()
        local urlbar = Material("gui/gbrp/gunshop/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/gunshop/page3/sidebar.png")
        local quickguns = Material("gui/gbrp/gunshop/page2/quickguns.png")
        function frame:Paint(w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(urlbar)
            surface.DrawTexturedRect(34,62,1132,52)

            surface.SetMaterial(sidebar)
            surface.DrawTexturedRect(1136,114,30,555)

            surface.SetMaterial(quickguns)
            surface.DrawTexturedRect(569,250,97,284)

            surface.SetDrawColor(162,8,8,230)
            surface.DrawRect(120,127,956,89)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(120,216,956,351)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(120,587,468,44)

            surface.SetDrawColor(0,0,0,178)
            surface.DrawRect(607,587,332,44)

            surface.SetFont("BankLarge")
            surface.SetTextColor(255,255,255,166)
            surface.SetTextPos(461,144)
            surface.DrawText("A  R  M  U  R  E  R  I  E")

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(93,670)
            surface.DrawText("VOTRE SOLDE: " .. gbrp.formatMoney(ply:GetBalance()))
        end

        local wep = {
            [1] = {classname = "weapon_breachingcharge",x = 152,    y = 230,    name = "C4",                price = 2500},
            [2] = {classname = "arccw_go_nade_smoke",   x = 168,    y = 298,    name = "M5210 Smoke",       price = 2500},
            [3] = {classname = "arccw_go_nade_molotov", x = 146,    y = 383,    name = "Coktail Molotov",   price = 2500},
            [4] = {classname = "arccw_go_nade_frag",    x = 157,    y = 491,    name = "M67 FRAG",          price = 2500},
            [5] = {classname = "arccw_bo2_fnp45",       x = 292,    y = 230,    name = "FNP-45",            price = 2500},
            [6] = {classname = "arccw_bo2_kard",        x = 416,    y = 230,    name = "TDI Kard",          price = 2500},
            [7] = {classname = "arccw_bo2_xpr50",       x = 888,    y = 229,    name = "XPR-50",            price = 2500},
            [8] = {classname = "arccw_bo2_scorpion",    x = 259,    y = 306,    name = "Scorpion Evo 3",    price = 2500},
            [9] = {classname = "arccw_bo2_s12",         x = 889,    y = 479,    name = "Saiga 12K",         price = 2500},
            [10] = {classname = "arccw_bo2_ksg",        x = 672,    y = 479,    name = "KSG",               price = 2500},
            [11] = {classname = "arccw_bo2_type95",     x = 669,    y = 298,    name = "QBZ-95-1",          price = 2500},
            [12] = {classname = "arccw_bo2_msmc",       x = 258,    y = 494,    name = "JPVC",              price = 2500},
            [13] = {classname = "arccw_bo2_pdw57",      x = 416,    y = 306,    name = "PDW-57",            price = 2500},
            [14] = {classname = "arccw_waw_thompson",   x = 409,    y = 490,    name = "Thompson",          price = 2500},
            [15] = {classname = "arccw_bo2_mtar",       x = 413,    y = 406,    name = "MTAR-21",           price = 5000},
            [16] = {classname = "arccw_bo2_mp7",        x = 289,    y = 401,    name = "HK MP7 A1",         price = 2500},
            [17] = {classname = "arccw_bo2_m27",        x = 668,    y = 388,    name = "HK-416",            price = 2500},
            [18] = {classname = "arccw_bo2_scarh",      x = 891,    y = 388,    name = "FN SCAR-H",         price = 2500},
            [19] = {classname = "arccw_bo2_osw",        x = 667,    y = 230,    name = "DSA SA 58",         price = 10000},
            [20] = {classname = "arccw_bo2_an94",       x = 887,    y = 298,    name = "AN-94",             price = 2500},
        }
        local selected = nil
        for k,v in pairs(wep) do
            v.button = vgui.Create("DImageButton",frame)
            v.button:SetPos(v.x,v.y)
            v.button:SetImage("gui/gbrp/gunshop/page3/" .. v.classname .. ".png")
            v.button:SizeToContents()

            v.label = vgui.Create("DLabel",frame)
            v.label:SetColor(Color(255,255,255,255))
            v.label:SetFont("CloseCaption_BoldItalic")
            v.label:SetText(v.name)
            v.label:SizeToContents()
            v.label:SetSize(v.label:GetWide() + 5,v.label:GetTall())
            v.label:SetPos(354 - v.label:GetWide() / 2,595)
            v.label:SetVisible(false)

            v.priceLabel = vgui.Create("DLabel",frame)
            v.priceLabel:SetColor(Color(255,0,0,255))
            v.priceLabel:SetFont("BankLarge")
            v.priceLabel:SetText(gbrp.formatMoney(v.price))
            v.priceLabel:SizeToContents()
            v.priceLabel:SetPos(773 - v.priceLabel:GetWide() / 2,583)
            v.priceLabel:SetVisible(false)
            function v.button:OnCursorEntered()
                if selected then
                    selected.label:SetVisible(false)
                    selected.priceLabel:SetVisible(false)
                end
                self:SetColor(Color(255,0,0,255))
                v.label:SetVisible(true)
                v.priceLabel:SetVisible(true)
            end
            function v.button:OnCursorExited()
                if selected == v then return end
                self:SetColor(Color(255,255,255,255))
                v.label:SetVisible(false)
                v.priceLabel:SetVisible(false)
                if selected then
                    selected.button:SetColor(Color(255,0,0,255))
                    selected.label:SetVisible(true)
                    selected.priceLabel:SetVisible(true)
                end
            end
            function v.button:DoClick()
                if selected then
                    selected.button:SetColor(Color(255,255,255,255))
                end
                selected = v
            end
        end

        local payer = vgui.Create("GBRPButton",frame)
        payer:SetImage("gui/gbrp/gunshop/page3/payer.png")
        payer:SizeToContents()
        payer:SetPos(956,587)
        function payer:DoClick()
            if not selected then GAMEMODE:AddNotify("Veuillez sélectionner un article.",1,2) return end
            if ply:CanAfford(selected.price) then
                frame:Remove()
                panelOpen = false
                net.Start("GBRP::buywep")
                net.WriteString(selected.classname)
                net.WriteInt(selected.price,7)
                net.SendToServer()
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    function LoadPageTwo()
        local urlbar = Material("gui/gbrp/gunshop/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/gunshop/page2/sidebar.png")
        local ar15 = Material("gui/gbrp/gunshop/page2/ar15.png")
        local quickguns = Material("gui/gbrp/gunshop/page2/quickguns.png")
        local balanceMat = Material("gui/gbrp/gunshop/page2/balance.png")
        local valueMat = Material("gui/gbrp/gunshop/page2/value.png")
        local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
        function frame:Paint(w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(urlbar)
            surface.DrawTexturedRect(34,62,1132,52)

            surface.SetMaterial(sidebar)
            surface.DrawTexturedRect(1136,114,42,563)

            surface.SetMaterial(ar15)
            surface.DrawTexturedRect(97,176,319,68)

            surface.SetMaterial(quickguns)
            surface.DrawTexturedRect(556,207,97,284)

            surface.SetMaterial(balanceMat)
            surface.DrawTexturedRect(96,371,321,68)

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(213,408)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            surface.SetMaterial(valueMat)
            surface.DrawTexturedRect(96,465,321,68)

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(213,502)
            surface.DrawText(gbrp.formatMoney(shop.value))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(66,620,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(66,620,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

            surface.SetFont("BankLarge")
            surface.SetTextPos(563,569)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(93,670)
            if ply:IsGangLeader() then
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
            else
                surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
            end
        end

        local dropcash = vgui.Create("DropCashButton",frame)
        dropcash:SetPos(722,176)
        dropcash:SetImage("gui/gbrp/gunshop/page2/dropcash.png")
        dropcash:SizeToContents()

        local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
        withdraw:SetImage("gui/gbrp/gunshop/page2/withdraw.png")
        withdraw:SetPos(722,310)
        withdraw:SizeToContents()

        local sell = vgui.Create("SellShopButton",frame)
        sell:SetImage("gui/gbrp/jewelrystore/sell.png")
        sell:SetPos(722,442)
        sell:SizeToContents()

        local entershop = vgui.Create("GBRPButton",frame)
        entershop:SetImage("gui/gbrp/gunshop/page2/entershop.png")
        entershop:SetPos(96,271)
        entershop:SizeToContents()
        function entershop:DoClick()
            self:Remove()
            sell:Remove()
            withdraw:Remove()
            dropcash:Remove()
            LoadPageThree()
        end
    end
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            LoadPageTwo()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::repairgarageReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local urlbar = Material("gui/gbrp/repairgarage/urlbar.jpg")
    local background = Material("gui/gbrp/repairgarage/background.jpg")
    local sidebar = Material("gui/gbrp/sidebar.png")
    local bottombar = Material("gui/gbrp/bottombar.jpg")
    local price = Material("gui/gbrp/repairgarage/page1/price.png")
    local value = Material("gui/gbrp/repairgarage/page1/value.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetPos(376,143)
    frame:SetSize(1220,937)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/pcscreen.png")
    function frame:Paint(w,h)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(urlbar)
        surface.DrawTexturedRect(34,58,1133,50)

        surface.SetFont("BankSmall")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(483,70)
        surface.DrawText("www.mecano-auto.fr")

        surface.SetMaterial(background)
        surface.DrawTexturedRect(34,108,1106,555)

        surface.SetMaterial(sidebar)
        surface.DrawTexturedRect(1136,108,31,555)

        surface.SetMaterial(bottombar)
        surface.DrawTexturedRect(36,663,1131,41)

        surface.SetMaterial(price)
        surface.DrawTexturedRect(183,472,377,53)

        surface.SetMaterial(value)
        surface.DrawTexturedRect(634,472,377,53)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(94,664)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(183,346)

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetPos(1115,69)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SizeToContents()

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/jewelrystore/customerarea.png")
    customerArea:SetPos(634,346)
    customerArea:SizeToContents()
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
            local balanceMat = Material("gui/gbrp/gunshop/page2/balance.png")
            local valueMat = Material("gui/gbrp/gunshop/page2/value.png")
            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelrystore/progressbar.png")
            function frame:Paint(w,h)
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetMaterial(urlbar)
                surface.DrawTexturedRect(34,58,1133,50)

                surface.SetFont("BankSmall")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(483,70)
                surface.DrawText("www.mec-à-nique.fr")

                surface.SetMaterial(background)
                surface.DrawTexturedRect(34,108,1106,555)

                surface.SetMaterial(sidebar)
                surface.DrawTexturedRect(1136,108,31,555)

                surface.SetMaterial(bottombar)
                surface.DrawTexturedRect(36,663,1131,41)

                surface.SetMaterial(valueMat)
                surface.DrawTexturedRect(57,121,321,68)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0)
                surface.SetTextPos(173,155)
                surface.DrawText(gbrp.formatMoney(shop.value))

                surface.SetMaterial(balanceMat)
                surface.DrawTexturedRect(795,121,321,68)

                surface.SetTextColor(255,255,255)
                surface.SetTextPos(907,155)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(66,394,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(66,364,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

                surface.SetFont("BankLarge")
                surface.SetTextPos(561,338)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(94,664)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end
            end

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash:SetPos(66,470)
            dropcash:SetImage("gui/gbrp/gunshop/page2/dropcash.png")
            dropcash:SizeToContents()

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw:SetImage("gui/gbrp/gunshop/page2/withdraw.png")
            withdraw:SetPos(432,470)
            withdraw:SizeToContents()

            local sell = vgui.Create("SellShopButton",frame)
            sell:SetImage("gui/gbrp/repairgarage/page2/sell.png")
            sell:SetPos(801,470)
            sell:SizeToContents()
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::drugstoreReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local urlbar = Material("gui/gbrp/macbook/urlbar.jpg")
    local background = Material("gui/gbrp/drugstore/page1/background.jpg")
    local bottombar = Material("gui/gbrp/macbook/bottombar.jpg")
    local logo = Material("gui/gbrp/drugstore/logo.png")
    local panel = Material("gui/gbrp/drugstore/page1/panel.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:CenterHorizontal()
    frame:SetY(ScrH() - 964)
    frame:MakePopup()
    frame.shop = shop
    frame.mat = Material("gui/gbrp/macbook/screen.png")
    function frame:Paint(w,h)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(urlbar)
        surface.DrawTexturedRect(41,42,1132,40)

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(517,50)
        surface.DrawText("www.rdv-dispistage-coco.com")

        surface.SetMaterial(background)
        surface.DrawTexturedRect(45,82,1127,564)

        surface.SetMaterial(bottombar)
        surface.DrawTexturedRect(44,646,1129,33)

        surface.SetMaterial(logo)
        surface.DrawTexturedRect(588,752,52,48)

        surface.SetMaterial(panel)
        surface.DrawTexturedRect(734,98,403,531)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(93,644)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

        surface.SetFont("BankSmall")
        surface.SetTextPos(906,326)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))

        surface.SetFont("BankSmall")
        surface.SetTextColor(255,0,0)
        surface.SetTextPos(906,296)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
    end

    local buy = vgui.Create("BuyShopButton",frame)
    buy:SetImage("gui/gbrp/jewelrystore/buy.png")
    buy:SizeToContents()
    buy:SetPos(182,206)

    local remove = vgui.Create("RemoveButton",frame)
    remove:SetPos(1112,48)
    remove:SetImage("gui/gbrp/jewelrystore/remove.png")
    remove:SizeToContents()

    local customerArea = vgui.Create("GBRPButton",frame)
    customerArea:SetImage("gui/gbrp/jewelrystore/customerarea.png")
    customerArea:SetPos(182,413)
    customerArea:SizeToContents()
    function customerArea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buy:Remove()
            surface.PlaySound("gui/gbrp/remove_customerarea.wav")
            local balanceMat = Material("gui/gbrp/drugstore/page2/balance.png")
            local valueMat = Material("gui/gbrp/drugstore/page2/value.png")
            background = Material("gui/gbrp/drugstore/page2/background.jpg")
            local progressbarframeMat = Material("gui/gbrp/jewelrystore/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/progressbar.png")
            function frame:Paint(w,h)
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetMaterial(background)
                surface.DrawTexturedRect(45,81,1127,565)

                surface.SetMaterial(urlbar)
                surface.DrawTexturedRect(41,42,1132,40)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,255,255)
                surface.SetTextPos(517,50)
                surface.DrawText("www.pharmagouille.com")

                surface.SetMaterial(bottombar)
                surface.DrawTexturedRect(44,646,1129,33)

                surface.SetMaterial(valueMat)
                surface.DrawTexturedRect(84,422,320,68)

                surface.SetFont("BankSmall")
                surface.SetTextColor(255,0,0)
                surface.SetTextPos(195,456)
                surface.DrawText(gbrp.formatMoney(shop.value))

                surface.SetMaterial(balanceMat)
                surface.DrawTexturedRect(84,319,320,68)

                surface.SetTextColor(255,255,255)
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(195,353)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(80,593,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(80,593,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27,Color(0,255,0,255))

                surface.SetFont("BankLarge")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(575,544)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0)
                surface.SetTextPos(93,644)
                if ply:IsGangLeader() then
                    surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                else
                    surface.DrawText("ARGENT SALE: " .. gbrp.formatMoney(ply.DarkRPVars.money))
                end
            end

            local dropcash = vgui.Create("DropCashButton",frame)
            dropcash:SetPos(83,166)
            dropcash:SetImage("gui/gbrp/gunshop/page2/dropcash.png")
            dropcash:SizeToContents()

            local withdraw = vgui.Create("WithdrawLaunderedMoneyButton",frame)
            withdraw:SetImage("gui/gbrp/gunshop/page2/withdraw.png")
            withdraw:SetPos(448,166)
            withdraw:SizeToContents()

            local sell = vgui.Create("SellShopButton",frame)
            sell:SetImage("gui/gbrp/jewelrystore/sell.png")
            sell:SetPos(816,166)
            sell:SizeToContents()

            local heal = vgui.Create("GBRPButton",frame)
            heal:SetImage("gui/gbrp/drugstore/page2/heal.png")
            heal:SetPos(816,373)
            heal:SizeToContents()
            heal.DoClick = function()
                if not ply.LastTimeHealed or CurTime() - ply.LastTimeHealed >= 420 then
                    ply.LastTimeHealed = CurTime()
                    net.Start("GBRP::heal")
                    net.SendToServer()
                elseif CurTime() - ply.LastTimeHealed < 420 then
                    GAMEMODE:AddNotify("Il vous faut attendre " .. tostring(math.Round(420 - CurTime() + ply.LastTimeHealed)) .. " secondes.",1,2)
                end
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)