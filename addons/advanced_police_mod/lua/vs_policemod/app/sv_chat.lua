VS_PoliceMod:NetReceive("OnPoliceChat", function(p, t)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end

    p.iLastPoliceChatSent = p.iLastPoliceChatSent or 0
    if p.iLastPoliceChatSent > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat"), 5)
        return
    end

    if (not t.sText) or (not isstring(t.sText)) or (string.len(t.sText) > 300) or (string.len(t.sText) < 1) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    local tCops = {}
	for pCop, bBool in pairs( VS_PoliceMod:GetCops() or {} ) do
		table.insert( tCops, pCop )
	end
    
    VS_PoliceMod:NetStart("OnPoliceChat", {pSender = p:UserID(), sText = t.sText, iTime = os.time()}, tCops)

    p.iLastPoliceChatSent = CurTime() + 2
end)