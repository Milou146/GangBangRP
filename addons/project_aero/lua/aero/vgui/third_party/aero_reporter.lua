        --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]


    function Aero.DeployReporter( self )
        if not rManager then 
            Aero.SendMessage( "No content here as Reporter (https://www.gmodstore.com/market/view/reporter-the-advanced-reporting-system) is not owned. Set it to disabled if you DO NOT own it." )
            return 
        end
        local scr_w, scr_h, ply = ScrW(), ScrH(), LocalPlayer()
        local scale = ScreenScale( 1 )
        self.Core_Container = self:MakeBaseContainer()
        
        self.Top_Header = self.Core_Container:Add( "DPanel" )
        self.Top_Header:Dock( TOP )
        self.Top_Header:SetTall( scr_h * 0.039 )
        self.Top_Header:SetWide( self.Core_Container )
        self.Top_Header:DockMargin( 0, scale * 1.6, 0, scale )

        self.Top_Header.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.DARK_BLACK )
        end

        self.Dash_Panel = self.Top_Header:Add( "DPanel" )
        self.Dash_Panel:Dock( TOP )
        self.Dash_Panel:SetWide( self:GetWide() )
        self.Dash_Panel:DockMargin( 0, -4, 0, 0 )
        self.Dash_Panel:SetTall( scr_h * 0.040 )
        self.Dash_Panel.Paint = nil

        self.Button_Dashboard = self.Dash_Panel:Add( "DIconLayout" )
        self.Button_Dashboard:Dock( FILL )
        self.Button_Dashboard:SetSpaceX( 2 )

        self.Button_Dashboard.Paint = function( me, w, h )
            --Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_HEADER )
        end

        self.Body = self.Core_Container:Add( "DPanel" )
        self.Body:Dock( TOP )
        self.Body:SetSize( self.Core_Container:GetWide() - scr_w * 0.009, scr_h * 0.47 )
        self.Body:DockMargin( scale * 0.4, 0, scale * 0.4, 0 )

        self.Body.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
        end

        local index = 1
        local buttons = {
            "Report a User",
            "My Warnings"
        }

        for k, v in pairs( buttons ) do
            local btn = Aero.CreateButton( self.Button_Dashboard, 0, 0, scr_w * 0.08, scr_h * 0.041, "Aero.Font.8", v )
            btn.Paint = function( me, w, h )
                if index == k then
                    Aero.DrawRect( 0, h - 2, w, h, Aero.Colors.GREEN )
                end
                --Aero.DrawRect( 0, 0, w, h, Aero.Colors.DARK_BLACK )
            end

            btn.DoClick = function()
                index = k
                self.Body:Clear()
                if index == 1 then
                    rManager.CatchReport( self.Body )
                else
                    rManager.GetPersonalWarnings( self, self.Body, true )
                end
            end
        end

        rManager.CatchReport( self.Body )
    end

