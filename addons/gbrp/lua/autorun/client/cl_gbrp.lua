surface.CreateFont("GBRP::bank",{
    font = "Banks Miles Single Line",
    size = 50
})

net.Receive("GBRP::bankreception", function()
    ply = LocalPlayer()
    local ft = CurTime()
    local frame = vgui.Create("EditablePanel")
    frame:SetSize(1000,550)
    frame:Center()
    frame:MakePopup()
    frame:SetAlpha(0)
    frame.Think = function(self)
        if CurTime() > ft + .1 and self:GetAlpha() != 255 then
            ft = CurTime()
            self:SetAlpha(math.Clamp(self:GetAlpha() + 100,0,255))
            print(self:GetAlpha())
        end
    end
    local background = vgui.Create("DImage",frame)
    background:SetImage("gui/gbrp/bankframe.png")
    background:SizeToContents()
    local close = vgui.Create("DImageButton",frame)
    close:SetPos(902,0)
    close:SetSize(48,53)
    close.DoClick = function(self)
        frame:Remove()
    end
    local depositButton = vgui.Create("DButton",frame)
    depositButton:SetText("Déposer de l'argent")
    depositButton:SetPos(174,211)
    depositButton:SetSize(238,137)
    depositButton.DoClick = function()
        local amount = ply:GetNWInt("GBRP::launderedmoney")
        if amount > 0 then
            net.Start("GBRP::bankdeposit")
            net.SendToServer()
            frame:Remove()
            GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
        else
            GAMEMODE:AddNotify("Vous n'avez pas d'argent blanchis sur vous.",1,2)
        end
        frame:Remove()
    end
    local withdrawButton = vgui.Create("DButton",frame)
    withdrawButton:SetText("Retirer de l'argent")
    withdrawButton:SetPos(562,211)
    withdrawButton:SetSize(238,137)
    withdrawButton.DoClick = function()
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry.OnEnter = function(self)
            local amount = tonumber(self:GetValue())
            if amount > 0 and ply:GetNWInt("GBRP::balance") - amount >= 0 then
                net.Start("GBRP::bankwithdraw")
                net.WriteUInt(amount,32)
                net.SendToServer()
                frame:Remove()
                GAMEMODE:AddNotify("Vous avez retiré " .. amount .. "$.",0,2)
            elseif amount <= 0 then
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local balance = vgui.Create("DLabel",frame)
    balance:SetText("SOLDE: " .. tostring(ply:GetNWInt("GBRP::balance")) .. "$")
    balance:SetFont("GBRP::bank")
    balance:SetPos(35,507)
    balance:SetSize(1000,41)
    balance:SetColor(Color(0,0,0,255))
end)

net.Receive("GBRP::shopreception", function()
    shop = net.ReadEntity()
    ply = LocalPlayer()
    if ply:IsGangChief() then
        if shop:Getowner() == ply:GetGang() then
            local frame = vgui.Create("DFrame")
            frame:SetSize(1000,500)
            frame:Center()
            frame:MakePopup()
            frame:SetTitle(shop.PrintName)
            local withdrawButton = vgui.Create("DButton",frame)
            withdrawButton:SetText("Retirer l'argent blanchis")
            withdrawButton:SetPos(100,100)
            withdrawButton:SetSize(200,200)
            withdrawButton.DoClick = function()
                net.Start("GBRP::shopwithdraw")
                net.WriteEntity(shop)
                net.SendToServer()
                frame:Remove()
                GAMEMODE:AddNotify("Vous avez retiré l'argent blanchis du magasin.",0,2)
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
                net.Start("GBRP::sellshop")
                net.WriteEntity(shop)
                net.SendToServer()
                frame:Remove()
                GAMEMODE:AddNotify("Vous avez vendu le magasin.",0,2)
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
                if GetGlobalInt(ply:GetGang() .. "Balance") - shop.price >= 0 then
                    net.Start("GBRP::buyshop")
                    net.WriteEntity(shop)
                    net.SendToServer()
                    frame:Remove()
                    GAMEMODE:AddNotify("Vous avez acheté le magasin.",0,2)
                else
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                end
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
    elseif shop:GetOwner() == ply:GetGang() then
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
                    GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
                elseif amount <= 0 then
                    GAMEMODE:AddNotify("Valeur non valide.",1,2)
                else
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                end
            end
        end
    end
end)