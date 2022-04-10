util.AddNetworkString("gundealer::dermaMenu")
util.AddNetworkString("gundealer::buy")

net.Receive("gundealer::buy", function(_, ply)
  local selected = net.ReadString()
    for k,v in pairs(ItemShop) do
      if tostring(k) == selected then
        if ply:getDarkRPVar("money") < v.Price then
          return
        end

        local trace = {}
        trace.start = ply:EyePos()
        trace.endpos = trace.start + ply:GetAimVector() * 85
        trace.filter = ply

        local tr = util.TraceLine(trace)

        local item = ents.Create(v.EntityName)

        DarkRP.placeEntity(item, tr, ply)

        item:SetModel(v.Model)
        item:Spawn()

        ply:addMoney(-v.Price)
    end
  end
end)
