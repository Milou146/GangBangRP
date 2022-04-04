hook.Add( "OnPlayerChat", "OsGuide_Command", function( caller, text )
	local LPlayer = LocalPlayer()

	if ( caller != LPlayer ) then return end

	if ( string.lower( text ) == OsGuide.adminDerma && OsGuide.adminGroup[ LPlayer:GetUserGroup() ] ) then
		OsGuide:OpenAdminDerma()
		return false
	end

end )