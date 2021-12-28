util.AddNetworkString("bankReception");

sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")

hook.Add("PlayerInitialSpawn", "GBRP::Client Init", function(ply)
    local data = sql.QueryRow("select * from gbrp where steamid64 = " .. ply:SteamID64() .. ";")
    if not data then sql.Query("insert into gbrp values(" .. ply:SteamID64() .. ", 0);"); ply:SetNWInt("GBRP::balance", 0)
    else ply:SetNWInt("GBRP::balance",tonumber(data.balance)) end
end)

concommand.Add("gbrp_addmoney", function( ply, cmd, args )
    if ply:IsAdmin() then
        local target = DarkRP.findPlayer(args[1])
        if IsValid(target) then
            target:SetNWInt("GBRP::balance",target:GetNWInt("GBRP::balance") + args[2])
            sql.Query("update gbrp set balance = " .. target:GetNWInt("GBRP::balance") .. " where steamid64 = " .. target:SteamID64() .. ";")
        end
    else
        ply:ChatPrint("Tu n'es pas admin baka")
    end
end)