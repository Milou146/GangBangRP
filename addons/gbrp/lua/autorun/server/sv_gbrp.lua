if engine.ActiveGamemode() ~= "darkrp" then return end
sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")
include("gbrp/sv_commands.lua")
include("gbrp/sv_hooks.lua")
include("gbrp/sv_net.lua")