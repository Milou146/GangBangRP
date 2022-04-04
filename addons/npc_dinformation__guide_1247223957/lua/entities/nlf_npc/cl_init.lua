include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:DrawTranslucent()
	self:Draw()
end

local iconInfo = Material( OsGuide.iconInfo )
function ENT:Draw()
	self:DrawModel()

	local LPlayer = LocalPlayer()
	local CTime = CurTime()
	local Pos = self:LocalToWorld( self:OBBCenter() ) + Vector( 0, 0, 50 )
	local Ang = Angle( 0, LPlayer:EyeAngles().y - 90, 90 )
	local clr = HSVToColor( ( (CTime * 10 ) % 360 ), 0.5, 0.5 )
	
	if ( self:GetPos():Distance( LPlayer:GetPos() ) > 1500 ) then return end

	cam.Start3D2D(Pos + Vector( 0, 0, math.sin( CTime ) * 2 ), Ang, 0.2)
		draw.SimpleTextOutlined( OsGuide.title, "guide_C_50", 0, -20, OsGuide.titleColor, TEXT_ALIGN_CENTER, 0, 1.5, Color(0, 0, 0, 255) )
		draw.SimpleTextOutlined( OsGuide.desc, "guide_R_50", 0, 25, Color(clr.r, clr.g, clr.b, 220), TEXT_ALIGN_CENTER, 0, 1, Color(0, 0, 0, 255) )
		
		surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial( iconInfo )
		surface.DrawTexturedRect(-18, -20, 32, 32)
	cam.End3D2D()
end
