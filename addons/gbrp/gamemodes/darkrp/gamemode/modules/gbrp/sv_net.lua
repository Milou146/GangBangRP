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
util.AddNetworkString("GBRP::robberyPanel")
util.AddNetworkString("GBRP::startRobbery") -- client to server
util.AddNetworkString("GBRP::bankruptMessage") -- server to client
util.AddNetworkString("GBRP::shopSolvation") -- client to server
util.AddNetworkString("GBRP::cityhallReception") -- server to client

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
net.Receive("GBRP::launderingRequest",function(len,ply)
    local launderer = net.ReadEntity()
    local amount = net.ReadInt(32)
    ply:addMoney(-amount)
    if launderer.cash[ply] then
        launderer.cash[ply] = launderer.cash[ply] + amount
    else
        launderer.cash[ply] = amount
    end
end)
net.Receive("GBRP::personnalBankDeposit",function(len,ply)
    ply:Cash(ply:GetNWInt("GBRP::personnalLaunderedMoney"))
    ply:SetNWInt("GBRP::personnalLaunderedMoney",0)
end)
net.Receive("GBRP::startRobbery",function(len,ply)
    local shop = net.ReadEntity()
    local shopGang = shop:GetGang()
    shop:StartRobbery(ply:GetGang())
    for _,pl in pairs(player.GetAll()) do
        if pl:GetGang() == shopGang then
            DarkRP.notify(pl,1,2,"Intrusion " .. string.lower(shop.niceName) .. " !")
        end
    end
end)
net.Receive("GBRP::shopSalvation",function(len,ply)
    if net.ReadBool() then
        ply:GetGang():Pay(net.ReadInt(32))
    else
        net.ReadEntity():SetGang(nil)
    end
end)