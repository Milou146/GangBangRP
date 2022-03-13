AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Caisse en bois"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_junk/wood_crate001a.mdl"
ENT.lootPos = { forward = 0, up = 35, right = 0 }
ENT.timeToLoot = 3
ENT.cooldownTime = 90

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_pistol"] = 10
ENT.lootList["item_ammo_pistol_large"] = 10
ENT.lootList["item_ammo_smg1"] = 10
ENT.lootList["item_ammo_smg1_large"] = 10
ENT.lootList["item_box_buckshot"] = 10
ENT.lootList["item_ammo_ar2"] = 10
ENT.lootList["item_ammo_ar2_large"] = 10
ENT.lootList["item_ammo_357"] = 10
ENT.lootList["item_ammo_357_large"] = 10
