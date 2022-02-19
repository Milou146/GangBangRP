local function TCF_RemoveAllEntities( ply, before, after )
	if TCF.Config.RemoveEntsOnTeamChange then
		if not table.HasValue( TCF.Config.CriminalTeams, team.GetName( after ) ) then
			 for k, v in ipairs( ents.GetAll() ) do
				if TCF.Config.CocaineEntityList[ v:GetClass() ] then
					local box_owner = ( IsValid( v:CPPIGetOwner() ) and v:CPPIGetOwner() ) or v.ItemStoreOwner
					
					if box_owner == ply then
						v:Remove()
					end
				end
			 end
		end
	end
end
hook.Add( "OnPlayerChangedTeam", "TCF_RemoveAllEntities", TCF_RemoveAllEntities )

local function TCF_RemoveAllEntitiesDC( ply )
	if TCF.Config.RemoveEntsOnDC then
		for k, v in ipairs( ents.GetAll() ) do
			if TCF.Config.CocaineEntityList[ v:GetClass() ] then
				local box_owner = ( IsValid( v:CPPIGetOwner() ) and v:CPPIGetOwner() ) or v.ItemStoreOwner
				
				if box_owner == ply then
					v:Remove()
				end
			end
		 end
	end
end
hook.Add( "PlayerDisconnected", "TCF_RemoveAllEntitiesDC", TCF_RemoveAllEntitiesDC )