    
    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    Aero.Recent_Cache = {}

    util.AddNetworkString( "Aero.Open.F4" )
    --> Function called when someone presses F4 <--
    function Aero.OpenF4( ply )
        if Nexus then
            Nexus.SetClientData( ply )
        end
        net.Start( "Aero.Open.F4" )
            net.WriteTable( Aero.Favourites[ ply:SteamID() ] or {} )
            net.WriteTable( Aero.Recent_Cache[ ply:SteamID() ] or {} )
            net.WriteTable( Aero.Tasks[ ply:SteamID() ] or {} )
            net.WriteTable( Aero.Rewards[ ply:SteamID() ] or {} )
            net.WriteInt( Aero.Active_Printers, 9 )
            net.WriteInt( Aero.MoneySpent, 32 )
        net.Send( ply )
    end
    hook.Add( "ShowSpare2", "Aero.Open.F4", Aero.OpenF4 )

    --> Returns if a name is found in a pool of origins <--
    function Aero.IsInPool( ply, name, origin, favourite )
        local tbl = favourite and Aero.Favourites[ ply:SteamID() ] or Aero.Recent_Cache[ ply:SteamID() ]
        for k, v in pairs( tbl and tbl[ origin ] or {} ) do
            if v.name == name then
                return true
            end
        end
        return false
    end

    --> Handles recent and favourites. <--
    function Aero.HandleItemPress( ply, name, origin, favourite )
        local reference = nil
        if favourite and not Aero.Favourites[ ply:SteamID() ] then
            Aero.Favourites[ ply:SteamID() ] = {}
            Aero.CreateSettingFile( ply )
        end
        if not favourite and not Aero.Recent_Cache[ ply:SteamID() ] then
            Aero.Recent_Cache[ ply:SteamID() ] = {}
        end
        reference = favourite and Aero.Favourites[ ply:SteamID() ] or Aero.Recent_Cache[ ply:SteamID() ]
        if not reference[ origin ] then reference[ origin ] = {} end
        local data = { name = name }
        if ( #reference[ origin ] > 3 ) then table.remove( reference[ origin ], 1 ) end
        table.insert( reference[ origin ], data )
        if not favourite then return end
        Aero.UpdateSettingFile( ply, Aero.Favourites[ ply:SteamID() ] )
    end

    util.AddNetworkString( "Aero.Handle.Request" )
    --> Called when any major component is called. <--
    function Aero.OnItemPressed( size, ply )
        local name = net.ReadString()
        local origin = net.ReadString()
        local favourite = net.ReadBool()
        if not Aero.IsInPool( ply, name, origin, favourite ) then
            Aero.HandleItemPress( ply, name, origin, favourite )
        else
            if favourite then
                if Aero.Favourites[ ply:SteamID() ][ origin ] then
                    for k, v in pairs( Aero.Favourites[ ply:SteamID() ][ origin ] ) do
                        if v.name == name then 
                            table.RemoveByValue( Aero.Favourites[ ply:SteamID() ][ origin ], v )
                            continue
                        end
                    end
                end
            end
        end
    end
    net.Receive( "Aero.Handle.Request", Aero.OnItemPressed )

    --> Stat Printer Scanning Time Stuff <--
    Aero.Active_Printers = 0
    Aero.Active_Bitminers = 0
    util.AddNetworkString( "Aero.Push.Printer.Count" )
    timer.Create( "Aero.Scan.Printers", Aero.Printer_Scan_Time, 0, function()
        if #player.GetAll() < 1 then return end
        local printers = 0
        local bitminers = 0
        for k, v in pairs( ents.GetAll() ) do
            if Aero.Printer_Classes[ v:GetClass() ] then
                printers = printers + 1
            end
            if Aero.Bitminer_Classes[ v:GetClass() ] then
                bitminers = bitminers + 1
            end
        end
        Aero.Active_Printers = printers
        Aero.Active_Bitminers = bitminers
        net.Start( "Aero.Push.Printer.Count" )
            net.WriteInt( Aero.Active_Printers, 9 )
            net.WriteInt( Aero.Active_Bitminers, 9 )
        net.Broadcast()
    end )
