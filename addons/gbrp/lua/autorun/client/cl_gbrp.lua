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
    gbrp.doors = net.ReadTable()
    gbrp.gangpanel = {}
    gbrp.gangpanel.properties = {
        ["house"] = {mat = Material("gui/gbrp/gangpanel/house.png"),x = 12,y = 30},
        ["appartment"] = {mat = Material("gui/gbrp/gangpanel/appartment.png"),x = 10,y = 14},
        ["hangar"] = {mat = Material("gui/gbrp/gangpanel/hangar.png"),x = 7,y = 10},
        ["hugetower"] = {mat = Material("gui/gbrp/gangpanel/hugetower.png"),x = 18,y = 11},
        ["garage"] = {mat = Material("gui/gbrp/gangpanel/garage.png"),x = 5,y = 29},
    }
    gbrp.gangpanel.shops = {
        ["gasstation"] = {mat = Material("gui/gbrp/gangpanel/gasstation.png"),x = 10,y = 10},
        ["sawmill"] = {mat = Material("gui/gbrp/gangpanel/sawmill.png"),x = 15,y = 5},
        ["jewelry"] = {mat = Material("gui/gbrp/gangpanel/diamond.png"),x = 5,y = 9},
        ["garage"] = {mat = Material("gui/gbrp/gangpanel/tire.png"),x = 6,y = 7},
        ["pharmacy"] = {mat = Material("gui/gbrp/gangpanel/pharmacy.png"),x = 8,y = 10},
        ["bar"] = {mat = Material("gui/gbrp/gangpanel/beer.png"),x = 15,y = 7},
        ["nightclub"] = {mat = Material("gui/gbrp/gangpanel/cocktail.png"),x = 7,y = 7},
        ["armory"] = {mat = Material("gui/gbrp/gangpanel/gun.png"),x = 7,y = 17},
    }
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudBattery"] = true
}
hook.Add("HUDShouldDraw","GBRP::HideHUD",function(name)
    if hide[name] then
        return false
    end
end)
hook.Add("onKeysMenuOpened","GBRP::DoorMenu",function(ent,frame)
    local ply = LocalPlayer()
    frame:Close()
    if gbrp.doors[ent:EntIndex()] then
        local gang = ply:GetGang()
        if not gbrp.doors[ent:EntIndex()].buyable then
            GAMEMODE:AddNotify("Cette propriété n'est pas à vendre.",1,2)
        elseif not ent:getDoorData().groupOwn then
            PrintTable(ent:getDoorData())
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,400)
            panel:SetTitle("")
            function panel:Paint(w,h)
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Prix: " .. tostring(gbrp.doors[ent:EntIndex()].price) .. "$")
            end
            panel:MakePopup()
            local button = vgui.Create("DButton",panel)
            button:SetPos(20,100)
            button:SetText("Acheter")
            function button:DoClick()
                if not ply:IsGangChief() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif GetGlobalInt(gang .. "Balance") - gbrp.doors[ent:EntIndex()].price < 0 then
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                else
                    net.Start("GBRP::buydoor")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
            end
        elseif ent:getDoorData().groupOwn == gbrp[gang].subject then
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,400)
            panel:SetTitle("")
            function panel:Paint(w,h)
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Valeur: " .. tostring(gbrp.doors[ent:EntIndex()].value) .. "$")
            end
            panel:MakePopup()
            local button = vgui.Create("DButton",panel)
            button:SetPos(20,100)
            button:SetText("Vendre")
            function button:DoClick()
                if not ply:IsGangChief() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                else
                    net.Start("GBRP::selldoor")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
            end
        else
            GAMEMODE:AddNotify("Cette propriété appartient à un autre gang.",1,2)
        end
    end
end)

gbrp.voices = {
    female = {
        "npc/female_speech_1.wav",
        "npc/female_speech_2.wav"
    };
    male = {
        "npc/male_speech_1.wav"
    };
}
local isnpcmenuopen = false
net.Receive("GBRP::bankreception", function()
    if isnpcmenuopen then return end
    isnpcmenuopen = true
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
        if CurTime() > ft + .05 and self:GetY() != SH - 550 then
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
        surface.DrawText("SOLDE: " .. tostring(ply:GetNWInt("GBRP::balance")) .. "$")
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
        isnpcmenuopen = false
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
            isnpcmenuopen = false
            GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
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
                GAMEMODE:AddNotify("Vous avez retiré " .. amount .. "$.",0,2)
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

net.Receive("GBRP::shopReception", function()
    if isnpcmenuopen then return end
    isnpcmenuopen = true
    local shop = net.ReadEntity()
    local ply = LocalPlayer()
    if ply:IsGangChief() then
        if shop:GetGang() == ply:GetGang() then
            local frame = vgui.Create("DFrame",GetHUDPanel())
            frame:SetSize(1000,500)
            frame:Center()
            frame:MakePopup()
            frame:SetTitle(shop.PrintName)
            local withdrawButton = vgui.Create("DButton",frame)
            withdrawButton:SetText("Retirer l'argent blanchis")
            withdrawButton:SetPos(100,100)
            withdrawButton:SetSize(200,200)
            withdrawButton.DoClick = function()
                shop:Withdraw(ply)
                frame:Remove()
                isnpcmenuopen = false
            end
            local depositButton = vgui.Create("DButton",frame)
            depositButton:SetText("Déposer de l'argent sâle")
            depositButton:SetPos(350,100)
            depositButton:SetSize(200,200)
            depositButton.DoClick = function()
                local textEntry = vgui.Create("DTextEntry",frame)
                textEntry:SetSize(200,25)
                textEntry:SetPlaceholderText("ex: 500")
                textEntry:Center()
                textEntry.OnEnter = function(self)
                    local amount = tonumber(self:GetValue())
                    if amount > 0 and ply:getDarkRPVar("money") - amount >= 0 then
                        net.Start("GBRP::shopdeposit")
                        net.WriteUInt(amount,32)
                        net.WriteEntity(shop)
                        net.SendToServer()
                        frame:Remove()
                        isnpcmenuopen = false
                        GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
                    elseif amount <= 0 then
                        GAMEMODE:AddNotify("Valeur non valide.",1,2)
                    else
                        GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                    end
                end
            end
            local sellButton = vgui.Create("DButton",frame)
            sellButton:SetText("Vendre le magasin")
            sellButton:SetPos(600,100)
            sellButton:SetSize(200,200)
            sellButton.DoClick = function()
                shop:GetSelled(ply)
                frame:Remove()
                isnpcmenuopen = false
            end
            local shopVal = vgui.Create("DLabel",frame)
            shopVal:SetText("Valeur: " .. shop.value .. "$")
            shopVal:SetPos(100,400)
            shopVal:SetSize(200,25)
            local balance = vgui.Create("DLabel",frame)
            balance:SetText("Argent blanchis: " .. shop:GetLaunderedMoney() .. "$")
            balance:SetPos(100,420)
            balance:SetSize(200,25)
        else
            local frame = vgui.Create("DFrame")
            frame:SetSize(1000,500)
            frame:Center()
            frame:MakePopup()
            frame:SetTitle(shop.PrintName)
            local buyButton = vgui.Create("DButton",frame)
            buyButton:SetText("Acheter le magasin")
            buyButton:SetPos(100,100)
            buyButton:SetSize(350,200)
            buyButton.DoClick = function()
                shop:GetBought(ply)
                frame:Remove()
                isnpcmenuopen = false
            end
            local accessButton = vgui.Create("DButton",frame)
            accessButton:SetText("Accéder au magasin")
            accessButton:SetPos(550,100)
            accessButton:SetSize(350,200)
            accessButton.DoClick = function()
            end
            local shopPrice = vgui.Create("DLabel",frame)
            shopPrice:SetText("Prix du magasin: " .. shop.price .. "$")
            shopPrice:SetPos(100,400)
            shopPrice:SetSize(200,25)
            local balance = vgui.Create("DLabel",frame)
            balance:SetText("Votre solde: " .. ply:GetNWInt("GBRP::balance") .. "$")
            balance:SetPos(100,420)
            balance:SetSize(200,25)
            local gangBalance = vgui.Create("DLabel",frame)
            gangBalance:SetText("Le solde du gang: " .. GetGlobalInt(ply:GetGang() .. "Balance") .. "$")
            gangBalance:SetPos(100,440)
            gangBalance:SetSize(200,25)
        end
    elseif shop:GetGang() == ply:GetGang() then
        local frame = vgui.Create("DFrame")
        frame:SetSize(1000,500)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle(shop.PrintName)
        local accessButton = vgui.Create("DButton",frame)
        accessButton:SetText("Accéder au magasin")
        accessButton:SetPos(100,100)
        accessButton:SetSize(350,200)
        accessButton.DoClick = function()
        end
        local depositButton = vgui.Create("DButton",frame)
        depositButton:SetText("Déposer de l'argent sâle")
        depositButton:SetPos(550,100)
        depositButton:SetSize(350,200)
        depositButton.DoClick = function()
            shop:Collect(ply)
        end
    end
end)

net.Receive("GBRP::jewelryReception",function()
    if isnpcmenuopen then return end
    isnpcmenuopen = true
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local shop = net.ReadEntity()
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
        surface.DrawText("SOLDE DU GANG: " .. tostring(GetGlobalInt(gang .. "Balance") .. "$"))
        surface.SetFont("GBRP::bank small")
        surface.SetTextPos(193,322)
        surface.DrawText("PRIX: " .. tostring(shop.price) .. "$")
        surface.SetTextPos(193,352)
        surface.DrawText("REVENTE: " .. tostring(shop.value) .. "$")
    end
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
    local buyshopButton = vgui.Create("DImageButton",frame)
    buyshopButton:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshopButton:SizeToContents()
    buyshopButton:SetPos(643,201)
    function buyshopButton:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/buyshoprollover.png")
    end
    function buyshopButton:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/buyshop.png")
    end
    function buyshopButton:DoClick()
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
            buyshopButton:Remove()
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
                isnpcmenuopen = false
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
                surface.DrawText("SOLDE DU GANG: " .. tostring(GetGlobalInt(gang .. "Balance")) .. "$")
                surface.SetMaterial(launderedmoneyMat)
                surface.DrawTexturedRect(238,489,321,68)
                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)
                surface.SetFont("GBRP::bank small")
                surface.SetTextPos(349,525)
                surface.DrawText(tostring(shop:GetBalance()) .. "$")
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(84,385,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(84,385,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(0,0,0,255)
                surface.SetTextPos(577,331)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
                surface.SetFont("GBRP::bank small")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(tostring(shop.value) .. "$")
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
        isnpcmenuopen = false
    end
end)

net.Receive("GBRP::nightclubReception",function()
    if isnpcmenuopen then return end
    isnpcmenuopen = true
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    if not gang then return end
    local shop = net.ReadEntity()
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
        surface.DrawText("SOLDE DU GANG: " .. tostring(GetGlobalInt(gang .. "Balance") .. "$"))
        surface.SetFont("GBRP::bank small")
        surface.SetTextPos(266,319)
        surface.DrawText("PRIX: " .. tostring(shop.price) .. "$")
        surface.SetTextPos(266,349)
        surface.DrawText("REVENTE: " .. tostring(shop.value) .. "$")
    end
    frame:MakePopup()
    local buyshopButton = vgui.Create("DImageButton",frame)
    buyshopButton:SetImage("gui/gbrp/jewelry/buyshop.png")
    buyshopButton:SizeToContents()
    buyshopButton:SetPos(716,197)
    function buyshopButton:OnCursorEntered()
        self:SetImage("gui/gbrp/jewelry/buyshoprollover.png")
    end
    function buyshopButton:OnCursorExited()
        self:SetImage("gui/gbrp/jewelry/buyshop.png")
    end
    function buyshopButton:DoClick()
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
            buyshopButton:Remove()
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
                isnpcmenuopen = false
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
                surface.DrawText("SOLDE DU GANG: " .. tostring(GetGlobalInt(gang .. "Balance")) .. "$")
                surface.SetMaterial(shopbalanceMat)
                surface.DrawTexturedRect(238,489,321,68)
                surface.SetMaterial(shopvalMat)
                surface.DrawTexturedRect(682,489,321,68)
                surface.SetFont("GBRP::bank small")
                surface.SetTextPos(349,525)
                surface.DrawText(tostring(shop:GetBalance()) .. "$")
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarframeMat)(84,385,1053,27)
                GWEN.CreateTextureBorder(0,0,27,27,8,8,8,8,progressbarMat)(84,385,1053 * shop:GetBalance() / (shop:GetBalance() + shop:GetDirtyMoney()), 27)
                surface.SetFont("GBRP::bank")
                surface.SetTextColor(255,255,255,255)
                surface.SetTextPos(577,331)
                surface.DrawText(tostring(math.Round(100 * shop:GetBalance() / (1 + shop:GetBalance() + shop:GetDirtyMoney()))) .. "%")
                surface.SetFont("GBRP::bank small")
                surface.SetTextColor(255,0,0,255)
                surface.SetTextPos(805,525)
                surface.DrawText(tostring(shop.value) .. "$")
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
        isnpcmenuopen = false
    end
end)