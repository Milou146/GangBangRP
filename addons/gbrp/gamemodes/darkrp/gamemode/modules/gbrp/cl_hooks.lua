local frame
local hide = {
    ["CHudHealth"] = true,
    --["CHudAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudBattery"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true
}

hook.Add("HUDShouldDraw","GBRP::HideHUD",function(name)
    if hide[name] then
        return false
    end
end)
hook.Add("onKeysMenuOpened","GBRP::DoorMenu",function(ent,darkrpframe)
    darkrpframe:Close()
    if IsValid(frame) then print("the frame is valid") return end
    local ply = LocalPlayer()
    if gbrp.doors[ent:EntIndex()] then
        local gang = ply:GetGang()
        if not gbrp.doors[ent:EntIndex()].buyable then
            GAMEMODE:AddNotify("Cette propriété n'est pas à vendre.",1,2)
        elseif gang and not ent:getDoorData().groupOwn and not ent:getDoorData().owner then
            frame = vgui.Create("EditablePanel",GetHUDPanel())
            frame:SetSize(800,400)
            frame:Center()
            frame:MakePopup()
            frame.mat = Material("gui/gbrp/property/frame.jpg")
            function frame:Paint(w,h)
                surface.SetDrawColor(Color(255,255,255,255))
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetTextPos(275,134)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet24")
                surface.DrawText(gbrp.formatMoney(gbrp.doors[ent:EntIndex()].price))

                surface.SetTextPos(51,362)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Bank")
                surface.DrawText(gbrp.formatMoney(gang:GetBalance()))
            end

            local buy = vgui.Create("GBRPButton",frame)
            buy.mat = Material("gui/gbrp/property/buy.png")
            buy.hoveredMat = Material("gui/gbrp/property/buyrollover.png")
            buy:SetSize(193,41)
            buy:SetPos(242,86)
            function buy:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif not gang:CanAfford(gbrp.doors[ent:EntIndex()].price) then
                    GAMEMODE:AddNotify("Solde insuffisant.",1,2)
                elseif #gang:GetHouses() >= 10 then
                    GAMEMODE:AddNotify("Votre gang a atteint le nombre maximal de propriétés en sa possession.",1,2)
                else
                    net.Start("GBRP::buyproperty")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                frame:Remove()
            end

            local remove = vgui.Create("RemoveButton",frame)
            remove:SetSize(30,33)
            remove:SetPos(766,9)
        elseif gang and ent:getDoorData().groupOwn == gang.name or ent:getDoorData().owner == ply:UserID() then

            local counter = {
                frame = Material("gui/gbrp/property/counter.png"),
                [0] = Material("gui/gbrp/property/0.png"),
                [1] = Material("gui/gbrp/property/1.png"),
                [2] = Material("gui/gbrp/property/2.png")
            }

            frame = vgui.Create("EditablePanel",GetHUDPanel())
            frame:SetSize(800,400)
            frame:Center()
            frame:MakePopup()
            frame.mat = Material("gui/gbrp/property/frame.jpg")
            function frame:Paint(w,h)
                surface.SetDrawColor(Color(255,255,255,255))
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)

                surface.SetTextPos(275,134)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Trebuchet24")
                surface.DrawText(gbrp.formatMoney(gbrp.doors[ent:EntIndex()].value))

                surface.SetTextPos(51,362)
                surface.SetTextColor(255,255,255)
                surface.SetFont("Bank")
                surface.DrawText(gbrp.formatMoney(gang:GetBalance()))

                surface.SetMaterial(counter.frame)
                surface.DrawTexturedRect(419,45,27,35)

                surface.SetMaterial(counter[gang:GetPrivateDoorsCount()])
                surface.DrawTexturedRect(418,47,15,18)
            end

            local sell = vgui.Create("GBRPButton",frame)
            sell.mat = Material("gui/gbrp/property/sell.png")
            sell.hoveredMat = Material("gui/gbrp/property/sellrollover.png")
            sell:SetSize(144,35)
            sell:SetPos(259,86)
            function sell:DoClick()
                if not ply:IsGangLeader() then
                    GAMEMODE:AddNotify("Vous devez être chef du gang.",1,2)
                elseif gbrp.doors[ent:EntIndex()].owner == gang.name then
                    ply:ChatPrint("Vous ne pouvez pas vendre la résidence principale du gang.")
                else
                    net.Start("GBRP::sellproperty")
                    net.WriteString(gbrp.doors[ent:EntIndex()].doorgroup)
                    net.SendToServer()
                end
                frame:Remove()
            end

            local remove = vgui.Create("RemoveButton",frame)
            remove.mat = Material("gui/gbrp/jewelrystore/remove.png")
            remove:SetSize(30,33)
            remove:SetPos(766,9)

            local privatize = vgui.Create("GBRPButton",frame)
            privatize.mat = Material("gui/gbrp/property/privatize.png")
            privatize.hoveredMat = Material("gui/gbrp/property/privatizerollover.png")
            privatize:SetSize(190,43)
            privatize:SetPos(237,45)
            privatize:SetEnabled(ent:getDoorData().owner ~= ply:UserID() and gang:GetPrivateDoorsCount() < 2)

            local collectivize = vgui.Create("GBRPButton",frame)
            collectivize.mat = Material("gui/gbrp/property/collectivize.png")
            collectivize.hoveredMat = Material("gui/gbrp/property/collectivizerollover.png")
            collectivize:SetSize(27,35)
            collectivize:SetPos(212,45)
            collectivize:SetEnabled(ent:getDoorData().owner == ply:UserID())
            privatize.DoClick = function()
                RunConsoleCommand("privatizedoor",tostring(ent:EntIndex()))
                privatize:SetEnabled(false)
                collectivize:SetEnabled(true)
            end
            collectivize.DoClick = function()
                RunConsoleCommand("collectivizedoor",tostring(ent:EntIndex()))
                collectivize:SetEnabled(false)
                privatize:SetEnabled(true)
            end
        else
            GAMEMODE:AddNotify("Cette propriété a déjà un propriétaire.",1,2)
        end
    end
end)
hook.Add("Think","GBRP::GangMenu",function()
    local ply = LocalPlayer()
    if input.IsKeyDown(KEY_M) and not vgui.GetKeyboardFocus() then
        if not ply:IsGangLeader() then ply:ChatPrint("Ce menu est réservé au chef de gang ;)") return end
        local gang = ply:GetGang()
        local gangHousesTypes = gang:GetHousesTypes()
        local gangshops = gang:GetShopNames()
        local panelMat = Material("gui/gbrp/gangpanel/panel.png")
        local graduationMat = Material("gui/gbrp/gangpanel/graduation.png")
        frame = vgui.Create("EditablePanel",GetHUDPanel())
        local membersbarMat = Material("gui/gbrp/gangpanel/membersbar.png")
        local earningsbarMat = Material("gui/gbrp/gangpanel/earningsbar.png")
        local expensesbarMat = Material("gui/gbrp/gangpanel/expensesbar.png")
        frame:SetSize(1080,720)
        frame:Center()
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(panelMat)
            surface.DrawTexturedRect(0,0,w,h)
            surface.SetFont("DermaLarge")
            surface.SetTextColor(255,255,255)
            surface.SetTextPos(19,25)
            surface.DrawText(string.upper(gang.name))
            surface.SetFont("DermaHuge")
            surface.SetTextColor(250,165,0)
            surface.SetTextPos(336,15)
            surface.DrawText(": " .. gbrp.formatMoney(gang:GetBalance()))
            surface.SetTextPos(127,531)
            surface.DrawText(": " .. tostring(table.Count(gangHousesTypes)))
            surface.SetTextPos(127,365)
            surface.DrawText(": " .. tostring(#gangshops))
            surface.SetTextPos(127,195)
            surface.DrawText(": " .. tostring(gang:GetMembersCount()))
            local i = 0
            local j = 0
            for k,v in pairs(gangHousesTypes) do
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
            GWEN.CreateTextureBorder(0,0,24,275,8,8,8,8,earningsbarMat)(803,364 + 300 * gang:GetExpenses() / (gang:GetIncomes() + gang:GetExpenses()),24,300 - 300 * gang:GetExpenses() / (gang:GetIncomes() + gang:GetExpenses()))
            surface.SetFont("DermaLarge")
            surface.SetTextColor(0,255,0)
            surface.SetTextPos(803,364 + 300 * gang:GetExpenses() / (gang:GetIncomes() + gang:GetExpenses()) - 40)
            surface.DrawText(gbrp.FormatNumber(gang:GetIncomes()))
            GWEN.CreateTextureBorder(0,0,24,208,8,8,8,8,expensesbarMat)(912,364 + 300 * gang:GetIncomes() / (gang:GetIncomes() + gang:GetExpenses()),24,300 - 300 * gang:GetIncomes() / (gang:GetIncomes() + gang:GetExpenses()))
            surface.SetFont("DermaLarge")
            surface.SetTextColor(255,0,0)
            surface.SetTextPos(912,364 + 300 * gang:GetIncomes() / (gang:GetIncomes() + gang:GetExpenses()) - 40)
            surface.DrawText(gbrp.FormatNumber(gang:GetExpenses()))
            GWEN.CreateTextureBorder(0,0,155,15,8,8,8,8,membersbarMat)(303,205,16,15)
            GWEN.CreateTextureBorder(0,0,155,15,8,8,8,8,membersbarMat)(318,205,721 * gang:GetMembersCount() / 10,15)
            surface.SetMaterial(graduationMat)
            surface.DrawTexturedRect(388,205,570,75)
        end
        frame:MakePopup()
        local remove = vgui.Create("DImageButton",frame)
        remove:SetPos(1034,20)
        remove:SetSize(46,46)
        remove.mat = Material("gui/gbrp/gangpanel/remove.png")
        remove.hoveredMat = Material("gui/gbrp/gangpanel/remove_rollover.png")
        function remove:GetMaterial()
            return Material(self:GetImage())
        end
        function remove:Paint(w,h)
            surface.SetDrawColor(255,255,255,255)
            if self:IsHovered() then
                surface.SetMaterial(self.hoveredMat)
                surface.DrawTexturedRect(0,0,w,h)
                return
            end
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(0,0,w,h)
        end
        function remove:DoClick()
            frame:Remove()
        end
    end
end)
hook.Add("HUDPaint","GBRP::HUD",function()
    if LocalPlayer():Health() < 100 then
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(gbrp.woundedMat)
        surface.DrawTexturedRect(1842,981,46,84)
    end
end)
hook.Add("HUDDrawDoorData","GBRP::HUDDrawDoorData",function()
    return true
end)
hook.Add("SpawnMenuOpen","GBRP::SpawnMenuOpen",function()
    local teamid = LocalPlayer():Team()
    if teamid ~= TEAM_YAKUZA2 and teamid ~= TEAM_MAFIA2 and teamid ~= TEAM_GANGSTER2 and not LocalPlayer():IsAdmin() then
        return false
    end
end)