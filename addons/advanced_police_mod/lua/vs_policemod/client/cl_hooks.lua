local CFG = VS_PoliceMod.Config
local font = KVS.GetFont

hook.Add( "OnPlayerChat", "VS_PoliceMod.Help:OnPlayerChat", function(p, sText) 
    if p ~= LocalPlayer() then return end

	if sText == VS_PoliceMod.Config.CallPoliceCommand then
        VS_PoliceMod:DisplayHelpCallMenu()
		return true
	end
end )

local colors = {
	Color( 40, 40, 40, 255 ),
	Color( 0, 0, 0, 0 ),
	Color( 150, 150, 150 ),
	Color( 200, 200, 200 )
}
hook.Add( "HUDPaint", "HUDPaint.VS_PoliceMod.OpenTabletVehicle", function()
	local posx, posy = ScrW() / 2 - 110, ScrH() - 45
	if LocalPlayer():InVehicle() and LocalPlayer():PM_IsPolice() and LocalPlayer():HasWeapon( "vs_policemod_tablet" ) then
		KVS:DrawLinearGradient( posx, posy, 220, 45, colors[2], colors[1], true )
		draw.RoundedBox( 3, posx + 10 + 12, posy + 10, 24, 24, colors[3] )
		draw.RoundedBox( 1, posx + 13 + 12, posy + 13, 18, 18, colors[4] )
		draw.SimpleText( string.upper( input.GetKeyName( CFG.KeyVehicle ) ), font( "Rajdhani Bold", 25 ), posx + 10 + 24, posy + 10 + 25 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( VS_PoliceMod:L("OpenTabletVehicle"), font( "Rajdhani", 25 ), posx + 110 + 12, posy + 22.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local posx, posy = ScrW() - 300, ScrH() * 0.3
	if LocalPlayer():InVehicle() and LocalPlayer():PM_IsPolice() and IsValid( LocalPlayer():GetWeapon( "vs_policemod_radio" ) ) then
		local radio = LocalPlayer():GetWeapon( "vs_policemod_radio" )
		KVS:DrawLinearGradient( posx, posy, 300, 45, colors[2], colors[1], false )
		draw.RoundedBox( 3, posx - 24 - 10 + 300, posy + 10, 24, 24, colors[3] )
		draw.RoundedBox( 1, posx - 24 - 7 + 300, posy + 13, 18, 18, colors[4] )
		draw.SimpleText( string.upper( input.GetKeyName( CFG.KeyRadioVehicle ) ), font( "Rajdhani Bold", 25 ), posx + 300 - 10 - 25 / 2, posy + 10 + 25 / 2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( string.format( VS_PoliceMod:L("Radio") .." : %s", LocalPlayer():GetWeapon( "vs_policemod_radio" ):GetPower() and VS_PoliceMod:L("ON") .. string.format( " (%s)", radio.DispatchGroups[ radio:GetFrequence() ] ) or VS_PoliceMod:L("OFF") ), font( "Rajdhani", 25 ), posx - 40 + 300, posy + 25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
end )