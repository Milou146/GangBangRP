-- INITIALIZE SCRIPT
if SERVER then
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "ch_cocaine/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cocaine/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/server/*.lua", "LUA" ) ) do
		include( "ch_cocaine/server/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cocaine/client/" .. v )
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "ch_cocaine/shared/" .. v )
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/client/*.lua", "LUA" ) ) do
		include( "ch_cocaine/client/" .. v )
	end
end