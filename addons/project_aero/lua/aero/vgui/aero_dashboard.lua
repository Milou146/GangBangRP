    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    local circle_data = {
        { str = "Players", icon = Material( "icons/playersonline.png" ) },
        { str = "Shops", icon = Material( "icons/shops.png" ) },
        { str = "Spent", icon = Material( "icons/spent.png" ) },
        { str = "Printers", icon = Material( "icons/printers.png" ) },
        { str = "Total", icon = Material( "icons/money.png" ) }
    }

    local GENERAL_COMMANDS = {
        { name = "Drop Money", show_box = "Enter the amount you wish to drop", command = "/dropmoney #number", data_type = "number"  },
        { name = "Change RP Name", show_box = "Enter your new name", command = "/name #string", data_type = "string"  },
        { name = "Drop Held Weapon", show_box = false, command = "/drop", data_type = nil  },
        { name = "Sell All Doors", show_box = false, command = "/sellalldoors", data_type = nil  },
        { name = "Make Player Wanted", show_box = "Select the name of the user", command = "/wanted #string", data_type = "string", selection = true, reason = true  },
        { name = "Make Player Unwanted", show_box = "Select the name of the user", command = "/dropmoney #string", data_type = "string", selection = true, reason = true  },
        { name = "Set Warrant", show_box = "Select the name of the user", command = "/wanted #string", data_type = "string", selection = true, reason = true  },
        { name = "Remove Warrant", show_box = "Select the name of the user", command = "/unwanted #string", data_type = "string", selection = true, reason = true  },
        { name = "Start Lockdown", show_box = false, command = "/lockdown", data_type = nil  },
        { name = "Stop Lockdown", show_box = false, command = "/unlockdown", data_type = nil  },
        { name = "Start Lottery", show_box = "Enter Lottery entry price", command = "/lottery #number", data_type = "number"  }
    }

    function Aero.DashboardButtons( self )

        Aero.Dashboard_Buttons = {
            { icon = Aero.Materials.DASHBOARD, name = "Dashboard", desc = "Server Information!", callback = Aero.DeployDashboard },
            { icon = Aero.Materials.JOBS, name = "Jobs", desc = "Choose your career!", callback = Aero.DeployJobs },
            { icon = Aero.Materials.ITEMS, name = "Items", desc = "Purchase goods!", callback = Aero.DeployItems, expands = true, lookup = "items" },
            { icon = Aero.Materials.REWARDS, name = "Rewards", desc = "Claim your daily rewards!", callback = Aero.DeployRewards, verify = Aero.Modules[ "Rewards" ] },
            { icon = Aero.Materials.NEXUS, name = "Unboxing", desc = "Unbox your Crates here!", callback = Aero.DeployNexus, verify = Aero.Modules[ "Nexus" ] },
            { icon = Aero.Materials.REPORT, name = "Report a User", desc = "File a report here!", callback = Aero.DeployReporter, verify = Aero.Modules[ "Reporter" ] },
            { icon = Aero.Materials.STEAM, name = "Steam", desc = "Join our group!", callback = Aero.DeploySteam },
            { icon = Aero.Materials.DISCORD, name = "Discord", desc = "Come talk to us!", callback = Aero.DeployDiscord },
        }

        local scr_w, scr_h = ScrW(), ScrH()
        local main_tab, sub_tab = 1, 1 
        local list = nil
        local ply = LocalPlayer()

        for k, v in pairs( Aero.Dashboard_Buttons ) do

            if v.verify == false then continue end

            local pnl_type = v.expands and "Aero.Button_List" or "DPanel"

            local background = self.Dashboard:Add( pnl_type )
            background:SetWide( self.Dashboard:GetWide() )
            background:SetTall( scr_h * 0.05 )
            background:SetCursor( "hand" )

            if v.expands then 
                background:SetText( "" )
                background.Header:SetTall( scr_h * 0.050 )
                background:SetExpanded( false )
                background:SetLabel( "" )
            end

            local size = scr_h * 0.030
            local height_now = background:GetTall()
            background.Paint = function( me, w, h )
                local white_flash = 100 + math.abs( math.sin( CurTime() * 3 ) * 255 )
                Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
                Aero.DrawTexture( v.icon, scr_w * 0.008, height_now / 2 - size / 2, size, size, Aero.Colors.WHITE )
                Aero.DrawText( v.name, "Aero.Font.7", scr_w * 0.008 + size * 1.3, height_now / 2 - scr_h * 0.007, main_tab == k and Color( white_flash, white_flash, white_flash ) or Aero.Colors.WHITE or Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                Aero.DrawText( v.desc, "Aero.Font.5", scr_w * 0.008 + size * 1.3, height_now / 2 + scr_h * 0.008, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end

            background.OnMousePressed = function()
                surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
                main_tab = k
                if pnl_type == "Aero.Button_List" then
                    list = background
                end
                if main_tab == 3 then
                    sub_tab = 1
                    list.Opened = true
                else
                    if list then
                        if list.Opened then
                            list:Toggle()
                            list = nil
                        end
                    end
                    sub_tab = 0
                end
                self.Core_Container:Clear()
                if self.Top_Header then self.Top_Header:Remove() end
                if v.callback then v.callback( self, self.Core_Container ) end
            end

            if not v.lookup then self.Dashboard:AddItem( background ) continue end
            local contents = vgui.Create( "DPanelList" )
            contents:SetSize( background:GetWide(), 100 )
            background:SetContents( contents )
    
            contents.Paint = nil
    
            if v.lookup then
                
                local list = self:PopulateLists()

                if not list then continue end
                for x, o in pairs( list ) do
                    if o.enabled != nil and o.enabled == false then continue end
                    if o.verification and not o.verification( ply ) then continue end
                    local menu = vgui.Create( "DPanel" )
                    menu:SetSize( background:GetWide(), scr_h * 0.03 )

                    menu.Paint = function( me, w, h )
                        local white_flash = 100 + math.abs( math.sin( CurTime() * 3 ) * 255 )
                        Aero.DrawRect( 0, 0, w, h, Aero.Colors.DARK_BLACK )
                        Aero.DrawText( o.name, "Aero.Font.6", scr_w * 0.008, scr_h * 0.017, sub_tab == x and Color( white_flash, white_flash, white_flash ) or Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                    end

                    menu.OnMousePressed = function()
                        surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
                        self.Core_Container:Clear()
                        if self.Top_Header then self.Top_Header:Remove() end
                        o.callback( self )
                        sub_tab = x
                    end

                    contents:AddItem( menu )
                end
            end

            self.Dashboard:AddItem( background )
        end
    end

    Aero.Active_Bitminers = 0
    function Aero.GetPrinterCount()
        Aero.Active_Printers = net.ReadInt( 9 )
        Aero.Active_Bitminers = net.ReadInt( 9 )
    end
    net.Receive( "Aero.Push.Printer.Count", Aero.GetPrinterCount )

    --> Credit to https://stackoverflow.com/users/1009479/yu-hao for this <--
    function Aero.FormatSpent( spent )
        if spent >= 10 ^ 6 then
            return string.format( "%.1fM", spent / 10 ^ 6 )
        elseif spent >= 10 ^ 3 then
            return string.format( "%.0fK", spent / 10 ^ 3 )
        else
            return tostring( spent )
        end
    end

    --> The main dashboard and all its content <--
    local max_dealers = nil
    function Aero.DeployDashboard( self )
        local scr_w, scr_h, ply = ScrW(), ScrH(), LocalPlayer()
        local scale = ScreenScale( 1 )

        self.Core_Container:Remove()
        self.Core_Container = self:MakeBaseContainer()

        self.Top_Header = self.Core_Container:Add( "DPanel" )
        self.Top_Header:Dock( TOP )
        self.Top_Header:SetTall( self.Core_Container:GetTall() / 2.1 )
        self.Top_Header:SetWide( self.Core_Container:GetWide() )
        self.Top_Header.Paint = nil

        local players_online, max_players = #player.GetAll(), game.MaxPlayers()

        local shops_open, max_shops_open = 0, 0

        for k, v in pairs( player.GetAll() ) do
            if Aero.Gun_Dealers[ team.GetName( v:Team() ) ] then
                shops_open = shops_open + 1
            end
        end

        if not max_dealers then
            max_dealers = 0
            --> Do this once, no need to do it every time the menu opens <--
            for k, v in pairs( Aero.Gun_Dealers ) do
                local value = Aero.GetLookupByName( k, "jobs" )
                if not value then continue end
                max_dealers = max_dealers + value.max
            end
        end

        local radius = 360

        local data = {
            { str = "Players", header = players_online .. "/" .. max_players, goal = ( radius / max_players ) * players_online },
            { str = "Shops", header = shops_open .. "/" .. max_dealers, goal = ( radius / max_dealers ) * shops_open },
            { str = "Spent", header = "$" .. Aero.FormatSpent( Aero.MoneySpent ), goal = radius },
            { str = "Printers", header =  Aero.Active_Printers .. " Active", goal = radius },
            { str = "Bitminers", header =  Aero.Active_Bitminers .. " Active", goal = radius }
        }
        
        local stat_content = Aero.GetDefaultLayout( self.Top_Header, LEFT, self.Core_Container:GetWide() / 2 - scr_w * 0.005, self.Top_Header:GetTall(), true, "Economy Stats", "A detailed view of the server's economy", "Circle" )   

        for i = 1, 5 do
            local circle = stat_content:Add( "DPanel" )
            circle:SetSize( scr_w * 0.069, scr_h * 0.11 )

            local width, height = scr_w * 0.059, scr_h * 0.105
            circle.Paint = function( me, w, h )
                Aero.CreateCircle( 0, 0, width, height, Aero.Circles[ i ], Aero.Colors.WHITE, circle_data[ i ], data[ i ] )
            end
        end

        local fav_content = Aero.GetDefaultLayout( self.Top_Header, RIGHT, self.Core_Container:GetWide() / 2 + scr_w * 0.003, self.Top_Header:GetTall(), true, "Favourite Jobs", "Your most commonly used jobs", "Circle" )

        for k, v in pairs( Aero.Favourites[ "jobs" ] or {} ) do
            local index = Aero.GetLookupByName( v.name, "jobs" )
            if not index then continue end
            Aero.BuildBaseContainer( fav_content, scr_h * 0.035, index.name, "Salary:", index.salary, index, "jobs", true )
        end

        self.Middle_Header = self.Core_Container:Add( "DPanel" )
        self.Middle_Header:Dock( TOP )
        self.Middle_Header:SetWide( self.Core_Container:GetWide() )
        self.Middle_Header:SetTall( self.Core_Container:GetTall() / 3.9 )
        self.Middle_Header:DockMargin( 0, 3, 0, 0 )
        self.Middle_Header.Paint = nil

        local staff_content = Aero.GetDefaultLayout( self.Middle_Header, FILL, self.Core_Container:GetWide(), self.Middle_Header:GetTall(), true, "Staff Online", "Staff Members online right now", "Panel" )

        for k, v in pairs( Aero.GetStaff() ) do
            local icon_size = scr_h * 0.08
            local data = Aero.Staff_Ranks[ v:GetUserGroup() ]

            local container = staff_content:Add( "DPanel" )
            container:SetWide( self.Core_Container:GetWide() / 3 - 5 )
            container:SetTall( self.Middle_Header:GetTall() - self.Middle_Header:GetTall() / 6 )

            local icon = container:Add( "CircleAvatar" )
            icon:SetPos( scr_w * 0.005, scr_h * 0.026 )
            icon:SetSize( icon_size, icon_size ) 
            icon:SetPlayer( v, icon_size )

            local name, group = v:Nick(), data.rank or "Unknown" 
            container.Paint = function( me, w, h )
                Aero.DrawText( name, "Aero.Font.7", scr_w * 0.053, h / 2 - scr_h * 0.011, Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
                Aero.DrawText( group, "Aero.Font.6", scr_w * 0.053, h / 2 + scr_h * 0.006, data.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end
        end
        
        
        self.Lower_Header = self.Core_Container:Add( "DPanel" )
        self.Lower_Header:Dock( TOP )
        self.Lower_Header:SetWide( self.Core_Container:GetWide() )
        self.Lower_Header:SetTall( self.Middle_Header:GetTall() / 1 )
        self.Lower_Header:DockMargin( 0, 3, 0, 3 )
        self.Lower_Header.Paint = nil
        
        local command_content = Aero.GetDefaultLayout( self.Lower_Header, FILL, self.Lower_Header:GetWide() - scale * 3.8, self.Middle_Header:GetTall() / 1, true, "Roleplay Commands", "Handy commands if you need them", "Panel" )
        command_content:SetSpaceX( 2 )
        command_content:SetSpaceY( 2 )
        command_content:DockMargin( scale * 3.6, scale * 3.5, 0, 0 )

        for k, v in pairs( GENERAL_COMMANDS ) do
            local button = Aero.CreateButton( command_content, 0, 0, self.Lower_Header:GetWide() / 4 - scr_w * 0.00404, scr_h * 0.035, "Aero.Font.5", v.name )
            button.DoClick = function( me )
                if v.show_box then self:Close() Aero.CreateDialogBox( v ) else RunConsoleCommand( "say", v.command ) print( "say ", v.command ) end
                surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
            end
        end
    end