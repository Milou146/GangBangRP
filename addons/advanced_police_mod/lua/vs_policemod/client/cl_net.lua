VS_PoliceMod.CurrentPoliceCalls = VS_PoliceMod.CurrentPoliceCalls or {}

VS_PoliceMod:NetReceive("OnNotification", function(t)
    VS_PoliceMod:Notify(t.sMsg, t.iLen)
end)

VS_PoliceMod:NetReceive("OnMissionReceived", function(t)
    t.emitter = Player(t.emitter)

    VS_PoliceMod.CurrentPoliceCalls[t.emitter] = t
    
    hook.Run("VS_PoliceMod:OnMissionReceived", t)
end)

VS_PoliceMod:NetReceive("OnMissionsSync", function(t)
    VS_PoliceMod.CurrentPoliceCalls = t

    for k, v in pairs(VS_PoliceMod.CurrentPoliceCalls) do
        VS_PoliceMod.CurrentPoliceCalls[k].emitter = Player(v.emitter)
    end
    
    hook.Run("VS_PoliceMod:OnMissionsSync", t)
end)

VS_PoliceMod:NetReceive("OnMissionCancelled", function(t)
    VS_PoliceMod.CurrentPoliceCalls[Player(t.id)] = nil

    hook.Run("VS_PoliceMod:OnMissionsCancelled", Player(t.id) )
end)

VS_PoliceMod:NetReceive("OnUseNPCOfficer", function(t)
    VS_PoliceMod:DisplayOfficerMenu(t.bails, t.npc)
end)

VS_PoliceMod:NetReceive( "AskContravention", function( tData )
    VS_PoliceMod:DisplayFine( tData[1] or {} )
end )

VS_PoliceMod:NetReceive("OpenVehicleTablet", function()
    VS_PoliceMod:OpenTablet( self )
end )