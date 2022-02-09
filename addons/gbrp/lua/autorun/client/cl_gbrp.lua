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

local PANEL = {}
function PANEL:OnCursorEntered()
    self:SetImage(string.StripExtension(self:GetImage()) .. "rollover.png")
end
function PANEL:OnCursorExited()
    self:SetImage(string.sub(self:GetImage(),1,#self:GetImage() - 12) .. ".png")
end
vgui.Register("GBRP::DImageButton",PANEL,"DImageButton")

net.Receive("GBRP::doorsinit",function()
    gbrp.doors = {}
    for k = 1,doorscount do
        gbrp.doors[net.ReadInt(32)] = net.ReadTable()
    end
end)

local hide = {
    ["CHudHealth"] = true,
    --["CHudAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudBattery"] = true
}
hook.Add("HUDShouldDraw","GBRP::HideHUD",function(name)
    if hide[name] then
        return false
    end
end)

local panelOpen = false
hook.Add("onKeysMenuOpened","GBRP::DoorMenu",function(ent,frame)
    frame:Close()
    if panelOpen then return end
    local ply = LocalPlayer()
    if gbrp.doors[ent:EntIndex()] then
        local gang = ply:GetGang()
        if not gbrp.doors[ent:EntIndex()].buyable then
            GAMEMODE:AddNotify("Cette propriété n'est pas à vendre.",1,2)
        elseif not ent:getDoorData().groupOwn then
            panelOpen = true
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,130)
            panel:SetTitle("")
            function panel:Paint(w,h)
                derma.SkinHook( "Paint", "Frame", self, w, h )
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Prix: " .. gbrp.formatMoney(gbrp.doors[ent:EntIndex()].price))
            end
            function panel:OnClose()
                panelOpen = false
            end
            panel:MakePopup()
            panel:SetKeyboardInputEnabled(false)
            local button = vgui.Create("DButton",panel)
            button:SetPos(20,100)
            button:SetText("Acheter")
            function button:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif not gang:CanAfford(gbrp.doors[ent:EntIndex()].price) then
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                elseif #gang:GetProperties() >= 10 then
                    GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de propriétés en sa possession.",1,2)
                else
                    net.Start("GBRP::buydoor")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
                panelOpen = false
            end
        elseif ent:getDoorData().groupOwn == gang.name then
            panelOpen = true
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,130)
            panel:SetTitle("")
            function panel:Paint(w,h)
                derma.SkinHook( "Paint", "Frame", self, w, h )
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Valeur: " .. gbrp.formatMoney(gbrp.doors[ent:EntIndex()].value))
            end
            function panel:OnClose()
                panelOpen = false
            end
            panel:MakePopup()
            panel:SetKeyboardInputEnabled(false)
            local button = vgui.Create("DButton",panel)
            button:SetPos(20,100)
            button:SetText("Vendre")
            function button:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif gbrp.doors[ent:EntIndex()].owner == gang.name then
                    ply:ChatPrint("Vous ne pouvez pas vendre la résidence principale du gang.")
                else
                    net.Start("GBRP::selldoor")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
                panelOpen = false
            end
        else
            GAMEMODE:AddNotify("Cette propriété appartient à un autre gang.",1,2)
        end
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
    local frameMat = Material("gui/gbrp/bank/frame.png")
    frame:SetSize(1016,550)
    frame:SetPos(SW / 2 -frame:GetWide() / 2, SH)
    frame:MakePopup()
    function frame:Think()
        if self:GetY() ~= SH - 550 then
            self:SetY(self:GetY() - 25)
        end
    end
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetFont("Bank")
        surface.SetTextPos(233,366)
        surface.SetTextColor(0,0,0,255)
        surface.DrawText("SOLDE: " .. gbrp.formatMoney(ply:GetNWInt("GBRP::balance")))
    end

    local close = vgui.Create("GBRP::DImageButton",frame)
    close:SetImage("gui/gbrp/bank/close.png")
    close:SetPos(745,22)
    close:SizeToContents()
    function close:DoClick()
        frame:Remove()
        panelOpen = false
    end

    local depositButton = vgui.Create("GBRP::DImageButton",frame)
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
            surface.PlaySound("gui/gbrp/deposit.wav")
        else
            GAMEMODE:AddNotify("Vous n'avez pas d'argent blanchi sur vous.",1,2)
        end
    end

    local withdrawButton = vgui.Create("GBRP::DImageButton",frame)
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
                surface.PlaySound("gui/gbrp/withdraw.wav")
            elseif amount <= 0 then
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
            self:Remove()
        end
    end
end)
net.Receive("GBRP::jewelryReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local frameMat = Material("gui/gbrp/jewelry/frame.png")
    local subpanelMat = Material("gui/gbrp/jewelry/subpanel.png")
    local shopbalMat = Material("gui/gbrp/jewelry/shopbal.png")
    local shopvalMat = Material("gui/gbrp/jewelry/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:SetPos(371,116)
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(subpanelMat)
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

    local buyshop = vgui.Create("GBRP::DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(643,201)
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local customerarea = vgui.Create("GBRP::DImageButton",frame)
    customerarea:SetImage("gui/gbrp/jewelry/customerarea.png")
    customerarea:SetPos(643,416)
    customerarea:SizeToContents()
    function customerarea:DoClick()
        if shop:GetGang() == gang then
            buyshop:Remove()
            self:Remove()
            local launder = vgui.Create("GBRP::DImageButton",frame)
            launder:SetImage("gui/gbrp/jewelry/launder.png")
            launder:SizeToContents()
            launder:SetPos(83,166)
            function launder:DoClick()
                shop:Collect(ply,frame)
            end

            local withdraw = vgui.Create("GBRP::DImageButton",frame)
            withdraw:SetImage("gui/gbrp/jewelry/withdraw.png")
            withdraw:SizeToContents()
            withdraw:SetPos(448,166)
            function withdraw:DoClick()
                shop:Withdraw(ply)
            end

            local sell = vgui.Create("GBRP::DImageButton",frame)
            sell:SetImage("gui/gbrp/jewelry/sell.png")
            sell:SizeToContents()
            sell:SetPos(816,166)
            function sell:DoClick()
                shop:GetSelled(ply)
                frame:Remove()
                panelOpen = false
            end

            local progressbarframeMat = Material("gui/gbrp/jewelry/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelry/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(frameMat)
                surface.DrawTexturedRect(0,0,w,h)
                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(93,644)
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
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

    local close = vgui.Create("GBRP::DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(1112,48)
    close:SizeToContents()
    function close:DoClick()
        frame:Remove()
        panelOpen = false
    end
end)
net.Receive("GBRP::nightclubReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local frameMat = Material("gui/gbrp/nightclub/frame.png")
    local subpanelMat = Material("gui/gbrp/nightclub/subpanel.png")
    local shopbalMat = Material("gui/gbrp/nightclub/shopbal.png")
    local shopvalMat = Material("gui/gbrp/nightclub/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1396,716)
    frame:SetPos(371,116)
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
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
    function frame:OnClose()
        panelOpen = false
    end

    local buyshop = vgui.Create("GBRP::DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(716,197)
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local customerarea = vgui.Create("GBRP::DImageButton",frame)
    customerarea:SetImage("gui/gbrp/jewelry/customerarea.png")
    customerarea:SetPos(716,412)
    customerarea:SizeToContents()
    function customerarea:DoClick()
        if shop:GetGang() == gang then
            buyshop:Remove()
            self:Remove()
            local launder = vgui.Create("GBRP::DImageButton",frame)
            launder:SetImage("gui/gbrp/jewelry/launder.png")
            launder:SizeToContents()
            launder:SetPos(156,162)
            function launder:DoClick()
                shop:Collect(ply,frame)
            end

            local withdraw = vgui.Create("GBRP::DImageButton",frame)
            withdraw:SetImage("gui/gbrp/jewelry/withdraw.png")
            withdraw:SizeToContents()
            withdraw:SetPos(521,162)
            function withdraw:DoClick()
                shop:Withdraw(ply)
            end

            local sell = vgui.Create("GBRP::DImageButton",frame)
            sell:SetImage("gui/gbrp/jewelry/sell.png")
            sell:SizeToContents()
            sell:SetPos(889,162)
            function sell:DoClick()
                shop:GetSelled(ply)
                frame:Remove()
                panelOpen = false
            end

            local progressbarframeMat = Material("gui/gbrp/jewelry/progressbarframe.png")
            local progressbarMat = Material("gui/gbrp/jewelry/progressbar.png")
            function frame:Paint(w,h)
                Derma_DrawBackgroundBlur(self, CurTime())
                surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(frameMat)
                surface.DrawTexturedRect(0,0,w,h)
                surface.SetFont("Bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(166,640)
                surface.DrawText("SOLDE DU GANG: " .. tostring(gang:GetBalance()))
                surface.SetMaterial(shopbalMat)
                surface.DrawTexturedRect(238,489,321,68)
                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)
                surface.SetFont("BankSmall")
                surface.SetTextPos(349,525)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(157,381,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(157,381,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)
                surface.SetFont("Bank")
                surface.SetTextColor(255,255,255,255)
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

    local close = vgui.Create("GBRP::DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(1189,45)
    close:SizeToContents()
    function close:DoClick()
        frame:Remove()
        panelOpen = false
    end
end)
net.Receive("GBRP::gasstationReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local frameMat = Material("gui/gbrp/gasstation/frame.png")
    local leftpanelMat = Material("gui/gbrp/gasstation/page1/leftpanel.png")
    local rightpanelMat = Material("gui/gbrp/gasstation/page1/rightpanel.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1376,1005)
    frame:SetPos(287,75)
    frame:MakePopup()
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        -- F R A M E --
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
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
    function frame:Close()
        self:Remove()
        panelOpen = false
    end

    local close = vgui.Create("GBRP::DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(178,135)
    close:SizeToContents()
    function close:DoClick()
        frame:Close()
    end

    local function LoadPageThree()
        close:SetPos(178,135)

        leftpanelMat = Material("gui/gbrp/gasstation/page3/leftpanel.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page3/rightpanel.png")
        local dollar = Material("gui/gbrp/gasstation/page3/dollar.png")
        local bluecard = Material("gui/gbrp/gasstation/page3/bluecard.png")
        local cheque = Material("gui/gbrp/gasstation/page3/cheque.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            -- F R A M E --
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(frameMat)
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
            [1] =   {classname = "eft_food_mre",y = 195,price = 15},
            [2] =   {classname = "eft_food_beefstew", y = 237,price = 7},
            [3] =   {classname = "eft_food_beefstew_family", y = 278, price = 10},
            [4] =   {classname = "eft_food_canned_fish", y = 318, price = 3},
            [5] =   {classname = "eft_food_peas", y = 358, price = 8},
            [6] =   {classname = "eft_food_squash", y = 397, price = 9},
            [7] =   {classname = "eft_food_hotrod", y = 444, price = 12},
            [8] =   {classname = "eft_food_juice", y = 489, price = 6},
            [9] =   {classname = "eft_food_oatmeal", y = 532, price = 3},
            [10] =   {classname = "eft_food_water", y = 575, price = 6}
        }
        local bill = 0
        local pretext = ""
        for k = 1,(10 - #tostring(bill)) do
            pretext = pretext .. " "
        end
        local shoppingBasket = ""
        local foodButtons = {}
        local billLabel = vgui.Create("DLabel",frame)
        billLabel:SetFont("Bank")
        billLabel:SetText( pretext .. "$" .. tostring(bill))
        billLabel:SetTextColor(Color(0,0,0))
        billLabel:SetPos(1030,258)
        billLabel:SizeToContents()
        for k,v in pairs(food) do
            foodButtons[k] = vgui.Create("DImageButton",frame)
            foodButtons[k]:SetSize(71,28)
            foodButtons[k]:SetPos(486,v.y)
            foodButtons[k].DoClick = function(self)
                shoppingBasket = v.classname
                bill = v.price
                pretext = ""
                for key = 1,(10 - #tostring(bill)) do
                    pretext = pretext .. " "
                end
                billLabel:SetText( pretext .. "$" .. tostring(bill))
                billLabel:SizeToContents()
            end
        end

        local confirm = vgui.Create("GBRP::DImageButton",frame)
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
        local launder = vgui.Create("GBRP::DImageButton",frame)
        launder:SetImage("gui/gbrp/jewelry/launder.png")
        launder:SizeToContents()
        launder:SetPos(817,181)
        function launder:DoClick()
            shop:Collect(ply,frame)
        end
        local withdraw = vgui.Create("GBRP::DImageButton",frame)
        withdraw:SetImage("gui/gbrp/jewelry/withdraw.png")
        withdraw:SizeToContents()
        withdraw:SetPos(817,315)
        function withdraw:DoClick()
            shop:Withdraw(ply)
        end
        local sell = vgui.Create("GBRP::DImageButton",frame)
        sell:SetImage("gui/gbrp/jewelry/sell.png")
        sell:SizeToContents()
        sell:SetPos(817,447)
        function sell:DoClick()
            shop:GetSelled(ply)
            frame:Remove()
            panelOpen = false
        end

        close:SetPos(786,101)

        local shopaccess = vgui.Create("GBRP::DImageButton",frame)
        shopaccess:SetImage("gui/gbrp/gasstation/page2/shopaccess.png")
        shopaccess:SetPos(226,169)
        shopaccess:SizeToContents()
        function shopaccess:DoClick()
            self:Remove()
            launder:Remove()
            withdraw:Remove()
            sell:Remove()
            LoadPageThree()
        end
        local progressbarframeMat = Material("gui/gbrp/jewelry/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelry/progressbar.png")
        local shopbalMat = Material("gui/gbrp/gasstation/page2/shopbal.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page2/rightpanel.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(frameMat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(776,93,465,539)

            surface.SetFont("Bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

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

    local buyshop = vgui.Create("GBRP::DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(853,129)
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local customerarea = vgui.Create("GBRP::DImageButton",frame)
    customerarea:SetImage("gui/gbrp/gasstation/page1/customerarea.png")
    customerarea:SetPos(670,129)
    customerarea:SizeToContents()
    function customerarea:DoClick()
        if shop:GetGang() == gang then
            self:Remove()
            buyshop:Remove()
            LoadPageTwo()
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end
end)
net.Receive("GBRP::armoryReception",function()
    local shop = net.ReadEntity()
    if panelOpen then return end
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    panelOpen = true
    local frameMat = Material("gui/gbrp/armory/frame.png")
    local panel = Material("gui/gbrp/armory/page1/panel.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetPos(376,137)
    frame:SetSize(1220,943)
    frame:MakePopup()
    function frame:Paint(w,h)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(panel)
        surface.DrawTexturedRect(34,62,1132,608)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(93,670)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
    end

    local buy = vgui.Create("GBRP::DImageButton",frame)
    buy:SetImage("gui/gbrp/jewelry/buyshop.png")
    buy:SizeToContents()
    buy:SetPos(149,210)
    function buy:DoClick()
        shop:GetBought(ply)
    end

    local close = vgui.Create("GBRP::DImageButton",frame)
    close:SetPos(1119,76)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SizeToContents()
    function close:DoClick()
        frame:Remove()
        panelOpen = false
    end

    local customerArea = vgui.Create("GBRP::DImageButton",frame)
    customerArea:SetImage("gui/gbrp/jewelry/customerarea.png")
    customerArea:SetPos(656,211)
    customerArea:SizeToContents()
    function LoadPageThree()
        local urlbar = Material("gui/gbrp/armory/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/armory/page3/sidebar.png")
        local quickguns = Material("gui/gbrp/armory/page2/quickguns.png")
        function frame:Paint(w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(frameMat)
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
            v.button:SetImage("gui/gbrp/armory/page3/" .. v.classname .. ".png")
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

        local payer = vgui.Create("GBRP::DImageButton",frame)
        payer:SetImage("gui/gbrp/armory/page3/payer.png")
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
        local urlbar = Material("gui/gbrp/armory/page2/urlbar.png")
        local sidebar = Material("gui/gbrp/armory/page2/sidebar.png")
        local ar15 = Material("gui/gbrp/armory/page2/ar15.png")
        local quickguns = Material("gui/gbrp/armory/page2/quickguns.png")
        local shopbal = Material("gui/gbrp/armory/page2/shopbal.png")
        local shopval = Material("gui/gbrp/armory/page2/shopval.png")
        function frame:Paint(w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.SetMaterial(frameMat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(urlbar)
            surface.DrawTexturedRect(34,62,1132,52)

            surface.SetMaterial(sidebar)
            surface.DrawTexturedRect(1136,114,42,563)

            surface.SetMaterial(ar15)
            surface.DrawTexturedRect(97,176,319,68)

            surface.SetMaterial(quickguns)
            surface.DrawTexturedRect(556,207,97,284)

            surface.SetMaterial(shopbal)
            surface.DrawTexturedRect(96,371,321,68)

            surface.SetFont("BankSmall")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(213,408)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            surface.SetMaterial(shopval)
            surface.DrawTexturedRect(96,465,321,68)

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(213,502)
            surface.DrawText(gbrp.formatMoney(shop.value))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(66,620,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(66,620,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

            surface.SetFont("DermaHuge")
            surface.SetTextPos(563,569)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(93,670)
            surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        end

        local launder = vgui.Create("GBRP::DImageButton",frame)
        launder:SetPos(722,176)
        launder:SetImage("gui/gbrp/armory/page2/launder.png")
        launder:SizeToContents()
        function launder:OnClick()
            shop:Collect(ply,frame)
        end

        local withdraw = vgui.Create("GBRP::DImageButton",frame)
        withdraw:SetImage("gui/gbrp/armory/page2/withdraw.png")
        withdraw:SetPos(722,310)
        withdraw:SizeToContents()
        function withdraw:OnClick()
            shop:Withdraw(ply)
        end

        local sell = vgui.Create("GBRP::DImageButton",frame)
        sell:SetImage("gui/gbrp/jewelry/sell.png")
        sell:SetPos(722,442)
        sell:SizeToContents()
        function sell:DoClick()
            shop:GetSelled(ply)
        end

        local entershop = vgui.Create("GBRP::DImageButton",frame)
        entershop:SetImage("gui/gbrp/armory/page2/entershop.png")
        entershop:SetPos(96,271)
        entershop:SizeToContents()
        function entershop:DoClick()
            self:Remove()
            sell:Remove()
            withdraw:Remove()
            launder:Remove()
            LoadPageThree()
        end
    end
    function customerArea:DoClick()
        self:Remove()
        buy:Remove()
        LoadPageTwo()
    end
end)