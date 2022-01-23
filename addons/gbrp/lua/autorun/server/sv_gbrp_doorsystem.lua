util.AddNetworkString("GBRP::doorsinit")
util.AddNetworkString("GBRP::buydoor")
util.AddNetworkString("GBRP::selldoor")
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