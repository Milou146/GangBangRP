local ft = CurTime()
local ft1 = CurTime()

hook.Add("PlayerInitialSpawn", "GBRP::Client Init", function(ply)
    local data = sql.QueryRow("select * from gbrp where steamid64 = " .. ply:SteamID64() .. ";")

    if not data then
        sql.Query("insert into gbrp values(" .. ply:SteamID64() .. ", 0);")
        ply:SetNWInt("GBRP::balance", 0)
    else
        ply:SetNWInt("GBRP::balance", tonumber(data.balance))
    end
    net.Start("GBRP::welcomeScreen")
    net.Send(ply)
end)
hook.Add("InitPostEntity", "GBRP::InitPostEntity", function()
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
    ply:SetNWInt("methItemsCount",0)
    ply:SetNWInt("cocaineItemsCount",0)
    ply:SetNWInt("cigaretteItemsCount",0)
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
hook.Add("PreCleanupMap", "GBRP::PreCleanupMap", function()
    gbrp.SaveDoors()
    gbrp.SaveShops()
end)
hook.Add("PostCleanupMap", "GBRP::PostCleanupMap", function()
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
hook.Add("PlayerChangedTeam", "GBRP::PlayerChangedTeam", function(ply,oldTeam,newTeam)
    if oldTeam == TEAM_VIP2 then
        gbrp.SpawnHotdogSalesmans()
    end
end)
hook.Add("PlayerLeaveVehicle", "GBRP::PlayerLeaveVehicle", function(ply,veh)
    ply:SetupHands()
end)
hook.Add("EntityTakeDamage","GBRP::EntityTakeDamage",function(ent,dmg)
    local mapid = ent:MapCreationID()
    if mapid and gbrp.customMapEntities[mapid] then
        local hp = ent:Health()
        ent:SetHealth(math.Clamp(hp - dmg:GetDamage(),0,10000))
        print(hp)
        if ent:Health() == 0 then
            ent:SetColor(Color(0,0,0,255))
        end
    end
end)
hook.Add("playerGetSalary","GBRP::salary",function(ply,amount)
    ply:Cash(amount)
    if amount == 0 then
        return true
    else
        return false,"Jour de paye, vous touchez " .. gbrp.formatMoney(amount),0
    end
end)
hook.Add("Think", "GBRP::Think",function()
    if CurTime() > ft + 1800 then
        ft = CurTime()
        gbrp.MoveNPCs()
    elseif CurTime() > ft1 + gbrp.taxSpeed then
        ft1 = CurTime()
        for _,gang in pairs(gbrp.gangs) do
            local gangLeader = gang:GetLeader()
            if gangLeader then
                local propertyTax = 0
                for _,shop in pairs(gang:GetShops()) do
                    propertyTax = propertyTax + shop.value
                end
                propertyTax = propertyTax * gbrp.GetPropertyTax() / 100
                gang:Pay(propertyTax)
                gangLeader:ChatPrint("Taxe foncière due : " .. gbrp.formatMoney(propertyTax))
                local housingTax = 0
                for _,house in pairs(gang:GetHouses()) do
                    housingTax = housingTax + house.price
                end
                housingTax = housingTax * gbrp.GetHousingTax() / 100
                gang:Pay(housingTax)
                gangLeader:ChatPrint("Taxe sur l'habitation due : " .. gbrp.formatMoney(housingTax))
                local incomeTax = GetGlobalInt(gang.name .. "Incomes") * gbrp.GetIncomeTax() / 100
                SetGlobalInt(gang.name .. "Incomes",0)
                SetGlobalInt(gang.name .. "Expenses",0)
                gang:Pay(incomeTax)
                gangLeader:ChatPrint("Impôt sur les sociétés : " .. gbrp.formatMoney(incomeTax))
            end
        end
    end
end)
hook.Add("PlayerShouldTakeDamage","GBRP::antiLeaderKill",function(ply,attacker)
    if ply:IsGangLeader() and attacker:IsPlayer() and attacker:GetGang() == ply:GetGang() then
        return false
    end
end)
hook.Add("PostPlayerDeath","GBRP::PostPlayerDeath",function(ply)
    if ply:IsGangLeader() then
        DarkRP.notifyAll(1, 4, "Le chef " .. ply:GetGang().name .. " est décédé.")
        ply:changeTeam(TEAM_CITIZEN, true)
    end
end)