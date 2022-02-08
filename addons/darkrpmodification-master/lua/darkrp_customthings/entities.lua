--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("Donut", {
    ent = "donut",
    model = "models/noesis/donut.mdl",
    price = 5,
    max = 0,
    cmd = "buydonut",
    allowed = {TEAM_VIP2}
})
DarkRP.createEntity("HotDog", {
    ent = "hotdog",
    model = "models/food/hotdog.mdl",
    price = 10,
    max = 0,
    cmd = "buyhotdog",
    allowed = {TEAM_VIP2}
})
DarkRP.createEntity("Red Bul", {
    ent = "eft_food_hotrod",
    model = "models/crunchy/props/eft_props/hotrod.mdl",
    price = 15,
    max = 0,
    cmd = "buyredbul",
    allowed = {TEAM_VIP2}
})
DarkRP.createEntity("Burger", {
    ent = "burger",
    model = "models/food/burger.mdl",
    price = 30,
    max = 0,
    cmd = "buyburger",
    allowed = {TEAM_VIP2}
})
-------
DarkRP.createEntity("Ordinateur", {
    ent = "dronesrewrite_console",
    model = "models/dronesrewrite/console/console.mdl",
    price = 0,
    max = 1,
    cmd = "buypc",
    allowed = {TEAM_VIP3}
})
DarkRP.createEntity("Drone", {
    ent = "dronesrewrite_dronebox",
    model = "models/dronesrewrite/dronebox/dronebox.mdl",
    price = 0,
    max = 1,
    cmd = "buydrone",
    allowed = {TEAM_VIP3}
})
----
---------------METH--------------------------------------
DarkRP.createEntity("Gas", {
    ent = "eml_gas",
    model = "models/props_c17/canister01a.mdl",
    price = 1,
    max = 2,
    cmd = "buygas",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Four", {
    ent = "eml_stove",
    model = "models/props_c17/furnitureStove001a.mdl",
    price = 1,
    max = 1,
    cmd = "buyfour",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Pot phosphore", {
    ent = "eml_pot",
    model = "models/props_c17/metalPot001a.mdl",
    price = 1,
    max = 2,
    cmd = "buyred",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Pot meth", {
    ent = "eml_spot",
    model = "models/props_c17/metalPot001a.mdl",
    price = 1,
    max = 2,
    cmd = "buymeth",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Ionid Jar", {
    ent = "eml_jar",
    model = "models/props_junk/plasticbucket001a.mdl",
    price = 1,
    max = 1,
    cmd = "buyion",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Muriatic Acid", {
    ent = "eml_macid",
    model = "models/props_junk/garbage_plasticbottle001a.mdl",
    price = 1,
    max = 10,
    cmd = "buymuria",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Sulfur", {
    ent = "eml_sulfur",
    model = "models/props_junk/garbage_glassbottle001a.mdl",
    price = 1,
    max = 10,
    cmd = "buysulf",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Water", {
    ent = "eml_water",
    model = "models/props_junk/garbage_plasticbottle003a.mdl",
    price = 1,
    max = 10,
    cmd = "buywat",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})

DarkRP.createEntity("Salt", {
    ent = "eml_salt",
    model = "models/props_junk/garbage_milkcarton002a.mdl",
    price = 1,
    max = 8,
    cmd = "buysal",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Liquid Iodine", {
    ent = "eml_iodine",
    model = "models/props_lab/jar01b.mdl",
    price = 1,
    max = 10,
    cmd = "buyliq",
	category = "METHAMPHETAMINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
