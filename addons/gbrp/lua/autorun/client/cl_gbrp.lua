net.Receive("GBRP::bankreception", function()
    ply = LocalPlayer()
    local frame = vgui.Create("DFrame")
    frame:SetSize(1000,500)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Banque")
    local depositButton = vgui.Create("DButton",frame)
    depositButton:SetText("Déposer de l'argent")
    depositButton:SetPos(100,100)
    depositButton:SetSize(350,200)
    depositButton.DoClick = function()
        ply = LocalPlayer()
        local amount = ply:GetNWInt("GBRP::launderedmoney")
        if amount > 0 then
            net.Start("GBRP::bankdeposit")
            net.WriteUInt(amount,32)
            net.SendToServer()
            frame:Remove()
            ply:ChatPrint("Vous avez déposé " .. amount .. "$.")
            GAMEMODE:AddNotify("Vous avez déposé " .. amount .. "$.",0,2)
        else
            ply:ChatPrint("Solde insuffisant.")
            GAMEMODE:AddNotify("Solde insuffisant.",1,2)
        end
        frame:Remove()
    end
    local withdrawButton = vgui.Create("DButton",frame)
    withdrawButton:SetText("Retirer de l'argent")
    withdrawButton:SetPos(550,100)
    withdrawButton:SetSize(350,200)
    withdrawButton.DoClick = function()
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry.OnEnter = function(self)
            ply = LocalPlayer()
            local amount = tonumber(self:GetValue())
            if amount > 0 and ply:GetNWInt("GBRP::balance") - amount >= 0 then
                net.Start("GBRP::bankwithdraw")
                net.WriteUInt(amount,32)
                net.SendToServer()
                frame:Remove()
                ply:ChatPrint("Vous avez retiré " .. amount .. "$.")
                GAMEMODE:AddNotify("Vous avez retiré " .. amount .. "$.",0,2)
            elseif amount <= 0 then
                ply:ChatPrint("Valeur non valide.")
                GAMEMODE:AddNotify("Valeur non valide.",1,2)
            else
                ply:ChatPrint("Solde insuffisant.")
                GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            end
        end
    end
    local balance = vgui.Create("DLabel",frame)
    balance:SetText("Solde: " .. tostring(ply:GetNWInt("GBRP::balance")) .. "$")
    balance:SetPos(100,400)
    balance:SetSize(200,25)
    local launderedmoney = vgui.Create("DLabel",frame)
    launderedmoney:SetText("Argent blanchis: " .. tostring(ply:GetNWInt("GBRP::launderedmoney")) .. "$")
    launderedmoney:SetPos(100,420)
    launderedmoney:SetSize(200,25)
end)