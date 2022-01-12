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