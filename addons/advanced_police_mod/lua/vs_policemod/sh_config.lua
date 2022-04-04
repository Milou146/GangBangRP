local CFG = {}

-- Language used by the addon
CFG.Language = "en"

-- are all the jobs defined as Civil Protection in your darkrp config police jobs in the addon
CFG.IsCPPoliceJobs = true

-- Key to open the tablet in a vehicle
CFG.KeyVehicle = KEY_T
-- Key to turn on/off the radio in a vehicle
CFG.KeyRadioVehicle = KEY_C
-- Jobs that are defined as police
CFG.PoliceJobs = {
	[ "N.Y.P.D" ] = true,
	[ "Commissaire" ] = true,
	[ "S.W.A.T" ] = true,
	[ "S.W.A.T Médic" ] = true,
	[ "S.W.A.T Sniper" ] = true,
}
}

-- Dispatch groups names
CFG.DispatchGroupsNames = {
	["Apero"] = true,
	["Brave"] = true,
	["Salient"] = true,
	["Delta"] = true,
	["Epsilon"] = true,
	["Zeta"] = true,
	["Omega"] = true,
	["Opera"] = true,
}

-- Time banned in the job after a fire
CFG.TimeBanAfterFire = 1800

-- Chat command to open the help call menu (Context Menu is also another solution)
CFG.CallPoliceCommand = "/emergency"

-- Reasons that can be set in a help call
CFG.CallsReason = {
	"Vol",
	"Activité de gang",
	"Agression",
	"Braquage",
	"Autre",
}

-- Reasons that can be used in a complaint
CFG.CallsReason = {
	"Vol",
	"Activité de gang",
	"Agression",
	"Braquage",
	"Autre",
}

-- Fines prices
CFG.Fine = {
	[ "Cambriolage" ] = {
		minPrice = 50,
		maxPrice = 1000
	},
	[ "Agression" ] = {
		minPrice = 100,
		maxPrice = 1500
	},
	[ "Thief" ] = {
		minPrice = 20,
		maxPrice = 800
	},
	[ "Speeding" ] = {
		minPrice = 50,
		maxPrice = 200
	}
}

-- How much time to wait to send a new fine to a player ( prevent fine spam )
CFG.FineDelay = 120

-- Automatic delay to close a help call
CFG.CallCancelDelay = 600

-- Price of the bail (seconds * value below)
CFG.JaiTimeBailMultiplier = 10

-- Available ones:
-- "[title/]here is your title",
-- "[content/]here is your content",
-- "[bold/]here is your bold text",
-- "[italic/]here is your italic text",
-- Skip a line : "[br/]",
CFG.HelpAppText = {
	"Faites respectez la loi."
	-- you're free to make it bigger & remove whatever
}

VS_PoliceMod.Config = CFG