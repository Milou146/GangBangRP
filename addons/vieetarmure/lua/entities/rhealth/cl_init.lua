include("shared.lua") 


surface.CreateFont( "TRE80", {
    font = "Arial", 
    size = ScreenScale(30),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "TRE65", {
    font = "Arial", 
    size = ScreenScale(23),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "TRE50", {
    font = "Arial", 
    size = ScreenScale(17),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "TRE40", {
    font = "Arial", 
    size = ScreenScale(14),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "QTYFont", {
    font = "Arial", 
    size = ScreenScale(12),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "TRE35", {
    font = "Arial ", 
    size = ScreenScale(10),
    weight = 800,
    antialias = true,
})

surface.CreateFont( "TRE28", {
    font = "Arial", 
    size = ScreenScale(8),
    weight = 500,
    antialias = true,
})

surface.CreateFont( "TRE20", {
    font = "Arial", 
    size = ScreenScale(7.5),
    weight = 500,
    antialias = true,
})

function ENT:Draw()

    self:DrawModel()

    local text = "Soins"
    local offset = Vector(0, 0, 80)
    local origin = self:GetPos()
    if LocalPlayer():GetPos():DistToSqr(origin) > (500*500) then return end
    local pos = origin + offset
    local ang = (LocalPlayer():EyePos() - pos):Angle()
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 180)
        local HealthIcon = Material("rhealth/health.png")
    cam.Start3D2D(pos, ang, 0.04)
        surface.SetFont("TRE80")
        local w, h = surface.GetTextSize(text)
        draw.RoundedBox(10 , -w*.5 -60, -h*.5, w + 120, h, Color(54, 54, 54, 255))
        draw.SimpleText(text, "TRE80", 50, 0, Color(255,255,255), 1, 1)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(HealthIcon)
        surface.DrawTexturedRect(-w*.6 - 20,-h*.5+10,70,70)

       --[[ draw.RoundedBox( 0, -w*.5 -30, -h*.5 , 15, 2, Color(255, 255, 255))
        draw.RoundedBox( 0, -w*.5 -30, -h*.5, 2, 15, Color(255, 255, 255))

        draw.RoundedBox( 0, -w*.5 -30, h*.5 - 2, 15, 2, Color(255, 255, 255))
        draw.RoundedBox( 0, -w*.5 -30, h*.5 - 15, 2, 15, Color(255, 255, 255))

        draw.RoundedBox( 0, w*.5 + 30 - 14, h*.5 - 2, 15, 2, Color(255, 255, 255))
        draw.RoundedBox( 0, w*.5 + 30 - 1, h*.5 - 15, 2, 15, Color(255, 255, 255))

        draw.RoundedBox( 0, w*.5 + 30 - 14,  -h*.5, 15, 2, Color(255, 255, 255))
        draw.RoundedBox( 0, w*.5 + 30 - 1, -h*.5, 2, 15, Color(255, 255, 255))--]]
    cam.End3D2D()

end

local blur = Material( "pp/blurscreen" )
function draw.BlurPanel( panel, amount )
	local x, y = panel:LocalToScreen(0, 0)
	local w, h = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 5 do
		blur:SetFloat( "$blur", (i)*(amount or 1) )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, w, h )
	end
end


local function OpenrHealth()
	
	local sw, sh = ScrW(), ScrH()
    local p = LocalPlayer()
    p:ConCommand( "play vo/npc/male01/health05.wav" )
    local e = p:GetNWEntity( "LastNPCUsed" )

    local f = vgui.Create("DFrame")
    f:SetSize(sw, sh)
    f:MakePopup()
    f:Center()
    f:SetTitle("")
    f.Paint = function(s, w, h)
    	draw.BlurPanel( s )

        local frac = math.Clamp(p:Health()/p:GetMaxHealth(), 0, 1)

        draw.RoundedBoxEx( 10, w*.5 - w*.15, h*.645 + 1, w*.30, h*.041 - 2 , Color(52,52,52),false,false,true,true )
        draw.RoundedBox( 10, w*.5 - w*.12, h *.655 , w*.24, h*.03-5, Color(35, 35, 35))
        draw.RoundedBox( 10, w*.5 - w*.12, h *.655, (w*.24 * frac), h*.03 - 5, Color(231, 76, 60))
        draw.SimpleText( p:Health().." / "..p:GetMaxHealth(), "TRE28", w*.5, h *.668, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        --draw.SimpleText( p:GetMaxHealth(), "TRE28", w*.625, h *.678, Color(255, 255, 255), 0, 1)
    end

    local fr = vgui.Create("DPanel", f)
	fr:SetSize(sw *.3, sh *.3)
	fr:Center()
    fr.Paint = function(s,w,h)
        draw.RoundedBoxEx( 10, 0, 0, w, h, Color(10, 10, 10),true,true,false,false )
        draw.RoundedBoxEx( 10, 1, 1, w -2, h -2, Color(35,35,35),true,true,false,false )
    end

    local h = vgui.Create("DPanel", fr)
    h:Dock(TOP)
    h:DockMargin( sh *.0075, sh *.0075, sh *.0075, sh *.0075 )
    h:SetTall( fr:GetTall() / 3 )
    h.Paint = function(s, w, h) 
        x, y = (sh * .11), 0
        local add = p:IsSuperAdmin() and 0 or h*.2
        draw.RoundedBoxEx( 10, 0, 0, w, h, Color(52,52,52, 155),true,true,false,false)
    	draw.SimpleText( "Besoin de soins ?", "TRE40", w*.22 , h *.2 + add, Color(255, 255, 255), 0, 1 )
        draw.SimpleText( "Choisissez parmi l'une de nos options ci-dessous :", "TRE20", w*.22 , h *.42 + add, Color(255, 255, 255), 0, 1 )
    end

    if p:IsSuperAdmin() then
        local btn = vgui.Create("DButton", h)
        btn:SetPos(fr:GetWide()/3-25, h:GetTall()/2+27)
        btn:SetSize( sw * .1, sh * .025)
        btn:SetFont("TRE28")
        btn:SetTextColor( Color(255, 255, 255) )
        btn:SetText("Configuration")
        btn.Paint = function(s, w, h)
            col = s:IsHovered() and Color(211, 56, 40) or Color(231, 76, 60)
            draw.RoundedBoxEx( 10, 0, 0, w, h , col,true,true,false,false )
        end
        btn.DoClick = function(s)
            local frame = vgui.Create("DFrame", f)
            frame:SetSize(sw * .15, sw * .05)
            frame:SetPos( sw * .5 - sw * .075, sh * .25)
            frame:SetTitle("")
            frame:ShowCloseButton(false)
            frame:SetDraggable(false)
            frame.Paint = function(s, w, h)
                draw.RoundedBox( 10, 0, 0, w, h, Color(35, 35, 35) )
                draw.RoundedBoxEx( 10, 0, 0, w, 25, Color(52, 52, 52),true,true,false,false )
                draw.SimpleText("Cost Per Health Point", "TRE20", w/2, 2, Color( 245, 245, 245, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end

            local te = vgui.Create("DTextEntry", frame)
            te:Dock(TOP)
            te:DockMargin(0,5,0,0)
            te:SetValue(e:GetNWInt("CostPerHealth"))

            local dbtn = vgui.Create("DButton", frame)
            dbtn:Dock(TOP)
            dbtn:DockMargin(0,10,0,0)
            dbtn:SetText("")
            dbtn:SetFont("TRE20")
            dbtn.Paint = function(self, w, h)
                if( dbtn:IsHovered() ) then
                draw.RoundedBox(5,0,0,w,h,Color(77, 186, 92,255) )
                draw.SimpleText("Confirmer le prix.", "TRE20", w/2,h/2,Color(245,245,245,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                else
                draw.RoundedBox(5,0,0,w,h,Color(52,52,52,255) )
                draw.SimpleText("Confirmer le prix.", "TRE20", w/2,h/2,Color(245,245,245,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

                end


            end
            dbtn.DoClick = function(s)
                net.Start("SaveHealthConfigChanges")
                    net.WriteFloat(te:GetValue())
                net.SendToServer()
                f:Close()
            end
        end
    end


   --[[ h.Think = function(s)
        if not p:IsSuperAdmin() then return end
        local w, h = s:GetWide(), s:GetTall()
        local mx, my = gui.MousePos()
        if input.IsMouseDown( MOUSE_FIRST ) and (mx > (sw * .5 - w*.3)) and (mx < (sw*.5 + w*.49)) and (my > (sh * .5 - h * .9)) and (my < (sh * .5 - h * .48)) then
            gui.OpenURL( s.URL )
        end
    end--]]

    local mdl = vgui.Create( "DModelPanel" , h)
	mdl:Dock(LEFT)
	mdl:SetWide(sh * .11)
	mdl:SetModel("models/Humans/Group03m/male_09.mdl")
	function mdl:LayoutEntity( Entity ) return end
	local angl = 60
	mdl:SetCamPos(Vector(70,-15,angl))
	mdl:SetLookAt(Vector(0,0,(angl + 3)))
	mdl:SetFOV(15)

    local b = vgui.Create("DButton", h)
    b:SetSize(sh*.02, sh*.02)
    b:SetPos(fr:GetWide() - sh*.04, sh*.007)
    b:SetText("")
    b.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(231, 76, 60))
    end
    b.DoClick = function(s)
        f:Close()
    end

    local bg = vgui.Create("DIconLayout", fr)
    bg:Dock(FILL)
    bg:DockMargin( sh * .01, 15, sh * .01, sh * .01)
    bg.Paint = function(s, w, h) end
    local BW = (fr:GetWide() - sh * .02) / 2
    local BH = (fr:GetTall() - h:GetTall() - sh * .0225) / 2   

    local col
    for k,v in SortedPairs(HEALTH_VALUES_MULTIPLIERS) do

        local hp = bg:Add("DButton")
        hp:SetFont("TRE35")
        hp:SetText( "" )
        hp:SetSize(BW, BH)
        hp.DoClick = function()
            net.Start("BuyHealth")
                net.WriteFloat(v)
            net.SendToServer()
        end
        hp.Paint = function(s,w,h)

            local health = LocalPlayer():Health()
            local maxhealth = LocalPlayer():GetMaxHealth()
            local quantity = math.Round(maxhealth * v)
            local IsMax = (quantity == maxhealth) and true or false
            quantity = IsMax and "100" or quantity
            local price = DarkRP.formatMoney((e:GetNWInt("CostPerHealth") * maxhealth) * v)
            
            local z = sh * .075

            col = s:IsHovered() and Color(211, 56, 40) or Color(231, 76, 60)
            draw.RoundedBox(10, w*.5 - w*.375, 0, w*.75, h*.7, Color(52, 52, 52))
            draw.RoundedBoxEx(10, w*.25 - z*.5, 0, w*.30, h*.7,  col, true, false, true, false) 

            draw.SimpleText( quantity.."%", "QTYFont", w*.25, h/2-10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
            draw.SimpleText( price, "TRE35", w*.85, h/2-10, Color(245, 245, 245), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) 
        end
	end
    f:ShowCloseButton( false )
end

net.Receive("rHealthMenuOpen",function()
	OpenrHealth()
end)