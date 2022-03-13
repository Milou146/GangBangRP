cf = {}

-- CONFIG --

-- REMEMBER TO DOWNLOAD THE WORKSHOP CONTENT!!! https://steamcommunity.com/sharedfiles/filedetails/?id=1514815567

-- Sell Mode | Setting it to false allows selling cigarettes without bringing them to the export van.
-- Note that if you're using default sell mode you need to save spawned vans using cf_save command! Otherwise vans will disappear after server restart.
cf.InstantSellMode = false

-- Maximum amount of tobacco machine can contain.
cf.maxTobaccoStorage = 3000

-- Maximum default paper storage.
cf.maxPaperStorage = 300

-- Time (in seconds) it takes to produce one pack.
cf.timeToProduce = 5

-- Amount of paper it takes to produce one pack.
cf.paperProductionCost = 2

-- Amount of tobacco it takes to produce one pack.
cf.tobaccoProductionCost = 20

-- Time (in seconds) it takes for a cigarette pack to despawn (reduces lag).
cf.cigAutoDespawnTime = 14

-- Engine performance multiplier after engine upgrade (1.5 makes it 50% more efficient).
cf.engineUpgradeBoost = 1.5

-- Amount of additional storage after storage upgrade.
cf.storageUpgradeBoostTobacco = 2000 
cf.storageUpgradeBoostPaper = 200

-- Base amount of $ you'll get for one pack sold.
cf.sellPrice = 19

-- How often should the price change (in seconds). 
cf.priceChangeTime = 60

-- Maximum difference in pack price.
cf.maxPriceDifference = 6

-- Max amount of packs that can fit into an export box.
cf.maxCigsBox = 64

-- Max amount of packs player can carry.
cf.maxCigsOnPlayer = 256

-- Machine maximum health
cf.maxMachineHealth = 300

-- Machine hp regen rate 
cf.machineRegen = 4

-- Cigarette SWEP compatibility ( REQUIRES https://steamcommunity.com/sharedfiles/filedetails/?id=793269226&searchtext=cigarette !!!)
cf.allowSwep = false

-- Should vans respawn after map cleanup
cf.AutoRespawn = true

-- Translation
cf.StorageText = "CAPACITÉ AUGMENTÉE"
cf.StorageDescText = ""
cf.ProductionOffText = "ÉTEINT"
cf.ProducingText = "EN COURS..."
cf.RefillNeededText = "A RECHARGER"
cf.EngineText = "BOOSTER"
cf.EngineDescText = ""
cf.BoxText = "BOÎTE D'EXPÉDITION"
cf.BoxDescText1 = ""
cf.BoxDescText2 = ""
cf.BoxDescText3 = "QUANTITÉ: "
cf.BoxDescText4 = "MONTANT: "
cf.CurrencyText = "$"
cf.Notification1 = "Vous ne pouvez pas transporter plus de "
cf.Notification2 = " cigarettes!"
cf.Notification3 = "Vous avez ramassé une boîte contenant "
cf.Notification4 = " PAQUET(S)!"
cf.MachineHealth = "HP"
cf.VanText = "EXPORTATION"
cf.VanDescText1 = ""
cf.VanDescText2 = " par paquet de cigarettes."
cf.SellText1 = "Votre solde "
cf.SellText2 = " paquet(s) de cigarettes pour "
cf.CommandText1 = "Les camionnettes d'exportation ont été sauvées."
cf.CommandText2 = "Les camionnettes d'exportation ont été chargées."

-- Fonts
if CLIENT then
	surface.CreateFont( "cf_machine_main", {
		font = "Impact",    
		size = 24
	})
	surface.CreateFont( "cf_machine_small", {
		font = "Impact",    
		size = 16,
		outline = true
	})
end