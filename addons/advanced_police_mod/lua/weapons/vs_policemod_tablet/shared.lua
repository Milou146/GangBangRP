SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss & Slawer"
SWEP.Instructions			= "Click to use"

SWEP.ViewModel				= Model( "models/stim/venatuss/car_dealer/tablet/c_tablet.mdl" )
SWEP.WorldModel 			= Model( "models/stim/venatuss/car_dealer/tablet/w_tablet.mdl" )

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
SWEP.PrintName				= "Police Tablet"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

if SERVER then

	util.AddNetworkString( "Unfocus.PoliceMod.Tablet" )

	net.Receive( "Unfocus.PoliceMod.Tablet", function( len, ply ) 
		if IsValid( ply:GetActiveWeapon() ) and ply:GetActiveWeapon():GetClass() == "vs_policemod_tablet" then
			ply:GetActiveWeapon():Unfocus()
		end
	end )

end

function SWEP:Unfocus()
	if CLIENT then 
		LocalPlayer():UnLock()
		net.Start( "Unfocus.PoliceMod.Tablet" )
		net.SendToServer()
	end
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self:SetHoldType( "slam" )
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if self.NextFire and self.NextFire > CurTime() then return end

	self.NextFire = CurTime() + self.Primary.Delay

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	
	self:SetHoldType( "pistol" )

	if CLIENT then
		LocalPlayer():Lock()

		timer.Simple( 1.2, function()
			if not IsValid( LocalPlayer():GetActiveWeapon() ) or LocalPlayer():GetActiveWeapon():GetClass() ~= "vs_policemod_tablet" then return end

			local eTablet = LocalPlayer():GetViewModel()

			if not IsValid( eTablet ) then return end

			local attachmentTop, attachmentBottom = eTablet:LookupAttachment( "topleft" ), eTablet:LookupAttachment( "bottomright" )
			local topLeft, bottomRight = eTablet:GetAttachment( attachmentTop ), eTablet:GetAttachment( attachmentBottom )

			local topleft, bottomright
			
			if topLeft and istable( topLeft ) and not table.IsEmpty( topLeft ) and bottomRight and istable( bottomRight ) and not table.IsEmpty( bottomRight ) then
				topleft, bottomright = topLeft.Pos:ToScreen(), bottomRight.Pos:ToScreen()	
			end

			VS_PoliceMod:OpenTablet( LocalPlayer():GetActiveWeapon(), topleft, bottomright )
		end )
	end
end

function SWEP:SetupDataTables()
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
	self:SetHoldType( "slam" )
end

function SWEP:OnRemove()
	if CLIENT then
		if LocalPlayer().UnLock then
			LocalPlayer():UnLock()
		end
	end
end

function SWEP:Holster()
	if CLIENT then
		if LocalPlayer().UnLock then
			LocalPlayer():UnLock()
		end
	end
    return true
end