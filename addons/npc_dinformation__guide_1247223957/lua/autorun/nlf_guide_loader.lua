OsGuide = OsGuide or { 
						Action = {},
						popUp = {},
						Lang = {},
						Entity = {},
						Path = "npc_core",
						Version = "3.0"
					}

-- REGISTER ACTION
local whitelistAction = {
	["text"] = true,
	["webURL"] = true,
	["ingameURL"] = true,
	["giveMoneyOneTime"] = true,
	["playSoundFile"] = true,
	["leave"] = true
}
function OsGuide.RegisterNewAction( content )
	if ( !istable( content ) ) then error( "structure arguments is not valid" ) return end
	if ( !isstring( content.name ) || !isstring( content.action ) || !isstring( content.text ) ) then error( "Name, Action or Text is not valid" ) return end
	if ( !whitelistAction[ content.action ] ) then error( "'" .. content.action .. "' is not valid action" ) return end

	table.insert(OsGuide.Action, content)
end

-- LOADER MODULES
local function includeFile( file, module )
	if ( file == nil || !isstring( file ) ) then return end
	if ( module == nil || !isstring( module ) ) then 
			module = "" 
	else
		module = module .. "/"
	end
		
	print(module .. file)

	local ext = string.sub( file, 1, 3)

	if ( ext == "cl_" || ext == "sh_" ) then
		if SERVER then
			AddCSLuaFile( module .. file )
		else
			include( module .. file )
		end
	end

	if ( ext == "sv_" || ext == "sh_" ) then 
		if SERVER then
			include( module .. file )
		end
	end

end

local function RunModule( module )
	local files, children = file.Find( module .. "/*", "LUA" )

	for _, file in ipairs( files ) do
		includeFile( file, module )
	end

	if ( children ) then
		for _, child in ipairs( children ) do
			RunModule( module .. "/" .. child )
		end
	end
end

local _, modules = file.Find( OsGuide.Path .. "/*", "LUA" )

includeFile( "sh_config.lua", OsGuide.Path  )
includeFile( "sh_" .. OsGuide.languageUse .. ".lua", OsGuide.Path .. "/language" )

for _, module in ipairs( modules ) do
	if ( module != "language" ) then
		RunModule( OsGuide.Path .. "/" .. module )
	end
end