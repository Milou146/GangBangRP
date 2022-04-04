function VS_PoliceMod:FetchCriminalRecords(pTarget, sCategory, callback)
    VS_PoliceMod.SQL:Query("SELECT * FROM vs_policemod_logs WHERE steamid=%sid% and category=%cname% ORDER BY id DESC LIMIT 100", {sid = pTarget:SteamID64(), cname = sCategory}, function(q, data)
        data = data or {}
        callback(data)
    end)
end

function VS_PoliceMod:FetchCriminalRecordsStats(pTarget, callback)
    VS_PoliceMod.SQL:Query("SELECT category, COUNT(category) AS count FROM vs_policemod_logs WHERE steamid=%sid% GROUP BY category", {sid = pTarget:SteamID64()}, function(q, data)
        data = data or {}
        callback(data)
    end)
end

--
-- Networking
--

VS_PoliceMod:NetReceive("OnGetCRStats", function(p, t)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end

    p.iLastFetchInfo = p.iLastFetchInfo or 0
    if p.iLastFetchInfo > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat"), 5)
        return
    end

    if not t.pid or not IsValid(Player(t.pid)) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    VS_PoliceMod:FetchCriminalRecordsStats(Player(t.pid), function(data)
        if not IsValid(Player(t.pid)) then 
            VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
            return
        end

        data.pid = t.pid
        VS_PoliceMod:NetStart("OnSendCRStats", data, p)
    end)

    p.iLastFetchInfo = CurTime() + 0.5
end)

local tCats = {
    ["arrests"] = true,
    ["unarrests"] = true,
    ["wanted"] = true,
    ["unwanted"] = true,
    ["warrants"] = true,
    ["unwarrants"] = true,
    ["fines"] = true,
    ["complaints"] = true,
}

VS_PoliceMod:NetReceive("OnGetCRContent", function(p, t)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end

    p.iLastFetchContentCR = p.iLastFetchContentCR or 0
    if p.iLastFetchContentCR > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat"), 5)
        return
    end

    if not t.pid or not IsValid(Player(t.pid)) or not t.cat or not isstring(t.cat) or not tCats[t.cat] then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    VS_PoliceMod:FetchCriminalRecords(Player(t.pid), t.cat, function(data)
        if not IsValid(Player(t.pid)) then 
            VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
            return
        end

        data.pid = t.pid
        VS_PoliceMod:NetStart("OnSendCRContent", data, p)
    end)

    p.iLastFetchContentCR = CurTime() + 0.5
end)

--
-- Logging
--

hook.Add("playerWanted", "VS_PoliceMod.CriminalRecords:playerWanted", function(pTarget, pEmitter, sReason)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end

    VS_PoliceMod:AddLog(pTarget, "wanted", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
        Reason = sReason
    })
end)

hook.Add("playerUnWanted", "VS_PoliceMod.CriminalRecords:playerUnWanted", function(pTarget, pEmitter)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end
    
    VS_PoliceMod:AddLog(pTarget, "unwanted", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
    })
end)

hook.Add("playerArrested", "VS_PoliceMod.CriminalRecords:playerArrested", function(pTarget, iTime, pEmitter)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end
    
    VS_PoliceMod:AddLog(pTarget, "arrests", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
    })
end)

hook.Add("playerUnArrested", "VS_PoliceMod.CriminalRecords:playerUnArrested", function(pTarget, pEmitter)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end
    
    VS_PoliceMod:AddLog(pTarget, "unarrests", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
    })
end)

hook.Add("playerWarranted", "VS_PoliceMod.CriminalRecords:playerWarranted", function(pTarget, pEmitter, sReason)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end
    
    VS_PoliceMod:AddLog(pTarget, "warrants", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
        Reason = sReason
    })
end)

hook.Add("playerUnWarranted", "VS_PoliceMod.CriminalRecords:playerUnWarranted", function(pTarget, pEmitter)
    if not IsValid(pTarget) or not IsValid(pEmitter) then return end
    
    VS_PoliceMod:AddLog(pTarget, "unwarrants", {
        Target = pTarget:Nick(),
        Emitter = pEmitter:Nick(),
    })
end)

hook.Add("VS_PoliceMod.NewComplaint", "VS_PoliceMod.CriminalRecords:NewComplaint", function(pTarget, sCat)
    if not IsValid(pTarget) or not sCat then return end

    VS_PoliceMod:AddLog(pTarget, "complaints", {
        Target = pTarget:Nick(),
        Reason = sCat
    })
end)