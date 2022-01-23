    
    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]


    if not CLIENT then return end

    local blur = Material( "pp/blurscreen" )
    function Aero.BlurRect(x, y, w, h, alpha)
    	local X, Y = 0,0

    	surface.SetDrawColor(255,255,255)
    	surface.SetMaterial(blur)

    	for i = 1, 5 do
    		blur:SetFloat("$blur", (i / 4) * (4))
    		blur:Recompute()

    		render.UpdateScreenEffectTexture()

    		render.SetScissorRect( x, y, x+w, y+h, true )
    			surface.DrawTexturedRect( X * -1, Y * -1, ScrW(), ScrH() )
    		render.SetScissorRect( 0, 0, 0, 0, false )
    	end

       draw.RoundedBox(0,x,y,w,h,Color(0,0,0,alpha))
    end

    function Aero.BlurMenu( panel, layers, density, alpha )
        -- Its a scientifically proven fact that blur improves a script
        local x, y = panel:LocalToScreen( 0, 0 )

        surface.SetDrawColor( 255, 255, 255, alpha )
        surface.SetMaterial( blur )

        for i = 1, 5 do
            blur:SetFloat( "$blur", ( i / 4 ) * 4 )
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
        end
    end


    function Aero.DrawRect( x, y, w, h, col )
        surface.SetDrawColor( col )
        surface.DrawRect( x, y, w, h )
    end

    function Aero.BuildFont( font, start, finish )
        for x = start, finish do
            surface.CreateFont( "Aero.Font." .. x, { font = font, size = ScreenScale( x ), weight = 0 } )
        end
    end

    Aero.BuildFont( "Roboto", 2, 20 )

    function Aero.DrawText( msg, fnt, x, y, c, align, extra )
        if extra then 
            draw.SimpleText( msg, fnt, x, y, c, align and align or TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        else
            draw.SimpleText( msg, fnt, x, y, c, align and align or TEXT_ALIGN_CENTER )
        end
    end

    function Aero.DrawOutline( x, y, w, h, t, c )
    surface.SetDrawColor( c )
        for i = 0, t - 1 do
            surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
        end
    end

    function Aero.DrawRoundedBox( rad, x, y, w, h, col )
        draw.RoundedBox( rad, x, y, w, h, col )
    end

    function Aero.DrawTexture( icon, x, y, w, h, col )
        surface.SetDrawColor( col )
        surface.SetMaterial( icon )
        surface.DrawTexturedRect( x, y, w, h )
    end

    function Aero.ConvertColour( tbl, reduction )
        reduction = reduction or 10
        return Color( tbl.r - reduction, tbl.g - reduction, tbl.b - reduction, tbl.a or 220 )
    end

    function Aero.CreateButton( parent, x, y, w, h, font, txt )
        local btn = vgui.Create( 'DButton', parent )
        btn:SetSize( w, h )
        btn:SetFont( font )
        btn:SetText( txt )
        btn:SetPos( x, y )
        btn:SetTextColor( Color( 255, 255, 255 ) )
        local hover_color = Aero.ConvertColour( Aero.Colors.DARK_BLACK, 3 )
        btn.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, me:IsHovered() and hover_color or Aero.Colors.DARK_BLACK )
        end
        return btn
    end

    function Aero.DrawIcon( mat, x, y, col, w, h )
        surface.SetDrawColor( col and col or Color( 255, 255, 255 ) )
        surface.SetMaterial( mat )
        surface.DrawTexturedRect( x, y, w and w or 32, h and h or 32 )
    end

    function Aero.PaintBar( parent, base_color, switch_color, bar_color )
        if not parent.VBar then print( 'No VBar found.' ) return end
        parent.VBar.Paint = function( me, w, h ) if not base_color then return else Aero.DrawRect( 0, 0, w, h, base_color ) end end
        parent.VBar.btnUp.Paint = function( me, w, h ) if not switch_color then return else Aero.DrawRect( 0, 0, w, h, switch_color ) end end
        parent.VBar.btnDown.Paint = function( me, w, h ) if not switch_color then return else Aero.DrawRect( 0, 0, w, h, switch_color ) end end
        parent.VBar.btnGrip.Paint = function( me, w, h ) if not bar_color then return else Aero.DrawRect( 3, 0, w / 2, h, bar_color ) end end
    end

    local blue = Color( 97, 114, 160 )
    function Aero.CreateClickableRow( parent, main_panel_size, base_size, extra )
        local player_panel = vgui.Create( "DCollapsibleCategory", parent )
        player_panel:SetExpanded( 0 )
        player_panel:SetLabel( '' )
        player_panel:GetChildren()[ 1 ]:SetTall( base_size )
        
        local hidden_list = vgui.Create( 'DPanelList' )
        hidden_list:SetSpacing( 1 )
        player_panel:SetContents( hidden_list )

        local hidden_panel = vgui.Create( "DPanel" )
        hidden_panel:SetSize( hidden_list:GetWide(), extra )
        hidden_list:AddItem( hidden_panel )
        hidden_panel.Paint = function( me, w, h ) Aero.DrawRect( 0, 0, w, h, blue ) end
        return player_panel, hidden_panel
    end

    function Aero.SecondsToClock( seconds )
        local seconds = tonumber( seconds )
        if seconds <= 0 then
            return "00:00:00"
        else
            if seconds >= 3600 then
                local hours = string.format( "%02.f", math.floor( seconds / 3600 ) )
                local mins = string.format( "%02.f", math.floor( seconds / 60 - (hours*60) ) )
                local secs = string.format( "%02.f", math.floor( seconds - hours*3600 - mins *60 ) )
                return hours .. ":" .. mins.. ":" .. secs
            else
                local mins = string.format( "%02.f", math.floor( seconds / 60 ) )
                local secs = string.format( "%02.f", math.floor( seconds - mins * 60 ) )
                return mins.. ":" .. secs
            end
        end
    end

    function Aero.MakeDFrame( width, height, title, background, outline, hide, hover, blur )
        local scr_w, scr_h, ply = ScrW(), ScrH(), LocalPlayer()

        local self = vgui.Create( "DFrame" )
        self:SetSize( width, height )
        self:SetTitle( "" )
        self:ShowCloseButton( false )
        self:SetDraggable( false )
        if hover then 
            self:SetPos( hover.x, hover.y ) 
        else
            self:Center()
        end

        self:MakePopup()

        self.Title = title
        self.Title_Color = Aero.Colors.WHITE

        local start_time = CurTime()
        self.Paint = function( me, w, h )
            Derma_DrawBackgroundBlur( me, start_time )
            if Aero.UsingBlur() then Aero.BlurMenu( me, 16, 16, 255 ) end
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_BACKGROUND )
        end

        self.Header = self:Add( "DPanel" )
        self.Header:SetWide( self:GetWide() )
        self.Header:SetTall( 41.3 )
        self.Header:Dock( TOP )
        self.Header:DockMargin( 0, -24, 0, 5 )

        self.Header.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_HEADER )
            Aero.DrawText( self.Title, "Aero.Font.8", 10, h / 2, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.Close_Button = Aero.CreateButton( self.Header, self.Header:GetWide() - 51, 7, 50, 25, 'Aero.Font.14', '×' )
        self.Close_Button:SetTextColor( Aero.Colors.GREY )
        self.Close_Button.DoClick = function() self:Close() surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" ) end
        self.Close_Button.Paint = function( me, w, h ) end

        if hide and self.Close_Button then self.Close_Button:Remove() end

        return self
    end

    function Aero.BuildHTMLPanel( self, link, use_browser )
        local scale = ScreenScale( 1 )

        self.Core_Container = self:MakeBaseContainer()

        local panel = vgui.Create( "DHTML", self.Core_Container )
        panel:Dock( FILL )
        if not use_browser then
            panel:OpenURL( link )
        else
            gui.OpenURL( link )
        end
    end
    
    --> Circle info only realtive to Aero <--

    local circles = include( "autorun/aero_circles.lua" )
    local scr_w, scr_h = ScrW(), ScrH()

    local start_x, start_y = scr_h * 0.053, scr_h * 0.052
    
    local circle_outline = circles.New( CIRCLE_OUTLINED, start_x, start_y, scr_h * 0.052, 6 ) 
    local circle = circles.New( CIRCLE_OUTLINED, start_x, start_y, scr_h * 0.052, 6 ) 
    circle:SetAngles( 0, 0 )
    circle_outline:SetAngles( 0, 360 )

    function Aero.DoCircleAnim( circle, goal, increment )
        if not circle.tracker then
            circle.tracker = 0
        end
        if not data then data = {} goal = 360 end
        if circle.tracker < goal then
            circle.tracker = circle.tracker + increment
            circle:SetAngles( 0, circle.tracker )
        else
            circle:SetAngles( 0, goal )
        end
    end

    --> Creates the nice gradient circles <--
    function Aero.CreateCircle( x, y, w, h, material, color, index, data, color_data )
        local scr_w, scr_h = ScrW(), ScrH()
        Aero.DoCircleAnim( circle, data.goal, 1 )
        for i = 1, 2 do
            if i == 1 then
                draw.NoTexture()
                surface.SetDrawColor( Aero.Colors.DARK_BLACK )
                circle_outline()
            else
                local pitch, yaw, roll = circle:GetAngles()
                local icon_width, icon_height = scr_w * 0.0168, scr_h * 0.030
                if yaw > 1 then 
                    draw.NoTexture()
                    surface.SetMaterial( material ) 
                    surface.SetDrawColor( color )
                    circle:SetRotation( -450 )
                    circle()
                end
                local font = data.font and data.font or "Aero.Font.6"
                Aero.DrawTexture( index.icon, w / 2 - icon_width / 2, scr_h * 0.017, icon_width, icon_height, Aero.Colors.WHITE )
                Aero.DrawText( data.header, font, w / 2, h / 2 + scr_h * 0.005, color_data and color_data.a or Aero.Colors.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                Aero.DrawText( data.str, "Aero.Font.5", w / 2, h / 2 + scr_h * 0.02, color_data and color_data.b or Aero.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        end
    end

    local other_circle = circles.New( CIRCLE_OUTLINED, scr_w * 0.017, scr_h * 0.041, scr_h * 0.050, 6 ) 
    other_circle:SetAngles( 0, 360 )
    other_circle:Scale( 0.5 )
    function Aero.QuickOutlineCircle( color, goal, str, w, h )
        local scr_w, scr_h = ScrW(), ScrH()
        Aero.DoCircleAnim( other_circle, goal, 1 )
        draw.NoTexture()
        surface.SetMaterial( Aero.Circles[ 6 ] )
        surface.SetDrawColor( color )
        other_circle:SetRotation( -450 )
        other_circle()
        Aero.DrawText( str, "Aero.Font.7", scr_w * 0.01653, scr_h * 0.041, Aero.Colors.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local circle_filled = circles.New( CIRCLE_FILLED, scr_w * 0.018, scr_h * 0.0372, scr_w * 0.0299, 8 ) 
    circle_filled:SetAngles( 0, 360 )
    circle_filled:Scale( 0.6 )
    function Aero.QuickFullCircle()
        draw.NoTexture()
        surface.SetDrawColor( Aero.Colors.DARK_BLACK )
        circle_filled:SetRotation( -450 )
        circle_filled()
    end

    function Aero.CirclesReset()
        circle_outline = circles.New( CIRCLE_OUTLINED, start_x, start_y, scr_h * 0.052, 6 ) 
        circle = circles.New( CIRCLE_OUTLINED, start_x, start_y, scr_h * 0.052, 6 ) 
        circle:SetAngles( 0, 0 )
        circle_outline:SetAngles( 0, 360 )

        other_circle = circles.New( CIRCLE_OUTLINED, scr_w * 0.017, scr_h * 0.041, scr_h * 0.050, 6 ) 
        other_circle:SetAngles( 0, 360 )
        other_circle:Scale( 0.5 )
    end

