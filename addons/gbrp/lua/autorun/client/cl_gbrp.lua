net.Receive("bankReception", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(1000,400)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Banque")
    local depositButton = vgui.Create("DButton",frame)
    depositButton:SetText("Déposer de l'argent")
    depositButton:SetPos(100,100)
    depositButton:SetSize(350,200)
    depositButton.DoClick = function()
        local textEntry = vgui.Create("DTextEntry",frame)
        textEntry:SetSize(200,25)
        textEntry:SetPlaceholderText("ex: 500")
        textEntry:Center()
        textEntry.OnEnter = function(self)
            frame:Remove()
            LocalPlayer():ChatPrint("Vous avez déposé " .. self:GetValue() .. " dollars")
        end
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
            frame:Remove()
            LocalPlayer():ChatPrint("Vous avez retiré " .. self:GetValue() .. " dollars")
        end
    end
end)