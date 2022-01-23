    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    if not Aero.Modules[ "Rewards" ] then return end

    --> Tasks that users can complete in the F4 Menu. <--
    Aero.Tasks_List = {
        [ "Change RP Name" ] = {
            reward = Aero.Task_Payouts[ "Name Change" ],
            hook = "onPlayerChangedName",
            callback = function( ply )
                Aero.SetTaskComplete( ply, "Change RP Name" )
            end,
        },
        [ "Drop some money" ] = {
            reward = Aero.Task_Payouts[ "Drop Money" ],
            hook = "playerDroppedMoney",
            callback = function( ply )
                Aero.SetTaskComplete( ply, "Drop some money" )
            end,
        },
        [ "Become the Mayor" ] = {
            reward = Aero.Task_Payouts[ "Mayor" ],
            hook = "OnPlayerChangedTeam",
            callback = function( ply, before, after )
                if after == TEAM_MAYOR or after == TEAM_PRESIDENT then
                    Aero.SetTaskComplete( ply, "Become the Mayor" )
                end
            end,
        },
        [ "Buy a door" ] = {
            reward = Aero.Task_Payouts[ "Buy Door" ],
            hook = "playerBoughtDoor",
            callback = function( ply )
                Aero.SetTaskComplete( ply, "Buy a door" )
            end,
        },
        [ "Become a Gun Dealer" ] = {
            reward = Aero.Task_Payouts[ "Gun Dealer" ],
            hook = "OnPlayerChangedTeam",
            callback = function( ply, before, after )
                if Aero.Gun_Dealers[ team.GetName( after ) ] then
                    Aero.SetTaskComplete( ply, "Become a Gun Dealer" )
                end
            end,
        },
        [ "Wanted by the Police" ] = {
            reward = Aero.Task_Payouts[ "Wanted" ],
            hook = "playerWanted",
            callback = function( criminal )
                Aero.SetTaskComplete( criminal, "Wanted by the Police" )
            end,
        },
        [ "Play for 24 hours" ] = {
            reward = Aero.Task_Payouts[ "24 Hours" ],
            hook = "Aero.Week.Complete",
            callback = function( ply )
                Aero.SetTaskComplete( ply, "Play for 24 hours" )
            end,
        },
        [ "Start a Lottery" ] = {
            reward = Aero.Task_Payouts[ "Lottery Started" ],
            hook = "lotteryStarted",
            callback = function( ply )
                Aero.SetTaskComplete( ply, "Start a Lottery" )
            end,
        },
        [ "Type Hello in chat" ] = {
            reward = Aero.Task_Payouts[ "First Words" ],
            hook = "PlayerSay",
            callback = function( ply, txt )
                if string.gsub( string.lower( txt ), 1, 5 ) == "hello" then
                    Aero.SetTaskComplete( ply, "Type Hello in chat" )
                end
            end,
        }
    }

    --> Generates the default task structure for a player <--
    function Aero.RegisterBaseTasks( ply )
        if not Aero.Tasks[ ply:SteamID() ] then Aero.Tasks[ ply:SteamID() ] = {} end
        for k, v in pairs( Aero.Tasks_List ) do
            if not Aero.Tasks[ ply:SteamID() ][ k ] then
                Aero.Tasks[ ply:SteamID() ][ k ] = { 
                    name = k,
                    reward = v.reward,
                    completed = false
                }
            end
        end
    end
    hook.Add( "PlayerInitialSpawn", "Aero.RegisterTasks", Aero.RegisterBaseTasks )

    --> Marks a specific task as completed. <--
    function Aero.SetTaskComplete( ply, name )
        if not Aero.Tasks[ ply:SteamID() ][ name ] then
            return
        end
        if Aero.Tasks[ ply:SteamID() ][ name ].completed then
            return
        end
        local task = Aero.Tasks[ ply:SteamID() ][ name ]
        task.completed = true
        Aero.SendMessage( ply, "Congratulations, you have just completed the Task: " .. name .. ". Your reward of $" .. string.Comma( task.reward ) .. " has been added to your wallet!" )
        Aero.UpdateRewardFile( ply )
        ply:addMoney( task.reward )
    end

    --> Deploys all hooks and functions relative to their task <--
    function Aero.RegisterTasks()
        for k, v in pairs( Aero.Tasks_List ) do
            if v.disabled then continue end
            hook.Add( v.hook, "Aero.Task." .. v.hook, v.callback )
        end
    end
    hook.Add( "Initialize", "Aero.InitTasks", Aero.RegisterTasks )


    --[[
        Start of Hourly/Weekly progress logic.
    --]]

    util.AddNetworkString( "Aero.Process.Claim" )
    --> Called when someone tries to calim a reward from the F4 menu <--
    function Aero.VerifyClaim( size, ply )
        local type = net.ReadString()
        local task = Aero.PullTimerData( ply, type )
        if not task then return end
        task = task[ type ]
        
        local time_check = task.session_start - math.abs( task.start_time - os.time() )

        if time_check > 1 then
            return
        end

        task.can_claim = false
        task.start_time = os.time()
        task.times_claimed = task.times_claimed + 1

        task.time_left = task.length
        task.session_start = task.time_left

        timer.Destroy( "Aero.Rewards." .. type .. ply:SteamID() )
        Aero.StartTimers( ply )
        if type == "Weekly-Shipment" then
            local pool = Aero.GetShipments()
            local choice = pool[ math.random( 1, #pool ) ]
            if not choice then
                Aero.SendMessage( ply, "There is an error with this Shipment. Please inform the server owner." )
                return
            end
            Aero.CreateShipment( ply, choice.key, choice )
            Aero.SendMessage( ply, "You have claimed your Shipment reward. [" .. choice.v.amount .. " x " .. choice.v.name .. "]." ) 
            hook.Call( "Aero.Week.Complete", nil, ply )
        else
            if type == "Weekly" then
                hook.Call( "Aero.Week.Complete", nil, ply )
            end
            ply:addMoney( task.reward )       
            Aero.SendMessage( ply, "You have claimed your reward. $" .. string.Comma( task.reward ) .. " has been added to your wallet." ) 
        end
    end
    net.Receive( "Aero.Process.Claim", Aero.VerifyClaim )

    --> Pulls all reward data releavent to a user <--
    function Aero.PullTimerData( ply, type )
        if not Aero.Rewards[ ply:SteamID() ] then return end
        local data = {}
        for k, v in pairs( Aero.Rewards[ ply:SteamID() ] ) do
            if type and k == type then
                data[ k ] = v
                continue
            end
            data[ k ] = v
        end
        return data
    end

    --> Calls all timers to be checked and executed <--
    function Aero.StartTimers( ply )
        local timers = Aero.PullTimerData( ply )
        for k, v in pairs( timers or {} ) do
            if k == "Tasks" then continue end
            local id = "Aero.Rewards." .. k .. ply:SteamID()
            if timer.Exists( id ) then continue end
            if v.time_left < 1 then continue end
            timer.Create( id, v.length, 1, function()
                if IsValid( ply ) then
                    Aero.SendMessage( ply, "You can now claim the " .. k .. " reward from the F4 menu!" )
                    v.can_claim = true
                end
            end )
        end
    end


    function Aero.GetTimeLeft( ply, type )
        local timer = Aero.PullTimerData( ply, type )
        if not timer then return end
        local time = table.Copy( timer[ type ] )
        return time.time_left
    end

    --> Destroys all active timers. <--
    function Aero.DestroyTimers( ply )
        local timers = Aero.PullTimerData( ply )
        for k, v in pairs( timers or {} ) do
            if k == "Tasks" then continue end
            local id = "Aero.Rewards." .. k .. ply:SteamID()
            if timer.Exists( id ) then
                timer.Destroy( id )
            end
            local time = v.session_start - math.abs( v.start_time - os.time() )
            v.time_left = time < 0 and 0 or time
        end
        Aero.UpdateRewardFile( ply )
    end
    hook.Add( "PlayerDisconnected", "Aero.DestroyRewardTimers", Aero.DestroyTimers )