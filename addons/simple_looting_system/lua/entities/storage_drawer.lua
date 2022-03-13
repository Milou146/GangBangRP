AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Poubelle"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_junk/TrashBin01a.mdl"
ENT.lootPos = { forward = 0, up = 50, right = 0 }
ENT.timeToLoot = 5
ENT.cooldownTime = 120

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_pistol"] = 8
ENT.lootList["item_ammo_pistol_large"] = 3
ENT.lootList["item_ammo_smg1"] = 8
ENT.lootList["item_ammo_smg1_large"] = 1
ENT.lootList["item_box_buckshot"] = 3
ENT.lootList["item_ammo_ar2"] = 5
ENT.lootList["item_ammo_ar2_large"] = 2
ENT.lootList["item_ammo_357"] = 2
ENT.lootList["item_ammo_357_large"] = 1
