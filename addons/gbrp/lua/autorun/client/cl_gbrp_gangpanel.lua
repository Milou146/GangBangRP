local gangPanelOpen = false
hook.Add("StartChat","GBRP::StartChat",function()
    gangPanelOpen = true
end)
hook.Add("FinishChat","GBRP::FinishChat",function()
    gangPanelOpen = false
end)
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
hook.Add("Think","GBRP::GangMenu",function()
    local ply = LocalPlayer()
    if input.IsKeyDown(KEY_M) and ply:IsGangChief() and not gangPanelOpen then
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
            surface.SetFont("GBRP::DermaHuge")
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

