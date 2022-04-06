TCF = TCF or {}
TCF.Config = TCF.Config or {}

-- SET LANGUAGE
-- Available languages: English: en - Danish: da - German: de - Polish: pl - Russian: ru - Spanish: es - French: fr - Chinese: cn - Turkish: tr
TCF.Config.Language = "fr" -- Set the language of the script.

-- GENERAL Config
TCF.Config.RemoveEntsOnTeamChange = true -- Should all cocaine related entities owned by the player be removed when changing to a non Criminal team (from list below)?
TCF.Config.RemoveEntsOnDC = true -- Same as above, but on disconnect all owned entities are removed.

-- GENERAL TEAM CONFIGURATION
TCF.Config.CriminalTeams = { -- These teams are allowed to interact with the cocaine buyer NPC.
	"Chef des Yakuzas",
	"Yakuza",
	"Yakuza Architecte",
	"Yakuza Médecin",
	"Parrain",
	"Mafieux",
	"Mafieux Architecte",
	"Mafieux Médecin",
	"Chef Gangster",
	"Gangster",
	"Gangster Architecte",
	"Gangster Médecin"
	
}

TCF.Config.PoliceTeams = { -- Police teams. These teams are NOT allowed to use the cocaine buyer NPC and can also confiscate packed boxes with cocaine.
	"Citoyen",
	"Civil Protection",
	"Police Chief",
	"Chief Civil Protection",
	"FBI",
	"S.W.A.T",
	"S.W.A.T Chief" -- THE LAST TEAM SHOULD NOT HAVE A COMMA
}

-- COCAINE BUYER NPC
TCF.Config.NPCDisplayName = "Tyrone Johnson" -- The display name shown above the NPC
TCF.Config.NPCDisplayDescription = "Sell me your cocaine packs." -- The description displayed above the NPC.

TCF.Config.SellDistance = 15000 -- How far away can the NPC detect your drug holder.
TCF.Config.RandomPayoutInterval = 300 -- How many seconds before the randomized payout is changed again. It randomizes the settings below.

TCF.Config.PayPerPackMin = 134735 -- How much should each cocaine pack be worth? Minimum value (without any donator bonuses)
TCF.Config.PayPerPackMax = 123520 -- How much should each cocaine pack be worth? Maximum value (without any donator bonuses)

TCF.Config.DisplayUIDistance = 300000 -- How far away from the drug dealer will the over-heads display show up? [Default = 300000]

-- STOVE ENTITY
TCF.Config.StoveHealth = 250 -- The amount of health the stove entity have.
TCF.Config.GasButtonDelay = 0.75 -- The amount of seconds delay there is when switching gas on/off on the stove.

TCF.Config.CookingSecondsMinimum = 30 -- Amount of seconds the pot must cook for MINIMUM before able to finish
TCF.Config.ChanceToFinish = 2 -- Default value is 2 which means there is a 50% chance of finishing after 30 seconds and when celcius is 100 (green area on arrow). If you put 3, there will be a 33% chance. So HIGHER number = lower chance to finish fast

TCF.Config.StoveExplosion = true -- Should the stove explode when destroyed. true/false
TCF.Config.ShowStoveHealth = true -- Enable or disable the health bar display on the stove.

TCF.Config.StoveSmokeEffect = true -- Should the pots on the stove emit smoke effect when cooking/turned on. true/false
TCF.Config.MinTemperatureForSmoke = 10 -- Minimum temperature the pot has to have before the smoke appears. It goes from 0 - 100.

TCF.Config.EnableOverCooking = true -- Should we enable overcooking or not?
TCF.Config.OverCookingTimeMin = 15 -- Minimum amount of seconds after the cooking is finished till it overcooks and catches fire.
TCF.Config.OverCookingTimeMax = 30 -- Maximum amount of seconds after the cooking is finished till it overcooks and catches fire.
TCF.Config.PotOnFireTimer = 8 -- Amount of seconds the pot should be on fire after overcooking before being removed.

TCF.Config.InstallPlatesDefault = false -- Should the cocaine stove automatically have plates installed (if enabled it removes the cooking plate entity from F4).

TCF.Config.DetachFinishedPotsWithE = true -- The ability to detach cooked pots by pressing E on the pot.

-- EXTRACTOR ENTITY
TCF.Config.ExtractorHealth = 200 -- The amount of health the barrel entity have.
TCF.Config.ExtractorSound = "ambient/gas/steam2.wav" -- Sound that plays while extracting the cocaine from the extractor entity.
TCF.Config.ExtractorSoundLevel = 50 -- Sound level of the steam sound from the extractor when in use.

TCF.Config.MinLeafAmount = 10 -- Minimum amount of leaf percentage added when adding leafs.
TCF.Config.MaxLeafAmount = 20 -- Maximum amount of leaf percentage added when adding leafs.

TCF.Config.MinCarbonateAmount = 25  -- Minimum amount of carbonate added when you add your finished pot.
TCF.Config.MaxCarbonateAmount = 25  -- Maximum amount of carbonate added when you add your finished pot.

TCF.Config.ExtractionTime = 30 -- Amount of seconds it takes for the extractor to finish.

TCF.Config.ExtractorExplosion = true -- Should the extractor explode when destroyed. true/false

-- POT/PAN ENTITY
TCF.Config.CookingPanHealth = 50 -- The amount of health the pot/pan entity have.

-- DRYING RACK ENTITY
TCF.Config.DryingRackHealth = 150 -- The amount of health the drying rack entity have.
TCF.Config.DryingTime = 20 -- Amount of seconds it takes for the drying rack to finish.

-- COCAINE BOX ENTITY
TCF.Config.CocaineBoxHealth = 75 -- The amount of health the drug holder/cocaine box entity have.
TCF.Config.PoliceConfiscateAmount = 200 -- Amount if money the police officers gets for confiscating a police box PER cocaine pack it contains.

-- BAKING SODA ENTITY
TCF.Config.BakingSodaHealth = 50 -- The amount of health the baking soda entity have.

-- COCAINE ENTITY
TCF.Config.CocaineHealth = 25 -- The amount of health the cocaine entity have.

-- GAS ENTITY
TCF.Config.GasHealth = 100 -- The amount of health the gas entity have.

TCF.Config.GasExplosion = true -- Should the gas canister explode when destroyed. true/false

-- LEAF ENTITY
TCF.Config.LeafHealth = 50 -- The amount of health the leaf entity have.

-- BATTERY ENTITY
TCF.Config.BatteryHealth = 50 -- The amount of health the leaf entity have.
TCF.Config.BatteryDecreaseTimer = 2 -- Every x seconds decrease some of the battery charge.
TCF.Config.BatteryDecreaseAmount = 2 -- How much of the battery charge is taken every x second (above). It reaches from 0 - 100.

-- WATER ENTITY
TCF.Config.WaterHealth = 50 -- The amount of health the water entity have.

-- BUCKET ENTITY
TCF.Config.BucketHealth = 50 -- The amount of health the bucket entity have.

-- COOKING PLATE ENTITY
TCF.Config.CookingPlateHealth = 50 -- The amount of health the cooking plate entity have.

-- DONATOR SETTINGS
TCF.Config.EnableDonatorBonus = true -- If this feature should be enabled or not (WORKS ONLY WITH ULX GROUPS).

TCF.Config.DonatorBonuses = {
	{ ULXGroup = "VIP", Bonus = 1.25 },
	{ ULXGroup = "VIP+", Bonus = 1.50 },
	{ ULXGroup = "moderateur_test_vip", Bonus = 1.25 },
	{ ULXGroup = "moderateur_test_vip+", Bonus = 1.50 },
	{ ULXGroup = "moderateur_vip", Bonus = 2 },
	{ ULXGroup = "moderateur_vip+", Bonus = 1.50 },
}

-- DarkRP Fire System ( https://www.gmodstore.com/market/view/302 )
-- Spawn fire when stove, extractor or gas canisters explode.
TCF.Config.CreateFireOnExplode = false -- false = disabled / true = enabled

-- XP SUPPORT
TCF.Config.DarkRPLevelSystemEnabled = false -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
TCF.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
TCF.Config.EXP2SystemEnabled = false -- Elite XP System (EXP2) by Axspeo https://www.gmodstore.com/market/view/4316
TCF.Config.EssentialsXPSystemEnabled = false -- Brick's Essentials and/or DarkRP Essentials by Brickwall https://www.gmodstore.com/market/view/5352 & https://www.gmodstore.com/market/view/7244
TCF.Config.GlorifiedLevelingXPSystemEnabled = false -- GlorifiedLeveling by GlorifiedPig https://www.gmodstore.com/market/view/7254

TCF.Config.OnSellGiveXP = false -- Should we give XP once they sell a box of cocaine to the druggie NPC?
TCF.Config.XPPerCocainePack = 25 -- Amount of experience to give to the player per cocaine pack?

TCF.Config.DryingRackGiveXP = false -- Should we give XP after completely drying a portion of cocaine?
TCF.Config.DryingRackXPAmount = 25 -- Amount of XP to give if enabled.

TCF.Config.FinishCookGiveXP = false -- Should we give XP after each pot has finished cooking?
TCF.Config.FinishCookXPAmount = 10 -- Amount of XP to give if enabled.

TCF.Config.ExtractorGiveXP = false -- Should we give XP after completing the extracting process? (once the bucket is full)
TCF.Config.ExtractorXPAmount = 25 -- Amount of XP to give if enabled.

-- List of cocaine entities deleted on team change and/or disconnect if enabled.
TCF.Config.CocaineEntityList = {
	["cocaine_baking_soda"] = true,
	["cocaine_box"] = true,
	["cocaine_bucket"] = true,
	["cocaine_cooking_plate"] = true,
	["cocaine_cooking_pot"] = true,
	["cocaine_drying_rack"] = true,
	["cocaine_extractor"] = true,
	["cocaine_gas"] = true,
	["cocaine_leaves"] = true,
	["cocaine_pack"] = true,
	["cocaine_stove"] = true,
	["cocaine_water"] = true
}

TCF.Config.HealableCocaineEntityList = {
	["cocaine_extractor"] = true,
	["cocaine_stove"] = true,
	["cocaine_drying_rack"] = true
}