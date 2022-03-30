AddCSLuaFile()

SWEP.Base = "arc9_base"

SWEP.Spawnable = true
SWEP.Category = "ARC-9 BellraD Test mdr"



SWEP.PrintName = "scar l de ché pa ki"
SWEP.TrueName = nil
SWEP.Class = "j'aime le sex"
SWEP.Trivia = {"milou est le meilleur dev <3"}

SWEP.HoldType = "ar2"

SWEP.Description = [[ g pa didé]]

SWEP.UseHands = true
SWEP.DefaultSelectIcon = nil

SWEP.ViewModel = "models/weapons/arc9/aperopera/scar-l/v_scarlcup.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"

SWEP.AnimDraw = false


SWEP.CustomizePos = Vector(0, 0, 0)

SWEP.SprintAng = Angle(30, -15, 0)
SWEP.SprintPos = Vector(5, 0, 0)


SWEP.ActivePos = Vector(0, -10, -1)
SWEP.ActiveAng = Angle(0, 0, 0)


SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    Pos = Vector(-20, 3, -3),
    Ang = Angle(-0, 0, 180),
    Scale = 1
}

SWEP.NoTPIK = false

SWEP.Crosshair = true


SWEP.DamageMax = 420
SWEP.DamageMin = 69

SWEP.DamageRand = 0

SWEP.Num = 1

SWEP.DeployTime = 0.2

SWEP.Penetration = 3

SWEP.RicochetAngleMax = 0
SWEP.RicochetChance = 0

SWEP.DamageType = DMG_BULLET

SWEP.ArmorPiercing = 1

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.AnimReload = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 1.25,
    [HITGROUP_CHEST] = 1,
    [HITGROUP_LEFTARM] = 0.9,
    [HITGROUP_RIGHTARM] = 0.9,
}

SWEP.AlwaysPhysBullet = false
SWEP.NeverPhysBullet = false

SWEP.PhysBulletMuzzleVelocity = 150000 -- Physical bullet muzzle velocity in Hammer Units/second. 1 HU ~= 1 inch.
SWEP.PhysBulletDrag = 1 -- Drag multiplier
SWEP.PhysBulletGravity = 1 -- Gravity multiplier
SWEP.PhysBulletDontInheritPlayerVelocity = false -- Set to true to disable "Browning Effect"

SWEP.FancyBullets = false -- set to true to allow for multicolor mags and crap
-- Each bullet runs HookP_ModifyBullet, within which modifications can be made

-- if true, bullets follow the player's cursor
SWEP.BulletGuidance = false
SWEP.BulletGuidanceAmount = 15000 -- the amount of guidance to apply

-- Make the physical bullet use a model instead of the tracer effect.
-- You MUST register the model beforehand in a SHARED context (such as the SWEP file) like so: ARC9:RegisterPhysBulletModel("models/weapons/w_missile.mdl")
SWEP.PhysBulletModel = nil
SWEP.PhysBulletModelStick = nil -- The amount of time a physbullet model will stick on impact.

SWEP.Ammo = "smg"

SWEP.ChamberSize = 1
SWEP.ClipSize = 30
SWEP.SupplyLimit = 3

SWEP.AmmoPerShot = 1
SWEP.InfiniteAmmo = true
SWEP.BottomlessClip = false

SWEP.ReloadWhileSprint = false
SWEP.ReloadInSights = false

SWEP.IronSights = {
     Pos = Vector(-2.955, -10, -0.62),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
}

SWEP.FreeAimRadiusSights = 0

SWEP.CanFireUnderWater = false

SWEP.AutoReload = false

SWEP.DropMagazineModel = nil

SWEP.RPM = 700

SWEP.Firemodes = {
    {
        Mode = -1,
        -- add other attachment modifiers
    },
    {
        Mode = 1
    }
}


SWEP.RecoilSeed = nil -- Leave blank to use weapon class name as recoil seed.
-- Should be a number.
SWEP.RecoilPatternDrift = 12 -- Higher values = more extreme recoil patterns.
SWEP.RecoilLookupTable = nil -- Use to set specific values for predictible recoil. If it runs out, it'll just use Recoil Seed.
-- SWEP.RecoilLookupTable = {
--     15,
--     3,
-- }
SWEP.RecoilLookupTableOverrun = nil -- Repeatedly take values from this table if we run out in the main table

-- General recoil multiplier
SWEP.Recoil = 0.3

-- These multipliers affect the predictible recoil by making the pattern taller, shorter, wider, or thinner.
SWEP.RecoilUp = 1 -- Multiplier for vertical recoil
SWEP.RecoilSide = 1 -- Multiplier for vertical recoil

-- These values determine how much extra movement is applied to the recoil entirely randomly, like in a circle.
-- This type of recoil CANNOT be predicted.
SWEP.RecoilRandomUp = 0.1
SWEP.RecoilRandomSide = 0.1

SWEP.RecoilDissipationRate = 10 -- How much recoil dissipates per second.
SWEP.RecoilResetTime = 0.1 -- How long the gun must go before the recoil pattern starts to reset.

SWEP.RecoilAutoControl = 1 -- Multiplier for automatic recoil control.

-- SInput rumble configuration
-- Max of 65535
SWEP.RumbleHeavy = 30000
SWEP.RumbleLight = 30000
SWEP.RumbleDuration = 0.12


SWEP.UseVisualRecoil = true

SWEP.VisualRecoilUp = 0.01 -- Vertical tilt for visual recoil.
SWEP.VisualRecoilSide = 0.05 -- Horizontal tilt for visual recoil.
SWEP.VisualRecoilRoll = 0.23 -- Roll tilt for visual recoil.

SWEP.VisualRecoilCenter = Vector(2, 4, 2) -- The "axis" of visual recoil. Where your hand is.

SWEP.VisualRecoilPunch = 1.5 -- How far back visual recoil moves the gun.

SWEP.VisualRecoilMult = 1

SWEP.VisualRecoilHipFire = true

SWEP.RecoilKick = 1 -- Camera recoil

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["draw"] = {
        Source = "draw",
        Time = 5,
        SoundTable = {{s = "weapons/shared/draw.ogg", t = 0}},
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.35,
    },

    ["fire"] = {
        Source = "shoot1",
        Time = 0.1,
        ShellEjectAt = 0.01,
        EventTable = {
        {s = "scar-l/shoot.wav", t = 0},
        },
    },
    ["reload"] = {
        Source = "reload",

EventTable = {
           {s = "scar-l/magout.wav", t = 0.49},
		   {s = "scar-l/magin.wav", t = 2},
		   {s = "scar-l/maghit.wav", t = 2.5},
        },

        Time = 3,
  
    },
    ["reload_empty"] = {
        Source = "reload_full",
        Time = 4,
		EventTable = {
           {s = "scar-l/magout.wav", t = 0.54},
		   {s = "scar-l/magin.wav", t = 2.39},
		   {s = "scar-l/maghit.wav", t = 2.9},
		  {s = "scar-l/boltfwd.wav", t = 3.3},
        },
    },
}


SWEP.Attachments = {}
