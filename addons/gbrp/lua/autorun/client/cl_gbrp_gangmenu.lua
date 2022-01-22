local gangmenuisopen = false
hook.Add("Think","GBRP::GangMenu",function()
    local ply = LocalPlayer()
    if input.IsKeyDown(KEY_M) and ply:IsGangChief() and not gangmenuisopen then
        gangmenuisopen = true
        local gangclass = gbrp[ply:GetGang()]
        local gangproperties = gangclass:GetProperties()
        local gangshops = gangclass:GetShops()
        local panelMat = Material("gui/gbrp/gangpanel/panel.png")
        local panel = vgui.Create("EditablePanel",GetHUDPanel())
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
            surface.DrawText(string.upper(gangclass.name))
            surface.SetFont("GBRP::DermaHuge")
            surface.SetTextColor(250,165,0)
            surface.SetTextPos(336,15)
            surface.DrawText(": " .. tostring(gangclass:GetBalance()) .. "$")
            surface.SetTextPos(127,531)
            surface.DrawText(": " .. tostring(table.Count(gangproperties)))
            surface.SetTextPos(127,365)
            surface.DrawText(": " .. tostring(#gangshops))
            surface.SetTextPos(127,195)
            surface.DrawText(": " .. tostring(gangclass:GetMembersCount()))
            local i = 0
            local j = 0
            for k,v in pairs(gangproperties) do
                surface.SetMaterial(gbrp.gangpanel.properties[v].mat)
                surface.DrawTexturedRect(319 + gbrp.gangpanel.properties[v].x + i * 72,504 + gbrp.gangpanel.properties[v].y + j * 70,gbrp.gangpanel.properties[v].mat:Width(),gbrp.gangpanel.properties[v].mat:Height())
                i = i + 1
                if i == 4 then i = 0; j = 1 end
            end
            i = 0
            j = 0
            for k,v in pairs(gangshops) do
                surface.SetMaterial(gbrp.gangpanel.shops[v].mat)
                surface.DrawTexturedRect(319 + gbrp.gangpanel.shops[v].x + i * 72,324 + gbrp.gangpanel.shops[v].y + j * 70,gbrp.gangpanel.shops[v].mat:Width(),gbrp.gangpanel.shops[v].mat:Height())
                i = i + 1
                if i == 4 then i = 0; j = 1 end
            end
            GWEN.CreateTextureBorder(0,0,24,275,8,8,8,8,earningsbarMat)(803,344 + 330 * gangclass:GetExpenses() / (gangclass:GetEarnings() + gangclass:GetExpenses()),24,330 - 330 * gangclass:GetExpenses() / (gangclass:GetEarnings() + gangclass:GetExpenses()))
            GWEN.CreateTextureBorder(0,0,24,208,8,8,8,8,expensesbarMat)(912,344 + 330 * gangclass:GetEarnings() / (gangclass:GetEarnings() + gangclass:GetExpenses()),24,330 - 330 * gangclass:GetEarnings() / (gangclass:GetEarnings() + gangclass:GetExpenses()))
        end
        panel:MakePopup()
        local close = vgui.Create("DImageButton",panel)
        close:SetPos(1027,0)
        close:SetSize(53,82)
        function close:DoClick()
            panel:Remove()
            gangmenuisopen = false
        end
    end
end)

