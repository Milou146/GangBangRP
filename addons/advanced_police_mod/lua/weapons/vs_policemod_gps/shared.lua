--SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss & Slawer"
SWEP.Instructions			= "Click : On/Off"

SWEP.ViewModel				= Model( "models/navigation/gps/v_gps.mdl" )
SWEP.WorldModel 			= Model( "models/navigation/gps/w_gps.mdl" )

SWEP.UseHands				= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Advanced Police Mod"
SWEP.PrintName				= "Police GPS"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

local font

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.9)

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	

	timer.Simple( 0.5, function()
		if not IsValid( self ) then return end

		if CLIENT then
			if (self.useNext or 0) > CurTime() then return end
			self.useNext = CurTime() + 0.9
			surface.PlaySound( 'buttons/button9.wav' )
		elseif SERVER then
			self:SetPower( not self:GetPower() )
		end
	end )
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.9)

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	

	timer.Simple( 0.5, function()
		if not IsValid( self ) then return end

		if CLIENT then
			if (self.useNext or 0) > CurTime() then return end
			self.useNext = CurTime() + 0.9
			surface.PlaySound( 'buttons/button9.wav' )
		elseif SERVER then
			self:SetPower( not self:GetPower() )
		end
	end )
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Power" )
	if SERVER then
		self:SetPower( true )
	end
end

function SWEP:Initialize()
	if not KVS then
		if CLIENT then 
			chat.AddText( Color( 255, 0, 0 ), "You need to add KVSLib to your server collection to use this weapon." )
			chat.AddText( Color( 255, 255, 255 ), "Link : https://steamcommunity.com/sharedfiles/filedetails/?id=2031595057" )
		end
		self:Remove()
		return
	end
	self:SetHoldType( "pistol" )
end

function SWEP:OnRemove()
end

function SWEP:Holster()
    return true
end

function SWEP:PostDrawViewModel( eViewModel )
	font = font or KVS.GetFont
	local vPosition = eViewModel:GetPos()
    vPosition = vPosition + eViewModel:GetForward() * 28 + eViewModel:GetRight() * 1.5 + eViewModel:GetUp() * -1.7
    local aAngle = eViewModel:GetAngles()

    aAngle:RotateAroundAxis( aAngle:Up(), 65 )
    aAngle:RotateAroundAxis( aAngle:Right(), -175 )
    aAngle:RotateAroundAxis( aAngle:Forward(), -120 )

	cam.Start3D2D( vPosition, aAngle, 0.01 )
		draw.SimpleText( VS_PoliceMod:L("Tracker"), font( "DS-Digital", 45 ), 195 / 2, 250 / 2 + 10, Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( self:GetPower() and VS_PoliceMod:L("ON") or VS_PoliceMod:L("OFF"), font( "DS-Digital", 55 ), 195 / 2, 250 / 2 + 10, Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	cam.End3D2D()
end