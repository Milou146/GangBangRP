local ft = CurTime()

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
    return false,"Jour de paye, vous touchez " .. gbrp.formatMoney(amount),0
end)
hook.Add("Think", "GBRP::Think",function()
    if CurTime() > ft + 1800 then
        ft = CurTime()
        gbrp.MoveNPCs()
    end
end)