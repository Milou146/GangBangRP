function VS_PoliceMod:CreateComplaint(sName, sCat, sContent)
    VS_PoliceMod.SQL:Query("INSERT INTO vs_policemod_complaints (citizen, category, content) VALUES (%pname%, %category%, %content%)", {pname = sName, category = sCat, content = sContent})
end

function VS_PoliceMod:FetchComplaints(state, callback)
    VS_PoliceMod.SQL:Query("SELECT * FROM vs_policemod_complaints WHERE state=%state% ORDER BY id DESC LIMIT 100", {state = state}, function(q, data)
        callback(data)
    end)
end

function VS_PoliceMod:UpdateComplaintState(p, id, new)
    VS_PoliceMod.SQL:Query("SELECT id FROM vs_policemod_complaints WHERE id=%cid% LIMIT 1", {cid = id}, function(q, data)
        if data then
            VS_PoliceMod.SQL:Query("UPDATE vs_policemod_complaints SET state = %newstate% WHERE id = %cid%", {newstate = new, cid = id}, function(q, d)
                local tCops = {}
                for pCop, bBool in pairs( VS_PoliceMod:GetCops() or {} ) do
                    table.insert( tCops, pCop )
                end
                VS_PoliceMod:NetStart("OnComplaintStateUpdated", {id = id}, tCops)
                
                VS_PoliceMod:Notify(p, VS_PoliceMod:L("ComplaintUpdated"), 5)
            end)
        else
            VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        end
    end)
end

VS_PoliceMod:NetReceive("OnAskForComplaints", function(p, t)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end

    if t.state == nil or not isbool(t.state) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    if p:GetActiveWeapon():GetClass() != "vs_policemod_tablet" then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    p.lastComplaintsRequest = p.lastComplaintsRequest or 0

    if p.lastComplaintsRequest > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat") )
        return
    end

    VS_PoliceMod:FetchComplaints(t.state and 1 or 0, function(data)
        VS_PoliceMod:NetStart("OnSendComplaints", data, p)
    end)

    lastComplaintsRequest = CurTime() + 2
end)

VS_PoliceMod:NetReceive("OnUpdateComplaintState", function(p, t)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end

    if t.id == nil or not tonumber(t.id) or t.state == nil or not tonumber(t.state) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    if p:GetActiveWeapon():GetClass() != "vs_policemod_tablet" then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    p.lastComplaintUpdate = p.lastComplaintUpdate or 0

    if p.lastComplaintUpdate > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat") )
        return
    end

    VS_PoliceMod:UpdateComplaintState(p, t.id, t.state == 1 and 0 or 1)

    p.lastComplaintUpdate = CurTime() + 5
end)

VS_PoliceMod:NetReceive("OnComplaintSent", function(p, t)
    if not t.desc or not isstring(t.desc) or not t.cat or not tonumber(t.cat) or not VS_PoliceMod.Config.ComplaintsReasons[t.cat] or string.len(t.desc) > 600 or string.len(t.desc) < 1 then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    local ent = Entity(t.npc)

    if not t.npc or not tonumber(t.npc) or not IsValid(ent) or not ent or ent:GetClass() ~= "vs_police_mod_officer" or ent:GetPos():DistToSqr(p:GetPos()) > 160000 then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    p.lastComplaintSent = p.lastComplaintSent or 0

    if p.lastComplaintSent > CurTime() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("WaitBeforeThat") )
        return
    end

    VS_PoliceMod:CreateComplaint(p:Nick(), VS_PoliceMod.Config.ComplaintsReasons[t.cat], t.desc)

    VS_PoliceMod:Notify(p, VS_PoliceMod:L("ComplaintSent"), 5)

    hook.Run("VS_PoliceMod.NewComplaint", p, VS_PoliceMod.Config.ComplaintsReasons[t.cat])

    p.lastComplaintSent = CurTime() + 30
end)