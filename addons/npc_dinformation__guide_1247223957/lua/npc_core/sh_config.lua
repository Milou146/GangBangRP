-------------------------------------------------------------
-- GLOBAL CONFIGURATION
OsGuide.adminGroup = {
	["superadmin"] = true, 
	["admin"] = true
}

OsGuide.languageUse = "fr" -- fr or en

OsGuide.adminDerma = "!guideadmin"
OsGuide.spawnCommand = "!newguide"

OsGuide.title = ""
OsGuide.desc = "Besoin d'aide ?"
OsGuide.titleColor = Color(255, 255, 255, 255)

OsGuide.modelNPC = "models/Humans/Group02/male_06.mdl"

-------------------------------------------------------------
-- DERMA CONFIGURATION
OsGuide.useSound = false 
OsGuide.useWebSound = false 
OsGuide.soundPath = "sound/music/nlftbotmainmusic.wav" 

OsGuide.useLogo = false
OsGuide.rotationLogo = true
OsGuide.pathLogo = "osbot/panel.png"

OsGuide.mainText = "........"
OsGuide.mainTextColor = Color( 255, 255, 255, 255 )

OsGuide.RegisterNewAction( {
	name = "Le serveur",
	text = "",
	action = "text",
} )

OsGuide.RegisterNewAction( {
	name = "Nos explications vidéos",
	text = "",
	action = "ingameURL",
} )

OsGuide.RegisterNewAction( {
	name = "Notre forum",
	text = "",
	action = "ingameURL",
} )

OsGuide.RegisterNewAction( {
	name = "Notre Discord",
	text = "https://www.google.com/",
	action = "ingameURL",
} )

OsGuide.RegisterNewAction( {
	name = "Notre boutique",
	text = "https://www.google.com/",
	action = "ingameURL",
} )

--OsGuide.RegisterNewAction( {
---	name = "Notre musique ! (Via fichier)",
--	text = "sound/music/nlftbotmainmusic.wav",
--	action = "playSoundFile",
-- )--


OsGuide.RegisterNewAction( {
	name = "Reçois t'es 500$ de départ !",
	text = "500",
	action = "giveMoneyOneTime",
} )

OsGuide.RegisterNewAction( {
	name = "Quitter",
	text = "",
	action = "leave",
} )

OsGuide.titleColor = Color( 190, 190, 190 )

OsGuide.backgroundColor = Color( 50, 50, 50, 250 )
OsGuide.backgroundContourColor = Color( 0, 0, 0, 200 )

OsGuide.navbarColor =   Color(175, 100, 100, 255)

OsGuide.buttonTextColor = Color( 255, 255, 255 )
OsGuide.buttonColor = Color( 25, 25, 25, 250 )
OsGuide.buttonHoveredColor =  Color( 100, 100, 100, 150 )

OsGuide.onClickSound = "buttons/button14.wav"
OsGuide.onHoveredSound = "buttons/lightswitch2.wav"


-------------------------------------------------------------
-- POPUP CONFIGURATION
OsGuide.popUp.titleColor = color_white
OsGuide.popUp.backgroundTitleColor = Color(41, 128, 255, 250)

OsGuide.popUp.exitTitle = "OK"

OsGuide.popUp.exitColor = Color(44, 62, 80, 60)
OsGuide.popUp.exitHover = Color(41, 128, 255, 100)

OsGuide.popUp.exitTextColor = color_white

-- ICON CONFIGURATION 

OsGuide.iconCreate = "osbot/create.png"

OsGuide.iconDelete = "osbot/delete.png"

OsGuide.iconShowData = "osbot/showdata.png"

OsGuide.iconSearch = "osbot/search.png"

OsGuide.iconCreator = "osbot/creator.png"

OsGuide.iconInfo = "osbot/info.png"