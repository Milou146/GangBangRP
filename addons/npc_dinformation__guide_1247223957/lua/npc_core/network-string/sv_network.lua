util.AddNetworkString( "Guide_Client" )
util.AddNetworkString( "Guide_Server" )

net.Receive( "Guide_Server", function( len , caller )
	local action = net.ReadInt( 4 )

	/*
		switch( action )
		 -8 -> Give money one time
		 -7 -> Delete one NPC
		 -6 -> Delete one user data
		 -5 -> Delete all NPC
		 -4 -> Delete all user data
		 -3 -> Remove all data ( NPC, User )
		 -2 -> Find offline user data
		 -1 -> Find ALL NPC data
		  0 -> Find online user data
		  1 -> Register new NPC Pos
		  2 : ~
		  3 : ~
		  4 : ~
		  5 : ~
		  6 : ~
		  7 : ~
	*/

	if ( action == -8 ) then
		OsGuide:GiveMoney( caller, net.ReadUInt( 16 ) )
	elseif ( action == -7 ) then
		OsGuide:DeleteNPC( caller, net.ReadString() )
	elseif ( action == -6 ) then
		OsGuide:DeleteUserData( caller, net.ReadString() )
	elseif ( action == -5 ) then
		OsGuide:DeleteAllNPC( caller )
	elseif ( action == -4 ) then
		OsGuide:DeleteAllUserData( caller )
	elseif ( action == -3 ) then
		OsGuide:DeleteAllNPC( caller )
		OsGuide:DeleteAllUserData( caller )
	elseif ( action == -2 ) then
		OsGuide:FindOfflineUserData( caller, net.ReadString() )
	elseif ( action == -1 ) then
		OsGuide:FindALLNPCData( caller )
	elseif ( action == 0 ) then
		OsGuide:FindUserData( caller, net.ReadString() )
	elseif ( action == 1 ) then
		OsGuide:RegisterNewPos( caller, net.ReadString() )
	end

end )