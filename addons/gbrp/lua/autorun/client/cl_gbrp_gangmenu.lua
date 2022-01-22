local ft = 0
gangmenuisopen = false
hook.Add("Think","GBRP::GangMenu",function()
    local ply = LocalPlayer()
    if input.IsKeyDown(KEY_M) and CurTime() > ft + 1 and ply:IsGangChief() and not gangmenuisopen then
        gangmenuisopen = true
        ft = CurTime()
        local gangclass = gbrp[ply:GetGang()]
        local gangproperties = gangclass:GetProperties()
        local gangshops = gangclass:GetShops()
        local panelMat = Material("gui/gbrp/gangpanel/panel.png")
        local panel = vgui.Create("EditablePanel",GetHUDPanel())
        local propertieslist = {
            ["house"] = {mat = Material("gui/gbrp/gangpanel/house.png"),x = 12,y = 30},
            ["appartment"] = {mat = Material("gui/gbrp/gangpanel/appartment.png"),x = 10,y = 14},
            ["hangar"] = {mat = Material("gui/gbrp/gangpanel/hangar.png"),x = 7,y = 10},
            ["hugetower"] = {mat = Material("gui/gbrp/gangpanel/hugetower.png"),x = 18,y = 11},
            ["garage"] = {mat = Material("gui/gbrp/gangpanel/garage.png"),x = 5,y = 29},
        }
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
                surface.SetMaterial(propertieslist[v].mat)
                surface.DrawTexturedRect(319 + propertieslist[v].x + i * 72,504 + propertieslist[v].y + j * 70,propertieslist[v].mat:Width(),propertieslist[v].mat:Height())
                i = i + 1
                if i == 4 then i = 0; j = 1 end
            end
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

