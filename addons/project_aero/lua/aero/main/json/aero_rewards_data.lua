    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    if not Aero.Modules[ "Rewards" ] then return end

    local directory = "Aero/reward_data/"
    local path = "DATA"

    function Aero.PrepareF4Rewards( ply )
        local file_name = ply:SteamID64() .. ".txt"
        if not file.Exists( directory .. file_name, path ) then
            Aero.Rewards[ ply:SteamID() ] = {
                [ "Hourly" ] = {
                    start_time = os.time(),
                    length = 60 * 60, -- 1 hour,
                    reward = Aero.Playtime_Payouts[ "Hourly" ],
                    can_claim = false,
                    times_claimed = 0
                },
                [ "Daily" ] = {
                    start_time = os.time(),
                    length = 24 * 3600, -- 24 hour,
                    reward = Aero.Playtime_Payouts[ "Daily" ],
                    can_claim = false,
                    times_claimed = 0
                },
                [ "Weekly" ] = {
                    start_time = os.time(),
                    length = 604800, -- 7 days,
                    reward = Aero.Playtime_Payouts[ "Weekly" ],
                    can_claim = false,
                    times_claimed = 0
                },
                [ "Weekly-Shipment" ] = {
                    start_time = os.time(),
                    length = 604800, -- 7 days,
                    reward = nil,
                    can_claim = false,
                    times_claimed = 0
                }
            }
            Aero.Rewards[ ply:SteamID() ][ "Tasks" ] = {}
            for k, v in pairs( Aero.Rewards[ ply:SteamID() ] ) do
                if not v.time_left then
                    v.time_left = v.length
                    v.session_start = v.time_left
                end
            end
            file.Write( directory .. file_name, util.TableToJSON( Aero.Rewards[ ply:SteamID() ] ) )
        else
            Aero.Rewards[ ply:SteamID() ] = util.JSONToTable( file.Read( directory .. file_name ), path )
            Aero.Tasks[ ply:SteamID() ] = Aero.Rewards[ ply:SteamID() ][ "Tasks" ]
            Aero.Rewards[ ply:SteamID() ][ "Tasks" ] = nil

            for k, v in pairs( Aero.Rewards[ ply:SteamID() ] ) do
                v.session_start = v.time_left
                v.start_time = os.time()
            end
        end
        Aero.StartTimers( ply )
    end
    hook.Add( "PlayerInitialSpawn", "Aero.PrepareF4Rewards", Aero.PrepareF4Rewards )

    function Aero.UpdateRewardFile( ply )
        if not Aero.Rewards[ ply:SteamID() ][ "Tasks" ] then
            Aero.Rewards[ ply:SteamID() ][ "Tasks" ] = Aero.Tasks[ ply:SteamID() ]
        end
        local file_name = ply:SteamID64() .. ".txt"
        file.Write( directory .. file_name, util.TableToJSON( Aero.Rewards[ ply:SteamID() ] ) )
    end