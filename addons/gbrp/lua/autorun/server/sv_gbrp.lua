util.AddNetworkString("GBRP::bankreception");
util.AddNetworkString("GBRP::bankwithdraw");
util.AddNetworkString("GBRP::bankdeposit");
util.AddNetworkString("GBRP::shopreception");
util.AddNetworkString("GBRP::buyshop");
util.AddNetworkString("GBRP::sellshop");
util.AddNetworkString("GBRP::shopwithdraw");

sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);");

gbrp.mafia = ents.Create("gbrp_gang");
gbrp.yakuzas = ents.Create("gbrp_gang");
gbrp.gang = ents.Create("gbrp_gang");

local plyMeta = FindMetaTable("Player")
function plyMeta:IsGangChief()
    return gbrp.jobs[team.GetName(self:Team())].gangChief
end
function plyMeta:GetGang()
    return gbrp.jobs[team.GetName(self:Team())].gang
end
function plyMeta:addLaunderedMoney(amount)
    self:SetNWInt("GBRP::launderedmoney",self:GetNWInt("GBRP::launderedmoney") + amount)
end

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

concommand.Add("gbrp_addlaunderedmoney", function( ply, cmd, args )
    if ply:IsAdmin() then
        local target = DarkRP.findPlayer(args[1])
        if IsValid(target) then
            target:addLaunderedMoney(args[2])
        end
    else
        ply:ChatPrint("Tu n'es pas admin baka")
    end
end)

net.Receive("GBRP::bankwithdraw", function(len,ply)
    local amount = net.ReadUInt(32)
    ply:SetNWInt("GBRP::balance",ply:GetNWInt("GBRP::balance") - amount)
    sql.Query("update gbrp set balance = " .. ply:GetNWInt("GBRP::balance") .. " where steamid64 = " .. ply:SteamID64() .. ";")
    ply:addMoney(amount)
end)

net.Receive("GBRP::bankdeposit", function(len,ply)
    ply:SetNWInt("GBRP::balance",ply:GetNWInt("GBRP::balance") + net.ReadUInt(32))
    sql.Query("update gbrp set balance = " .. ply:GetNWInt("GBRP::balance") .. " where steamid64 = " .. ply:SteamID64() .. ";")
    ply:SetNWInt("GBRP::launderedmoney", 0)
end)

net.Receive("GBRP::shopwithdraw", function(len,ply)
    shop = net.ReadEntity()
    ply:addLaunderedMoney(shop:GetLaunderedMoney())
    shop:SetLaunderedMoney(0)
end)

net.Receive("GBRP::sellshop", function(len,ply)
    shop = net.ReadEntity()
    gang = shop:GetOwner()
    shop:SetOwner(nil)
    gang:AddMoney(ent.value)
end)