VS_PoliceMod = {}
VS_PoliceMod.Lang = {}

VS_PoliceMod.Colors = {
	[ "blue" ] = Color( 0, 0, 255, 255 )
}

function VS_PoliceMod:LoadLanguage()
	local chosenLang = VS_PoliceMod.Config.Language or "en"

	local dirLang = "vs_policemod/languages/" .. chosenLang .. ".lua"

	if not file.Exists(dirLang, "LUA") then chosenLang = "en" end

	if SERVER then
		AddCSLuaFile(dirLang)
	end
	VS_PoliceMod.Lang = include(dirLang)
end

function VS_PoliceMod:Init()
	local directories = { -- for priority order
		[ 1 ] = 'shared',
		[ 2 ] = 'server',
		[ 3 ] = 'client',
		[ 4 ] = 'app',
	}
	for _, file_name in pairs( file.Find( 'vs_policemod/sh_*.lua', 'LUA' ) ) do

		-- include shared
		include( 'vs_policemod/' .. file_name )
		if SERVER then
			-- AddCSLuaFile shared
			AddCSLuaFile( 'vs_policemod/' .. file_name )
		end
	end
	for _, file_name in pairs( file.Find( 'vs_policemod/cl_*.lua', 'LUA' ) ) do
		if SERVER then	
			-- AddCSLuaFile client
			AddCSLuaFile( 'vs_policemod/' .. file_name )
		elseif CLIENT then
			-- include client
		end
	end
	for _, file_name in pairs( file.Find( 'vs_policemod/sv_*.lua', 'LUA' ) ) do
		if SERVER then	
			-- include server
			include( 'vs_policemod/' .. file_name )
		end
	end

	self:LoadLanguage()

	for _, dir in pairs( directories ) do
		for _, file_name in pairs( file.Find( 'vs_policemod/' .. dir .. '/sh_*.lua', 'LUA' ) ) do

			-- include shared
			include( 'vs_policemod/' .. dir .. '/' .. file_name )
			if SERVER then
				-- AddCSLuaFile shared
				AddCSLuaFile( 'vs_policemod/' .. dir .. '/' .. file_name )
			end
		end
		for _, file_name in pairs( file.Find( 'vs_policemod/' .. dir .. '/cl_*.lua', 'LUA' ) ) do
			if SERVER then	
				-- AddCSLuaFile client
				AddCSLuaFile( 'vs_policemod/' .. dir .. '/' .. file_name )
			elseif CLIENT then
				-- include client
				include( 'vs_policemod/' .. dir .. '/' .. file_name )
			end
		end
		for _, file_name in pairs( file.Find( 'vs_policemod/' .. dir .. '/sv_*.lua', 'LUA' ) ) do
			if SERVER then	
				-- include server
				include( 'vs_policemod/' .. dir .. '/' .. file_name )
			end
		end
	end
end

function VS_PoliceMod:L(sKey)
	return VS_PoliceMod.Lang[sKey] or sKey
end

if KVS then
	VS_PoliceMod:Init()
else
	hook.Add( 'KVS.OnKVSLoaded', 'KVS.OnKVSLoaded.VS_PoliceMod', function( )
		VS_PoliceMod:Init()
	end )

	hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.KVSNeeded", function( pPlayer )
		if filesLoaded then
			hook.Remove( "PlayerInitialSpawn", "PlayerInitialSpawn.KVSNeeded" )
			return
		end

		MsgC( Color( 255, 0, 0 ), "!!! Some scripts of this server need KVSLib to work !!!\n", Color( 255, 255, 255 ), "Add these contents to make sure everything will work well : https://steamcommunity.com/sharedfiles/filedetails/?id=2031595057")
	end )
end
