
timer.Simple(1, function() -- Wait lib load before first launch
	hook.Add("InitPostEntity", "OsGuide_SpawnNPC", OsGuide:InitData() )

	hook.Add("InitPostEntity", "OsGuide_SpawnNPC", OsGuide:SpawnNPC() )
	hook.Add("PostCleanupMap", "OsGuide_SpawnNPC", OsGuide:SpawnNPC() )
end )

hook.Add( "PlayerSay", "OsGuide_Action", function( caller , text )

	if ( string.lower( text ) == OsGuide.spawnCommand && OsGuide.adminGroup[ caller:GetUserGroup() ] ) then
		OsGuide:RegisterNewPos( caller, "random" )
	end

end )

-- Check Version
local greatVersion = 1

http.Fetch( "https://raw.githubusercontent.com/OsmosKesko/nlf_guide/master/version.txt", 
	function( body )
		greatVersion = string.sub( body, 1, 3 ) == OsGuide.Version && 1 or 0
	end,
	function( error )

	end
)

hook.Add( "PlayerInitialSpawn", "OsGuide_OnSpawn", function( user )
	if ( OsGuide.adminGroup[ user:GetUserGroup() ] && greatVersion == 0 ) then
		user:ChatPrint( OsGuide.Lang.nlfbotl81 )
	end
end )