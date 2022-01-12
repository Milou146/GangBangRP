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

concommand.Add("setplayerbalance", function(ply, cmd, args)
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

concommand.Add("setgangbalance" ,function(ply,cmd,args)
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

gbrp.npcs = {
    [1] = {
        class = "gbrp_bank_receptionist",
        gender = "female",
        model = "models/mossman.mdl",
        pos = Vector(-954.399658,2831.927979,-38.031754),
        ang = Angle(3.926940,-89.345398,0.000000)
    };
    [2] = {
        class = "gbrp_bank_receptionist",
        gender = "female",
        model = "models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl",
        pos = Vector(-1063.368408,2830.685547,-38.031754),
        ang = Angle(3.926940,-89.730392,0.000000)
    };
    [3] = {
        class = "gbrp_bank_receptionist",
        gender = "female",
        model = "models/mossman.mdl",
        pos = Vector(-1159.221558,2812.594482,-38.031754),
        ang = Angle(1.616941,-90.346390,0.000000)
    };
    [4] = {
        class = "gbrp_shop",
        gender = "female",
        model = "models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl",
        pos = Vector(-576.345520,253.843369,-30.031754),
        ang = Angle(2.771948,-0.539320,0.000000)
    };
    [5] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/odessa.mdl",
        pos = Vector(1298.557983,-1579.187866,-29.987122),
        ang = Angle(12.045322,90.987114,0.000000)
    };
    [6] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/monk.mdl",
        pos = Vector(-1099.968750,10497.299805,202.012878),
        ang = Angle(0.971108,-179.686249,0.000000)
    };
    [7] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/Kleiner.mdl",
        pos = Vector(-6566.270508,3409.478027,42.012878),
        ang = Angle(6.782911,-90.832703,0.000000)
    };
    [8] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/breen.mdl",
        pos = Vector(-7678.176758,5545.522461,66.012878),
        ang = Angle(13.747030,89.205963,0.000000)
    };
    [9] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/p2_chell.mdl",
        pos = Vector(-7678.176758,5545.522461,66.012878),
        ang = Angle(12.699938,-5.253576,0.000000)
    };
    [10] = {
        class = "gbrp_shop",
        gender = "female",
        model = "models/alyx.mdl",
        pos = Vector(4955.289063,8042.855957,210.012878),
        ang = Angle(1.311556,0.218067,0.000000)
    };
    [11] = {
        class = "gbrp_shop",
        gender = "male",
        model = "models/eli.mdl",
        pos = Vector(-5872.972168,1543.199097,50.012878),
        ang = Angle(1.861327,-92.799614,0.000000)
    };
    [12] = {
        class = "gbrp_shop",
        gender = "female",
        model = "models/Group01/female_03.mdl",
        pos = Vector(3966.805908,6776.076660,81.896027),
        ang = Angle(1.647831,-89.800575,0.000000)
    }
}

hook.Add( "PlayerInitialSpawn", "FullLoadSetup", function()
    for k,v in pairs(gbrp.npcs) do
        local npc = ents.Create(v.class);
        npc.gender = v.gender
        npc.model = v.model
        npc:Spawn()
        npc:SetPos(v.pos)
        npc:SetAngles(v.ang)
        npc:Initialize()
    end
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