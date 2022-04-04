hook.Add( "playerWarranted", "playerWarranted.CitizenManagement", function( pCriminal, pActor, sReason )
	pCriminal:setDarkRPVar( "warrant", true )
	pCriminal:setDarkRPVar( "warrantReason", sReason )
end )

hook.Add( "playerUnWarranted", "playerUnWarranted.CitizenManagement", function( pCriminal, pActor, sReason )
	pCriminal:setDarkRPVar( "warrant", false )
end )
