
    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    function Aero.GetDefaultLayout( parent, origin, width, height, horizontal, main_str, sub_str, type )
        
        local scr_w, scr_h = ScrW(), ScrH()
        local margin = ScreenScale( 3 )

        local container = parent:Add( "DPanel" )
        container:Dock( origin )
        container:SetWide( width )
        container:SetTall( height )
        if type == "Circle" then container:DockMargin( 0, margin / 2, 0, 0 ) end
        container.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
        end

        local header = container:Add( "DPanel" )
        header:Dock( TOP )
        header:SetWide( width )
        header:SetTall( ( origin == FILL and parent:GetTall() / 4 or parent:GetTall() / 6 ) )
        header.Paint = function( me, w, h )
            Aero.DrawText( main_str, "Aero.Font.7", scr_w * 0.005, scr_h * 0.015, Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            Aero.DrawText( sub_str, "Aero.Font.6", scr_w * 0.005, scr_h * 0.033, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local scroll
        if origin == FILL then
            scroll = container:Add( "DScrollPanel" )
            scroll:Dock( FILL )
            scroll:SetSize( width, height )
            Aero.PaintBar( scroll, nil, nil, Aero.Colors.DARK_BLACK )
        end

        local content = scroll and scroll:Add( "DIconLayout" ) or container:Add( "DIconLayout" )
        content:Dock( FILL )
        content:SetSize( width, height - header:GetTall() )
        if origin == LEFT then
            content:DockMargin( margin * 2.32, margin * 2, margin, 0 )
        end
        if type == "Circle" then
            content:SetSpaceX( 0 )
            content:SetSpaceY( 0 )
        else
            content:SetSpaceX( 0 )
            content:SetSpaceY( 0 )
        end 

        return content
    end
   
    function Aero.SortCategoryContent( self, content, origin )
        if content == nil then -- Food/Vehicles, WHY is there no category for this in DarkRP???
            local backup = {
                [ "food" ] = { 
                    name = "Other",
                    sortOrder = 100,
                    members = FoodItems,
                    color = Aero.Colors.GREY
                }
            }
            content = { backup[ origin ] }
        end
        for k, v in pairs( content ) do
            if v.members and #v.members < 1 then continue end
            Aero.CreateCategory( self.Core_Container, v.name, v.members, origin, v.color )
        end
    end

    function Aero.GetSortedCategories( name )
        local to_sort = DarkRP.getCategories()[ name ]
        if not to_sort then return end

        table.sort( to_sort, function( a, b )
            if a.sortOrder and b.sortOrder then return a.sortOrder < b.sortOrder end
        end )

        return to_sort
    end

    local recent_check_cache = true
    local favourite_check_cache = true

    function Aero.DeployNavBar( self, origin )

        local scr_w, scr_h = ScrW(), ScrH()

        self.Top_Header = self:Add( "DPanel" )
        self.Top_Header:Dock( TOP )
        self.Top_Header:SetTall( scr_h * 0.035 )
        self.Top_Header:SetWide( self:GetWide() - self.Dashboard:GetWide() )

        self.Top_Header.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.DARK_BLACK )
        end

        self.Search = Aero.MakeTextField( self.Top_Header, scr_w * 0.003, scr_h * 0.0065, scr_w * 0.10, scr_h * 0.023, "Search by name..", true )
        self.Search.Query_Ran = false

        self.Show_Recent = self.Top_Header:Add( "Skeleton.Checkbox" )
        self.Show_Recent:SetText( "Show recent" )
        self.Show_Recent:SetSize( scr_w * 0.085, scr_h * 0.023 )
        self.Show_Recent:SetPos( self.Top_Header:GetWide() - scr_w * 0.18, scr_h * 0.0065 )
        self.Show_Recent:SetChecked( recent_check_cache )
        self.Show_Recent:SetCallback( function( me )
            if self.Core_Container then
                self.Core_Container:Clear()
                Aero.DeployTab( self, origin, true )
                recent_check_cache = !recent_check_cache
            end
        end )

        self.Show_Favourite = self.Top_Header:Add( "Skeleton.Checkbox" )
        self.Show_Favourite:SetText( "Show favourites" )
        self.Show_Favourite:SetSize( scr_w * 0.085, scr_h * 0.023 )
        self.Show_Favourite:SetPos( self.Top_Header:GetWide() - scr_w * 0.093, scr_h * 0.0065 )
        self.Show_Favourite:SetChecked( favourite_check_cache )
        self.Show_Favourite:SetCallback( function( me )
            if self.Core_Container then
                self.Core_Container:Clear()
                Aero.DeployTab( self, origin, true )
                favourite_check_cache = !favourite_check_cache
            end
        end )

        self.Search.OnChange = function( me )
            if #me:GetText() < 1 then 
                if self.Search.Query_Ran then
                    self.Search.Query_Ran = false
                    self.Core_Container:Clear()
                    self.Core_Container:SetWide( self.Top_Header:GetWide() )
                    Aero.CreateCategory( self.Core_Container, "Your Favourites",  Aero.Favourites[ origin ], origin )
                    local sorted_data = Aero.GetSortedCategories( origin )
                    Aero.SortCategoryContent( self, sorted_data, origin )
                    return
                end
            end
            local input = me:GetText()
            self.Search.Query_Ran = true
            self.Core_Container:Clear()
            self.Core_Container:SetWide( self.Top_Header:GetWide() )
            Aero.CreateCategory( self.Core_Container, "Your Search: " .. input, Aero.GetWithName( input, origin ), origin )
        end
    end

    function Aero.GetF4Press()
        local scr_w, scr_h = ScrW(), ScrH()
        local self = vgui.Create( "Skeleton_Base" )
        self:Center()
        self:MakePopup()
        self:SetMainTitle( Aero.Main_Title )

        Aero.Favourites = net.ReadTable()
        Aero.Recent_Cache = net.ReadTable()
        Aero.Tasks = net.ReadTable()
        Aero.Rewards = net.ReadTable()
        Aero.Active_Printers = net.ReadInt( 9 )
        Aero.MoneySpent = net.ReadInt( 32 )

        self.OnClose = function()
            Aero.CirclesReset()
        end
        
        self.Core_Container = self:MakeBaseContainer()

        Aero.DeployDashboard( self )
        Aero.DashboardButtons( self )
    
    end
    net.Receive( "Aero.Open.F4", Aero.GetF4Press )
    