if game.SinglePlayer() then

hook.Add("EntityTakeDamage", "ARC9_ETD", function(npc, dmg)
    timer.Simple(0, function()
        if !IsValid(npc) then return end
        if npc:Health() <= 0 then
            net.Start("ARC9_sp_health")
            net.WriteEntity(npc)
            net.Broadcast()
        end
    end)
end)

end