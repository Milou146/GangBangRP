surface.CreateFont("GBRP::bank",{
    font = "Banks Miles Single Line",
    size = 36
})
surface.CreateFont("GBRP::bank small",{
    font = "Banks Miles Single Line",
    size = 24
})
surface.CreateFont("GBRP::DermaHuge",{
    font = "Verdana",
    size = 48
})

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
    local ft = CurTime()
    local SW = ScrW()
    local SH = ScrH()
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    local frameMat = Material("gui/gbrp/bank/frame.png")
    frame:SetSize(1016,550)
    frame:SetPos(SW / 2 -frame:GetWide() / 2, SH)
    frame:MakePopup()
    frame.Think = function(self)
        if CurTime() > ft + .05 and self:GetY() ~= SH - 550 then
            ft = CurTime()
            self:SetY(self:GetY() - 25)
        end
    end
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetFont("GBRP::bank")
        surface.SetTextPos(233,366)
        surface.SetTextColor(0,0,0,255)
        surface.DrawText("SOLDE: " .. gbrp.formatMoney(ply:GetNWInt("GBRP::balance")))
    end
    function frame:OnClose()
        panelOpen = false
    end

    local close = vgui.Create("DImageButton",frame)
    close:SetImage("gui/gbrp/bank/close.png")
    close:SetPos(745,22)
    close:SizeToContents()
    function close:OnCursorEntered()
        self:SetImage("gui/gbrp/bank/closerollover.png")
    end
    function close:OnCursorExited()
        self:SetImage("gui/gbrp/bank/close.png")
    end
    close.DoClick = function(self)
        frame:Remove()
        panelOpen = false
    end
    local depositButton = vgui.Create("DImageButton",frame)
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
    function depositButton:OnCursorEntered()
        self:SetImage("gui/gbrp/bank/depositrollover.png")
    end
    function depositButton:OnCursorExited()
        self:SetImage("gui/gbrp/bank/deposit.png")
    end
    local withdrawButton = vgui.Create("DImageButton",frame)
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
    function withdrawButton:OnCursorEntered()
        self:SetImage("gui/gbrp/bank/withdrawrollover.png")
    end
    function withdrawButton:OnCursorExited()
        self:SetImage("gui/gbrp/bank/withdraw.png")
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
    local launderedmoneyMat = Material("gui/gbrp/jewelry/launderedmoney.png")
    local shopvalMat = Material("gui/gbrp/jewelry/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1217,964)
    frame:SetPos(371,116)
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(subpanelMat)
        surface.DrawTexturedRect(76,99,403,531)
        surface.SetFont("GBRP::bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(93,644)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("GBRP::bank small")
        surface.SetTextPos(193,322)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
        surface.SetTextPos(193,352)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
    end
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
    function frame:OnClose()
        panelOpen = false
    end

    local buyshop = vgui.Create("DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(643,201)
    function buyshop:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/buyshoprollover.png")
    end
    function buyshop:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/buyshop.png")
    end
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local accountaccess = vgui.Create("DImageButton",frame)
    accountaccess:SetImage("gui/gbrp/jewelry/accountaccess.png")
    accountaccess:SetPos(643,416)
    accountaccess:SizeToContents()
    function accountaccess:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/accountaccessrollover.png")
    end
    function accountaccess:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/accountaccess.png")
    end
    function accountaccess:DoClick()
        if shop:GetGang() == gang then
            buyshop:Remove()
            self:Remove()
            local laundermoneyButton = vgui.Create("DImageButton",frame)
            laundermoneyButton:SetImage("gui/gbrp/jewelry/laundermoney.png")
            laundermoneyButton:SizeToContents()
            laundermoneyButton:SetPos(83,166)
            function laundermoneyButton:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/laundermoneyrollover.png")
            end
            function laundermoneyButton:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/laundermoney.png")
            end
            function laundermoneyButton:DoClick()
                shop:Collect(ply,frame)
            end
            local withdraw = vgui.Create("DImageButton",frame)
            withdraw:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
            withdraw:SizeToContents()
            withdraw:SetPos(448,166)
            function withdraw:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/withdrawmoneyrollover.png")
            end
            function withdraw:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
            end
            function withdraw:DoClick()
                shop:Withdraw(ply)
            end
            local sellshopButton = vgui.Create("DImageButton",frame)
            sellshopButton:SetImage("gui/gbrp/jewelry/sellshop.png")
            sellshopButton:SizeToContents()
            sellshopButton:SetPos(816,166)
            function sellshopButton:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/sellshoprollover.png")
            end
            function sellshopButton:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/sellshop.png")
            end
            function sellshopButton:DoClick()
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
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(93,644)
                surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
                surface.SetMaterial(launderedmoneyMat)
                surface.DrawTexturedRect(238,489,321,68)
                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)
                surface.SetFont("GBRP::bank small")
                surface.SetTextPos(349,525)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(84,385,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(84,385,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(577,331)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
                surface.SetFont("GBRP::bank small")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(gbrp.formatMoney(shop.value))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local close = vgui.Create("DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(1112,48)
    close:SizeToContents()
    function close:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/closerollover.png")
    end
    function close:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/close.png")
    end
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
    local shopbalanceMat = Material("gui/gbrp/nightclub/shopbalance.png")
    local shopvalMat = Material("gui/gbrp/nightclub/shopval.png")
    local frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame:SetSize(1396,716)
    frame:SetPos(371,116)
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(frameMat)
        surface.DrawTexturedRect(0,0,w,h)
        surface.SetMaterial(subpanelMat)
        surface.DrawTexturedRect(149,95,403,531)
        surface.SetFont("GBRP::bank")
        surface.SetTextColor(0,0,0,255)
        surface.SetTextPos(166,640)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        surface.SetFont("GBRP::bank small")
        surface.SetTextPos(266,319)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
        surface.SetTextPos(266,349)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
    end
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
    function frame:OnClose()
        panelOpen = false
    end

    local buyshop = vgui.Create("DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(716,197)
    function buyshop:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/buyshoprollover.png")
    end
    function buyshop:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/buyshop.png")
    end
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local accountaccess = vgui.Create("DImageButton",frame)
    accountaccess:SetImage("gui/gbrp/jewelry/accountaccess.png")
    accountaccess:SetPos(716,412)
    accountaccess:SizeToContents()
    function accountaccess:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/accountaccessrollover.png")
    end
    function accountaccess:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/accountaccess.png")
    end
    function accountaccess:DoClick()
        if shop:GetGang() == gang then
            buyshop:Remove()
            self:Remove()
            local laundermoneyButton = vgui.Create("DImageButton",frame)
            laundermoneyButton:SetImage("gui/gbrp/jewelry/laundermoney.png")
            laundermoneyButton:SizeToContents()
            laundermoneyButton:SetPos(156,162)
            function laundermoneyButton:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/laundermoneyrollover.png")
            end
            function laundermoneyButton:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/laundermoney.png")
            end
            function laundermoneyButton:DoClick()
                shop:Collect(ply,frame)
            end
            local withdraw = vgui.Create("DImageButton",frame)
            withdraw:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
            withdraw:SizeToContents()
            withdraw:SetPos(521,162)
            function withdraw:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/withdrawmoneyrollover.png")
            end
            function withdraw:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
            end
            function withdraw:DoClick()
                shop:Withdraw(ply)
            end
            local sellshopButton = vgui.Create("DImageButton",frame)
            sellshopButton:SetImage("gui/gbrp/jewelry/sellshop.png")
            sellshopButton:SizeToContents()
            sellshopButton:SetPos(889,162)
            function sellshopButton:OnCursorEntered()
                self:SetImage("gui/gbrp/jewelry/sellshoprollover.png")
            end
            function sellshopButton:OnCursorExited()
                self:SetImage("gui/gbrp/jewelry/sellshop.png")
            end
            function sellshopButton:DoClick()
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
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(166,640)
                surface.DrawText("SOLDE DU GANG: " .. tostring(gang:GetBalance()))
                surface.SetMaterial(shopbalanceMat)
                surface.DrawTexturedRect(238,489,321,68)
                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)
                surface.SetFont("GBRP::bank small")
                surface.SetTextPos(349,525)
                surface.DrawText(gbrp.formatMoney(shop:GetBalance()))
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(157,381,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(157,381,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(577,331)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
                surface.SetFont("GBRP::bank small")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(gbrp.formatMoney(shop.value))
            end
        else
            GAMEMODE:AddNotify("Vous n'êtes pas membre.",1,2)
        end
    end

    local close = vgui.Create("DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(1189,45)
    close:SizeToContents()
    function close:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/closerollover.png")
    end
    function close:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/close.png")
    end
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
        surface.SetFont("GBRP::bank")
        surface.SetTextColor(255,255,255)
        surface.SetTextPos(177,681)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
        -- V A L E U R --
        surface.SetFont("GBRP::bank small")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(943,280)
        surface.DrawText("REVENTE: " .. gbrp.formatMoney(shop.value))
        -- P R I X --
        surface.SetTextColor(255,0,0,255)
        surface.SetTextPos(194,630)
        surface.DrawText("PRIX: " .. gbrp.formatMoney(shop.price))
    end
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
    function frame:OnClose()
        panelOpen = false
    end

    local close = vgui.Create("DImageButton",frame)
    close:SetImage("gui/gbrp/jewelry/close.png")
    close:SetPos(178,135)
    close:SizeToContents()
    function close:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/closerollover.png")
    end
    function close:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/close.png")
    end
    function close:DoClick()
        frame:Remove()
        panelOpen = false
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
            surface.SetFont("GBRP::bank")
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
        billLabel:SetFont("GBRP::bank")
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

        local confirm = vgui.Create("DImageButton",frame)
        confirm:SetImage("gui/gbrp/gasstation/page3/confirm.png")
        confirm:SetPos(1094,422)
        confirm:SizeToContents()
        function confirm:OnCursorEntered()
            self:SetImage("gui/gbrp/gasstation/page3/confirmrollover.png")
        end
        function confirm:OnCursorExited()
            self:SetImage("gui/gbrp/gasstation/page3/confirm.png")
        end
        function confirm:DoClick()
            if shoppingBasket ~= "" and ply:canAfford(bill) then
                frame:Remove()
                panelOpen = false
                net.Start("GBRP::buyfood")
                net.WriteString(shoppingBasket)
                net.WriteInt(bill,7)
                net.SendToServer()
            end
        end
    end
    local function LoadPageTwo()
        local laundermoneyButton = vgui.Create("DImageButton",frame)
        laundermoneyButton:SetImage("gui/gbrp/jewelry/laundermoney.png")
        laundermoneyButton:SizeToContents()
        laundermoneyButton:SetPos(817,181)
        function laundermoneyButton:OnCursorEntered()
            self:SetImage("gui/gbrp/jewelry/laundermoneyrollover.png")
        end
        function laundermoneyButton:OnCursorExited()
            self:SetImage("gui/gbrp/jewelry/laundermoney.png")
        end
        function laundermoneyButton:DoClick()
            shop:Collect(ply,frame)
        end
        local withdraw = vgui.Create("DImageButton",frame)
        withdraw:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
        withdraw:SizeToContents()
        withdraw:SetPos(817,315)
        function withdraw:OnCursorEntered()
            self:SetImage("gui/gbrp/jewelry/withdrawmoneyrollover.png")
        end
        function withdraw:OnCursorExited()
            self:SetImage("gui/gbrp/jewelry/withdrawmoney.png")
        end
        function withdraw:DoClick()
            shop:Withdraw(ply)
        end
        local sellshopButton = vgui.Create("DImageButton",frame)
        sellshopButton:SetImage("gui/gbrp/jewelry/sellshop.png")
        sellshopButton:SizeToContents()
        sellshopButton:SetPos(817,447)
        function sellshopButton:OnCursorEntered()
            self:SetImage("gui/gbrp/jewelry/sellshoprollover.png")
        end
        function sellshopButton:OnCursorExited()
            self:SetImage("gui/gbrp/jewelry/sellshop.png")
        end
        function sellshopButton:DoClick()
            shop:GetSelled(ply)
            frame:Remove()
            panelOpen = false
        end

        close:SetPos(786,101)

        local shopaccess = vgui.Create("DImageButton",frame)
        shopaccess:SetImage("gui/gbrp/gasstation/page2/shopaccess.png")
        shopaccess:SetPos(226,169)
        shopaccess:SizeToContents()
        function shopaccess:OnCursorEntered()
            self:SetImage("gui/gbrp/gasstation/page2/shopaccessrollover.png")
        end
        function shopaccess:OnCursorExited()
            self:SetImage("gui/gbrp/gasstation/page2/shopaccess.png")
        end
        function shopaccess:DoClick()
            self:Remove()
            laundermoneyButton:Remove()
            withdraw:Remove()
            sellshopButton:Remove()
            LoadPageThree()
        end
        local progressbarframeMat = Material("gui/gbrp/jewelry/progressbarframe.png")
        local progressbarMat = Material("gui/gbrp/jewelry/progressbar.png")
        local shopbalanceMat = Material("gui/gbrp/gasstation/page2/shopbalance.png")
        rightpanelMat = Material("gui/gbrp/gasstation/page2/rightpanel.png")
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(frameMat)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetMaterial(rightpanelMat)
            surface.DrawTexturedRect(776,93,465,539)

            surface.SetFont("GBRP::bank")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(177,681)
            surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

            surface.SetMaterial(shopbalanceMat)
            surface.DrawTexturedRect(174,548,321,68)

            surface.SetFont("GBRP::bank small")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(285,587)
            surface.DrawText(gbrp.formatMoney(shop:GetBalance()))

            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(174,637,1053,27)
            GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(174,637,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)

            surface.SetFont("GBRP::bank")
            surface.SetTextPos(616,563)
            surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")

            surface.SetFont("GBRP::bank small")
            surface.SetTextColor(255,0,0,255)
            surface.SetTextPos(836,601)
            surface.DrawText(gbrp.formatMoney(shop.value))
        end
    end

    local buyshop = vgui.Create("DImageButton",frame)
    buyshop:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshop:SizeToContents()
    buyshop:SetPos(853,129)
    function buyshop:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/buyshoprollover.png")
    end
    function buyshop:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/buyshop.png")
    end
    function buyshop:DoClick()
        shop:GetBought(ply)
    end

    local customerarea = vgui.Create("DImageButton",frame)
    customerarea:SetImage("gui/gbrp/gasstation/page1/customerarea.png")
    customerarea:SetPos(670,129)
    customerarea:SizeToContents()
    function customerarea:OnCursorEntered()
        self:SetImage("gui/gbrp/gasstation/page1/customerarearollover.png")
    end
    function customerarea:OnCursorExited()
        self:SetImage("gui/gbrp/gasstation/page1/customerarea.png")
    end
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