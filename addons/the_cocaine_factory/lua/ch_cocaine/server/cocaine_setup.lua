-- Workshop resource
resource.AddWorkshop( "1734833080" )

-- Net messages
util.AddNetworkString( "COCAINE_DryCocaine" )
util.AddNetworkString( "COCAINE_DryingSwitch" )

util.AddNetworkString( "COCAINE_ExtractorSwitch" )
util.AddNetworkString( "COCAINE_ExtractorGaugeBucketFill" )

util.AddNetworkString( "TCF_CloseSellMenu" )
util.AddNetworkString( "TCF_SellDrugsMenu" )
util.AddNetworkString( "TCF_SellCocaine" )

-- Initialize
local map = string.lower( game.GetMap() )

function TCF.SpawnNPCBuyer()
	timer.Simple( 5, function()
		if not file.IsDir( "craphead_scripts", "DATA" ) then
			file.CreateDir( "craphead_scripts", "DATA" )
		end

		if not file.IsDir( "craphead_scripts/the_cocaine_factory/".. map .."", "DATA" ) then
			file.CreateDir( "craphead_scripts/the_cocaine_factory/".. map .."", "DATA" )
		end
		
		for k, v in pairs( file.Find( "craphead_scripts/the_cocaine_factory/".. map .."/drugs_buyer_location_*.txt", "DATA") ) do
			local PositionFile = file.Read( "craphead_scripts/the_cocaine_factory/".. map .."/".. v, "DATA" )
			local ThePosition = string.Explode( ";", PositionFile )
			local TheVector = Vector( ThePosition[1], ThePosition[2], ThePosition[3] )
			local TheAngle = Angle( tonumber( ThePosition[4] ), ThePosition[5], ThePosition[6] )

			local druggie_npc = ents.Create( "cocaine_drugs_buyer" )
			druggie_npc:SetPos( TheVector )
			druggie_npc:SetAngles( TheAngle )
			druggie_npc:Spawn()
		end
	end )
end
hook.Add( "Initialize", "TCF.SpawnNPCBuyer", TCF.SpawnNPCBuyer )

function TCF.RespawnEntCleanup()
	print( "[THE COCAINE FACTORY] - Map cleaned up. Respawning cocaine buyer npcs" )

	timer.Simple( 1, function()
		TCF.SpawnNPCBuyer()
	end )
end
hook.Add( "PostCleanupMap", "TCF.RespawnEntCleanup", TCF.RespawnEntCleanup )