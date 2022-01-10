util.AddNetworkString("GBRP::bankreception")
util.AddNetworkString("GBRP::bankwithdraw")
util.AddNetworkString("GBRP::bankdeposit")
util.AddNetworkString("GBRP::shopreception")
util.AddNetworkString("GBRP::buyshop")
util.AddNetworkString("GBRP::sellshop")
util.AddNetworkString("GBRP::shopwithdraw")
util.AddNetworkString("GBRP::shopdeposit")
sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")

SetGlobalInt("yakuzasBalance",0);
SetGlobalInt("mafiaBalance",0);
SetGlobalInt("gangBalance",0);

local plyMeta = FindMetaTable("Player")

function plyMeta:addLaunderedMoney(amount)
    self:SetNWInt("GBRP::launderedmoney", self:GetNWInt("GBRP::launderedmoney") + amount)
end

hook.Add("PlayerInitialSpawn", "GBRP::Client Init", function(ply)
    local data = sql.QueryRow("select * from gbrp where steamid64 = " .. ply:SteamID64() .. ";")

    if not data then
        sql.Query("insert into gbrp values(" .. ply:SteamID64() .. ", 0);")
        ply:SetNWInt("GBRP::balance", 0)
    else
        ply:SetNWInt("GBRP::balance", tonumber(data.balance))
    end
end)

concommand.Add("gbrp_addmoney", function(ply, cmd, args)
    if ply:IsAdmin() then
        local target = DarkRP.findPlayer(args[1])

        if IsValid(target) then
            target:SetNWInt("GBRP::balance", target:GetNWInt("GBRP::balance") + args[2])
            sql.Query("update gbrp set balance = " .. target:GetNWInt("GBRP::balance") .. " where steamid64 = " .. target:SteamID64() .. ";")
        end
    else
        ply:ChatPrint("Tu n'es pas admin baka")
    end
end)

concommand.Add("gbrp_addlaunderedmoney", function(ply, cmd, args)
    if ply:IsAdmin() then
        local target = DarkRP.findPlayer(args[1])

        if IsValid(target) then
            target:addLaunderedMoney(args[2])
        end
    else
        ply:ChatPrint("Tu n'es pas admin baka")
    end
end)

net.Receive("GBRP::bankwithdraw", function(len, ply)
    local amount = net.ReadUInt(32)
    ply:SetNWInt("GBRP::balance", ply:GetNWInt("GBRP::balance") - amount)
    sql.Query("update gbrp set balance = " .. ply:GetNWInt("GBRP::balance") .. " where steamid64 = " .. ply:SteamID64() .. ";")
    ply:addMoney(amount)
end)

-- the ply is the chief of the gang here
net.Receive("GBRP::bankdeposit", function(len, ply)
    gang = ply:GetGang()

    for _, v in pairs(ply.launderedMoney) do
        SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") + tonumber(v.amount / 2))
        v.gangster:SetNWInt("GBRP::balance", v.gangster:GetNWInt("GBRP::balance") + tonumber(v.amount * 25 / 100))
        sql.Query("update gbrp set balance = " .. v.gangster:GetNWInt("GBRP::balance") .. " where steamid64 = " .. v.gangster:SteamID64() .. ";")
        ply:SetNWInt("GBRP::balance", ply:GetNWInt("GBRP::balance") + tonumber(v.amount * 10 / 100))
        sql.Query("update gbrp set balance = " .. ply:GetNWInt("GBRP::balance") .. " where steamid64 = " .. ply:SteamID64() .. ";")
        local members = {}
        for _,pl in pairs(player.GetAll()) do
            if pl:GetGang() == gang then
                table.insert(members,pl)
            end
        end
        v.amount = v.amount * 15 / 100
        for _,member in pairs(members) do
            member:SetNWInt("GBRP::balance", member:GetNWInt("GBRP::balance") + tonumber(v.amount / #members))
            sql.Query("update gbrp set balance = " .. member:GetNWInt("GBRP::balance") .. " where steamid64 = " .. member:SteamID64() .. ";")
        end
    end

    ply:SetNWInt("GBRP::launderedmoney", 0)
    ply.launderedMoney = {}
end)

net.Receive("GBRP::shopwithdraw", function(len, ply)
    shop = net.ReadEntity()

    if not ply.launderedMoney then
        ply.launderedMoney = shop.launderedMoney
    else
        table.Add(ply.launderedMoney, shop.launderedMoney)
    end
    shop.launderedMoney = {}
    ply:addLaunderedMoney(shop:GetLaunderedMoney())
    shop:SetLaunderedMoney(0)
end)

net.Receive("GBRP::shopdeposit", function(len, ply)
    amount = net.ReadUInt(32)
    shop = net.ReadEntity()
    table.insert(shop.money, {gangster = ply,wallet = amount})
    ply:addMoney(-amount)
end)

net.Receive("GBRP::sellshop", function(len, ply)
    shop = net.ReadEntity()
    gang = shop:Getowner()
    shop:Setowner("nil")
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") + shop.value)
end)

net.Receive("GBRP::buyshop", function(len, ply)
    shop = net.ReadEntity()
    gang = ply:GetGang()
    shop:Setowner(gang)
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") - shop.price)
end)