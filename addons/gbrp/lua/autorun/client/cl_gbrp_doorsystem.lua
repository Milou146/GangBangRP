local ft = 0

net.Receive("GBRP::doorsinit",function()
    gbrp.doors = net.ReadTable()
end)

hook.Add("Think","GBRP::DoorThink",function()
    local ply = LocalPlayer()
    local eyetrace = ply:GetEyeTrace()
    if gbrp.doors[eyetrace.Entity:EntIndex()] and input.IsKeyDown(93) and CurTime() > ft + 1 and gbrp.doors[eyetrace.Entity:EntIndex()].buyable and eyetrace.Entity:GetPos():Distance(ply:GetPos()) < 200 then
        ft = CurTime()
        local gang = ply:GetGang()
        if eyetrace.Entity:GetNWString("owner") == "nobody" then
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,400)
            panel:SetTitle("")
            function panel:Paint(w,h)
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Prix: " .. tostring(gbrp.doors[eyetrace.Entity:EntIndex()].price) .. "$")
            end
            panel:MakePopup()
            local button = vgui.Create("DButton",panel)
            button:SetPos(20,100)
            button:SetText("Acheter")
            function button:DoClick()
                if not ply:IsGangChief() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif GetGlobalInt(gang .. "Balance") - gbrp.doors[eyetrace.Entity:EntIndex()].price < 0 then
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                else
                    net.Start("GBRP::buydoor")
                    net.WriteString(gang)
                    net.WriteString(gbrp.doors[eyetrace.Entity:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
            end
        elseif eyetrace.Entity:GetNWString("owner") == gang and ply:IsGangChief() then
            local panel = vgui.Create("DFrame",GetHUDPanel())
            panel:Center()
            panel:SetSize(400,400)
            panel:SetTitle("")
            function panel:Paint(w,h)
                surface.SetTextPos(50,50)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet18")
                surface.DrawText("Valeur: " .. tostring(gbrp.doors[eyetrace.Entity:EntIndex()].value) .. "$")
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
                    net.WriteString(gang)
                    net.WriteString(gbrp.doors[eyetrace.Entity:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                panel:Remove()
            end
        else
            GAMEMODE:AddNotify("Cette propriété appartient à un autre gang.",1,2)
        end
    end
end)

