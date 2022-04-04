VS_PoliceMod.CopsPlayers = VS_PoliceMod.CopsPlayers or {}

function VS_PoliceMod:Notify(pPlayer, sMessage, iLength)
    VS_PoliceMod:NetStart("OnNotification", {sMsg = sMessage, iLen = iLength}, pPlayer)
end
function VS_PoliceMod:GetCops()
	return VS_PoliceMod.CopsPlayers or {}
end

function VS_PoliceMod:EndMission(pEmitter)
	if not VS_PoliceMod.CurrentPoliceCalls[ pEmitter:UserID() ] then return false end

	VS_PoliceMod.CurrentPoliceCalls[ pEmitter:UserID() ] = nil

    local tCops = {}
    for pCop, _ in pairs( VS_PoliceMod:GetCops() or {} ) do
        table.insert( tCops, pCop )
    end

    VS_PoliceMod:NetStart( "OnMissionCancelled", {id = pEmitter:UserID()}, tCops )
    return true
end

function VS_PoliceMod:AddLog(pPlayer, sCategory, sContent)
    VS_PoliceMod.SQL:Query("INSERT INTO vs_policemod_logs (steamid, category, content, date) VALUES (%psid%, %category%, %content%, %unixdate%)", {psid = pPlayer:SteamID64(), category = sCategory, content = util.TableToJSON(sContent), unixdate = os.time()})
end
