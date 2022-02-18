if engine.ActiveGamemode() ~= "darkrp" then return end
-------------------------------
-- M I S C E L L A N E O U S --
-------------------------------

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

sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")

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
hook.Add( "InitPostEntity", "GBRP::InitPostEntity", function()
    gbrp.SpawnNPCs()
    gbrp.SpawnHotdogSalesmans()
    gbrp.InitDoors()
end)
hook.Add("PlayerDisconnected","GBRP::PlayerDisconnected",function(ply)
    if ply:IsGangLeader() then ply:GetGang():Reset() end
end)
hook.Add("PlayerSpawn","GBRP:PlayerSpawn",function(ply)
    if ply:IsGangLeader() then
        ply:GetGang():SetBalance(gbrp.startingFunds)
    end
end)
hook.Add("PlayerDeath","GBRP:PlayerDeath",function(ply)
    if ply:IsGangLeader() then
        ply:GetGang():Reset()
    end
end)
hook.Add("PlayerInitialSpawn","GBRP:DoorsInitCS",function(ply)
    timer.Simple(4, function()
        gbrp.SendDoorsData(ply)
    end)
end)
hook.Add( "PreCleanupMap", "GBRP::PreCleanupMap", function()
    gbrp.SaveDoors()
    gbrp.SaveShops()
end)
hook.Add( "PostCleanupMap", "GBRP::PostCleanupMap", function()
    gbrp.SpawnNPCs()
    gbrp.InitDoors() --build the new gbrp.doors table
    for _,ply in pairs(player.GetAll()) do
        gbrp.SendDoorsData(ply) --send the new table to the clients
    end
    gbrp.LoadDoors()
    gbrp.LoadShops()
    for _,ply in pairs(player.GetAll()) do if ply:isCook() then return end end
    gbrp.SpawnHotdogSalesmans()
end)
hook.Add( "PlayerChangedTeam", "GBRP::PlayerChangedTeam", function(ply,oldTeam,newTeam)
    if oldTeam == TEAM_VIP2 then
        gbrp.SpawnHotdogSalesmans()
    end
end)

---------------
---- N E T ----
---------------

net.Receive("GBRP::buyproperty",function(len,ply)
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
net.Receive("GBRP::sellproperty",function(len,ply)
    local gang = ply:GetGang()
    local doorgroup = net.ReadString()
    for _,doorid in pairs(gbrp.doorgroups[doorgroup].doors) do
        local door = ents.GetMapCreatedEntity(doorid)
        door:setDoorGroup(nil)
        if door:getDoorOwner() then
            door:keysUnOwn(ply)
            gang:AddPrivateDoor(-1)
        end
        door:Fire("lock", "", 0)
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
    local foodName = net.ReadString()
    local food = gbrp.foods[foodName]

    local foodTable = {
        cmd = "buyfood",
        max = GAMEMODE.Config.maxfooditems
    }

    if ply:customEntityLimitReached(foodTable) then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", GAMEMODE.Config.chatCommandPrefix .. "buyfood"))

        return ""
    end

    ply:addCustomEntity(foodTable)

    local SpawnedFood = ents.Create("spawned_food")
    SpawnedFood.DarkRPItem = foodTable
    SpawnedFood:Setowning_ent(ply)
    SpawnedFood:SetPos(Vector(-5872.747070,1485.609375,20.000000))
    SpawnedFood.onlyremover = true
    SpawnedFood.SID = ply.SID
    SpawnedFood:SetModel(food.model)

    -- for backwards compatibility
    SpawnedFood.FoodName = foodName
    SpawnedFood.FoodEnergy = food.energy
    SpawnedFood.FoodPrice = food.price

    SpawnedFood.foodItem = food
    SpawnedFood:Spawn()

    ply:Pay(food.price)
    DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_bought", foodName, gbrp.formatMoney(cost), ""))

    hook.Call("playerBoughtFood", nil, ply, food, SpawnedFood, food.price)
end)
net.Receive("GBRP::buywep",function(len,ply)
    ply:Give(net.ReadString())
    ply:Pay(net.ReadInt(7))
end)
net.Receive("GBRP::heal",function(len,ply)
    ply:SetHealth(100)
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
concommand.Add("setplayerbalance", function(ply,cmd,args)
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
concommand.Add("privatizedoor",function(ply,cmd,args)
    local door = ents.GetByIndex(args[1])
    if ply:IsAdmin() or ply:IsGangLeader() and door:getDoorData().groupOwn == ply:GetGang().name then
        door:setDoorGroup(nil)
        door:keysOwn(ply)
        ply:GetGang():AddPrivateDoor(1)
    end
end)
concommand.Add("collectivizedoor",function(ply,cmd,args)
    local door = ents.GetByIndex(args[1])
    local gang = ply:GetGang()
    if ply:IsAdmin() or ply:IsGangLeader() and door:getDoorData().owner == ply then
        door:setDoorGroup(gang.name)
        door:keysUnOwn(ply)
        gang:AddPrivateDoor(-1)
    end
end)