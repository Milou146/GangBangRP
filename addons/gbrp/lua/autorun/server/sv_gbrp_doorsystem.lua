util.AddNetworkString("GBRP::doorsinit")
util.AddNetworkString("GBRP::buydoor")
util.AddNetworkString("GBRP::selldoor")
net.Receive("GBRP::buydoor",function(len,ply)
    local gang = net.ReadString()
    local doorgroup = net.ReadString()
    for _,door in pairs(gbrp.doorgroups[doorgroup].doors) do
        local ent = ents.GetMapCreatedEntity(door)
        ent:SetNWString("owner",gang)
    end
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") - gbrp.doorgroups[doorgroup].attributes.price)
    for k,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            pl:ChatPrint("Votre gang a acheté" .. doorgroup)
        end
    end
end)
net.Receive("GBRP::selldoor",function(len,ply)
    local gang = net.ReadString()
    local doorgroup = net.ReadString()
    for _,door in pairs(gbrp.doorgroups[doorgroup].doors) do
        local ent2 = ents.GetMapCreatedEntity(door)
        ent2:SetNWString("owner","nobody")
    end
    SetGlobalInt(gang .. "Balance",GetGlobalInt(gang .. "Balance") + gbrp.doorgroups[doorgroup].attributes.value)
    for k,pl in pairs(player.GetAll()) do
        if pl:GetGang() == gang then
            pl:ChatPrint("Votre gang a vendu" .. doorgroup)
        end
    end
end)

hook.Add("PlayerInitialSpawn","DoorGroupsDefinition",function(ply)
    local doors = {}
    for doorgroupname,doorgroup in pairs(gbrp.doorgroups) do
        for _,door in pairs(doorgroup.doors) do
            local ent = ents.GetMapCreatedEntity(door)
            ent:SetNWString("owner",doorgroup.owner)
            if doorgroup.locked then
                ent:Fire("lock", "", 0)
            end
            ent.groupname = doorgroupname
            doors[ent:EntIndex()] = doorgroup.attributes
            net.Start("GBRP::doorsinit")
            net.WriteTable(doors)
            net.Send(ply)
        end
    end
end)