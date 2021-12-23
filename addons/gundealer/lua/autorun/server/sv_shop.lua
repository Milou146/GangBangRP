util.AddNetworkString("DermaDesign")

util.AddNetworkString("buy")

net.Receive("buy", function(_, ply)
  local selected = net.ReadString()
    for k,v in pairs(ItemShop) do
      if tostring(k) == selected then
        if ply:getDarkRPVar("money") < v.Price then
          return
        end
        local item = ents.Create(v.EntityName)
        item:SetPos( ply:GetPos()+ Vector(6,50,6))
        item:SetModel(v.Model)
        item:Spawn()
        ply:addMoney(-v.Price)
    end
  end
end)
