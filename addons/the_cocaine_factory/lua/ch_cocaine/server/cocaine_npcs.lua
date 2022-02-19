local map = string.lower( game.GetMap() )

local function TCF_SetPosNPCBuyer( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint("Please choose a UNIQUE name for the druggie NPC! For example type 'cocainebuyer_setpos gasstation'") 
			return
		end
		
		if file.Exists( "craphead_scripts/the_cocaine_factory/".. map .."/drugs_buyer_location_".. FileName ..".txt", "DATA" ) then 
			ply:ChatPrint("This file name is already in use. Please choose another name for this druggie NPC.")
			return
		end
		
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/the_cocaine_factory/".. map .."/drugs_buyer_location_".. FileName ..".txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint( "Successfully setup a new spawn point for a cocaine buyer NPC!" )
		ply:ChatPrint( "All NPC's will respawn in 5 seconds. Please move out of the way." )
		
		for k, npc in ipairs( ents.FindByClass( "cocaine_drugs_buyer" ) ) do
			if IsValid( npc ) then
				npc:Remove()
			end
		end
		
		TCF.SpawnNPCBuyer()
	else
		ply:ChatPrint( "Only administrators can perform this action" )
	end
end
concommand.Add( "cocainebuyer_setpos", TCF_SetPosNPCBuyer )

local function TCF_RemoveNPCBuyerPos( ply, cmd, args )
	if ply:IsAdmin() then
		local FileName = args[1]
		
		if not FileName then
			ply:ChatPrint( "Please enter a filename!" ) 
			return
		end
		
		if file.Exists( "craphead_scripts/the_cocaine_factory/".. map .."/drugs_buyer_location_".. FileName ..".txt", "DATA" ) then
			file.Delete( "craphead_scripts/the_cocaine_factory/".. map .."/drugs_buyer_location_".. FileName ..".txt" )
			ply:ChatPrint( "The selected NPC has been removed!" )
		else
			ply:ChatPrint( "The selected NPC does not exist!" )
		end
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add( "cocainebuyer_removepos", TCF_RemoveNPCBuyerPos )