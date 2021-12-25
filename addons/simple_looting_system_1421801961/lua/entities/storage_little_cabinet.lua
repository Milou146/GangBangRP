AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Conteneur"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_junk/TrashDumpster01a.mdl"
ENT.lootPos = { forward = 0, up = 50, right = 0 }
ENT.timeToLoot = 10
ENT.cooldownTime = 300

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_pistol"] = 5
ENT.lootList["item_ammo_pistol_large"] = 10
ENT.lootList["item_ammo_smg1"] = 5
ENT.lootList["item_ammo_smg1_large"] = 10
ENT.lootList["item_box_buckshot"] = 5
ENT.lootList["item_ammo_ar2"] = 5
ENT.lootList["item_ammo_ar2_large"] = 10
ENT.lootList["item_ammo_357"] = 5
ENT.lootList["item_ammo_357_large"] = 10

