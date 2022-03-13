AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Bidon de metal"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_c17/oildrum001.mdl"
ENT.lootPos = { forward = 0, up = 50, right = 0 }
ENT.timeToLoot = 5
ENT.cooldownTime = 120

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_pistol"] = 10
ENT.lootList["item_ammo_pistol_large"] = 5
ENT.lootList["item_ammo_smg1"] = 10
ENT.lootList["item_ammo_smg1_large"] = 3
ENT.lootList["item_box_buckshot"] = 5
ENT.lootList["item_ammo_ar2"] = 7
ENT.lootList["item_ammo_ar2_large"] = 2
ENT.lootList["item_ammo_357"] = 4
ENT.lootList["item_ammo_357_large"] = 2
