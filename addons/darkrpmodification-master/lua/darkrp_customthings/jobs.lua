-------------------------------------------------------------------------------
TEAM_CITIZEN = DarkRP.createJob("Citoyen", {
    color = Color(0, 0, 0, 255),
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
    category = "CITOYEN",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end
})

--------------------------------------------------------------------------------
TEAM_NYPD = DarkRP.createJob("N.Y.P.D", {
    color = Color(0, 0, 230, 255),
    model = {
        "models/taggart/police01/male_01.mdl",
        "models/taggart/police01/male_02.mdl",
        "models/taggart/police01/male_03.mdl",
        "models/taggart/police01/male_04.mdl",
        "models/taggart/police01/male_05.mdl",
        "models/taggart/police01/male_06.mdl",
        "models/taggart/police01/male_07.mdl",
        "models/taggart/police01/male_08.mdl",
        "models/taggart/police01/male_09.mdl"},
    description = [[Agent de police, gardez vos concitoyens en sécurité et empéchez les bandits de transformer la ville en champ de bataille.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weaponchecker","weapon_frost_lidargun"},
    command = "nypd",
    max = 8,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "POLICE",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
})

--------------------------------------------------------------------------------
TEAM_NYPD1 = DarkRP.createJob("Commissaire", {
    color = Color(0, 0, 230, 255),
    model = {
        "models/sentry/gtav/lspd/fcopbpm.mdl",
        "models/sentry/gtav/lspd/fcopwpm.mdl",
        "models/sentry/gtav/lspd/vtrafcoppm.mdl"},
    description = [[Commissaire de la police, dirigez vos agents de façon efficace et protégez la ville.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weaponchecker","weapon_frost_lidargun","door_ram"},
    command = "cnypd",
    max = 1,
    salary = 10,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = false,
    category = "POLICE",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(75)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end
})

--------------------------------------------------------------------------------
TEAM_NYPD2 = DarkRP.createJob("S.W.A.T", {
    color = Color(0, 0, 230, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", "models/akitos_model_pack/modern_swat.mdl", "models/akitos_model_pack/old_swat.mdl", "models/akitos_model_pack/swat_hazmat.mdl"},
    description = [[Agent du S.W.A.T, intervenez lors de conflits et participez aux interventions à risques.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weaponchecker"},
    command = "swat",
    max = 4,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "POLICE",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end
})

--------------------------------------------------------------------------------
TEAM_NYPD3 = DarkRP.createJob("S.W.A.T Médic", {
    color = Color(212, 212, 17, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", "models/akitos_model_pack/modern_swat.mdl", "models/akitos_model_pack/old_swat.mdl", "models/akitos_model_pack/swat_hazmat.mdl"},
    description = [[Médecin du S.W.A.T, gardez vos coéquipiers en vie et intervenez sur les missions à risques.]],
    weapons = {"weapon_tg_fists", "weapon_medkit", "pocket", "keys", "weaponchecker"},
    command = "swatmed",
    max = 1,
    salary = 12,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "POLICE",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})

--------------------------------------------------------------------------------
TEAM_NYPD4 = DarkRP.createJob("S.W.A.T Sniper", {
    color = Color(212, 164, 17, 255),
    model = {"models/akitos_model_pack/alt_swat.mdl", "models/akitos_model_pack/modern_swat.mdl", "models/akitos_model_pack/old_swat.mdl", "models/akitos_model_pack/swat_hazmat.mdl"},
    description = [[Tireur de précision du S.W.A.T, occupez-vous de la prise d'information et éliminez les cibles importantes.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weaponchecker"},
    command = "swatsnip",
    max = 2,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "POLICE",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(100)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"superadmin", "VIP +", "moderateur_VIP+", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})

--------------------------------------------------------------------------------
TEAM_YAKUZA = DarkRP.createJob("Chef des Yakuzas", {
    color = Color(204, 51, 153, 255),
    model = {"models/players/Kimonos_25.mdl"},
    description = [[Chef des Yakuzas, dirigez vos sous-fifres d'une main de fer et faites prospérer votre gang.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weapon_mse_katana"},
    command = "yakuleader",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "YAKUZA",
    PlayerDeath = function(ply)
        ply.LastTimeAsYakuzaLeader = CurTime()
        ply:changeTeam(TEAM_CITIZEN, true)
        DarkRP.notifyAll(1, 4, "Le chef Yakuza est décédé.")
    end,
    customCheck = function(ply)
        if ply.LastTimeAsYakuzaLeader then
            return CurTime() - ply.LastTimeAsYakuzaLeader > 900
        else
            return true
        end
    end,
    customCheckFailMsg = "Il vous faut attendre 15 minutes après avoir quitté ce job.",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.yakuzas,
    gangLeader = true
})

--------------------------------------------------------------------------------
TEAM_YAKUZA1 = DarkRP.createJob("Yakuza", {
    color = Color(204, 51, 153, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[Membre du gang des Yakuzas, écoutez votre chef et combattez pour son honnneur ainsiq que le votre.]],
    weapons = {"weapon_tg_fists", "pocket", "keys"},
    command = "yaku",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "YAKUZA",
    skins = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
    bodygroups = {
        ["Casque/Helmet"] = {0, 1, 2, 3, 4, 5, 6, 7, 8},
        ["Arme/Weapon"] = {0},
        ["Arme2/Weapon2"] = {0},
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.yakuzas
})

--------------------------------------------------------------------------------
TEAM_YAKUZA2 = DarkRP.createJob("Yakuza Architecte", {
    color = Color(204, 51, 153, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[Membre du gang des Yakuzas, fortifiez les positions de votre gang, et gardez tout le monde en vie grace à vos compétences architecturales.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "alydPOLICE_fortificationbuildertablet"},
    command = "yakuarchi",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "YAKUZA",
    skins = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
    bodygroups = {
        ["Casque/Helmet"] = {0, 1, 2, 3, 4, 5, 6, 7, 8},
        ["Arme/Weapon"] = {0},
        ["Arme2/Weapon2"] = {0},
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.yakuzas
})

--------------------------------------------------------------------------------
TEAM_YAKUZA3 = DarkRP.createJob("Yakuza Médecin", {
    color = Color(212, 212, 17, 255),
    model = {"models/players/Kimonos.mdl", "models/players/Kimonos_02.mdl", "models/players/Kimonos_03.mdl", "models/players/Kimonos_04.mdl", "models/players/Kimonos_05.mdl", "models/players/Kimonos_06.mdl", "models/players/Kimonos_07.mdl", "models/players/Kimonos_10.mdl", "models/players/Kimonos_14.mdl", "models/players/Kimonos_15.mdl", "models/players/Kimonos_17.mdl", "models/players/Kimonos_18.mdl", "models/players/Kimonos_19.mdl", "models/players/Kimonos_21.mdl", "models/players/Kimonos_26.mdl"},
    description = [[Membre du gang des Yakuzas, soignez vos collègues et faites en sorte que vous vous en sortiez tous vivants.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weapon_medkit"},
    command = "yakumedic",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "YAKUZA",
    skins = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
    bodygroups = {
        ["Casque/Helmet"] = {0, 1, 2, 3, 4, 5, 6, 7, 8},
        ["Arme/Weapon"] = {0},
        ["Arme2/Weapon2"] = {0},
    },
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
    gang = gbrp.gangs.yakuzas
})

--------------------------------------------------------------------------------
TEAM_MAFIA = DarkRP.createJob("Parrain", {
    color = Color(191, 128, 64, 255),
    model = {"models/vito.mdl"},
    description = [[Chef de la mafia italienne, dirigez vos sous-fifres d'une main de fer et faites prospérer votre gang.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "arccw_waw_p38"},
    command = "mafialeader",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "MAFIA",
    PlayerDeath = function(ply)
        ply.LastTimeAsMafiaLeader = CurTime()
        ply:changeTeam(TEAM_CITIZEN, true)
        DarkRP.notifyAll(1, 4, "Le parrain est décédé.")
    end,
    customCheck = function(ply)
        if ply.LastTimeAsMafiaLeader then
            return CurTime() - ply.LastTimeAsMafiaLeader > 900
        else
            return true
        end
    end,
    customCheckFailMsg = "Il vous faut attendre 15 minutes après avoir quitté ce job.",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.mafia,
    gangLeader = true
})

--------------------------------------------------------------------------------
TEAM_MAFIA1 = DarkRP.createJob("Mafieux", {
    color = Color(191, 128, 64, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale2pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale4pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale6pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale7pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale8pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale9pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[Membre de la mafia italienne, écoutez votre chef et faites-vous respecter par la population.]],
    weapons = {"weapon_tg_fists", "pocket", "keys"},
    command = "mafia",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "MAFIA",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.mafia
})

--------------------------------------------------------------------------------
TEAM_MAFIA2 = DarkRP.createJob("Mafieux Architecte", {
    color = Color(191, 128, 64, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale2pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale4pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale6pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale7pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale8pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale9pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[Membre de la mafia italienne, fortifiez les positions de votre gang et gardez tout le monde en vie grace à vos compétences architecturales.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "alydPOLICE_fortificationbuildertablet"},
    command = "mafiaarchi",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "MAFIA",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.mafia
})

--------------------------------------------------------------------------------
TEAM_MAFIA3 = DarkRP.createJob("Mafieux Médecin", {
    color = Color(212, 212, 17, 255),
    model = {"models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl", "models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale2pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale4pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale6pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale7pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale8pm.mdl", "models/sentry/sentryoldmob/MAFIA/sentrymobmale9pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl", "models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"},
    description = [[Membre de la mafia italienne, soignez vos collègues et faites en sorte que vous vous en sortiez tous vivants.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weapon_medkit"},
    command = "mafiamedic",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "MAFIA",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
    gang = gbrp.gangs.mafia
})

--------------------------------------------------------------------------------
TEAM_GANGSTER = DarkRP.createJob("Chef Gangster", {
    color = Color(4, 149, 40, 255),
    model = {"models/sentry/gtav/families/stpunk2pm.mdl"},
    description = [[Chef des gangs américains, dirigez vos sous-fifres d'une main de fer et faites prospérer votre gang.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "arccw_bo2_browninghp"},
    command = "gangleader",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "GANGSTER",
    PlayerDeath = function(ply)
        ply.LastTimeAsGangsterLeader = CurTime()
        ply:changeTeam(TEAM_CITIZEN, true)
        DarkRP.notifyAll(1, 4, "Le chef gangster est décédé.")
    end,
    customCheck = function(ply)
        if ply.LastTimeAsGangsterLeader then
            return CurTime() - ply.LastTimeAsGangsterLeader > 900
        else
            return true
        end
    end,
    customCheckFailMsg = "Il vous faut attendre 15 minutes après avoir quitté ce job.",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(10)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.gang
})

--------------------------------------------------------------------------------
TEAM_GANGSTER1 = DarkRP.createJob("Gangster", {
    color = Color(4, 149, 40, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl", "models/sentry/gtav/ballas/balfpm.mdl", "models/sentry/gtav/ballas/ballaseastpm.mdl", "models/sentry/gtav/ballas/ballasorigpm.mdl", "models/sentry/gtav/ballas/ballassoutpm.mdl", "models/sentry/gtav/families/famfpm.mdl", "models/sentry/gtav/families/famcapm.mdl", "models/sentry/gtav/families/famfopm.mdl", "models/sentry/gtav/families/famdnpm.mdl", "models/sentry/gtav/lost/lostgirlbpm.mdl", "models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[Membre des gangs américains, écoutez votre chef et devenez riche.]],
    weapons = {"weapon_tg_fists", "pocket", "keys"},
    command = "gang",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "GANGSTER",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.gang
})

--------------------------------------------------------------------------------
TEAM_GANGSTER2 = DarkRP.createJob("Gangster Architecte", {
    color = Color(4, 149, 40, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl", "models/sentry/gtav/ballas/balfpm.mdl", "models/sentry/gtav/ballas/ballaseastpm.mdl", "models/sentry/gtav/ballas/ballasorigpm.mdl", "models/sentry/gtav/ballas/ballassoutpm.mdl", "models/sentry/gtav/families/famfpm.mdl", "models/sentry/gtav/families/famcapm.mdl", "models/sentry/gtav/families/famfopm.mdl", "models/sentry/gtav/families/famdnpm.mdl", "models/sentry/gtav/lost/lostgirlbpm.mdl", "models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[Membre des gangs américains, fortifiez les positions de votre gang, et gardez tout le monde en vie grace à vos compétences architecturales.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "alydPOLICE_fortificationbuildertablet"},
    command = "gangarchi",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "GANGSTER",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    gang = gbrp.gangs.gang
})

--------------------------------------------------------------------------------
TEAM_GANGSTER3 = DarkRP.createJob("Gangster Médecin", {
    color = Color(212, 212, 17, 255),
    model = {"models/sentry/gtav/ballas/ogbalpm.mdl", "models/sentry/gtav/ballas/balfpm.mdl", "models/sentry/gtav/ballas/ballaseastpm.mdl", "models/sentry/gtav/ballas/ballasorigpm.mdl", "models/sentry/gtav/ballas/ballassoutpm.mdl", "models/sentry/gtav/families/famfpm.mdl", "models/sentry/gtav/families/famcapm.mdl", "models/sentry/gtav/families/famfopm.mdl", "models/sentry/gtav/families/famdnpm.mdl", "models/sentry/gtav/lost/lostgirlbpm.mdl", "models/sentry/gtav/lost/lostgirlwpm.mdl"},
    description = [[Membre des gangs américains, soignez vos collègues et faites en sorte que vous vous en sortiez tous vivants.]],
    weapons = {"weapon_tg_fists", "pocket", "keys", "weapon_medkit"},
    command = "gangmedic",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "GANGSTER",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
    gang = gbrp.gangs.gang
})

TEAM_STAFF = DarkRP.createJob("STAFF", {
    color = Color(255, 0, 0, 255),
    model = {"models/bratplat/cuadrado/cuadrado.mdl"},
    description = [[STAFF]],
    weapons = {"weapon_physgun", "gmod_tool", "weapon_tg_fists", "climb_swep2", "weaponchecker", "keys"},
    command = "STAFF",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "STAFF",
    customCheck = function(ply)
        return table.HasValue({"superadmin", "moderateur", "moderateur_VIP+", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Job STAFF",
})

----------VIP---------------------------------------
TEAM_VIP = DarkRP.createJob("YAMAKASI", {
    color = Color(212, 212, 17, 255),
    model = {"models/player/Group03/male_01.mdl", "models/player/Group03/male_02.mdl", "models/player/Group03/male_04.mdl", "models/player/Group03/male_09.mdl", "models/player/Group03/female_06.mdl", "models/player/Group03/female_02.mdl", "models/player/Group03/female_05.mdl"},
    description = [[Vous êtes un grimpeur non affilié, aidez les gangs ou la police avec vos talents dans l'escalade urbaine.]],
    weapons = {"climb_swep2", "pocket", "keys"},
    command = "yama",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "VIP",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.2, GAMEMODE.Config.runspeed * 1.2)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})

-------------------------------------------------
TEAM_VIP1 = DarkRP.createJob("Chauffeur de taxi", {
    color = Color(212, 212, 17, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[Répondez aux appels de vos clients, allez les chercher et emmenez-les à destination.]],
    weapons = {"pocket", "keys"},
    command = "cdt",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "VIP",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})

-------------------------------------------------
TEAM_VIP2 = DarkRP.createJob("Vendeur hot dog", {
    color = Color(212, 212, 17, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[Choisissez votre stand et vendez les meilleurs hots dogs de la ville.]],
    weapons = {"pocket", "keys"},
    command = "vhd",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "VIP",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
        gbrp.RemoveHotdogSalesmans()
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})

-------------------------------------------------
TEAM_VIP3 = DarkRP.createJob("Hacker", {
    color = Color(212, 212, 17, 255),
    model = {"models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl", "models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"},
    description = [[Vous êtes un hacker non affilié, aidez les gangs ou la police avec vos talents en informatique et votre drone.]],
    weapons = {"pocket", "keys"},
    command = "hac",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "VIP",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"VIP", "superadmin", "VIP +", "moderateur_VIP", "moderateur_VIP+", "moderateur_test_VIP", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP seulement.This job is VIP only.",
})

--------------------------------------------------------------------------------
TEAM_VIP4 = DarkRP.createJob("Agent secret", {
    color = Color(212, 164, 17, 255),
    model = {"models/fbi_pack/fbi_01.mdl", "models/fbi_pack/fbi_02.mdl", "models/fbi_pack/fbi_03.mdl", "models/fbi_pack/fbi_04.mdl", "models/fbi_pack/fbi_05.mdl", "models/fbi_pack/fbi_06.mdl", "models/fbi_pack/fbi_07.mdl", "models/fbi_pack/fbi_08.mdl","models/fbi_pack/fbi_09.mdl"},
    description = [[Membre du FBI, infiltrez-vous dans les gangs et informez votre supérieur des mouvements des gangs importants.]],
    weapons = {"disguise_swep", "pocket", "keys"},
    command = "ags",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "VIP+",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(20)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.1, GAMEMODE.Config.runspeed * 1.1)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"superadmin", "VIP +", "moderateur_VIP+", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})

--------------------------------------------------------------------------------
TEAM_VIP5 = DarkRP.createJob("Vendeur d'armes ambulant", {
    color = Color(212, 164, 17, 255),
    model = {"models/player/leet.mdl"},
    description = [[Vendez vos armes discrètement aux clients intéressés]],
    weapons = {"arccw_bo2_browninghp", "pocket", "keys"},
    command = "vda",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "VIP+",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"superadmin", "VIP +", "moderateur_VIP+", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
})

--------------------------------------------------------------------------------
TEAM_VIP6 = DarkRP.createJob("Tueur à gage", {
    color = Color(212, 164, 17, 255),
    model = {"models/player/gman_high.mdl"},
    description = [[Réalisez les contrats donnés par vos clients en respectant leurs conditions.]],
    weapons = {"pocket", "keys"},
    command = "tag",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "VIP+",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.walkspeed * 1.0, GAMEMODE.Config.runspeed * 1.0)
    end,
    customCheck = function(ply)
        return CLIENT or table.HasValue({"superadmin", "VIP +", "moderateur_VIP+", "moderateur_test_VIP+", "admin"}, ply:GetNWString("usergroup"))
    end,
    customCheckFailMsg = "Ce métier est réservé aux membres VIP+ seulement.This job is VIP+ only.",
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