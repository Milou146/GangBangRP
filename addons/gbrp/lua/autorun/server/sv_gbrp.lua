if engine.ActiveGamemode() ~= "darkrp" then return end

util.AddNetworkString("GBRP::doorsinit") -- server to client
util.AddNetworkString("GBRP::buyproperty")
util.AddNetworkString("GBRP::sellproperty")
util.AddNetworkString("GBRP::bankreception") -- server to client
util.AddNetworkString("GBRP::bankdeposit")
util.AddNetworkString("GBRP::bankwithdraw")
util.AddNetworkString("GBRP::buyshop")
util.AddNetworkString("GBRP::sellshop")
util.AddNetworkString("GBRP::shopdeposit")
util.AddNetworkString("GBRP::shopwithdraw")
util.AddNetworkString("GBRP::buyfood")
util.AddNetworkString("GBRP::buywep")
util.AddNetworkString("GBRP::heal")
util.AddNetworkString("GBRP::jewelrystoreReception")
util.AddNetworkString("GBRP::gunshopReception")
util.AddNetworkString("GBRP::gasstationReception")
util.AddNetworkString("GBRP::clubReception")
util.AddNetworkString("GBRP::drugstoreReception")
util.AddNetworkString("GBRP::repairgarageReception")
util.AddNetworkString("GBRP::barReception")
util.AddNetworkString("GBRP::welcomeScreen")
util.AddNetworkString("GBRP::laundererReception")
util.AddNetworkString("GBRP::launderingRequest")
util.AddNetworkString("GBRP::personnalBankDeposit")

sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")

include("gbrp/sv_commands.lua")
include("gbrp/sv_hooks.lua")
include("gbrp/sv_net.lua")