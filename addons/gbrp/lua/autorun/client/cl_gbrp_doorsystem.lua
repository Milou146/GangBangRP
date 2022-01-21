local ft = 0

net.Receive("GBRP::doorsinit",function()
    gbrp.doors = net.ReadTable()
end)

hook.Add("PostDrawHUD","GBRP::IdentifyDoor",function()
    local ply = LocalPlayer()
    local eyetrace = ply:GetEyeTrace()
    if gbrp.doors[eyetrace.Entity:EntIndex()] and gbrp.doors[eyetrace.Entity:EntIndex()].buyable then
        local gang = ply:GetGang()
        if eyetrace.Entity:GetNWString("owner") == "nobody" then
            surface.SetTextColor(255,255,255,255)
            surface.SetFont("Trebuchet24")
            surface.SetTextPos(ScrW() / 2 - 50, ScrH() / 2)
            surface.DrawText("La propriété coûte " .. tostring(gbrp.doors[eyetrace.Entity:EntIndex()].price) .. "$")
            surface.SetTextColor(255,255,255,255)
            surface.SetFont("DermaDefault")
            surface.SetTextPos(ScrW() / 2 - 50, ScrH() / 2 + 50)
            surface.DrawText("F2 pour l'acheter")
        elseif eyetrace.Entity:GetNWString("owner") == gang then
            surface.SetTextColor(255,255,255,255)
            surface.SetFont("Trebuchet24")
            surface.SetTextPos(ScrW() / 2 - 50, ScrH() / 2)
            surface.DrawText("Cette propriété appartient à votre gang")
            surface.SetTextColor(255,255,255,255)
            surface.SetFont("DermaDefault")
            surface.SetTextPos(ScrW() / 2 - 50, ScrH() / 2 + 50)
            surface.DrawText("F2 pour la vendre")
        else
            surface.SetTextColor(247,4,4)
            surface.SetFont("Trebuchet24")
            surface.SetTextPos(ScrW() / 2 - 50, ScrH() / 2)
            surface.DrawText("Cette propriété appartient à " .. eyetrace.Entity:GetNWString("owner") )
        end
    end
end)

hook.Add("Think","GBRP::DoorThink",function()
    local ply = LocalPlayer()
    local eyetrace = ply:GetEyeTrace()
    if input.IsKeyDown(93) and CurTime() > ft + 1 and eyetrace.Entity:GetClass() == "func_door_rotating" or eyetrace.Entity:GetClass() == "func_door" and gbrp.doors[eyetrace.Entity:EntIndex()].buyable then
        ft = CurTime()
        local gang = ply:GetGang()
        if eyetrace.Entity:GetNWString("owner") == "nobody" then
            if not ply:IsGangChief() then GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
            elseif GetGlobalInt(gang .. "Balance") - gbrp.doors[eyetrace.Entity:EntIndex()].price < 0 then GAMEMODE:AddNotify("Solde insuffisant.",1,2)
            else
                net.Start("GBRP::buydoor")
                net.WriteString(gang)
                net.WriteString(gbrp.doors[eyetrace.Entity:EntIndex()].doorgroup)
                net.SendToServer()
            end
        elseif eyetrace.Entity:GetNWString("owner") == gang and ply:IsGangChief() then
            net.Start("GBRP::selldoor")
            net.WriteString(gang)
            net.WriteString(gbrp.doors[eyetrace.Entity:EntIndex()].doorgroup)
            net.SendToServer()
        end
    end
end)

