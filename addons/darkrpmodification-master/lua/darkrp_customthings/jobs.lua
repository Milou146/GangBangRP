-------------------------------------------------------------------------------


TEAM_CITIZEN = DarkRP.createJob("Citoyen", {
    color = Color(17, 85, 51, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[.]],
    weapons = {"pocket", "keys"},
    command = "citoyen",
    max = 0,
    salary = 1,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Z",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
})
--------------------------------------------------------------------------------
TEAM_NYPD = DarkRP.createJob("N.Y.P.D", {
    color = Color(34, 85, 85, 255),
    model = {"models/taggart/police01/male_01.mdl", 
	"models/taggart/police01/male_02.mdl", 
	"models/taggart/police01/male_04.mdl", 
	"models/taggart/police01/male_05.mdl", 
	"models/taggart/police01/male_06.mdl", 
	"models/taggart/police01/male_07.mdl", 
	"models/taggart/police01/male_08.mdl", 
	"models/taggart/police01/male_09.mdl"
	},
    description = [[]],
    weapons = {"weapon_fists", "pocket", "keys", "weaponchecker"},
    command = "nypd",
    max = 8,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "us",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end
})
--------------------------------------------------------------------------------
TEAM_NYPD1 = DarkRP.createJob("Commissaire", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/gtav/lspd/fcopbpm.mdl", 
	"models/sentry/gtav/lspd/fcopwpm.mdl", 
	"models/sentry/gtav/lspd/vtrafcoppm.mdl" 
		},
    description = [[]],
    weapons = {"weapon_fists", "pocket", "keys", "weaponchecker"},
    command = "cnypd",
    max = 1,
    salary = 10,
    admin = 0,
    vote = true,
    hasLicense = true,
	candemote = false,
    category = "us",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(75)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end
})
--------------------------------------------------------------------------------
TEAM_NYPD2 = DarkRP.createJob("S.W.A.T", {
    color = Color(34, 85, 85, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", 
	"models/akitos_model_pack/modern_swat.mdl", 
	"models/akitos_model_pack/old_swat.mdl", 
	"models/akitos_model_pack/swat_hazmat.mdl"
	},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","weaponchecker"},
    command = "swat",
    max = 4,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "us",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end
})
--------------------------------------------------------------------------------
TEAM_NYPD3 = DarkRP.createJob("S.W.A.T Médic", {
    color = Color(34, 85, 85, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", 
	"models/akitos_model_pack/modern_swat.mdl", 
	"models/akitos_model_pack/old_swat.mdl", 
	"models/akitos_model_pack/swat_hazmat.mdl"
	},
    description = [[]],
    weapons = {"weapon_fists", "weapon_medkit","pocket", "keys", "weaponchecker"},
    command = "swatmed",
    max = 1,
    salary = 12,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "us",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})
--------------------------------------------------------------------------------
TEAM_NYPD4 = DarkRP.createJob("S.W.A.T Sniper", {
    color = Color(34, 85, 85, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", 
	"models/akitos_model_pack/modern_swat.mdl", 
	"models/akitos_model_pack/old_swat.mdl", 
	"models/akitos_model_pack/swat_hazmat.mdl"
	},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","weaponchecker"},
    command = "swatsnip",
    max = 2,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "us",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"superadmin","VIP +","moderateur_VIP+","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})
--------------------------------------------------------------------------------
TEAM_YAKU = DarkRP.createJob("Chef des Yakuzas", {
    color = Color(34, 85, 85, 255),
    model = {"models/players/Kimonos_25.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","weapon_mse_katana"},
    command = "chefy",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "yaku",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
	
})
--------------------------------------------------------------------------------
TEAM_YAKU2 = DarkRP.createJob("Yakuza", {
    color = Color(34, 85, 85, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys"},
    command = "yaku",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "yaku",
	 skins = {0,1,2,3,4,5,6,7,8,9},
        bodygroups = {
				["Casque/Helmet"] = {0,1,2,3,4,5,6,7,8},
                ["Arme/Weapon"] = {0},
                ["Arme2/Weapon2"] = {0},
                                
        },        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
	
})
--------------------------------------------------------------------------------
TEAM_YAKU3 = DarkRP.createJob("Yakuza Architecte", {
    color = Color(34, 85, 85, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys", "alydus_fortificationbuildertablet"},
    command = "yakuarc",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "yaku",
	 skins = {0,1,2,3,4,5,6,7,8,9},
        bodygroups = {
				["Casque/Helmet"] = {0,1,2,3,4,5,6,7,8},
                ["Arme/Weapon"] = {0},
                ["Arme2/Weapon2"] = {0},
                                
        },        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
	
})
--------------------------------------------------------------------------------
TEAM_YAKU4 = DarkRP.createJob("Yakuza Médecin", {
    color = Color(34, 85, 85, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys", "weapon_medkit"},
    command = "yakumed",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "yaku",
	 skins = {0,1,2,3,4,5,6,7,8,9},
        bodygroups = {
				["Casque/Helmet"] = {0,1,2,3,4,5,6,7,8},
                ["Arme/Weapon"] = {0},
                ["Arme2/Weapon2"] = {0},
                                
        },        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
	
})
--------------------------------------------------------------------------------
TEAM_MAFIA = DarkRP.createJob("Parrain", {
    color = Color(34, 85, 85, 255),
    model = {"models/vito.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","arccw_waw_p38"},
    command = "cmafia",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "mafia",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
		
})
--------------------------------------------------------------------------------
TEAM_MAFIA1 = DarkRP.createJob("Mafieux", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys"},
    command = "mafia",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "mafia",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
		
})
--------------------------------------------------------------------------------
TEAM_MAFIA2 = DarkRP.createJob("Mafieux Architecte", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","alydus_fortificationbuildertablet"},
    command = "mafiaarc",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "mafia",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
		
})
--------------------------------------------------------------------------------
TEAM_MAFIA3 = DarkRP.createJob("Mafieux Médecin", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl","models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl","models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl","models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","weapon_medkit"},
    command = "mafiamed",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "mafia",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
		
})
--------------------------------------------------------------------------------
TEAM_GANG = DarkRP.createJob("Chef Gangster", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/gtav/families/stpunk2pm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","arccw_bo2_browninghp"},
    command = "cgang",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "gang",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
			
})
--------------------------------------------------------------------------------
TEAM_GANG1 = DarkRP.createJob("Gangster", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl","models/sentry/gtav/ballas/balfpm.mdl","models/sentry/gtav/ballas/ballaseastpm.mdl","models/sentry/gtav/ballas/ballasorigpm.mdl","models/sentry/gtav/ballas/ballassoutpm.mdl","models/sentry/gtav/families/famfpm.mdl","models/sentry/gtav/families/famcapm.mdl","models/sentry/gtav/families/famfopm.mdl","models/sentry/gtav/families/famdnpm.mdl","models/sentry/gtav/lost/lostgirlbpm.mdl","models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys"},
    command = "gang",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "gang",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
			
})
--------------------------------------------------------------------------------
TEAM_GANG2 = DarkRP.createJob("Gangster Architecte", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl","models/sentry/gtav/ballas/balfpm.mdl","models/sentry/gtav/ballas/ballaseastpm.mdl","models/sentry/gtav/ballas/ballasorigpm.mdl","models/sentry/gtav/ballas/ballassoutpm.mdl","models/sentry/gtav/families/famfpm.mdl","models/sentry/gtav/families/famcapm.mdl","models/sentry/gtav/families/famfopm.mdl","models/sentry/gtav/families/famdnpm.mdl","models/sentry/gtav/lost/lostgirlbpm.mdl","models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","alydus_fortificationbuildertablet"},
    command = "agang",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "gang",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
			
})
--------------------------------------------------------------------------------
TEAM_GANG3 = DarkRP.createJob("Gangster Médecin", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl","models/sentry/gtav/ballas/balfpm.mdl","models/sentry/gtav/ballas/ballaseastpm.mdl","models/sentry/gtav/ballas/ballasorigpm.mdl","models/sentry/gtav/ballas/ballassoutpm.mdl","models/sentry/gtav/families/famfpm.mdl","models/sentry/gtav/families/famcapm.mdl","models/sentry/gtav/families/famfopm.mdl","models/sentry/gtav/families/famdnpm.mdl","models/sentry/gtav/lost/lostgirlbpm.mdl","models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[]],
    weapons = {"weapon_fists","pocket", "keys","weapon_medkit"},
    command = "mgang",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "gang",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
			
})

TEAM_STAFF = DarkRP.createJob("STAFF", {
    color = Color(14, 81, 11, 255),
    model = {"models/bratplat/cuadrado/cuadrado_colorized.mdl"},
    description = [[STAFF]],
    weapons = {"weapon_physgun","gmod_tool","weapon_fists","climb_swep2","weaponchecker","keys"},
    command = "staff",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "staff",
    customCheck = function(ply) return
        table.HasValue({"superadmin","moderateur","moderateur_VIP+","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Job staff",
})

----------VIP---------------------------------------
TEAM_VIP = DarkRP.createJob("YAMAKASI", {
    color = Color(34, 85, 85, 255),
    model = {"models/player/Group03/male_01.mdl","models/player/Group03/male_02.mdl","models/player/Group03/male_04.mdl","models/player/Group03/male_09.mdl","models/player/Group03/female_06.mdl","models/player/Group03/female_02.mdl","models/player/Group03/female_05.mdl"},
    description = [[]],
    weapons = {"climb_swep2","pocket", "keys"},
    command = "yama",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "vip",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.2, GAMEMODE.Config.runspeed * 1.2)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
			
})
-------------------------------------------------
TEAM_VIP1 = DarkRP.createJob("Chauffeur de taxi", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[]],
    weapons = {"pocket", "keys"},
    command = "cdt",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "vip",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
			
})
-------------------------------------------------
TEAM_VIP2 = DarkRP.createJob("Vendeur hot dog", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[]],
    weapons = {"pocket", "keys"},
    command = "vhd",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "vip",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
			
})
-------------------------------------------------
TEAM_VIP3 = DarkRP.createJob("Hacker", {
    color = Color(34, 85, 85, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[]],
    weapons = {"pocket", "keys"},
    command = "hac",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "vip",
	      
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"VIP","superadmin","VIP +", "moderateur_VIP","moderateur_VIP+","moderateur_test_VIP","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
			
})
--------------------------------------------------------------------------------
TEAM_VIP4 = DarkRP.createJob("Agent secret", {
    color = Color(34, 85, 85, 255),
    model = {"models/taggart/police01/male_01.mdl", 
	"models/taggart/police01/male_02.mdl", 
	"models/taggart/police01/male_04.mdl", 
	"models/taggart/police01/male_05.mdl", 
	"models/taggart/police01/male_06.mdl", 
	"models/taggart/police01/male_07.mdl", 
	"models/taggart/police01/male_08.mdl", 
	"models/taggart/police01/male_09.mdl"
	},
    description = [[]],
    weapons = {"disguise_swep","pocket", "keys"},
    command = "ags",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "vip+",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(20)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"superadmin","VIP +","moderateur_VIP+","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})
--------------------------------------------------------------------------------
TEAM_VIP5 = DarkRP.createJob("Vendeur d'amres ambulant", {
    color = Color(34, 85, 85, 255),
    model = {"models/player/leet.mdl"},
    description = [[]],
    weapons = {"arccw_bo2_browninghp","pocket", "keys"},
    command = "vda",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "vip+",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"superadmin","VIP +","moderateur_VIP+","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})
--------------------------------------------------------------------------------
TEAM_VIP6 = DarkRP.createJob("Tueur à gage", {
    color = Color(34, 85, 85, 255),
    model = {"models/player/gman_high.mdl"},
    description = [[]],
    weapons = {"weapon_doiwelrod","pocket", "keys"},
    command = "tag",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
	candemote = false,
    category = "vip+",
	        
	PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
	GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
	customCheck = function(ply) return CLIENT or
        table.HasValue({"superadmin","VIP +","moderateur_VIP+","moderateur_test_VIP+","admin"}, ply:GetNWString("usergroup"))
    end,
    CustomCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})


--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
