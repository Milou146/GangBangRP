local CFG = VS_PoliceMod.Config

util.AddNetworkString( "PoliceMod.Dispatch" )

VS_PoliceMod.DispatchGroups = VS_PoliceMod.DispatchGroups or {}

hook.Add( "VS_PoliceMod.NewCop", "VS_PoliceMod.NewCop.Dispatch", function( pPlayer )
	-- Use normal net as we send players
	net.Start( "PoliceMod.Dispatch" )
		net.WriteTable( VS_PoliceMod.DispatchGroups or {} )
	net.Send( pPlayer )
end )

VS_PoliceMod:NetReceive( "ChangeDispatch", function( pSender, tData )
	if not tData or not tData[1] then return end

	if not pSender:PM_IsChief() then
		VS_PoliceMod:Notify( pCop, VS_PoliceMod:L("NotAllowed") )
		return
	end

	local pPlayer = Player( tData[1] )

	if not IsValid( pPlayer ) then return end

	local newDispatchGroup = tData[2]
	local oldDispatchGroup = tData[3]

	if not newDispatchGroup or not CFG.DispatchGroupsNames[ newDispatchGroup ] then
		-- set as not dispatched
		if oldDispatchGroup and CFG.DispatchGroupsNames[ oldDispatchGroup ] then
			VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] or {}
			VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players or {}
			VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players[ pPlayer ] = nil
			if table.Count( VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players ) <= 0 then
				VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = nil
			end
		end
		pPlayer.Dispatch = nil
	elseif not oldDispatchGroup or not CFG.DispatchGroupsNames[ oldDispatchGroup ] then
		-- set in a team from not dispatched
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ] = VS_PoliceMod.DispatchGroups[ newDispatchGroup ] or {}
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players or {}
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players[ pPlayer ] = true
		pPlayer.Dispatch = newDispatchGroup
	else
		-- set in a team from another
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ] = VS_PoliceMod.DispatchGroups[ newDispatchGroup ] or {}
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players or {}
		VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] or {}
		VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players or {}
		VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players[ pPlayer ] = nil
		if table.Count( VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players ) <= 0 then
			VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = nil
		end
		VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players[ pPlayer ] = true
		pPlayer.Dispatch = newDispatchGroup
	end

	local tCops = {}
	for pCop, bBool in pairs( VS_PoliceMod:GetCops() or {} ) do
		table.insert( tCops, pCop )
	end

	VS_PoliceMod:NetStart( "ChangeDispatchClient", tData, tCops )
end )

VS_PoliceMod:NetReceive( "FireCop", function( pSender, tData )
	if not tData or not tData[ 1 ] then return end

	local pCop = Player( tData[ 1 ] )
	if not IsValid( pCop ) then return end

	if not pSender:PM_IsChief() then
		VS_PoliceMod:Notify( pSender, VS_PoliceMod:L("NotAllowed") )
		return
	end

	if pCop == pSender then return end
	if not pSender:PM_IsPolice() or not pCop:PM_IsPolice() then return end

	pCop:changeTeam( GAMEMODE.DefaultTeam, true, true )
	pCop:teamBan( pCop:Team(), CFG.TimeBanAfterFire )
	VS_PoliceMod:Notify( pCop, VS_PoliceMod:L("FiredFromPolice"):format( pSender:Name() ) )
	VS_PoliceMod:Notify( pSender, VS_PoliceMod:L("YouFired"):format( pCop:Name() ) )
end )
