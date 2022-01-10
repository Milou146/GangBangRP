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

concommand.Add("gbrp_setplayerbalance", function(ply, cmd, args)
    if ply:IsAdmin() then
        local target = DarkRP.findPlayer(args[1])

        if IsValid(target) then
            target:SetNWInt("GBRP::balance", args[2])
            sql.Query("update gbrp set balance = " .. target:GetNWInt("GBRP::balance") .. " where steamid64 = " .. target:SteamID64() .. ";")
        end
    else
        ply:ChatPrint("Tu n'es pas admin baka")
    end
end)

concommand.Add("gbrp_setgangbalance" ,function(ply,cmd,args)
    local gang = args[1]
    if ply:IsAdmin() and gang == "yakuzas" or gang == "mafia" or gang == "gang" then
            SetGlobalInt(gang .. "Balance", tonumber(args[2]))
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
    local gang = ply:GetGang()
    local gangPay = 0
    local members = {}
    for _,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            members[pl] = 0
        end
    end
    for _, v in pairs(ply.launderedMoney) do
        gangPay = gangPay + tonumber(v.amount / 2) -- La part du gang
        members[v.gangster] = members[v.gangster] + tonumber(v.amount * 25 / 100) -- La part de l'initiateur
        members[ply] = members[ply] + tonumber(v.amount * 10 / 100) -- La part du chef

        -- La part des membres
        for member,_ in pairs(members) do
            members[member] = members[member] + tonumber(v.amount * 15 / 100 * #members)
        end
    end
    for member,pay in pairs(members) do
        member:SetNWInt("GBRP::balance", member:GetNWInt("GBRP::balance") + pay)
        sql.Query("update gbrp set balance = " .. member:GetNWInt("GBRP::balance") .. " where steamid64 = " .. member:SteamID64() .. ";")
        member:ChatPrint(gbrp[gang].subject .. " vous rémunère " .. pay .. "$.")
    end
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") + gangPay)
    ply:ChatPrint(gbrp[gang].subject .. " gagne " .. gangPay .. "$.")

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