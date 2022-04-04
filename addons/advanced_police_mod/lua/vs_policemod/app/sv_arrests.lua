VS_PoliceMod.BailsList = VS_PoliceMod.BailsList or {}

hook.Add("playerArrested", "VS_PoliceMod.Bails:playerArrested", function(p, iTime)
    VS_PoliceMod.BailsList[p:UserID()] = VS_PoliceMod.Config.JaiTimeBailMultiplier * iTime
    p:setDarkRPVar("bailAvailable", true)
end)

hook.Add("playerUnArrested", "VS_PoliceMod.Bails:playerUnArrested", function(p, iTime)
    VS_PoliceMod.BailsList[p:UserID()] = nil
end)

VS_PoliceMod:NetReceive("PayBail", function(p, tbl)
    if not tbl.pid or not tonumber(tbl.pid) or not IsValid(Player(tbl.pid)) or not VS_PoliceMod.BailsList[tbl.pid] then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    local ent = Entity(tbl.npc)

    if not tbl.npc or not tonumber(tbl.npc) or not IsValid(ent) or not ent or ent:GetClass() ~= "vs_police_mod_officer" or ent:GetPos():DistToSqr(p:GetPos()) > 160000 then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    local iPrice = VS_PoliceMod.BailsList[tbl.pid]

    if not p:canAfford(iPrice) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("NotEnoughMoneyBail"), 5)
        return
    end

    p:addMoney(-iPrice)
    local pVictim = Player(tbl.pid)

    if pVictim.RHC_UnArrest then
        pVictim:RHC_UnArrest()
    else
        pVictim:unArrest()
    end
    if pVictim:HasWeapon("weapon_r_cuffed") then
        pVictim:StripWeapon("weapon_r_cuffed")
    end

    VS_PoliceMod:Notify(p, VS_PoliceMod:L("BailPaid"), 5)
end)

VS_PoliceMod:NetReceive("ReleaseFromJail", function(p, tbl)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end
    
    if not tbl.pid or not tonumber(tbl.pid) or not IsValid(Player(tbl.pid)) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    local pTarget = Player(tbl.pid)

    if not pTarget:isArrested() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("NotInJail"), 5)
        return
    end

    if pTarget.RHC_UnArrest then
        pTarget:RHC_UnArrest()
    else
        pTarget:unArrest()
    end
    if pTarget:HasWeapon("weapon_r_cuffed") then
        pTarget:StripWeapon("weapon_r_cuffed")
    end

    VS_PoliceMod:Notify(p, VS_PoliceMod:L("CitizenReleased"), 5)
end)

VS_PoliceMod:NetReceive("DisableBail", function(p, tbl)
    if not p:PM_IsPolice() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("YoureNotPoliceman"), 5)
        return
    end
    
    if not tbl.pid or not tonumber(tbl.pid) or not IsValid(Player(tbl.pid)) then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured"), 5)
        return
    end

    local pTarget = Player(tbl.pid)

    if not pTarget:isArrested() then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("NotInJail"), 5)
        return
    end

    if not VS_PoliceMod.BailsList[tbl.pid] then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("BailAlreadyDisabled"), 5)
        return
    end

    VS_PoliceMod.BailsList[tbl.pid] = nil
    pTarget:setDarkRPVar("bailAvailable", false)

    VS_PoliceMod:Notify(p, VS_PoliceMod:L("BailDisabled"), 5)
end)