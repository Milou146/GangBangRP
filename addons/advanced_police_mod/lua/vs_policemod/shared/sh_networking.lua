if SERVER then util.AddNetworkString("VS_PoliceMod") end

VS_PoliceMod.NetsList = VS_PoliceMod.NetsList or {}

function VS_PoliceMod:NetReceive(strName, fnCallback)
	VS_PoliceMod.NetsList[strName] = fnCallback
end

function VS_PoliceMod:NetStart(strName, tblToSend, pTo)
	local tbl, iLen = VS_PoliceMod:Compress(tblToSend)

	net.Start("VS_PoliceMod")
		net.WriteString(strName)
		net.WriteUInt(iLen, 32)
		net.WriteData(tbl, iLen)
	if SERVER then
		if pTo then
			net.Send(pTo)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

net.Receive("VS_PoliceMod", function(_, pSender)
	-- net delay
	if SERVER then
		pSender.lastVS_PoliceModSent = pSender.lastVS_PoliceModSent or 0
		if pSender.lastVS_PoliceModSent > CurTime() then return end
		pSender.lastVS_PoliceModSent = CurTime() + 0.2
	end

	local strName = net.ReadString()
	local iLen = net.ReadUInt(32)
	local tCompressed = net.ReadData(iLen)
	local tblToSend = VS_PoliceMod:Decompress(tCompressed)

	if not VS_PoliceMod.NetsList[strName] then return end

	if SERVER then
		VS_PoliceMod.NetsList[strName](pSender, tblToSend)
	else
		VS_PoliceMod.NetsList[strName](tblToSend)
	end
end)

--[[
	Serverside:

	VS_PoliceMod:NetReceive(string UniqueName, function(player Sender, table Information)
	end)

	VS_PoliceMod:NetStart(string UniqueName, table Parameters, pTo)


	Clientside:

	VS_PoliceMod:NetReceive(string UniqueName, function(table Information)
	end)

	VS_PoliceMod:NetStart(string UniqueName, table Parameters)
]]--