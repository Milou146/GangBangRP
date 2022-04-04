local CFG = VS_PoliceMod.Config

VS_PoliceMod.CopsPlayers = VS_PoliceMod.CopsPlayers or {}

hook.Add("OnPlayerChangedTeam", "OnPlayerChangedTeam.VS_PoliceMod", function( pPlayer, iOldTeam, iNewTeam )
	local oldTeamCP = iOldTeam and ( ( GAMEMODE.CivilProtection and GAMEMODE.CivilProtection[ iOldTeam ] ) or ( CFG.PoliceJobs[ team.GetName( iOldTeam ) ] ) )
	local newTeamCP = iNewTeam and ( ( GAMEMODE.CivilProtection and GAMEMODE.CivilProtection[ iNewTeam ] ) or ( CFG.PoliceJobs[ team.GetName( iNewTeam ) ] ) )

	if oldTeamCP and not newTeamCP then
		-- leave police
		VS_PoliceMod.CopsPlayers[ pPlayer ] = nil
	elseif not oldTeamCP and newTeamCP then
		-- join police
		VS_PoliceMod.CopsPlayers[ pPlayer ] = true
		hook.Run( "VS_PoliceMod.NewCop", pPlayer )
		VS_PoliceMod:NetStart("OnMissionsSync", VS_PoliceMod.CurrentPoliceCalls, pPlayer)
	end
end )

hook.Add( "PlayerDisconnected", "PlayerDisconnected.VS_PoliceMod", function( pPlayer )

	if pPlayer:PM_IsPolice() then
		-- leave police
		VS_PoliceMod.CopsPlayers[ pPlayer ] = nil
	end

	if VS_PoliceMod.CurrentPoliceCalls[pPlayer:UserID()] then
		VS_PoliceMod:EndMission(pPlayer)
	end
end )

hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.VS_PoliceMod", function( pPlayer )
	timer.Simple( 0, function()
		if pPlayer:PM_IsPolice() then
			-- join police
			VS_PoliceMod.CopsPlayers[ pPlayer ] = true
			hook.Run( "VS_PoliceMod.NewCop", pPlayer )
			VS_PoliceMod:NetStart("OnMissionsSync", VS_PoliceMod.CurrentPoliceCalls, pPlayer)
		end
	end )
end )

hook.Add( "PlayerButtonDown", "PlayerButtonDown.VS_PoliceMod", function( pPlayer, button )
	if button == CFG.KeyRadioVehicle and pPlayer:Alive() and pPlayer:InVehicle() and pPlayer:PM_IsPolice() and IsValid( pPlayer:GetWeapon( "vs_policemod_radio" ) ) then
		pPlayer:GetWeapon( "vs_policemod_radio" ):SetPower( not pPlayer:GetWeapon( "vs_policemod_radio" ):GetPower() )
	end
	if button == CFG.KeyVehicle and pPlayer:Alive() and pPlayer:InVehicle() and pPlayer:PM_IsPolice() and pPlayer:HasWeapon( "vs_policemod_tablet" ) then
		VS_PoliceMod:NetStart("OpenVehicleTablet", nil, pPlayer)
	end
end )

hook.Add("canDropWeapon", "VS_PoliceMod:canDropWeapon", function(p, w)
	if not IsValid( w ) then return end
	if w:GetClass() == "vs_policemod_tablet" then return false end
end)
