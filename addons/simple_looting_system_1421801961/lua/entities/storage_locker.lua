AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Storage locker"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_c17/Lockers001a.mdl"
ENT.lootPos = { forward = 25, up = 0, right = 0 }
ENT.timeToLoot = 7
ENT.cooldownTime = 225

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_ar2"] = 25
ENT.lootList["item_ammo_pistol"] = 25
ENT.lootList["item_ammo_smg1"] = 25
ENT.lootList["weapon_smg1"] = 5
ENT.lootList["weapon_frag"] = 1
