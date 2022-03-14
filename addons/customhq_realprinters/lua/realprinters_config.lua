--------------------------------------CONFIG FILE-------------------------------------------
-- Printer-Feature Settings
-- White/Cheap printer settings
hqprinter1 = {}
hqprinter1["PrinterColor"]   	= Color(255,255,255)	-- RGB Color of the printer
hqprinter1["PName"] 			= "Cheap Printer"		-- The display name on the printer
hqprinter1["MaxMoney"] 			= 1000					-- Max money the printer will store
hqprinter1["PrintMoney"]   	  	= 250  					-- How much money it prints per print
hqprinter1["PrintTimeMin"] 		= 150  					-- Minimum amount of time for the printer to print (random number between these two)
hqprinter1["PrintTimeMax"] 		= 250  					-- Maximum amount of time for the printer to print
hqprinter1["HeatPower"]  		= 15					-- every N sec +2 to temperature  with calculating current power
hqprinter1["HeatSpeed"] 		= 10					-- every 15 sec +N to temperature
hqprinter1["PaperEating"]		= 2						-- How much paper is consumed per 1 print?
hqprinter1["ColorEating"] 		= 3						-- How much printer ink is consumed per 1 print?
hqprinter1["PapersPerBlock"] 	= 50    				-- How much paper is added to the printer per paper roll?
hqprinter1["ColorsPerBlock"]	= 30    				-- How much ink is added to the printer per ink cartridge
hqprinter1["MaxPapers"] 		= 100					-- How much paper can this printer hold?
hqprinter1["MaxColors"]			= 120					-- How much ink can this printer hold?

-- Pinky printer settings
hqprinter2 = {}
hqprinter2["PrinterColor"]   	= Color(251,175,255) 	-- RGB Color of the printer
hqprinter2["PName"] 			= "Pinky Printer"		-- The display name on the printer
hqprinter2["MaxMoney"] 			= 3000					-- Max money the printer will store
hqprinter2["PrintMoney"]   	  	= 270  					-- How much money it prints per print
hqprinter2["PrintTimeMin"] 		= 110  					-- Minimum amount of time for the printer to print (random number between these two)
hqprinter2["PrintTimeMax"] 		= 120  					-- Maximum amount of time for the printer to print
hqprinter2["HeatPower"]  		= 10					-- every N sec +2 to temperature  with calculating current power
hqprinter2["HeatSpeed"] 		= 8						-- every 15 sec +N to temperature 
hqprinter2["AllowCooler"] 		= true					-- allow add cooler on our money printer
hqprinter2["PaperEating"]		= 2						-- How much paper is consumed per 1 print? 
hqprinter2["ColorEating"] 		= 4						-- How much printer ink is consumed per 1 print? 
hqprinter2["PapersPerBlock"] 	= 50    				-- How much paper is added to the printer per paper roll?
hqprinter2["ColorsPerBlock"]	= 30    				-- How much ink is added to the printer per ink cartridge
hqprinter2["MaxPapers"] 		= 100					-- How much paper can this printer hold?
hqprinter2["MaxColors"]			= 120					-- How much ink can this printer hold?	

-- Green printer settings
hqprinter3 = {}
hqprinter3["PrinterColor"]   	= Color(161, 255, 171)  -- RGB Color of the printer
hqprinter3["PName"] 			= "Green Printer"		-- The display name on the printer
hqprinter3["MaxMoney"] 			= 2000					-- Max money the printer will store
hqprinter3["PrintMoney"]   	  	= 280  					-- How much money it prints per print
hqprinter3["PrintTimeMin"] 		= 100  					-- Minimum amount of time for the printer to print (random number between these two)
hqprinter3["PrintTimeMax"] 		= 150  					-- Maximum amount of time for the printer to print
hqprinter3["HeatPower"]  		= 10					-- every N sec +2 to temperature  with calculating current power
hqprinter3["HeatSpeed"] 		= 3						-- every 15 sec +N to temperature 
hqprinter3["AllowCooler"] 		= true					-- allow add Cooler on our money printer
hqprinter3["PaperEating"]		= 2						-- How much paper is consumed per 1 print? 
hqprinter3["ColorEating"] 		= 2						-- How much printer ink is consumed per 1 print? 
hqprinter3["PapersPerBlock"] 	= 50    				-- How much paper is added to the printer per paper roll?
hqprinter3["ColorsPerBlock"]	= 30    				-- How much ink is added to the printer per ink cartridge
hqprinter3["MaxPapers"] 		= 120					-- How much paper can this printer hold?
hqprinter3["MaxColors"]			= 100					-- How much ink can this printer hold?	

-- Golden printer settings
hqprinter4 = {}
hqprinter4["PrinterColor"]   	= Color(255, 251, 154)  -- RGB Color of the printer
hqprinter4["PName"] 			= "Gold Printer"		-- The display name on the printer
hqprinter4["MaxMoney"] 			= 5000					-- Max money the printer will store
hqprinter4["PrintMoney"]   	  	= 350  					-- How much money it prints per print
hqprinter4["PrintTimeMin"] 		= 80  					-- Minimum amount of time for the printer to print (random number between these two)
hqprinter4["PrintTimeMax"] 		= 120  					-- Maximum amount of time for the printer to print
hqprinter4["HeatPower"]  		= 15					-- every N sec +2 to temperature  with calculating current power
hqprinter4["HeatSpeed"] 		= 20					-- every 15 sec +N to temperature 
hqprinter4["AllowCooler"] 		= true					-- allow add Cooler on our money printer
hqprinter4["PaperEating"]		= 2						-- How much paper is consumed per 1 print? 
hqprinter4["ColorEating"] 		= 5						-- How much printer ink is consumed per 1 print? 
hqprinter4["PapersPerBlock"] 	= 50    				-- How much paper is added to the printer per paper roll?
hqprinter4["ColorsPerBlock"]	= 30    				-- How much ink is added to the printer per ink cartridge
hqprinter4["MaxPapers"] 		= 140					-- How much paper can this printer hold?
hqprinter4["MaxColors"]			= 180					-- How much ink can this printer hold?	

-- DarkRP entities, do not change anything that is not commented or the custom models go away. Or you break it.
--[--hook.Add("loadCustomDarkRPItems", "customhqprinterload", function()
--AddEntity("Printer - Cheap", {					-- Name you see on the f4 menu
	--price = 1000,								-- The price of the printer
	--max = 5,									-- Max amount of these printers a player can spawn
	--cmd = "buy_cheap_printer",					-- Command the player types to spawn printer (must be unique)
--ent = "custom_printer_white",
	--model = "models/custom/rprinter.mdl"
--})

--AddEntity("Printer - Pinky", {					-- Name you see on the f4 menu
	--price = 4000,								-- The price of the printer
	--max = 1,									-- Max amount of these printers a player can spawn
	--cmd = "buy_pinky_printer",					-- Command the player types to spawn printer (must be unique)
	--ent = "custom_printer_pinky",
	--model = "models/custom/rprinter.mdl"
--})

--AddEntity("Printer - Green", {					-- Name you see on the f4 menu
	--price = 6000,								-- The price of the printer
	--max = 1,									-- Max amount of these printers a player can spawn
	--cmd = "buy_green_printer",					-- Command the player types to spawn printer (must be unique)
	--ent = "custom_printer_green",
	--model = "models/custom/rprinter.mdl"
--})

--AddEntity("Printer - Gold", {					-- Name you see on the f4 menu
	--price = 8000,								-- The price of the printer
	--max = 2,									-- Max amount of these printers a player can spawn
	--cmd = "buy_gold_printer",					-- Command the player types to spawn printer (must be unique)
	--ent = "custom_printer_gold",
	--model = "models/custom/rprinter.mdl"
--})

--]--AddEntity("Ink for printer", {					-- Name you see on the f4 menu
	--model = "models/props_lab/jar01b.mdl",		-- You can change the model here if you want
	--price = 400,								-- Price of the printer ink
	--max = 3,									-- How many printer ink jars can be spawned
	--cmd = "buyprintercolors",					-- Command the player types to spawn the ink (must be unique)
	--ent = "upgrade_color"
--})
--[--
--AddEntity("Paper for printer", {							-- Name you see on the f4 menu
	--model = "models/props/cs_office/paper_towels.mdl",		-- You could change the model, I guess.
	--price = 300,											-- Price of the printer paper
	--max = 3,												-- How many printer paper entities the player can spawn
	--cmd = "buyprinterpaper",								-- Command the player types to spawn the printer paper
	--ent = "upgrade_paper"
--})

--AddEntity("Cooler for printer", {				-- Name you see on the f4 menu
	--price = 4000,								-- Price of the printer cooler with 2 fans
	--max = 3,									-- Max printer coolers the player can spawn
	--cmd = "buyprintercooler",					-- Command the player types to spawn the printer cooler (must be unique)
	--ent = "upgrade_cooler",
	--model = "models/custom/coolerx2.mdl"
--})

--AddEntity("Miniature cooler for printer", {		-- Name you see on the f4 menu
	--price = 2000,								-- Price of the mini printer cooler (has 1 fan)
	--max = 3,									-- How many mini coolers a player can spawn
	--cmd = "buyprintercooler2",					-- Command the player types to spawn the printer cooler (must be unique)
	--ent = "upgrade_cooler_mini",
	--model = "models/custom/coolermini.mdl"
--})
--end)