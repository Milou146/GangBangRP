AddCSLuaFile()

SWEP.Base = "arc9_base"

SWEP.Spawnable = true
SWEP.Category = "ARC-9 BellraD Test mdr"



SWEP.PrintName = "L'AK de Milou mdr"
SWEP.TrueName = nil
SWEP.Class = "j'aime le sex"
SWEP.Trivia = {"milou est le meilleur dev <3"}

SWEP.HoldType = "ar2"

SWEP.Description = [[ g pa didé]]

SWEP.UseHands = true
SWEP.DefaultSelectIcon = nil

SWEP.ViewModel = "models/weapons/arc9/aperopera/akm/akm.mdl" -- model de l'arme
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl" -- world model (pas celui que le jouer tient , mais celui qui spawn quand tu fera / drop par exemple

SWEP.AnimDraw = false -- touche pas


SWEP.CustomizePos = Vector(0, 0, 0)	

SWEP.SprintAng = Angle(30, -15, 0) -- pour changer la transformation angle sur l'axe X Y Z quaand tu sprint
SWEP.SprintPos = Vector(5, 0, 0) -- pareil quau dessu mais pour la position


SWEP.ActivePos = Vector(-1, -5, -1) -- pour changer la manière dont tu tien l'arme en fps sans toucher a blender c pratique 
SWEP.ActiveAng = Angle(0, 0, 0) -- pareil mais pour l'angle


SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    Pos = Vector(-9, 0, 0),
    Ang = Angle(-0, 0, 180),
    Scale = 0.8
}

SWEP.NoTPIK = false -- touche pas a moin que ta envi de ruiner le fun

SWEP.Crosshair = true


SWEP.DamageMax = 420 -- lol
SWEP.DamageMin = 69 -- xd

SWEP.DamageRand = 0

SWEP.Num = 1 -- numero de balle que le swep tire

SWEP.DeployTime = 0.2 -- le temps que l'arme prend pour etre sorti / ranger

SWEP.Penetration = 3 -- penetration en unité de bois

SWEP.RicochetAngleMax = 0 -- ricochet angle max
SWEP.RicochetChance = 0 -- chance de ricochet

SWEP.DamageType = DMG_BULLET -- touche pas a moin que on a envis de faire des armes laser ou ché pa quoi

SWEP.ArmorPiercing = 1 -- 1 : ignore l'armure , 2 : endommage la santé mais reduit si armure

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 -- anim quand tu tire
SWEP.AnimReload = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 -- anim pour recharger (je mets une anim d'attaque comme ça la vrai animation en worldmodel est bien visible pour le joueur)

-- touche pas en dessous c'est des multiplier lol

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 1.25,
    [HITGROUP_CHEST] = 1,
    [HITGROUP_LEFTARM] = 0.9,
    [HITGROUP_RIGHTARM] = 0.9,
}

-- a changer pour performance du serveur

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

-- parametre de swep de base lol javais oublié de les mettre en premier car jsuis intelligent

SWEP.Ammo = "ar2"

SWEP.ChamberSize = 1
SWEP.ClipSize = 30
SWEP.SupplyLimit = 3

SWEP.AmmoPerShot = 1
SWEP.InfiniteAmmo = true -- a enlever apres phase de test 
SWEP.BottomlessClip = false -- pour avoir jamais a recharger

SWEP.ReloadWhileSprint = false -- pour recharger en sprintant
SWEP.ReloadInSights = false -- pour recharger en visant

SWEP.IronSights = {
     Pos = Vector(-3.29, -6.446, 0.007),
     Ang = Angle(0, 0, 0),
    Magnification = 1.1,
}

-- ^^ position pour les mires

SWEP.FreeAimRadiusSights = 0

SWEP.CanFireUnderWater = false

SWEP.AutoReload = false

SWEP.DropMagazineModel = nil -- a voir dans le futur pour mettre un model de chargeur qui tombe sur le sol suivant l'animation que je fait

SWEP.RPM = 600

SWEP.Firemodes = {
    {
        Mode = -1,
-- 1: full auto
-- 0: cran de sureté
-- 1: semi
-- 2: 2 coup
-- 3: 3 coup
    },
    {
        Mode = 1
    }
}


-- parti avancer en dessou pour le recul a playtest pour faire que toute les armes sont fair

SWEP.RecoilSeed = nil -- 

SWEP.RecoilPatternDrift = 12 
SWEP.RecoilLookupTable = nil 
SWEP.RecoilLookupTableOverrun = nil


SWEP.Recoil = 0.3


SWEP.RecoilUp = 1 
SWEP.RecoilSide = 1 



SWEP.RecoilRandomUp = 0.1
SWEP.RecoilRandomSide = 0.1

SWEP.RecoilDissipationRate = 10 
SWEP.RecoilResetTime = 0.1 

SWEP.RecoilAutoControl = 1 


SWEP.RumbleHeavy = 30000
SWEP.RumbleLight = 30000
SWEP.RumbleDuration = 0.12


-- recul visiuel

SWEP.UseVisualRecoil = true

SWEP.VisualRecoilUp = 0.01 
SWEP.VisualRecoilSide = 0.05 --
SWEP.VisualRecoilRoll = 0.23 

SWEP.VisualRecoilCenter = Vector(2, 4, 2) 

SWEP.VisualRecoilPunch = 1.5 

SWEP.VisualRecoilMult = 1

SWEP.VisualRecoilHipFire = true

SWEP.RecoilKick = 1 -- recul camera

-- sa c a moi ta pas intere a toucher

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
        Source = "fire1",
        Time = 0.1,
        ShellEjectAt = 0.01,
        EventTable = {
        {s = "akm/ak_bang.wav", t = 0},
        },
    },
    ["reload"] = {
        Source = "reload",

EventTable = {
           {s = "akm/magout.ogg", t = 0.35},
		   {s = "akm/magin.ogg", t = 1.5},
        },

        Time = 2.5,
  
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        Time = 4,
		EventTable = {
           {s = "akm/magout.ogg", t = 0.35},
		   {s = "akm/magin.ogg", t = 1.6},
		   {s = "akm/boltback.ogg", t = 3.1},
		   {s = "akm/boltfwd.ogg", t = 3.3},
        },
    },
}


SWEP.Attachments = {}
