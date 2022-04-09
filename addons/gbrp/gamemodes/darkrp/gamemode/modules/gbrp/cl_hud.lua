local ft1,ft2 = 0,0
local SmoothArmor = function() return Lerp(5 * (CurTime() - ft1), 0, LocalPlayer():Armor()) end
local energy = function() return Lerp(CurTime() - ft2, 0, LocalPlayer():getDarkRPVar("Energy") or 0) end
local ImgBurger = Material("gui/gbrp/hud/armorpng.png")
local ImgArmor = Material("gui/gbrp/hud/burgurpng.png")
local ImgLicence = Material("gui/gbrp/hud/licencepng.png")
local MaxAR, Timestamp, TimeString, money, argent
local scrw, scrh = ScrW(), ScrH()
hook.Add("HUDDrawTargetID", "NUC_VANILLA_PLAYER_TARGETID", function() return false end)

surface.CreateFont("PricedownLarge", {
    font = "Pricedown",
    size = 65
})

hook.Add("OnContextMenuOpen", "GBRPContext", function()
    ContextMenuBase = vgui.Create("DFrame")
    ContextMenuBase:SetSize(ScrW(), ScrH())
    ContextMenuBase:SetPos(0, 0)
    ContextMenuBase:SetTitle("")
    ContextMenuBase:SetDraggable(false)
    ContextMenuBase:ShowCloseButton(false)
    ft1 = CurTime()
    ft2 = CurTime()

    -- Image de la licence
    if LocalPlayer():getDarkRPVar("HasGunlicense") then
        ContextMenuBase.Paint = function(self, w, h)
            MaxAR = LocalPlayer():GetMaxArmor()
            -- Partie Armure 
            draw.drawArc(scrw * .47, scrh * 0.5, 85, 210, 30, 10, 8, Color(68, 68, 68, 255))
            draw.drawArc(scrw * .53, scrh * 0.5, 85, 210, 410, 10, 8, Color(68, 68, 68, 255))
            draw.drawArc(scrw * .47, scrh * 0.5, 85, 30 + SmoothArmor() / MaxAR * 180, 30, 10, 8, Color(51, 169, 229, 255))
            -- Partie Faim
            draw.drawArc(scrw * .53, scrh * 0.5, 85, 210 + energy() / 100 * 200, 210, 10, 8, Color(255, 192, 0, 255))
            -- Partie Temps
            Timestamp = os.time()
            TimeString = os.date("%H:%M", Timestamp)
            draw.SimpleText(TimeString, "PricedownLarge", scrw * 0.5, scrh * 0.5, Color(255, 255, 255, 225), 1, 1) -- 280  , ScrH() - 302.5
            -- Partie Argent
            money = LocalPlayer():getDarkRPVar("money")
            argent = gbrp.formatMoney(money)
            draw.SimpleText(argent, "PricedownLarge", scrw * 0.5, scrh * 0.1, Color(20, 127, 16, 225), 1, 1) -- 30, ScrH() - 302.5
            -- Image du burger
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ImgBurger)
            surface.DrawTexturedRect(scrw * 0.44, scrh * 0.505, 60, 60)
            -- Image de Gilet
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ImgArmor)
            surface.DrawTexturedRect(scrw * 0.525, scrh * 0.43, 60, 60)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ImgLicence)
            surface.DrawTexturedRect(scrw * 0.46, scrh * 0.825, 130, 130)
        end
    else
        ContextMenuBase.Paint = function(self, w, h)
            MaxAR = LocalPlayer():GetMaxArmor()
            -- Partie Armure 
            draw.drawArc(scrw * .47, scrh * 0.5, 85, 210, 30, 10, 8, Color(68, 68, 68, 255))
            draw.drawArc(scrw * .47, scrh * 0.5, 85, 30 + SmoothArmor() / MaxAR * 180, 30, 10, 8, Color(51, 169, 229, 255))
            -- Partie Faim
            draw.drawArc(scrw * .53, scrh * 0.5, 85, 210, 410, 10, 8, Color(68, 68, 68, 255))
            draw.drawArc(scrw * .53, scrh * 0.5, 85, 210 + energy() / 100 * 200, 210, 10, 8, Color(255, 192, 0, 255))
            -- Partie Temps
            Timestamp = os.time()
            TimeString = os.date("%H:%M", Timestamp)
            draw.SimpleText(TimeString, "PricedownLarge", scrw * 0.5, scrh * 0.5, Color(255, 255, 255, 225), 1, 1) -- 280  , ScrH() - 302.5
            -- Partie Argent
            money = LocalPlayer():getDarkRPVar("money")
            argent = gbrp.formatMoney(money)
            draw.SimpleText(argent, "PricedownLarge", scrw * 0.5, scrh * 0.1, Color(20, 127, 16, 225), 1, 1) -- 30, ScrH() - 302.5
            -- Image du burger
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ImgBurger)
            surface.DrawTexturedRect(scrw * 0.44, scrh * 0.505, 60, 60)
            -- Image de Gilet
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(ImgArmor)
            surface.DrawTexturedRect(scrw * 0.525, scrh * 0.43, 60, 60)
        end
    end
end)

hook.Add("OnContextMenuClose", "GBRPContext", function()
    if IsValid(ContextMenuBase) then
        ContextMenuBase:Close()
    end

    if IsValid(ContextMenuSecond) then
        ContextMenuSecond:Close()
    end

    gui.EnableScreenClicker(false)
end)

--x, y, radius, angle1, angle2, step, thick, color
function draw.drawArc(x, y, r, a1, a2, step, thickness, color)
    local trad = r - thickness

    if a2 < a1 then
        a2, a1 = a1, a2
    end

    local a, px, py, ox, oy, ar, vx, vy, fx, fy = false, 0, 0, 0, 0, 0, 0, 0, 0, 0
    repeat
        a = a and math.min(a + step, a2) or a1
        ar = a + 90
        px, py = x + r * math.cos(math.rad(ar)), y + r * math.sin(math.rad(ar))
        vx, vy = x + trad * math.cos(math.rad(ar)), y + trad * math.sin(math.rad(ar))
        fx, fy = x + trad * math.cos(math.rad(ar - step)), y + trad * math.sin(math.rad(ar - step))

        if a ~= a1 and ar - step > 0 then
            surface.SetDrawColor(color)

            surface.DrawPoly({
                {
                    x = vx,
                    y = vy
                },
                {
                    x = fx,
                    y = fy
                },
                {
                    x = ox,
                    y = oy
                },
                {
                    x = px,
                    y = py
                }
            })
        end

        ox, oy = px, py
    until (a >= a2)
end