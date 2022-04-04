local CFG = VS_PoliceMod.Config
VS_PoliceMod.CurrentPoliceCalls = VS_PoliceMod.CurrentPoliceCalls or {}

VS_PoliceMod:NetReceive( "AnswerContravention", function( pPlayer, tData )
    if not pPlayer.HasFine then return end

    local pOfficer = pPlayer.HasFine.officer and Player( pPlayer.HasFine.officer )
    if not IsValid( pOfficer ) or not pOfficer:PM_IsPolice() then
        VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("FineCancelledOfficer") )
        return
    end

    local iPrice = pPlayer.HasFine.price or 0
    if not iPrice or not isnumber( iPrice ) or iPrice <= 0 then return end

    local sReasons
    for sReason, bBool in pairs( pPlayer.HasFine.reasons or {} ) do
        if not CFG.Fine[ sReason ] then continue end
        sReasons = sReasons and sReasons .. ", " .. sReason or sReason
    end

    local isAccepted = tData.paid
    if not isAccepted then
        VS_PoliceMod:AddLog( pPlayer, "fines", {
            Emitter = pOfficer:Name(),
            Target = pPlayer:Name(),
            Price = iPrice,
            Reasons = sReasons,
            HasPaid = false,
        } )
        VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("YouRefusedToPay") )
        VS_PoliceMod:Notify( pOfficer, string.format( VS_PoliceMod:L("DidNotPayForReason"), pPlayer:Name(), "Refuse to pay" ) )
        return
    end

    if not pPlayer:canAfford( iPrice ) then
        VS_PoliceMod:AddLog( pPlayer, "fines", {
            Emitter = pOfficer:Name(),
            Target = pPlayer:Name(),
            Price = iPrice,
            Reasons = sReasons,
            HasPaid = false,
        } )
        VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("NotEnoughMoneyFine") )
        VS_PoliceMod:Notify( pOfficer, string.format( VS_PoliceMod:L("DidNotPayForReason"), pPlayer:Name(), "Not enough money" ) )
        return
    end

    pPlayer:addMoney( -iPrice )
    pOfficer:addMoney( iPrice )

    pPlayer.HasFine = nil

    VS_PoliceMod:AddLog( pPlayer, "fines", {
        Emitter = pOfficer:Name(),
        Target = pPlayer:Name(),
        Price = iPrice,
        Reasons = sReasons,
        HasPaid = true,
    } )

    VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("PaidFine") )
    VS_PoliceMod:Notify( pOfficer, string.format( VS_PoliceMod:L("HasPaidFine"), pPlayer:Name() ) )

end )
VS_PoliceMod:NetReceive( "SendContravention", function( pPlayer, tData )
    if not pPlayer:PM_IsPolice() then return end

    if not tData then return end

    local pCriminal = tData[ 1 ] and Player( tData[ 1 ] )
    if not pCriminal or not IsValid( pCriminal ) then return end

    if pCriminal.HasFine then
        VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("AlreadyReceivedFine") )
        return
    end

    local tFineReasons = tData[ 2 ]
    if not tFineReasons or not istable( tFineReasons ) or table.IsEmpty( tFineReasons ) then return end

    local iFinePrice = tData[ 3 ] and tonumber( tData[ 3 ] )
    if not iFinePrice or not isnumber( iFinePrice ) or iFinePrice <= 0 then return end

    local minPrice = 0
    local maxPrice = 0

    for sReason, bBool in pairs ( tFineReasons ) do
        if not CFG.Fine[ sReason ] then continue end

        minPrice = minPrice + CFG.Fine[ sReason ].minPrice or 0
        maxPrice = maxPrice + CFG.Fine[ sReason ].maxPrice or 0
    end

    if math.Clamp( iFinePrice, minPrice, maxPrice ) ~= iFinePrice then return end

    pCriminal.HasFine = {
        price = iFinePrice,
        officer = pPlayer:UserID(),
        reasons = tFineReasons
    }

    timer.Simple( CFG.FineDelay, function()
        if IsValid( pCriminal ) and pCriminal.HasFine then
            if not IsValid( pPlayer ) then return end

            local sReasons
            for sReason, bBool in pairs( pCriminal.HasFine.reasons or {} ) do
                if not CFG.Fine[ sReason ] then continue end
                sReasons = sReasons and sReasons .. ", " .. sReason or sReason
            end

            pCriminal.HasFine = nil
            
            VS_PoliceMod:AddLog( pCriminal, "fines", {
                Emitter = pPlayer:Name(),
                Target = pCriminal:Name(),
                Price = iPrice,
                Reasons = sReasons,
                HasPaid = false,
            } )

            VS_PoliceMod:Notify( pPlayer, string.format(VS_PoliceMod:L("DidNotPayForReason"), pCriminal:Name(), "No answer" ) )
        end
    end )

    VS_PoliceMod:Notify( pPlayer, VS_PoliceMod:L("FineSent") )
    VS_PoliceMod:NetStart( "AskContravention", { pCriminal.HasFine }, pCriminal )
end )

VS_PoliceMod:NetReceive("OnMissionSent", function(p, t)
    if VS_PoliceMod.CurrentPoliceCalls[p:UserID()] then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("AlreadyPendingCall") )
        return
    end

    if not t.desc or not isstring(t.desc) or not t.cat or not tonumber(t.cat) or not VS_PoliceMod.Config.CallsReason[t.cat] or string.len(t.desc) > 150 then
        VS_PoliceMod:Notify(p, VS_PoliceMod:L("ErrorHasOccured") )
        return
    end

    local tResult = {
        emitter = p:UserID(),
        missionDesc = t.desc,
        missionType = VS_PoliceMod.Config.CallsReason[t.cat],
        positionEmitter = p:GetPos(),
        dispatchGroup = nil,
        timeStart = os.time()
    }

	local tCops = {}
	for pCop, _ in pairs( VS_PoliceMod:GetCops() or {} ) do
        VS_PoliceMod:Notify(pCop, VS_PoliceMod:L("NewCallReceived"), 5)
		table.insert( tCops, pCop )
	end

    local sTimer = "VS_PoliceMod.Calls" .. p:UserID()
    if timer.Exists(sTimer) then timer.Remove(sTimer) end
    timer.Create(sTimer, VS_PoliceMod.Config.CallCancelDelay, 1, function()
        if IsValid(p) then
            local shouldNotify = VS_PoliceMod:EndMission(p)

            if shouldNotify then VS_PoliceMod:Notify(p, VS_PoliceMod:L("HelpRequestAutoClosed") ) end
        end
    end)

    VS_PoliceMod.CurrentPoliceCalls[p:UserID()] = tResult

	VS_PoliceMod:NetStart( "OnMissionReceived", tResult, tCops )

    VS_PoliceMod:Notify(p, VS_PoliceMod:L("CallSent"), 5)
end)

VS_PoliceMod:NetReceive( "MissionSolved", function( pPlayer, tData ) 
    if not tData or not tData[ 1 ] then return end
    if not VS_PoliceMod.CurrentPoliceCalls[ tData[ 1 ] ] then return end

    if not pPlayer:PM_IsPolice() then return end

    local pEmitter = Player( tData[ 1 ] )

    if IsValid( pEmitter ) then 
        local shouldNotify = VS_PoliceMod:EndMission( pEmitter )
        if shouldNotify then VS_PoliceMod:Notify( pEmitter, VS_PoliceMod:L("YourHelpRequestMarkedSolved") ) end
    end
end )

VS_PoliceMod:NetReceive( "SelectDispatch", function( pPlayer, tData ) 
    if not tData or not tData[ 1 ] then return end
    if not VS_PoliceMod.CurrentPoliceCalls[ tData[ 1 ] ] then return end

    if not pPlayer:PM_IsChief() then
        VS_PoliceMod:Notify( pCop, VS_PoliceMod:L("NotAllowed") )
        return
    end

    if not tData[ 2 ] or not CFG.DispatchGroupsNames[ tData[ 2 ] ] and VS_PoliceMod.DispatchGroups[ tData[ 2 ] ] then
        VS_PoliceMod.CurrentPoliceCalls[ tData[ 1 ] ].dispatchGroup = nil
    else
        VS_PoliceMod.CurrentPoliceCalls[ tData[ 1 ] ].dispatchGroup = tData[ 2 ]
    end

    local tCops = {}
    for pCop, _ in pairs( VS_PoliceMod:GetCops() or {} ) do
        table.insert( tCops, pCop )
    end

    VS_PoliceMod:NetStart( "DispatchSelected", tData, tCops )
end )