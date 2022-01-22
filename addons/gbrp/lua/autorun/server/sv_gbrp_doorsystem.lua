util.AddNetworkString("GBRP::doorsinit")
util.AddNetworkString("GBRP::buydoor")
util.AddNetworkString("GBRP::selldoor")
net.Receive("GBRP::buydoor",function(len,ply)
    local gang = ply:GetGang()
    local doorgroup = net.ReadString()
    for _,door in pairs(gbrp.doorgroups[doorgroup].doors) do
        local ent = ents.GetMapCreatedEntity(door)
        ent:setDoorGroup(gang)
    end
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") - gbrp.doorgroups[doorgroup].attributes.price)
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
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") + gbrp.doorgroups[doorgroup].attributes.value)
    SetGlobalInt(gang .. "Earnings",GetGlobalInt(gang .. "Earnings") + gbrp.doorgroups[doorgroup].attributes.value)
    DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("door_sold", DarkRP.formatMoney(gbrp.doorgroups[doorgroup].attributes.value)))
    for k,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            pl:ChatPrint([[Votre gang a vendu ']] .. doorgroup .. [[']])
        end
    end
end)
hook.Add("InitPostEntity","GBRP::DoorsInit",function()
    gbrp.doors = {}
    for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
        for _,door in pairs(doorgroup.doors) do
            local ent = ents.GetMapCreatedEntity(door)
            ent:setDoorGroup(doorgroup.owner)
            if doorgroup.locked then
                ent:Fire("lock", "", 0)
            end
            ent.groupname = doorgroupname
            gbrp.doors[ent:EntIndex()] = doorgroup.attributes
        end
    end
end)
hook.Add("PlayerInitialSpawn","GBRP:DoorsInitCS",function(ply)
    timer.Simple(4, function()
        net.Start("GBRP::doorsinit")
        for k,v in pairs(gbrp.doors) do
            net.WriteInt(k,32)
            net.WriteTable(v)
        end
        net.Send(ply)
    end)
end)