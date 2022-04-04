net.Receive( "Guide_Client", function( len , ply )
	local action = net.ReadInt( 4 )

	/*
		switch( action )
		 -8 -> Open NPC Derma
		 -7 -> Open ADMIN Derma
		 -6 -> Update Derma Show Data user
		 -5 -> Show ALL NPC data
		 -4 : ~
		 -3 : ~
		 -2 : ~
		 -1 : ~
		  0 : ~
		  1 : ~
		  2 : ~
		  3 : ~
		  4 : ~
		  5 : ~
		  6 : ~
		  7 : ~
	*/

	if ( action == -8 ) then
		OsGuide:OpenDerma()
	elseif ( action == -7 ) then 
		OsGuide:OpenAdminDerma()
	elseif ( action == -6 ) then
		OsGuide:ShowData( net.ReadTable() )
	elseif ( action == -5 ) then
		OsGuide:ShowDataNPC( net.ReadTable() )
	end

end )