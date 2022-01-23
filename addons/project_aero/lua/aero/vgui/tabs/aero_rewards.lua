    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29675

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    include( "aero/vgui/helpers/aero_skeleton.lua" )

    function Aero.DeployRewardPanels( self, parent, data )

        local scale = ScreenScale( 1 )
        local scr_w, scr_h = ScrW(), ScrH()

        parent:DockMargin( scale, 0, scale, 0 )

        for key, value in pairs( data ) do
            for k, v in pairs( value ) do
                v = Aero.Rewards[ key ]
                local ref = data[ key ][ k ]
                local width, height = scr_w * 0.059, scr_h * 0.105
                self.Reward_Container = parent:Add( "DPanel" )
                self.Reward_Container:Dock( TOP )
                self.Reward_Container:SetTall( parent:GetTall() / 2 - scr_h * 0.005 )
                self.Reward_Container:DockMargin( scale, 0, scale, scale )

                self.Circle = self.Reward_Container:Add( "DPanel" )
                self.Circle:SetPos( scr_w * 0.002, self.Reward_Container:GetTall() / 2 - height / 2 + scr_h * 0.005 )
                self.Circle:SetSize( scr_w * 0.069, scr_h * 0.11 )

                local can_claim = false
                local radius = 0
                self.Circle.OnMousePressed = function( me )
                    local time_check = math.Round( v.session_start - math.abs( v.start_time - os.time() ) )
                    if time_check > 0 then 
                        Aero.SendMessage( "You can claim your reward in " .. time_check .. " seconds." )
                        surface.PlaySound( "physics/plaster/ceiling_tile_step1.wav" )
                        return 
                    end
                    v.start_time = os.time()
                    can_claim = false
                    radius = 0
                    net.Start( "Aero.Process.Claim" )
                        net.WriteString( key )
                    net.SendToServer()
                    surface.PlaySound( "vo/coast/odessa/male01/nlo_cheer02.wav" )
                end

                local seconds_passed = 0
                local set = false
                local wait_time = CurTime() + 1
                self.Circle.Paint = function( me, w, h )
                    local active_time = v.session_start - math.abs( v.start_time - os.time() )
                    local time_difference = os.difftime( v.length, active_time )
                    if not set then
                        radius = 360 / v.session_start * time_difference
                        set = true
                    else
                        if CurTime() > wait_time then
                            local increase = 360 / v.session_start
                            seconds_passed = seconds_passed + 1
                            radius = radius + increase
                            wait_time = CurTime() + 1
                        end
                    end
                    if active_time < 1 then 
                        radius = 360 
                        can_claim = true
                    end
                    Aero.CreateCircle( 0, 0, width, height, ref.circle, Aero.Colors.WHITE, { icon = ref.icon }, { header = ( v.reward and "$" .. string.Comma( v.reward ) ) or "Weapon Drop", str = can_claim and "Claimable" or Aero.SecondsToClock( active_time ), goal = radius or 0, font = "Aero.Font.5" }, { b = ref.title_color } )
                end

                self.Description_Text = self.Reward_Container:Add( "DLabel" )
                self.Description_Text:SetPos( scr_w * 0.063, scr_h * 0.057 )
                self.Description_Text:SetSize( scr_w * 0.15, parent:GetTall() )
                self.Description_Text:SetText( ref.desc )
                self.Description_Text:SetWrap( true )
                self.Description_Text:SetContentAlignment( 7 )
                self.Description_Text:SetFont( "Aero.Font.6" )
                self.Description_Text:SetTextColor( Aero.Colors.WHITE )

                self.Reward_Container.Paint = function ( me, w, h )
                    Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
                    Aero.DrawText( ref.title, "Aero.Font.7", scr_w * 0.062, scr_h * 0.041, ref.title_color or Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                end
            end
        end
        
    end

    local content_daily = {
        [ "Hourly" ] = {
            { icon = Aero.Materials.MONEY, title = "Hourly Reward!", desc = "Claim $1,000 once you have played for a total of one hour.", title_color = Aero.Colors.GOLD, circle = Aero.Circles[ 2 ] }
        },
        [ "Daily" ] = {
            { icon = Aero.Materials.MONEY, title = "Daily Reward!", desc = "Claim $5,000 once you have played for a total of 24 hours.", title_color = Aero.Colors.PURPLE, circle = Aero.Circles[ 4 ] },
        },
    }

    local content_weekly = {    
        [ "Weekly" ] = {
            { icon = Aero.Materials.MONEY, title = "Weekly Reward", desc = "Play for one week and you will receive $10,000.", title_color = Aero.Colors.BLUE, circle = Aero.Circles[ 5 ] },
        },
        [ "Weekly-Shipment" ] = {
            { icon = Aero.Materials.SHIPMENT, title = "Weapon Drop", desc = "Play for one week and you will receive a random shipment for free.", title_color = Aero.Colors.GREEN, circle = Aero.Circles[ 3 ] }
        }
    }


    function Aero.DeployRewards( self )

        local scr_w, scr_h = ScrW(), ScrH()
        local scale = ScreenScale( 1 )

        self.Core_Container:Remove()
        self.Core_Container = self:MakeBaseContainer()

        self.Top_Header = self.Core_Container:Add( "DPanel" )
        self.Top_Header:Dock( TOP )
        self.Top_Header:SetTall( self.Core_Container:GetTall() / 1.9 )
        self.Top_Header:SetWide( self.Core_Container:GetWide() )
        self.Top_Header.Paint = nil

        local daily_content = Aero.GetDefaultLayout( self.Top_Header, LEFT, self.Core_Container:GetWide() / 2 - scr_w * 0.001, self.Top_Header:GetTall(), true, "Playtime Rewards", "Claim your daily login rewards here", "Circle" )  
        Aero.DeployRewardPanels( self, daily_content, content_daily )
        
        local weekly_content = Aero.GetDefaultLayout( self.Top_Header, RIGHT, self.Core_Container:GetWide() / 2, self.Top_Header:GetTall(), true, "Weekly Rewards", "You must have played at least twice this week to claim.", "Circle" )  
        Aero.DeployRewardPanels( self, weekly_content, content_weekly )

        self.Middle_Header = self.Core_Container:Add( "DPanel" )
        self.Middle_Header:Dock( TOP )
        self.Middle_Header:SetWide( self.Core_Container:GetWide() )
        self.Middle_Header:SetTall( self.Core_Container:GetTall() / 2.5 )
        self.Middle_Header:DockMargin( 0, scale, 0, 0 )
        self.Middle_Header.Paint = nil

        local task_content = Aero.GetDefaultLayout( self.Middle_Header, TOP, self.Core_Container:GetWide(), self.Middle_Header:GetTall(), true, "Challenge Rewards", "Complete these rewards to earn some starter cash!", "Panel" )
        task_content:DockMargin( scale * 3, scale, scale * 3, 0 )
        task_content:SetSpaceX( 2 )
        task_content:SetSpaceY( 2 )

        for key, value in pairs( Aero.Tasks ) do
            for k, v in pairs( { Aero.Tasks[ key ] } ) do
                local mat, color = "", ""
                if v.completed then 
                    mat = Aero.Materials.CIRCLE_FILLED
                    color = Aero.Colors.WHITE
                else
                    mat = Aero.Materials.CIRCLE_OUTLINE
                    color = Aero.Colors.GREY
                end
                local reward_container = task_content:Add( "DPanel" )
                reward_container:SetSize( scr_w * 0.10833, scr_h * 0.04 )
                reward_container.Paint = function( me, w, h )
                    Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.DARK_BLACK )
                    Aero.DrawText( v.name, "Aero.Font.5", scr_w * 0.003, scr_h * 0.013, Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                    Aero.DrawText( "$" .. string.Comma( v.reward ), "Aero.Font.5", scr_w * 0.003, scr_h * 0.028, Aero.Colors.GREEN, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                    Aero.DrawTexture( mat, w - scr_w * 0.010, scr_h * 0.021, scr_w * 0.0084, scr_h * 0.015, color )
                end
            end
        end
    end
