    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]
    
    local function ReturnWeaponStr( data )
        local str = ""
        for k, v in pairs( data ) do
            str = str .. v .. ( k == #data and "" or ",\n" )
        end
        if #data < 1 then str = "No extra weapons are given." end
        return str
    end

    local PURCHASE_ACTIONS = {
        [ "items" ] = function( ply, v )
            RunConsoleCommand( "darkrp", v.cmd )
        end,
        [ "singles" ] = function( ply, v )
            RunConsoleCommand( "darkrp", "buy", v.name )
        end,
        [ "shipments" ] = function( ply, v )
            RunConsoleCommand( "darkrp", "buyshipment", v.name )
        end,
        [ "ammo" ] = function( ply, v )
            RunConsoleCommand( "darkrp", "buyammo", v.ammoType )
        end,
        [ "food" ] = function( ply, v )
            RunConsoleCommand( "darkrp", "buyfood", v.ammoType )
        end,
        [ "vehicles" ] = function( ply, v )
            RunConsoleCommand( "darkrp", "buyvehicle", v.ammoType )
        end,
    }

    local function IsFavourite( name, origin )
        for k, v in pairs( Aero.Favourites[ origin ] or {} ) do
            if v.name == name then return true end
        end
        return false
    end

    Aero.Object = nil
    function Aero.BuildBaseContainer( parent, height, name, price_str, price, v, origin, full_length )
        local scr_w, scr_h = ScrW(), ScrH()
        height = scr_h * 0.065
        local end_y = height / 2 - scr_h * 0.070 / 2
        local circle_w, circle_h = scr_w * 0.55, scr_h * 0.09
        local full_circle_w, full_circle_h = scr_w * 0.04, scr_h * 0.070
        local section = nil
        local ply = LocalPlayer()

        if origin != "jobs" then
            full_circle_w, full_circle_h = scr_w * 0.035, scr_h * 0.064
        end

        local container = vgui.Create( "DPanel", parent )
        container:SetWide( full_length and parent:GetWide() or parent:GetWide() / 2 - 8.8 )
        container:SetTall( scr_h * 0.063 )

        container.Paint = function( me, w, h )
            if Aero.UsingBlur() or !Aero.UsingBlur() and !full_length then
                Aero.DrawRoundedBox( 6, full_length and 3 or 0, 0, full_length and w - scr_w * 0.004 or w - scr_w * 0.001, h, me:IsHovered() and Aero.Colors.BASE_HEADER or Aero.Colors.DARK_BLACK )
            end
            Aero.DrawText( name, "Aero.Font.7", scr_w * 0.040, height / 2 - scr_h * 0.005, me:IsHovered() and Aero.Colors.WHITE or Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            Aero.DrawText( price_str .. " $" .. string.Comma( price or 0 ), "Aero.Font.5", scr_w * 0.040, height / 2 + scr_h * 0.010, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        local circle = container:Add( "DPanel" )
        circle:SetPos( 0, -scr_h * 0.004 )
        circle:SetSize( full_circle_w, full_circle_h )
        circle.Paint = function( me, w, h )
            Aero.QuickFullCircle()
        end

        local model = circle:Add( "DModelPanel" )
        model:SetSize( scr_h * 0.043, scr_h * 0.0485 )
        model.LayoutEntity = function() return end
        model:SetPos( scr_h * 0.0115, scr_h * 0.013 )
        model:SetModel( type( v.model ) == "table" and v.model[ 1 ] or v.model )
        model:SetFOV( 38 )

        if origin == "jobs" then
            model:SetCamPos( Vector( 25, 0, 66 ) )
            model:SetLookAt( Vector( 10, 0, 66 ) )
        else
            local mn, mx = model.Entity:GetRenderBounds()
            local size = 0
            size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
            size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
            size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
            model:SetCamPos( Vector( size, size, size ) )
            model:SetLookAt( ( mn + mx ) * 0.5 )
        end

        container.OnMousePressed = function()
            surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
            if not PURCHASE_ACTIONS[ origin ] then
                -- jobs
                if not Aero.Hide_Unusable_Jobs and v.customCheck and not v.customCheck( ply ) then
                    notification.AddLegacy( v.CustomCheckFailMsg or "You do not meet the criteria to use this job.", 1, 5 )
                    return
                end
                Aero.DeployJobPreview( v )
            else
                PURCHASE_ACTIONS[ origin ]( ply, v )
                net.Start( "Aero.Handle.Request" )
                    net.WriteString( name )
                    net.WriteString( origin )
                    net.WriteBool( false )
                net.SendToServer()
            end
        end

        local favourite = container:Add( "DPanel" )
        favourite:SetSize( scr_h * 0.0225, scr_h * 0.0225 )
        favourite:SetPos( scr_w * 0.178, container:GetTall() / 2 - favourite:GetTall() / 2 + scr_h * 0.003 )
        favourite.WasPressed = IsFavourite( name, origin )

        local default_color = Color( 104, 104, 104, 40 )
        favourite.OnMousePressed = function( me )
            me.WasPressed = !me.WasPressed
            net.Start( "Aero.Handle.Request" )
                net.WriteString( name )
                net.WriteString( origin )
                net.WriteBool( true )
            net.SendToServer()
            if me.WasPressed then
                surface.PlaySound( "garrysmod/balloon_pop_cute.wav" )
                if not Aero.Favourites[ origin ] then
                    Aero.Favourites[ origin ] = {}
                end
                table.insert( Aero.Favourites[ origin ], { name = name } )
                Aero.DeployTab( Aero.Object, origin, true )
            else
                for k, v in pairs( Aero.Favourites[ origin ] ) do
                    if v.name == name then
                        table.RemoveByValue( Aero.Favourites[ origin ], v )
                    end 
                end
                Aero.DeployTab( Aero.Object, origin, true ) 
            end
        end

        favourite.Paint = function( me, w, h )
            local hovered = me:IsHovered()
            Aero.DrawTexture( me.WasPressed and Aero.Materials.HEART_GRADIENT or Aero.Materials.HEART, 0, 0, w, h, me.WasPressed and Aero.Colors.WHITE or default_color ) 
        end
        
        if origin != "jobs" then 

            local possible_strs = {
                [ "items" ] = ( v.max or "" ) .. " Max",
                [ "singles" ] = "Single",
                [ "shipments" ] = "x" .. ( v.amount or 0 ),
                [ "ammo" ] = "x" .. ( v.amountGiven or 0 ),
                [ "food" ] = "+" .. ( v.healthGiven or 0 ),
                [ "vehicles" ] = "∞"
            }

            local max_ents = container:Add( "DPanel" )
            max_ents:SetSize( scr_w * 0.027, scr_h * 0.0175 )
            max_ents:SetPos( scr_w * 0.192, max_ents:GetTall() / 2 + scr_h * 0.017 ) 
            max_ents.Paint = function( me, w, h )
                Aero.DrawText( possible_strs[ origin ] or ":(", "Aero.Font.5", w / 2, h / 2, Aero.Colors.GREY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.DARK_BLACK )
            end

            parent:Add( container ) 
            return 
        end

        local circle_container = container:Add( "DPanel" )
        circle_container:SetPos( scr_w * 0.19, -scr_w * 0.005 ) 
        circle_container:SetSize( circle_w, circle_h )


        local key, value = Aero.GetJobIndex( name )
        circle_container.Paint = function( me, w, h )
            Aero.QuickOutlineCircle( v.color, 360, team.NumPlayers( key ) .. "/" .. ( value.max == 0 and "∞" or value.max ), w, h )
        end

        parent:Add( container )
    end

    function Aero.MakeTextField( parent, x, y, width, height, txt, search_bar )
        local container = nil
        local scr_w, scr_h = ScrW(), ScrH()
        local bar_width = scr_w * 0.009
        if search_bar then
            container = parent:Add( "DPanel" )
            container:SetPos( x, y )
            container:SetSize( width, height )
            container.Paint = function( me, w, h )
                Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
                Aero.DrawTexture( Aero.Materials.SEARCH, scr_w * 0.0021, h / 2 - scr_h * 0.0075, scr_w * 0.0084, scr_h * 0.015, Aero.Colors.GREY )
            end
        end
        if container then
            x = x + bar_width
            y = y - scr_h * 0.006
        end
        local object = container and container:Add( "DTextEntry" ) or parent:Add( "DTextEntry" )
        object:SetSize( width, height )
        object:SetPos( x, y )
        object:SetText( txt )
        object:SetFont( "Aero.Font.6" )

        object.OnMousePressed = function( me ) me:SetText( "" ) end

        object.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
            me:DrawTextEntryText( Aero.Colors.GREY, Aero.Colors.RED, Aero.Colors.WHITE )
        end
        return object
    end

    Aero.Category_Data = {}
    function Aero.CreateCategory( self, name, tbl, origin, color )
        local scr_w, scr_h = ScrW(), ScrH()
        local scale = ScreenScale( 1 )
        local ply = LocalPlayer()

        if color != nil then color.a = 100 end

        local useable_content = {}

        for k, v in pairs( tbl or {} ) do
            if v.canSee and not v.canSee( ply ) then
                continue
            end
            if origin == "singles" and not GAMEMODE.Config.restrictbuypistol then
                table.insert( useable_content, v )
                continue
            end
            if Aero.Hide_Unusable_Jobs then
                if v.customCheck and not v.customCheck( ply ) then
                    continue
                end
            end
            if v.allowed then
                if type( v.allowed ) == "table" then
                    if not table.HasValue( v.allowed, ply:Team() ) then continue end
                else
                    if ply:Team() != v.allowed then continue end
                end
            end
            table.insert( useable_content, v )
        end

        if table.Count( useable_content ) < 1 then return end

        self.Category = self:Add( "DCollapsibleCategory" )
        self.Category:Dock( TOP )
        self.Category:SetLabel( "" )
        self.Category.Header:SetTall( scr_h * 0.035 )
        self.Category:SetWide( self:GetWide() )

        self.Category.Paint = function( me, w, h )
            Aero.DrawRect( 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
            Aero.DrawRect( scr_w * 0.002, 0, scr_w * 0.0015, scr_h * 0.033, color or Aero.Colors.GREY ) 
            Aero.DrawText( name, "Aero.Font.8", w * 0.015, scr_h * 0.017, Aero.Colors.WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end

        self.Category_Content = vgui.Create( "DIconLayout", self.Category )
        self.Category_Content:Dock( TOP )
        self.Category_Content:SetSize( self.Category:GetWide(), self.Category:GetTall() )
        self.Category_Content:SetSpaceX( 1 )
        self.Category_Content:SetSpaceY( 4 )

        for k, v in pairs( tbl or {} ) do
            local index = Aero.GetLookupByName( v.name, origin )
            if not index then continue end
            if origin == "singles" then
                if !index.seperate then continue end
                index.price = index.pricesep
            elseif origin == "shipments" then
                if index.noship then continue end
                index.price = index.price
            else
                index.price = index.price
            end
            if Aero.Hide_Unusable_Jobs then
                if v.customCheck and not v.customCheck( ply ) then
                    continue
                end
                if v.allowed then
                    if type( v.allowed ) == "table" then
                        if not table.HasValue( v.allowed, ply:Team() ) then continue end
                    else
                        if ply:Team() != v.allowed then continue end
                    end
                end
            end
            Aero.BuildBaseContainer( self.Category_Content, scr_h * 0.035, index.name, index.salary and "Salary:" or "Price:", index.salary or index.price, index, origin )
        end

        return self.Category
    end

    function Aero.DeployTab( self, id, block_nav )
        local name_type = {
            [ "items" ] = "entities",
            [ "singles" ] = "shipments",
        }
        if not self then return end
        self.Core_Container = self:MakeBaseContainer()
        if not block_nav then Aero.DeployNavBar( self, id ) end
        if self.Show_Favourite.Active then
            self.Favourites = Aero.CreateCategory( self.Core_Container, "Your Favourites", Aero.Favourites[ id ], id, nil )
        end
        if self.Show_Recent.Active and Aero.Recent_Cache[ id ] then
            local title = id:gsub( "^%l", string.upper )
            self.Recent = Aero.CreateCategory( self.Core_Container, "Recent " .. title, Aero.Recent_Cache[ id ], id, nil )
        end
        local sorted_data = Aero.GetSortedCategories( name_type[ id ] or id )
        Aero.SortCategoryContent( self, sorted_data, id )
        Aero.Object = self
    end

    local frame_open = false
    function Aero.DeployJobPreview( v )
        if frame_open == true then return end
        frame_open = true
        local scr_w, scr_h, ply = ScrW(), ScrH(), LocalPlayer()
        local preview_width, preview_height = scr_w * 0.35, scr_h * 0.45
        local frame = Aero.MakeDFrame( preview_width, preview_height, v.name or "Unknown", Aero.Colors.BASE_CONTAINER, nil, nil, nil, true )
        frame.Think = function( me )
            me:MoveToFront()
        end
        frame.OnRemove = function()
            frame_open = false
        end

        local preview_y_pos = scr_h * 0.045

        local model_preview = frame:Add( "DModelPanel" )
        model_preview:Dock( LEFT )
        model_preview:SetSize( scr_w * 0.12, frame:GetTall() - preview_y_pos )
        model_preview:SetCamPos( Vector( 45, 0, 70 ) )
        model_preview:SetFOV( 70 )
        model_preview:SetMouseInputEnabled( false )
        model_preview:SetModel( type( v.model ) == "table" and v.model[ 1 ] or v.model )
        model_preview.LayoutEntity = function() return end

        model_preview.Paint = function( me, w, h )
            Aero.DrawOutline( 0, 0, w, h, 2, Aero.Colors.DARK_BLACK )
            baseclass.Get( "DModelPanel" ).Paint( me, w, h )
        end

        local description_container = frame:Add( "DPanel" )
        description_container:Dock( TOP )
        description_container:SetTall( scr_h * 0.092 )
        description_container:SetWide( frame:GetWide() - model_preview:GetWide() )

        description_container.Paint = function( me, w, h )
            Aero.DrawText( "Description", "Aero.Font.7", scr_w * 0.0255, scr_h * 0.010, Aero.Colors.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local description = vgui.Create( "DLabel", description_container )
        description:SetPos( scr_w * 0.003, scr_h * 0.023 )
        description:SetSize( scr_w * 0.22, description_container:GetTall() )
        description:SetWrap( true )
        description:SetText( v.description:gsub( "%s+", "-" ):gsub( "-", " " ) )
        description:SetContentAlignment( 7 )
        description:SetFont( "Aero.Font.6" )
        description:SetTextColor( Aero.Colors.GREY )

        local weapon_container = frame:Add( "DPanel" )
        weapon_container:Dock( TOP )
        weapon_container:SetTall( scr_h * 0.123 )
        weapon_container:SetWide( frame:GetWide() - model_preview:GetWide() )

        weapon_container.Paint = function( me, w, h )
            Aero.DrawText( "Weapons", "Aero.Font.7", scr_w * 0.022, scr_h * 0.010, Aero.Colors.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local weapons = vgui.Create( "DLabel", weapon_container )
        weapons:SetPos( scr_w * 0.003, scr_h * 0.023 )
        weapons:SetSize( scr_w * 0.22, weapon_container:GetTall() )
        weapons:SetWrap( true )
        weapons:SetText( ReturnWeaponStr( v.weapons ) )
        weapons:SetContentAlignment( 7 )
        weapons:SetFont( "Aero.Font.6" )
        weapons:SetTextColor( Aero.Colors.GREY )

        local model_preview_container = frame:Add( "DPanel" )
        model_preview_container:Dock( TOP )
        model_preview_container:SetTall( scr_h * 0.15 )
        model_preview_container.Paint = nil

        local model_scroll = model_preview_container:Add( "DScrollPanel" )
        model_scroll:Dock( FILL )
        Aero.PaintBar( model_scroll, nil, nil, Aero.Colors.DARK_BLACK )

        local model_container = model_scroll:Add( "DIconLayout" )
        model_container:Dock( TOP )
        model_container:DockMargin( 2, 0, 2, 0 )
        
        for k, value in pairs( type( v.model ) == "table" and v.model or { v.model } ) do

            local circle = model_container:Add( "DPanel" )
            circle:SetPos( 0, -scr_h * 0.004 )
            circle:SetSize( scr_w * 0.04, scr_h * 0.070 )
            circle.Paint = function( me, w, h )
                Aero.QuickFullCircle()
            end

            local model = circle:Add( "DModelPanel" )
            model:SetSize( scr_h * 0.043, scr_h * 0.0485 )
            model.LayoutEntity = function() return end
            model:SetPos( scr_h * 0.0115, scr_h * 0.013 )
            model:SetModel( value )
            model:SetFOV( 38 )
            model:SetCamPos( Vector( 25, 0, 66 ) )
            model:SetLookAt( Vector( 10, 0, 66 ) )

            model.OnMousePressed = function()
                model_preview:SetModel( value )
                DarkRP.setPreferredJobModel( Aero.GetJobIndex( v.name ), value )
            end
        end

        local become_job = Aero.CreateButton( frame, 0, 0, frame:GetWide(), scr_h * 0.035, "Aero.Font.5", "Become Job" )
        become_job:Dock( TOP )
        become_job:DockMargin( 4, 0, 0, 0 )
        local hover_color = Aero.ConvertColour( Aero.Colors.BASE_CONTAINER, 1 )
        become_job.Paint = function( me, w, h )
            Aero.DrawRoundedBox( 6, 0, 0, w, h, me:IsHovered() and hover_color or Aero.Colors.DARK_BLACK )
        end

        become_job.DoClick = function()
            RunConsoleCommand( "darkrp", ( v.vote and "vote" .. v.command ) or v.command )
            frame:Close()
            net.Start( "Aero.Handle.Request" )
                net.WriteString( v.name )
                net.WriteString( "jobs" )
                net.WriteBool( false )
            net.SendToServer()
            surface.PlaySound( "physics/plaster/ceiling_tile_impact_soft2.wav" )
        end
    end

    --> Creates the whole Job layout <--
    function Aero.DeployJobs( self )
        Aero.DeployTab( self, "jobs" )
    end

