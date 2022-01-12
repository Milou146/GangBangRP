--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]
DarkRP.createShipment("TOKAREV", {
    model = "models/weapons/arccw/c_waw_tt33.mdl",
    entity = "arccw_waw_tt33",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "PISTOLETS",
})
DarkRP.createShipment("MAKAROV PM", {
    model = "models/weapons/arccw/c_bo1_makarov.mdl",
    entity = "arccw_bo1_makarov",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "PISTOLETS",
})
DarkRP.createShipment("PISTOLET NAMBU", {
    model = "models/weapons/arccw/c_waw_p38.mdl",
    entity = "arccw_waw_nambu",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "PISTOLETS",
})
DarkRP.createShipment("OTS-02 KISPARIS", {
    model = "models/weapons/arccw/c_bo1_kiparis.mdl",
    entity = "arccw_bo1_kiparis",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "SMG",
})
DarkRP.createShipment("KS-23", {
    model = "models/weapons/arccw/c_bo1_ks23.mdl",
    entity = "arccw_bo1_ks23",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "POMPES",
})
DarkRP.createShipment("DEGTIAREV DP 28", {
    model = "models/weapons/arccw/c_waw_dp28.mdl",
    entity = "arccw_waw_dp28",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "FUSILS",
})
DarkRP.createShipment("STURMGEWEHR 44", {
    model = "models/weapons/arccw/w_waw_stg44.mdl",
    entity = "arccw_bo3_stg44",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "PISTOLETS",
})
DarkRP.createShipment("AKS 74U", {
    model = "models/weapons/arccw/c_bo1_ak74u.mdl",
    entity = "arccw_bo1_ak74u",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "FUSILS",
})
DarkRP.createShipment("KARABINER 98", {
    model = "models/weapons/arccw/w_waw_k98k.mdl",
    entity = "arccw_waw_k98k",
    price = 100,
    amount = 1,
    separate = false,
    pricesep = 100,
    noship = false,
    allowed = {TEAM_VIP5, TEAM_GUN},
    category = "SNIPERS",
})