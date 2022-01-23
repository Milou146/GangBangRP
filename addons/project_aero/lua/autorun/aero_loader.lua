    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]
    
    
    --> Declare global Aero chocolate bar <--
    Aero = Aero or {}

    --> Tracks users progress for certain rewards. <--
    Aero.Rewards = Aero.Rewards or {}

    --> Users actual task progress <--
    Aero.Tasks = Aero.Tasks or {}

    --> Materials used in Aero <--
    Aero.Materials = {
        DASHBOARD = Material( "icons/dashboard.png" ),
        JOBS = Material( "icons/jobs.png" ),
        ITEMS = Material( "icons/items.png" ),
        NEXUS = Material( "icons/chance.png" ),
        REWARDS = Material( "icons/rewards.png" ),
        MONEY = Material( "icons/money.png" ),
        SHIPMENT = Material( "icons/shipments.png" ),
        STEAM = Material( "icons/steam.png" ),
        DISCORD = Material( "icons/discord.png" ),
        HEART = Material( "icons/heart.png" ),
        HEART_GRADIENT = Material( "icons/heart_fav.png" ),
        SEARCH = Material( "icons/search.png" ),
        CIRCLE_FILLED = Material( "skeleton/circle_filled.png" ),
        CIRCLE_OUTLINE = Material( "skeleton/circle_outline.png" ),
        REPORT = Material( "icons/report.png" ),
    }

    if SERVER then
        resource.AddWorkshop( "2161619974" )
        util.AddNetworkString( "Aero.SendMessage" )
        --> Sends a message to a specific client <--
        function Aero.SendMessage( ply, message )
            net.Start( "Aero.SendMessage" )
                net.WriteString( message )
            net.Send( ply )
        end

        --> Returns if a shipment exists <--
        function Aero.GetShipments()
            local shipments = {}
            for k, v in pairs( CustomShipments ) do
                if v.noship then continue end
                table.insert( shipments, { key = k, v = v  } )
            end
            return shipments
        end

        --> Creates a Shipment in the world <--
        function Aero.CreateShipment( ply, key, item )
            item = item.v
            if not DarkRP then print( string.format( 'Error creating %s, gamemode is not %s', item.name, 'DarkRP' ) ) return end
            local ent = ents.Create( "spawned_shipment" )
            if not IsValid( ent ) then 
                Aero.SendMessage( ply, "Failed to create entity " .. item.name .. " shipment does not exist. Please fix this." )
                return
            end
            ent:SetPos( ply:GetPos() + ply:GetForward() * 100 + Vector( 0, 0, 20 ) )
            ent:SetPlayer( ply )   
            ent:SetContents( key, item.amount )
            ent:Spawn()
            ent.SID = ply.SID
        end
    else
        function Aero.SendMessage( message )
            chat.AddText( Aero.Prefix_Color, Aero.Chat_Prefix, Aero.Chat_Color, message )
        end

        net.Receive( "Aero.SendMessage", function()
            Aero.SendMessage( net.ReadString() or "Message Error." )
        end )
    end

    --> Returns if Theme is set to Blur <--
    function Aero.UsingBlur()
        return Aero.Theme == "Classic"
    end

    --> Returns the table of a specific name <--
    function Aero.GetLookupByName( name, origin )
        local points = {
            [ "jobs" ] = RPExtraTeams,
            [ "items" ] = DarkRPEntities,
            [ "singles" ] = CustomShipments,
            [ "shipments" ] = CustomShipments,
            [ "ammo" ] = GAMEMODE.AmmoTypes,
            [ "food" ] = FoodItems,
            [ "vehicles" ] = CustomVehicles
        }
        for k, v in pairs( points[ origin ] or {} ) do
            if name == v.name then
                return table.Copy( v )
            end
        end
        return nil
    end

    --> Returns a job based on name <--
    function Aero.GetJobIndex( name )
        local low = string.lower
        for k, v in pairs( RPExtraTeams ) do
            if low( name ) == low( v.name ) then
                return k, v
            end
        end
    end

    --> Returns all strings that possibly match a search <--
    function Aero.GetWithName( name, origin )
        local low = string.lower
        local data = {}
        local table_origin = {
            [ "jobs" ] = RPExtraTeams,
            [ "items" ] = DarkRPEntities,
            [ "singles" ] = CustomShipments,
            [ "shipments" ] = CustomShipments,
            [ "ammo" ] = GAMEMODE.AmmoTypes,
            [ "food" ] = FoodItems,
            [ "vehicles" ] = CustomVehicles
        }
        for k, v in pairs( table_origin[ origin ] or {} ) do
            if string.find( low( v.name ), low( name ) ) then
                table.insert( data, v )
            end
        end
        return data
    end

    --> Get all members of Staff <--
    function Aero.GetStaff()
        local staff = {}
        for k, v in pairs( player.GetAll() ) do
            if Aero.Staff_Ranks[ v:GetUserGroup() ] then
                table.insert( staff, v )
            end
        end
        return staff
    end

    --> The core folders releated to Aero <--
    Aero.Folders = {
        [ "root" ] = "Aero/",
        [ "main" ] = "main/",
        [ "vgui" ] = "vgui/"
    }

    --> The core files that make Aero tick <--
    Aero.Files = {
        { name = "aero_config.lua", type = "SHARED" },
        { name = "json/aero_user_settings.lua", type = "SERVER" },
        { name = "json/aero_rewards_data.lua", type = "SERVER" },
        { name = "json/aero_money_spent.lua", type = "SERVER" },
        { name = "aero_core.lua", type = "SERVER" },
        { name = "aero_reward_handler.lua", type = "SERVER" },

        { name = "helpers/aero_avatar.lua", type = "CLIENT" },
        { name = "helpers/aero_checkbox.lua", type = "CLIENT" },
        { name = "helpers/aero_functions.lua", type = "CLIENT" },
        { name = "tabs/aero_rewards.lua", type = "CLIENT" },
        { name = "aero_frame.lua", type = "CLIENT" },

        { name = "tabs/aero_jobs.lua", type = "CLIENT" },
        { name = "tabs/aero_items.lua", type = "CLIENT" },
        { name = "tabs/aero_singles.lua", type = "CLIENT" },
        { name = "tabs/aero_shipments.lua", type = "CLIENT" },
        { name = "tabs/aero_ammo.lua", type = "CLIENT" },
        { name = "tabs/aero_food.lua", type = "CLIENT" },
        { name = "tabs/aero_vehicles.lua", type = "CLIENT" },

        { name = "third_party/aero_nexus.lua", type = "CLIENT" },
        { name = "third_party/aero_reporter.lua", type = "CLIENT" },

        { name = "aero_dashboard.lua", type = "CLIENT" },
        { name = "helpers/aero_skeleton.lua", type = "CLIENT" },
        { name = "helpers/aero_button_list.lua", type = "CLIENT" },
    }

    hook.Add( "PostGamemodeLoaded", "Aero.Block.Defaults", function()
        function GAMEMODE:ShowSpare2() return false end -- This overwrites the default F4 menu, because there's no hook attatched to it.
    end )

    --> Loads all Aero files into their designated sections <--
    function Aero.Load()
        local root, core, vgui = Aero.Folders[ "root" ], Aero.Folders[ "main" ], Aero.Folders[ "vgui" ]
        for k, v in pairs( Aero.Files ) do
            if v.type == "SERVER" then
                if SERVER then include( root .. core .. v.name ) end
            elseif v.type == "CLIENT" then
                if SERVER then AddCSLuaFile( root .. vgui .. v.name ) else include( root .. vgui .. v.name ) end
            else
                if SERVER then AddCSLuaFile( v.name ) include( v.name ) else include( v.name ) end
            end
        end
    end

    --> Make Aero load <--
    Aero.Load()

