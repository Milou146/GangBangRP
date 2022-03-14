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
---------------COCAINE--------------------------------------
DarkRP.createEntity("Gazinière", {
    ent = "cocaine_stove",
    model = "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl",
    price = 1,
    max = 1,
    cmd = "buygazi",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Gaz", {
    ent = "cocaine_gas",
    model = "models/craphead_scripts/the_cocaine_factory/utility/gas_tank.mdl",
    price = 1,
    max = 2,
    cmd = "buygaz",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Plaque de cuisson", {
    ent = "cocaine_cooking_plate",
    model = "models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl",
    price = 1,
    max = 4,
    cmd = "buypla",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Casserole", {
    ent = "cocaine_cooking_pot",
    model = "models/craphead_scripts/the_cocaine_factory/utility/pot.mdl",
    price = 1,
    max = 4,
    cmd = "buycas",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Bicarbonate", {
    ent = "cocaine_baking_soda",
    model = "models/craphead_scripts/the_cocaine_factory/utility/soda.mdl",
    price = 1,
    max = 5,
    cmd = "buybic",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Eau", {
    ent = "cocaine_water",
    model = "models/craphead_scripts/the_cocaine_factory/utility/water.mdl",
    price = 1,
    max = 5,
    cmd = "buyeau",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Extracteur", {
    ent = "cocaine_extractor",
    model = "models/craphead_scripts/the_cocaine_factory/extractor/extractor.mdl",
    price = 1,
    max = 1,
    cmd = "buyext",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Feuilles", {
    ent = "cocaine_leaves",
    model = "models/craphead_scripts/the_cocaine_factory/utility/leaves.mdl",
    price = 1,
    max = 5,
    cmd = "buyfeu",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Seau", {
    ent = "cocaine_bucket",
    model = "models/craphead_scripts/the_cocaine_factory/utility/bucket.mdl",
    price = 1,
    max = 1,
    cmd = "buysea",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Déshydrateur", {
    ent = "cocaine_drying_rack",
    model = "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl",
    price = 1,
    max = 1,
    cmd = "buydes",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Batterie", {
    ent = "cocaine_battery",
    model = "models/craphead_scripts/the_cocaine_factory/utility/battery.mdl",
    price = 1,
    max = 2,
    cmd = "buybat",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Boîte", {
    ent = "cocaine_box",
    model = "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl",
    price = 1,
    max = 1,
    cmd = "buyboi",
	category = "COCAINE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
---------------CIGARETTE--------------------------------------
DarkRP.createEntity("AUTO-CIG 2000", {
    ent = "cf_cigarette_machine",
    model = "models/cigarette_factory/cf_machine.mdl",
    price = 1,
    max = 2,
    cmd = "buyauto",
	category = "CIGARETTE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Tabac", {
    ent = "cf_tobacco_pack",
    model = "models/cigarette_factory/cf_tobacco_pack.mdl",
    price = 1,
    max = 5,
    cmd = "buytab",
	category = "CIGARETTE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Feuilles blanches", {
    ent = "cf_roll_paper",
    model = "models/cigarette_factory/cf_rollpaper.mdl",
    price = 1,
    max = 3,
    cmd = "buypap",
	category = "CIGARETTE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Carton", {
    ent = "cf_delievery_box",
    model = "models/props_junk/cardboard_box003a.mdl",
    price = 1,
    max = 2,
    cmd = "buycar",
	category = "CIGARETTE",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Amélioration du stockage [VIP]", {
    ent = "cf_storage_upgrade",
    model = "models/thrusters/jetpack.mdl",
    price = 1,
    max = 2,
    cmd = "buysto",
	category = "CIGARETTE",
	customCheck = function(ply) return CLIENT or table.HasValue({'superadmin', 'admin', 'moderateur_vip', 'moderateur_vip+', 'VIP+', 'VIP','moderateur_test_vip','moderateur_test_vip+'}, ply:GetNWString('usergroup')) end,
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Amélioration de la vitesse", {
    ent = "cf_engine_upgrade",
    model = "models/maxofs2d/thruster_propeller.mdl",
    price = 1,
    max = 2,
    cmd = "buyvit",
	category = "CIGARETTE",
	allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
---------------PRINTERS--------------------------------------
DarkRP.createEntity("Printer", {
    ent = "custom_printer_white",
    model = "models/custom/rprinter.mdl",
    price = 1,
    max = 1,
    cmd = "buy_cheap_printer",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Printer modifié", {
    ent = "custom_printer_pinky",
    model = "models/custom/rprinter.mdl",
    price = 1,
    max = 1,
    cmd = "buy_pinky_printer",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Printer amélioré", {
    ent = "custom_printer_green",
    model = "models/custom/rprinter.mdl",
    price = 1,
    max = 1,
    cmd = "buy_green_printer",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Printer GOLD [VIP]", {
    ent = "custom_printer_gold",
    model = "models/custom/rprinter.mdl",
    price = 1,
    max = 1,
    cmd = "buy_gold_printer",
	category = "PRINTERS",
	customCheck = function(ply) return CLIENT or table.HasValue({'superadmin', 'admin', 'moderateur_vip', 'moderateur_vip+', 'VIP+', 'VIP','moderateur_test_vip','moderateur_test_vip+'}, ply:GetNWString('usergroup')) end,
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Encre", {
    ent = "upgrade_color",
    model = "models/props_lab/jar01b.mdl",
    price = 1,
    max = 3,
    cmd = "buyprintercolors",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Papier", {
    ent = "upgrade_paper",
    model = "models/props/cs_office/paper_towels.mdl",
    price = 1,
    max = 3,
    cmd = "buyprinterpaper",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Ventilateur [VIP]", {
    ent = "upgrade_cooler",
    model = "models/custom/coolerx2.mdl",
    price = 1,
    max = 1,
    cmd = "buyprintercooler",
	category = "PRINTERS",
	customCheck = function(ply) return CLIENT or table.HasValue({'superadmin', 'admin', 'moderateur_vip', 'moderateur_vip+', 'VIP+', 'VIP','moderateur_test_vip','moderateur_test_vip+'}, ply:GetNWString('usergroup')) end,
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})
DarkRP.createEntity("Mini Ventilateur", {
    ent = "upgrade_cooler_mini",
    model = "models/custom/coolermini.mdl",
    price = 1,
    max = 1,
    cmd = "buyprintercooler2",
	category = "PRINTERS",
    allowed = {TEAM_YAKUZA,TEAM_YAKUZA1,TEAM_YAKUZA2,TEAM_YAKUZA3,TEAM_MAFIA,TEAM_MAFIA1,TEAM_MAFIA2,TEAM_MAFIA3,TEAM_GANGSTER,TEAM_GANGSTER1,TEAM_GANGSTER2,TEAM_GANGSTER3}
})