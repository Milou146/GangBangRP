KVS:RegisterFontAlias( "FAS", "Font Awesome 5 Free Solid" )
KVS:RegisterFontAlias( "R", "Rajdhani" )
KVS:RegisterFontAlias( "Radjhani", "Rajdhani" ) -- trying to avoid a few issues
KVS:RegisterFontAlias( "Radjhani Bold", "Radjhani Bold" ) -- trying to avoid a few issues

list.Set( "DesktopWindows", "VS_PoliceModCallForHelp", {
	title = VS_PoliceMod:L("CallPolice"),
	icon = "materials/police_mod/alarm.png",
	init = function( icon, window )
		VS_PoliceMod:DisplayHelpCallMenu()
	end
} )