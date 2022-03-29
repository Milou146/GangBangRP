sql.Query("create table if not exists gbrp(steamid64 bigint not null, balance bigint);")
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
concommand.Add("spawn", function(ply,cmd,args)
    if not ply:IsAdmin() then return end
    local hitpos = ply:GetEyeTrace().HitPos
    local ent = ents.Create(args[1])
    if IsValid(ent) then
        ent:SetPos(hitpos)
        ent:Spawn()
    end

end)