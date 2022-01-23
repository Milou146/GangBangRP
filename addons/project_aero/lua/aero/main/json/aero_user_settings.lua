
    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]
    
    Aero.Favourites = {}

    local folders = {
        "Aero/",
        "Aero/user_settings/",
        "Aero/reward_data/",
        "Aero/money_spent/"
    }

    local directory = "DATA"
    local settings_path = folders[ 2 ]

    function Aero.CreateStructure()
        for k, v in pairs( folders ) do
            if not file.IsDir( v, directory ) then
                file.CreateDir( v )
            end
        end
    end
    hook.Add( "Initialize", "Aero.Create.Structure", Aero.CreateStructure )

    function Aero.LoadSettingData( ply )
        local file_name = ply:SteamID64() .. ".txt"
        if not file.Exists( settings_path .. file_name, directory ) then return end
        Aero.Favourites[ ply:SteamID() ] = util.JSONToTable( file.Read( settings_path .. file_name ), directory )
    end
    hook.Add( "PlayerInitialSpawn", "Aero.Load.Setting.Data", Aero.LoadSettingData )

    function Aero.CreateSettingFile( ply )
        local file_name = ply:SteamID64() .. ".txt"
        if not file.Exists( settings_path .. file_name, directory ) then
            file.Write( settings_path .. file_name, "[]" )
        end
    end

    function Aero.UpdateSettingFile( ply, tbl )
        local file_name = ply:SteamID64() .. ".txt"
        file.Write( settings_path .. file_name, util.TableToJSON( Aero.Favourites[ ply:SteamID() ] ) )
    end
