util.AddNetworkString("GBRP::doorsinit") -- server to client
util.AddNetworkString("GBRP::buydoor")
util.AddNetworkString("GBRP::selldoor")
util.AddNetworkString("GBRP::bankreception") -- server to client
util.AddNetworkString("GBRP::bankdeposit")
util.AddNetworkString("GBRP::bankwithdraw")
util.AddNetworkString("GBRP::buyshop")
util.AddNetworkString("GBRP::sellshop")
util.AddNetworkString("GBRP::shopdeposit")
util.AddNetworkString("GBRP::shopwithdraw")
util.AddNetworkString("GBRP::buyfood")

sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")

SetGlobalInt("yakuzasBalance",0);
SetGlobalInt("mafiaBalance",0);
SetGlobalInt("gangBalance",0);

-------------------
---- H O O K S ----
-------------------

hook.Add("PlayerInitialSpawn", "GBRP::Client Init", function(ply)
    local data = sql.QueryRow("select * from gbrp where steamid64 = " .. ply:SteamID64() .. ";")

    if not data then
        sql.Query("insert into gbrp values(" .. ply:SteamID64() .. ", 0);")
        ply:SetNWInt("GBRP::balance", 0)
    else
        ply:SetNWInt("GBRP::balance", tonumber(data.balance))
    end
end)
gbrp.npcs = {
    [1] = { -- banquière
        class = "gbrp_bank_receptionist",
        gender = "female",
        model = "models/mossman.mdl",
        pos = Vector(-954.399658,2831.927979,-38.031754),
        ang = Angle(0,-89.345398,0)
    };
    [2] = { -- banquier
        class = "gbrp_bank_receptionist",
        gender = "male",
        model = "models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl",
        pos = Vector(-1063.368408,2830.685547,-38.031754),
        ang = Angle(0,-89.730392,0)
    };
    [3] = { -- banquière
        class = "gbrp_bank_receptionist",
        gender = "female",
        model = "models/mossman.mdl",
        pos = Vector(-1159.221558,2812.594482,-38.031754),
        ang = Angle(0,-90.346390,0)
    };
    [4] = { -- bijoutier
        class = "gbrp_shop",
        gender = "female",
        model = "models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl",
        pos = Vector(-576.345520,253.843369,-30.031754),
        ang = Angle(0,0,0),
        name = "jewelry"
    };
    [5] = { -- Quincaillerie
        class = "gbrp_shop",
        gender = "male",
        model = "models/odessa.mdl",
        pos = Vector(1298.557983,-1579.187866,-29.987122),
        ang = Angle(0,90.987114,0)
    };
    [6] = { -- Armurerie
        class = "gbrp_shop",
        gender = "male",
        model = "models/monk.mdl",
        pos = Vector(-1099.968750,10497.299805,202.012878),
        ang = Angle(0,-179.686249,0)
    };
    [7] = { -- Pharmacie
        class = "gbrp_shop",
        gender = "male",
        model = "models/Kleiner.mdl",
        pos = Vector(-6566.270508,3409.478027,42.012878),
        ang = Angle(0,-90.832703,0)
    };
    [8] = { -- Boîte de nuit
        class = "gbrp_shop",
        gender = "male",
        model = "models/breen.mdl",
        pos = Vector(-7678.176758,5545.522461,66.012878),
        ang = Angle(0,89.205963,0),
        name = "nightclub"
    };
    [9] = { -- Garagiste
        class = "gbrp_shop",
        gender = "male",
        model = "models/p2_chell.mdl",
        pos = Vector(-2378.206543,6402.301758,90.012878),
        ang = Angle(0,-5.253576,0)
    };
    [10] = { -- Bar
        class = "gbrp_shop",
        gender = "female",
        model = "models/alyx.mdl",
        pos = Vector(4955.289063,8042.855957,210.012878),
        ang = Angle(0,0,0)
    };
    [11] = { -- Station service
        class = "gbrp_shop",
        gender = "male",
        model = "models/eli.mdl",
        pos = Vector(-5872.972168,1543.199097,50.012878),
        ang = Angle(0,-92.799614,0),
        name = "gasstation"
    };
    [12] = { -- Archiviste
        class = "gbrp_shop",
        gender = "female",
        model = "models/humans/Group01/female_03.mdl",
        pos = Vector(3966.805908,6776.076660,16.896027),
        ang = Angle(0,-90,0)
    };
    [12] = { -- ???
        class = "gbrp_shop",
        gender = "male",
        model = "models/player/hostage/hostage_01.mdl",
        pos = Vector(1505.933350,7163.607422,81.896027),
        ang = Angle(0,-90,0)
    }
}
hook.Add( "InitPostEntity", "GBRP::NPCSetup", function()
    for k,v in pairs(gbrp.npcs) do
        local npc = ents.Create(v.class);
        if v.name then
            npc.name = v.name
            util.AddNetworkString("GBRP::" .. npc.name .. "Reception")
        end
        npc.gender = v.gender
        npc.model = v.model
        npc:Spawn()
        npc:SetPos(v.pos)
        npc:SetAngles(v.ang)
        npc:DropToFloor()
    end
end)
hook.Add("PlayerDisconnected","GBRP::PlayerDisconnected",function(ply)
    if ply:IsGangLeader() then ply:GetGang():Reset() end
end)
hook.Add("PlayerSpawn","GBRP:PlayerSpawn",function(ply)
    if ply:IsGangLeader() then
        ply:GetGang():SetBalance(gbrp.startingFunds)
    end
end)
hook.Add("PlayerDeath","GBRP:PlayerDeath",function()
    if ply:IsGangLeader() then
        ply:GetGang():Reset()
    end
end)

---------------
---- N E T ----
---------------

net.Receive("GBRP::buydoor",function(len,ply)
    local gang = ply:GetGang()
    local doorgroup = net.ReadString()
    for _,door in pairs(gbrp.doorgroups[doorgroup].doors) do
        local ent = ents.GetMapCreatedEntity(door)
        ent:setDoorGroup(gang.name)
    end
    gang:Pay(gbrp.doorgroups[doorgroup].attributes.price)
    for k,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            pl:ChatPrint([[Votre gang a acheté ']] .. doorgroup .. [[']])
        end
    end
end)
net.Receive("GBRP::selldoor",function(len,ply)
    local gang = ply:GetGang()
    local doorgroup = net.ReadString()
    for _,door in pairs(gbrp.doorgroups[doorgroup].doors) do
        local ent2 = ents.GetMapCreatedEntity(door)
        ent2:setDoorGroup(nil)
        ent2:Fire("lock", "", 0)
    end
    gang:Cash(gbrp.doorgroups[doorgroup].attributes.value)
    for k,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            pl:ChatPrint([[Votre gang a vendu ']] .. doorgroup .. [[']])
        end
    end
end)
net.Receive("GBRP::bankdeposit", function(len, gangLeader)
    local gang = gangLeader:GetGang()
    local gangPay = 0
    local members = {}
    for _,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            members[pl] = 0
        end
    end
    for _, v in pairs(gangLeader.launderedMoney) do
        gangPay = gangPay + tonumber(v.amount / 2) -- La part du gang
        members[v.gangster] = members[v.gangster] + tonumber(v.amount * 25 / 100) -- La part de l'initiateur
        members[gangLeader] = members[gangLeader] + tonumber(v.amount * 10 / 100) -- La part du chef

        -- La part des membres
        for member,_ in pairs(members) do
            members[member] = members[member] + tonumber(v.amount * 15 / 100 * #members)
        end
    end
    for member,pay in pairs(members) do
        member:SetNWInt("GBRP::balance", member:GetNWInt("GBRP::balance") + pay)
        sql.Query("update gbrp set balance = " .. member:GetNWInt("GBRP::balance") .. " where steamid64 = " .. member:SteamID64() .. ";")
        member:ChatPrint(gang.subject .. " vous rémunère $" .. pay .. ".")
    end
    gang:Cash(gangPay)
    gangLeader:ChatPrint(gang.subject .. " gagne " .. gbrp.formatMoney(gangPay) .. ".")

    gangLeader:SetNWInt("GBRP::launderedmoney", 0)
    gangLeader.launderedMoney = {}
end)
net.Receive("GBRP::bankwithdraw", function(len, ply)
    local amount = net.ReadUInt(32)
    ply:SetNWInt("GBRP::balance", ply:GetNWInt("GBRP::balance") - amount)
    sql.Query("update gbrp set balance = " .. ply:GetNWInt("GBRP::balance") .. " where steamid64 = " .. ply:SteamID64() .. ";")
    ply:addMoney(amount)
end)
net.Receive("GBRP::buyshop", function(len, ply)
    local shop = net.ReadEntity()
    local gang = ply:GetGang()
    shop:SetGang(gang)
    gang:Pay(shop.price)
    for k,door in pairs(gbrp.doorgroups[shop:GetShopName()].doors) do
        local ent = ents.GetMapCreatedEntity(door)
        ent:setDoorGroup(gang.name)
    end
end)
net.Receive("GBRP::sellshop", function(len, ply)
    local shop = net.ReadEntity()
    local gang = shop:GetGang()
    shop:SetGang(nil)
    gang:Cash(shop.value)
    for k,door in pairs(gbrp.doorgroups[shop:GetShopName()].doors) do
        local ent = ents.GetMapCreatedEntity(door)
        ent:setDoorGroup(nil)
    end
end)
net.Receive("GBRP::shopdeposit", function(len, ply)
    local amount = net.ReadUInt(32)
    local shop = net.ReadEntity()
    table.insert(shop.money, {gangster = ply,wallet = amount})
    shop:SetDirtyMoney(shop:GetDirtyMoney() + amount)
    ply:addMoney(-amount)
end)
net.Receive("GBRP::shopwithdraw", function(len, ply)
    local shop = net.ReadEntity()

    if not ply.launderedMoney then
        ply.launderedMoney = shop.launderedMoney
    else
        table.Add(ply.launderedMoney, shop.launderedMoney)
    end
    shop.launderedMoney = {}
    ply:AddLaunderedMoney(shop:GetBalance())
    shop:SetBalance(0)
end)
net.Receive("GBRP::buyfood",function(len,ply)
    local food = ents.Create(net.ReadString())
    food:Spawn()
    food:SetPos(Vector(-5872.747070,1485.609375,20.000000))
    ply:addMoney(-net.ReadInt(7))
end)

-------------------------
---- C O M M A N D S ----
-------------------------

concommand.Add("getposeye", function(ply,cmd,args,argStr)
    print(ply:GetEyeTrace().HitPos)
    ply:ChatPrint(tostring(ply:GetEyeTrace().HitPos))
end)
concommand.Add("getid", function(ply,cmd,args,argStr)
    print(tostring(ply:GetEyeTrace().Entity:MapCreationID()))
    ply:ChatPrint(tostring(ply:GetEyeTrace().Entity:MapCreationID()))
end)
concommand.Add("setgangbalance" ,function(ply,cmd,args)
    local gang = args[1]
    if ply:IsAdmin() and gang == "yakuzas" or gang == "mafia" or gang == "gang" then
            SetGlobalInt(gang .. "Balance", tonumber(args[2]))
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