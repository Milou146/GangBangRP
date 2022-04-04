/*
	OsGuide:InitData
*/
function OsGuide:InitData()

	if ( !file.Exists( "nlf", "DATA" ) ) then
		file.CreateDir( "nlf" )
	end

	if ( !file.Exists( "nlf/givemoneyonetime", "DATA" ) ) then
		file.CreateDir( "nlf/givemoneyonetime" )
	end

	if ( !file.Exists( "nlf/" .. string.lower( game.GetMap() ), "DATA" ) ) then
		file.CreateDir( "nlf/" .. string.lower( game.GetMap() ) )
	end


end

/*
	OsGuide:SpawnNPC
*/
function OsGuide:SpawnNPC()

    for _, v in ipairs( self.Entity ) do v:Remove() end

    local path = "nlf/" .. string.lower( game.GetMap() ) .. "/"

    for _, v in ipairs( file.Find( path .. "*.txt", "DATA" ) ) do
	    local positionSpawn = string.Explode( " ", file.Read( path .. v, "DATA" ) )

	   	local entity = ents.Create("nlf_npc")
	    entity:SetPos( Vector( positionSpawn[1], positionSpawn[2], positionSpawn[3] ) )
	    entity:SetAngles( Angle( positionSpawn[4], positionSpawn[5], positionSpawn[6] ) )
	    entity:Spawn()
    end
end


/*
	OsGuide:GiveMoney :
		target -> Player
		key    -> Integer
*/
function OsGuide:GiveMoney( target, key )
	if ( !IsValid( target ) || !target:IsPlayer() ) then error( "User is not valid" ) return end
	if ( !isnumber( key ) || !self.Action[ key ] ) then error( "Index is not valid" ) return end

    local playerPath = "nlf/givemoneyonetime/" .. target:SteamID64() .. ".txt"
    if ( !file.Exists( playerPath, "DATA" ) ) then	

    	local amount = self.Action[ key ].text
    	amount = tonumber( amount ) && amount or error( "The best help i can give you :\n\t- Look you'r money configuration for action n°" .. key )
		target:addMoney( amount )

		file.Write( playerPath, "SteamID: '" .. target:SteamID() .. "' Amount: '".. amount .."' Name: '".. target:Nick() .. "' Date : '" .. os.date( "%H:%M:%S - %d/%m/%Y" , os.time() ) .. "'" )

		DarkRP.notify( target, 3, 4, string.format( self.Lang.nlfbotl27, amount ) )
	else 
		DarkRP.notify( target, 1, 4, self.Lang.nlfbotl29 )
	end

end 

/*
	OsGuide:DeleteNPC :
		caller -> Player
		target -> String ( name of NPC )
*/
function OsGuide:DeleteNPC( caller, target )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( target == nil || !isstring( target ) ) then error( "Target is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

    local npcPath = "nlf/" .. string.lower( game.GetMap() ) .. "/npc_" .. target .. ".txt"
    if ( file.Exists( npcPath, "DATA") ) then
        file.Delete( npcPath )

		self:SpawnNPC()

        DarkRP.notify(caller, 3, 4, string.format( self.Lang.nlfbotl30, target ) )
    else
        DarkRP.notify(caller, 1, 4, string.format( self.Lang.nlfbotl33, target ) )
    end

end

/*
	OsGuide:DeleteUserData :
		caller -> Player
		target -> String ( SteamID or SteamID64 )

*/
function OsGuide:DeleteUserData( caller, target )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( target == nil || !isstring( target ) ) then error( "Target is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

	local targetID = string.find( target, "STEAM_" ) && util.SteamIDTo64( target ) or target

	local targetPath = "nlf/givemoneyonetime/" .. targetID .. ".txt"
	if file.Exists( targetPath, "DATA" ) then
		file.Delete( targetPath )
		DarkRP.notify( caller, 3, 4, string.format( self.Lang.nlfbotl36, target ) )
	else
		DarkRP.notify( caller, 1, 4, string.format( self.Lang.nlfbotl38, target ) )
	end

end

/*
	OsGuide:DeleteAllNPC :
		caller -> Player

*/
function OsGuide:DeleteAllNPC( caller )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

	local path = "nlf/" .. string.lower( game.GetMap() )
	for _, doc in ipairs( file.Find (path .. "/*.txt", "DATA") ) do
        file.Delete( path .. "/" .. doc )
    end

    for _, entity in ipairs( self.Entity ) do
    	entity:Remove()
    end

end

/*
	OsGuide:DeleteAllUserData :
		caller -> Player

*/
function OsGuide:DeleteAllUserData( caller )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

	local path = "nlf/givemoneyonetime/"
    for _, doc in ipairs( file.Find( path .. "*.txt", "DATA" ) ) do
        file.Delete( path .. doc )
    end

    DarkRP.notify( caller, 3, 4, self.Lang.nlfbotl46 )
end

/*
	 OsGuide:FindOfflineUserData
	 	caller -> Player
		target -> String ( SteamID or SteamID64 )
	
*/
function OsGuide:FindOfflineUserData( caller, target )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( target == nil || !isstring( target ) ) then error( "Target is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

	local targetID = string.find( target, "STEAM_" ) && util.SteamIDTo64( target ) or target

	local path = "nlf/givemoneyonetime/" .. targetID .. ".txt"
	if file.Exists( path, "DATA" ) then

		local Data = string.Explode( " ", file.Read( path, "DATA" ) )
			net.Start( "Guide_Client" )
				net.WriteInt( -6, 4 )
				net.WriteTable( {
					Data[2],
					Data[6],
					Data[4]
					} )
			net.Send( caller )
	else 
		DarkRP.notify( caller, 1, 4, targetID .. OsGuide.Lang.nlfbotl42 )
	end 
end

/*
	 OsGuide:FindALLNPCData : 
	 	caller -> Player

*/
function OsGuide:FindALLNPCData( caller )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

    net.Start( "Guide_Client" )
    	net.WriteInt( -5, 4 )
        net.WriteTable( file.Find( "nlf/" .. string.lower( game.GetMap() ) .. "/*.txt", "DATA" ) )
     net.Send( caller )
end

/*
	 OsGuide:FindUserData :
	 	caller -> Player
	 	target -> String

*/
function OsGuide:FindUserData( caller, target )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( target == nil || !isstring( target ) ) then error( "Target is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end
	
	for _, player in ipairs( player.GetAll() ) do
		target = ( player:Nick():lower() == target:lower() ) && player or target
	end
		
	local targetPath = "nlf/givemoneyonetime/" .. target:SteamID64() .. ".txt"
	if file.Exists( targetPath, "DATA" ) then
	 
		local Data = string.Explode(" ", file.Read( targetPath, "DATA" ) )
		net.Start( "Guide_Client" )
			net.WriteInt( -6, 4 )
			net.WriteTable( {
				Data[2],
				target:Nick(),
				Data[4]
				} )
		net.Send( caller )
	end 

end

/*
	OsGuide:RegisterNewPos :
		caller -> Player
		target -> String

*/
function OsGuide:RegisterNewPos( caller, target )
	if ( !IsValid( caller ) || !caller:IsPlayer() ) then error( "Caller is not valid" ) return end
	if ( target == nil || !isstring( target ) ) then error( "Target is not valid" ) return end
	if ( !self.adminGroup[ caller:GetUserGroup() ] ) then return end

	if ( target == "random" ) then
		target = #self.Entity + 1
	end

	local targetPath = "nlf/" .. string.lower( game.GetMap() ) .. "/npc_" .. target .. ".txt"

    if file.Exists( targetPath, "DATA" ) then
		DarkRP.notify( caller, 1, 4, OsGuide.Lang.nlfbotl1 .. " " .. string.format( OsGuide.Lang.nlfbotl3, target ) )
        return
    end

    local targetVector = string.Explode(" ", tostring( caller:GetEyeTrace().HitPos ) )
    local targetAngles = string.Explode(" ", tostring( caller:GetAngles() + Angle(0, -180, 0) ) )
    file.Write( targetPath, targetVector[1] .. " " .. targetVector[2] .. " " .. targetVector[3] .. " " .. targetAngles[1] .. " " .. targetAngles[2] .. " " .. targetAngles[3], "DATA")
	
	DarkRP.notify( caller, 3, 4, OsGuide.Lang.nlfbotl1 .. " " .. OsGuide.Lang.nlfbotl5 )

	self:SpawnNPC()
end