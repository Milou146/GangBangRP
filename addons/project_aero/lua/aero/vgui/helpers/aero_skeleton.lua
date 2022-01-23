    
    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    function Aero.DeploySteam( self )
        Aero.BuildHTMLPanel( self, Aero.Links[ "Steam" ] )
    end

    function Aero.DeployDiscord( self )
        Aero.BuildHTMLPanel( self, Aero.Links[ "Discord" ], true )
    end

    if Aero.UsingBlur() then
        local colors = {
            BASE_BACKGROUND = Color( 0, 0, 0, 230 ),
            BASE_HEADER = Color( 0, 0, 0, 200 ),
            BASE_CONTAINER = Color( 0, 0, 0, 90 ),
            DARK_BLACK = Color( 0, 0, 0, 50 ),
            GREY = Aero.Colors.WHITE
        }
        for k, v in pairs( colors ) do
            if Aero.Colors[ k ] then Aero.Colors[ k ] = v end
        end
    end

    Aero.Circles = {
        Material( "circles/circle_gradient1.png", "smooth" ),
        Material( "circles/circle_gradient2.png", "smooth"  ),
        Material( "circles/circle_gradient3.png", "smooth"  ),
        Material( "circles/circle_gradient4.png", "smooth"  ),
        Material( "circles/circle_gradient5.png", "smooth"  ),
        Material( "circles/circle_white.png", "smooth"  )
    }

    function Aero.CreateDialogBox( v )
        local scr_w, scr_h, ply, startTime = ScrW(), ScrH(), LocalPlayer(), CurTime()

        local self = vgui.Create( "DFrame" )
        self:SetSize( 384, v.reason and 216 or 146.88 )
        self:Center()
        self:SetTitle( "" )
        self:SetDraggable( false ) 
        self:ShowCloseButton( false )
        self:MakePopup()

        self.Paint = function( me, w, h )
            Derma_DrawBackgroundBlur( me, openTime ) 
            Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_BACKGROUND )
        end

        self.Header = vgui.Create( "DPanel", self )
        self.Header:Dock( TOP )
        self.Header:SetTall( 35 )
        self.Header:DockMargin( -5, -30, -5, 0 )

        self.Header.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
            Aero.DrawText( v.name, "Aero.Font.8", 6, h / 2, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.Description_Text = vgui.Create( "DLabel", self )
        self.Description_Text:Dock( TOP )
        self.Description_Text:DockMargin( 0, 8, 0, 3 )
        self.Description_Text:SetText( v.show_box )
        self.Description_Text:SetContentAlignment( 8 )
        self.Description_Text:SetFont( "Aero.Font.7" )
        self.Description_Text:SetTextColor( Aero.Colors.GREY )

        self.Info_Field = vgui.Create( v.selection and "DComboBox" or "DTextEntry", self )
        self.Info_Field:Dock( TOP )
        self.Info_Field:DockMargin( 30, 5, 30, 5 )
        self.Info_Field:SetTall( 30 )
        self.Info_Field:SetText( v.selection and "Select a user.." or "" )
        self.Info_Field:SetFont( "Aero.Font.7" )

        self.Info_Field.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
            me:DrawTextEntryText( Aero.Colors.WHITE, Aero.Colors.RED, Aero.Colors.WHITE )
        end

        if v.selection then
            --> If there's a selction to make, load all the players into the list <--
            for k, v in pairs( player.GetAll() ) do
                if v == ply then continue end
                self.Info_Field:AddChoice( v:Nick() )
            end

            --> If there's a selection, create another text-field to store said reason <--

            self.Description_Text = vgui.Create( "DLabel", self )
            self.Description_Text:Dock( TOP )
            self.Description_Text:DockMargin( 0, 3, 0, 5 )
            self.Description_Text:SetText( "Enter a reason below" )
            self.Description_Text:SetContentAlignment( 8 )
            self.Description_Text:SetFont( "Aero.Font.7" )
            self.Description_Text:SetTextColor( Aero.Colors.GREY )

            self.Reason_Field = vgui.Create( "DTextEntry", self )
            self.Reason_Field:Dock( TOP )
            self.Reason_Field:DockMargin( 30, 5, 30, 5 )
            self.Reason_Field:SetTall( 30 )
            self.Reason_Field:SetFont( "Aero.Font.7" )

            self.Reason_Field.Paint = function( me, w, h )
                Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_HEADER )
                me:DrawTextEntryText( Aero.Colors.WHITE, Aero.Colors.RED, Aero.Colors.WHITE )
            end
        end

        local confirm_width = v.reason and 164 or 105
        self.Confirm = vgui.Create( "DButton", self )
        self.Confirm:Dock( TOP )
        self.Confirm:DockMargin( 120, 3, 120, 3 )
        self.Confirm:SetTall( 30 )
        self.Confirm:SetText( "Confirm" )
        self.Confirm:SetFont( "Aero.Font.7" )
        self.Confirm:SetTextColor( Aero.Colors.WHITE )

        self.Confirm.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.GREEN )
        end

        self.Confirm.DoClick = function( me )
            surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
            local str_reason = "No reason was given."
            if v.selection then
                if self.Reason_Field:GetValue() == "" then
                    Aero.SendMessage( "Error: No reason has been given." )
                    return
                end
                if self.Info_Field:GetValue() == "Select a user.." then
                    Aero.SendMessage( "Error: No player has been selected." )
                    return
                end
                str_reason = self.Reason_Field:GetValue()
            else
                if self.Info_Field:GetValue() == "" then
                    Aero.SendMessage( "Error: No reason has been given." )
                    return
                end
                str_reason = self.Info_Field:GetValue()
            end
            local command = v.command
            command = string.gsub( command, "#string", v.selection and self.Info_Field:GetSelected() or str_reason )
            command = string.gsub( command, "#number", tonumber( str_reason ) or "" ) --> Number N/A if nil
            if v.selection then --> If selection, we must append the reason.
                 command = command .. " " .. str_reason
            end
            RunConsoleCommand( "say", command )
            self:Close()
        end

        self.Close_Button = Aero.CreateButton( self, self:GetWide() - 40, 7, 50, 19, 'Aero.Font.14', '×' )
        self.Close_Button:SetTextColor( Aero.Colors.GREY )
        self.Close_Button.DoClick = function() self:Close() surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" ) end
        self.Close_Button.Paint = function( me, w, h ) end

    end 

    --> Create our Panel base <--
    local Skeleton = {}

    function Skeleton:SetMainTitle( title )
        self.Title = title
    end

    function Skeleton:GetMainTitle()
        return self.Title or "No Name Set"
    end

    function Skeleton:PopulateLists()
        local list = {
            { name = "Miscellaneous", origin = DarkRPEntities, callback = Aero.DeployItems },
            { name = "Weapons", origin = CustomShipments, verification = 
            function( ply ) 
                if not GAMEMODE.Config.restrictbuypistol then
                    return true
                else
                    return Aero.Gun_Dealers[ team.GetName( ply:Team() ) ] 
                end
            end, callback = Aero.DeploySingles },
            { name = "Shipments", origin = CustomShipments, verification = function( ply ) return Aero.Gun_Dealers[ team.GetName( ply:Team() ) ] end, callback = Aero.DeployShipments },
            { name = "Ammo", origin = GAMEMODE.AmmoTypes, enabled = Aero.Tabs[ "Ammo" ], callback = Aero.DeployAmmo },
            { name = "Food", origin = FoodItems, enabled = Aero.Tabs[ "Food" ], callback = Aero.DeployFood },
            { name = "Vehicles", origin = CustomVehicles, enabled = Aero.Tabs[ "Vehicles" ], callback = Aero.DeployVehicles }
        }
        return list
    end

    function Skeleton:MakeBaseContainer()
        if IsValid( self.Scroll ) then self.Scroll:Remove() end

        local scale = ScreenScale( 1 )

        self.Scroll = self:Add( "DScrollPanel" )
        self.Scroll:SetSize( self:GetWide() - self.Dashboard:GetWide(), self:GetTall() - self.Header:GetTall() )
        self.Scroll:DockMargin( 3, 0, -6, 0 )
        self.Scroll:Dock( FILL )
        self.Scroll.Paint = nil
        Aero.PaintBar( self.Scroll, nil, nil, Aero.Colors.DARK_BLACK )
        
        self.Core_Container = self.Scroll:Add( "DIconLayout" )
        self.Core_Container:Dock( FILL )
        self.Core_Container:SetSize( self.Scroll:GetWide(), self.Scroll:GetTall() )
        self.Core_Container:SetSpaceY( 2 )
        self.Core_Container.Paint = nil

        return self.Core_Container
    end

    function Skeleton:Init()
        local tab = 1
        local scr_w, scr_h = ScrW(), ScrH()
        local low_res = scr_w < 1768
        
        self:SetSize( scr_w * 0.573, scr_h * 0.676 )
        self:Center()
        self:MakePopup()
        self:SetTitle( "" )
        self:ShowCloseButton( false )

        self.Open_Delay = CurTime() + 1

        self.Think = function()
            if CurTime() > self.Open_Delay and input.IsKeyDown( KEY_F4 ) then
                self:Close()
            end
        end

        self.Paint = function( me, w, h )
            if Aero.UsingBlur() then Aero.BlurMenu( me, 16, 16, 255 ) end
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_BACKGROUND )
        end

        self.Header = self:Add( "DPanel" )
        self.Header:Dock( TOP )
        self.Header:SetWide( self:GetWide() )
        self.Header:SetTall( 40 )
        self.Header:DockMargin( -5, -30, -5, 0 )

        self.Header.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_HEADER )
            Aero.DrawText( self:GetMainTitle(), "Aero.Font.8", 10, h / 2, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.Close_Button = Aero.CreateButton( self.Header, self.Header:GetWide() - 41, 7, 50, 25, 'Aero.Font.14', '×' )
        self.Close_Button:SetTextColor( Aero.Colors.GREY )
        self.Close_Button.DoClick = function() self:Close() surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" ) end
        self.Close_Button.Paint = function( me, w, h ) end

        self.Dashboard = self:Add( "DPanelList" )
        self.Dashboard:Dock( LEFT )
        self.Dashboard:SetSpacing( 2 )
        self.Dashboard:SetWide( self:GetWide() / 4.8 )
        self.Dashboard:DockMargin( -5, 3, 0, 0 )
        self.Dashboard.Paint = nil

        return self.Container
    end

    vgui.Register( "Skeleton_Base", Skeleton, "DFrame" )

