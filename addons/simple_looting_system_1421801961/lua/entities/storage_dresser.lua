AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Carton clair"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_junk/cardboard_box001b.mdl"
ENT.lootPos = { forward = 0, up = 30, right = 0 }
ENT.timeToLoot = 2
ENT.cooldownTime = 60

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_pistol"] = 8
ENT.lootList["item_ammo_smg1"] = 8
ENT.lootList["item_box_buckshot"] = 3
ENT.lootList["item_ammo_ar2"] = 5
ENT.lootList["item_ammo_357"] = 2
