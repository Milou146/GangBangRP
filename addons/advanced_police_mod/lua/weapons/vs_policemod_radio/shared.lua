--SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss & Slawer"
SWEP.Instructions			= "Left Click : Next Channel\nRight Click : On/Off"

SWEP.ViewModel				= Model( "models/slawer/radio/v_radio.mdl" )
SWEP.WorldModel 			= Model( "models/slawer/radio/w_radio.mdl" )

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
SWEP.PrintName				= "Police Radio"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

local font
local CFG = VS_PoliceMod.Config

hook.Add( "PlayerCanHearPlayersVoice", "PlayerCanHearPlayersVoice.VS_PoliceMod.Radio", function( pListener, pTalker )
	if not IsValid( pListener ) or not IsValid( pTalker ) then return end
	
	if pListener == pTalker then return end

    if not pTalker.PM_IsPolice or not pTalker:PM_IsPolice() then return end

    if pTalker:InVehicle() then
    	if not IsValid( pTalker:GetWeapon( "vs_policemod_radio" ) )
	   		or not pTalker:GetWeapon( "vs_policemod_radio" ):GetPower() then return end

    else 
	    if not IsValid( pTalker:GetActiveWeapon() )
	    	or pTalker:GetActiveWeapon():GetClass() ~= "vs_policemod_radio" or not pTalker:GetActiveWeapon():GetPower() then return end
	end

	if not pListener:PM_IsPolice() or not IsValid( pListener:GetWeapon( "vs_policemod_radio" ) )
   		or not pListener:GetWeapon( "vs_policemod_radio" ):GetPower()
   		or not pListener:GetWeapon( "vs_policemod_radio" ).GetFrequence or not isfunction( pListener:GetWeapon( "vs_policemod_radio" ).GetFrequence )
   		or not pTalker:GetActiveWeapon().GetFrequence  or not isfunction( pTalker:GetActiveWeapon().GetFrequence )
   		or pListener:GetWeapon( "vs_policemod_radio" ):GetFrequence() ~= pTalker:GetActiveWeapon():GetFrequence() then return end

    return true
end)

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if not self:GetPower() then return end
	self:SetNextPrimaryFire(CurTime() + 0.7)

	if not self.DispatchGroups then return end
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	if CLIENT then
		if (self.primaryNext or 0) > CurTime() then return end
		self.primaryNext = CurTime() + 0.7

		timer.Simple( 0.5, function()
			if not IsValid( self ) then return end

			surface.PlaySound( 'buttons/button15.wav' )
		end)
	elseif SERVER then
		timer.Simple( 0.5, function()
			if not IsValid( self ) then return end

			if self:GetFrequence() + 1 > #self.DispatchGroups then
				self:SetFrequence( 1 )
				return
			end

			self:SetFrequence( self:GetFrequence() + 1 )
		end )
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.7)

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	

	if CLIENT then
		if (self.secondaryNext or 0) > CurTime() then return end
		self.secondaryNext = CurTime() + 0.7
		timer.Simple( 0.5, function()
			if not IsValid( self ) then return end
			surface.PlaySound( 'buttons/button9.wav' )
		end )
	elseif SERVER then
		timer.Simple( 0.5, function()
			if not IsValid( self ) then return end
			self:SetPower( not self:GetPower() )
		end )
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Frequence" )
	self:NetworkVar( "Bool", 0, "Power" )
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
	self.DispatchGroups = { VS_PoliceMod:L("General") }
	for sGroupName, bBool in pairs( CFG.DispatchGroupsNames ) do
		if not bBool then continue end
		table.insert( self.DispatchGroups, sGroupName )
	end

	if SERVER then
		self:SetPower( true )
		self:SetFrequence( 1 )
	end
end

function SWEP:OnRemove()
end

function SWEP:Holster()
    return true
end

function SWEP:PostDrawViewModel( eViewModel )
	font = font or KVS.GetFont
	local vPosition = eViewModel:GetPos()
    vPosition = vPosition + eViewModel:GetForward() * 22.29 + eViewModel:GetRight() * 3.1 + eViewModel:GetUp() *0.2
    local aAngle = eViewModel:GetAngles()

    aAngle:RotateAroundAxis( aAngle:Up(), 50 )
    aAngle:RotateAroundAxis( aAngle:Right(), -183 )
    aAngle:RotateAroundAxis( aAngle:Forward(), -100 )

	cam.Start3D2D( vPosition, aAngle, 0.01 )
		draw.SimpleText( self:GetPower() and (self.DispatchGroups[ self:GetFrequence() ] or VS_PoliceMod:L("NoFrequence") ) or VS_PoliceMod:L("OFF"), font( "DS-Digital", 45 ), 90, 30, Color( 0, 0, 0, 200 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end