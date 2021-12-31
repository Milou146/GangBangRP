if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/weapon_doiwelrod")
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
killicon.Add( "weapon_doiwelrod", "vgui/hud/weapon_doiwelrod", Color( 0, 0, 0, 255 ) )
end

SWEP.PrintName = "Welrod"

SWEP.Category = "DoI Sweps"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/doi/v_welrod.mdl" 
SWEP.WorldModel = "models/weapons/doi/w_welrod.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 0
 
SWEP.UseHands = true

SWEP.HoldType = "pistol" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = false

SWEP.Base = "weapon_base"

SWEP.CSMuzzleFlashes = true

SWEP.Sprint = 0
SWEP.FireEnd = 0
SWEP.IronSightsPos = Vector(-2.3, 0, 0.829)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.Primary.Cone = 0.02

SWEP.Primary.Sound = Sound("weapons/welrod/welrod_fp.wav")
SWEP.Primary.Damage = 10000
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 3
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 240
SWEP.Primary.Spread = 0.00001
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 3
SWEP.Primary.Force = 5

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Deploy()
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
Sprint = 0
FireEnd = 0
self.NextSecondaryAttack = 0
self:SetIronsights( false )
self.DrawCrosshair = true
end

function SWEP:Holster()
self.NextSecondaryAttack = 0
Sprint = 0
FireEnd = 0
self:SetIronsights( false )
self.DrawCrosshair = true
return true
end

function SWEP:PrimaryAttack()

if ( !self:CanPrimaryAttack() ) || not(Sprint == 0) then return end

FireEnd = 1

local bullet = {} 
bullet.Num = self.Primary.NumberofShots 
bullet.Src = self.Owner:GetShootPos() 
bullet.Dir = self.Owner:GetAimVector() 
bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
bullet.Tracer = 1 
bullet.Force = self.Primary.Force 
bullet.Damage = self.Primary.Damage 
bullet.AmmoType = self.Primary.Ammo 
 
local rnda = self.Primary.Recoil * -1 
local rndb = self.Primary.Recoil * math.random(-1, 1) 
 
self:ShootEffects()
if self.Weapon:GetNetworkedBool( "Ironsights", true ) then
self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_DEPLOYED)
end
if (FireEnd == 1) then
timer.Simple(0.7, function()
if (FireEnd == 1) and self.Weapon:Clip1() > 0 then
self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
end
if (FireEnd == 1) and (bIron) and self.Weapon:Clip1() > 0 then
self.Weapon:SendWeaponAnim(ACT_VM_RELOAD_DEPLOYED)
end
FireEnd = 0
end)
end
self.Owner:FireBullets( bullet )
self:EmitSound(Sound(self.Primary.Sound))
self.Owner:MuzzleFlash()
self.Owner:ViewPunch( Angle( math.Rand(-1,-0.8) * self.Primary.Recoil, math.Rand(-0.5,0.5) *self.Primary.Recoil, 0 ) )
self.Owner:SetEyeAngles(self.Owner:EyeAngles()+Angle(-2,math.random(-0.5,0.5),0))
self:TakePrimaryAmmo(self.Primary.TakeAmmo)
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

local IRONSIGHT_TIME = 0.2

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.1
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	if (bIron) then
	self.DrawCrosshair = false
	end
	if not(bIron) then
	self.DrawCrosshair = true
	end
	return pos, ang
	
end

function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.2
	
end

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	self.DrawCrosshair = true
	
end

function SWEP:Reload()
self.Weapon:DefaultReload( ACT_VM_RELOAD )
self.NextSecondaryAttack = 0
self:SetIronsights( false )
self.DrawCrosshair = true
Sprint = 0
FireEnd = 0
end

function SWEP:Think()
if SERVER then
if (Sprint == 0) then
if self.Owner:KeyDown(IN_SPEED) and (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) || self.Owner:KeyDown(IN_MOVERIGHT)) then
Sprint = 1
self.NextSecondaryAttack = 0
self:SetIronsights( false )
self.DrawCrosshair = true
end
end
if (Sprint == 1) then
self.Weapon:SendWeaponAnim(ACT_VM_SPRINT_IDLE)
Sprint = 2
end
if (Sprint == 2) then
if self.Owner:KeyReleased(IN_SPEED) then
self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
Sprint = 0
end
end
end
end