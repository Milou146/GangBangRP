

util.AddNetworkString("bodygroups_change")
util.AddNetworkString("skins_change")
util.AddNetworkString("bodyman_chatprint")
util.AddNetworkString("bodyman_model_change")

function BODYMAN:ChatPrint( ply, msg )
	if IsValid( ply ) then
		net.Start( "bodyman_chatprint" )
		net.WriteString( msg )
		net.Send( ply )
	else
		self:Log( msg )
	end
end

hook.Add("PlayerInitialSpawn", "GiveBodygroupsTable", function(ply)
	ply.bodygroups = {}

	ply.LastJob_bodygroupr = "none"
	ply.LastPlayermodel = nil

	-- check the allowed bodygroups and apply them

end)

net.Receive("bodyman_model_change", function( len, ply )
	local oldModel = ply:GetModel()
	local newModel = oldModel

	if BODYMAN:PlayerCommandIsThrottled(ply, "bodyman_model_change") then
		print(ply:Nick() .. " (" .. ply:SteamID64() .. ") is being throttled from changing models")
		return false
	end

	if not BODYMAN:CanAccessCommand(ply, "bodyman_model_change") then
		return false
	end

	if (not BODYMAN:CloseEnoughCloset( ply )) and BODYMAN.ClosetsOnly then return false end

	local job = ply:getJobTable()

	local playermodels = job.model

	if type( playermodels ) == "table" then
		local idx = net.ReadInt(8)
		if playermodels[idx] then
			newModel = playermodels[idx]
			ply:SetModel(newModel)
			ply:SetupHands()
			timer.Simple(0.5, function() ply:SendLua( [[BODYMAN:RefreshAppearanceMenu()]] ) end )
		end
	end

	ply.LastJob_bodygroupr = job.command or "none"
end)

net.Receive("bodygroups_change", function(len, ply)

	-- if not BODYMAN:CanAccessCommand(ply, "bodygroups_change") then
	--	return false
	--end

	--if not BODYMAN:CloseEnoughCloset( ply ) and BODYMAN.ClosetsOnly then return false end

	local data = net.ReadTable()

	ply:SetBodygroup(data[1], data[2])

		-- BodygroupManagerLog( ply:Nick().." changed their bodygroup: (" .. ply:GetBodygroupName(data[1])..","..tostring(data[2])..")" )

	ply.LastPlayermodel = ply:GetModel()
end)

net.Receive("skins_change", function(len, ply)

	if not BODYMAN:CanAccessCommand(ply, "skins_change") then
		return false
	end

	if (not BODYMAN:CloseEnoughCloset( ply )) and BODYMAN.ClosetsOnly then return false end

	local wants = net.ReadInt(8) -- the skin that they wants

	local job = ply:getJobTable()
	local skins = {}
	if job.skins then
		skins = table.Copy(job.skins)
	else
		local numskins = ply:SkinCount()
		for i = 0, numskins do
			table.insert( skins, i )
		end
	end

	if job.vipskins then
		vipskintable = table.Copy(job.vipskins)
		if BODYMAN:IsVip(ply) then
			for _,v in ipairs(vipskintable) do
				table.insert(skins,v)
			end
		end
	end

	if skins ~= {} then
		local allowed = false
		for k,v in ipairs(skins) do
			if v == wants then
				allowed = true
			end
		end

		if allowed then
			ply:SetSkin(wants)
			BodygroupManagerLog( ply:Nick() .. " changed their skin: (" .. tostring(wants) .. ")" )
		end
	else
		ply:SetSkin( wants )
		BodygroupManagerLog( ply:Nick() .. " changed their skin: (" .. tostring(wants) .. ")" )
	end

	ply.LastJob_bodygroupr = job.command or "none"
	ply.LastPlayermodel = ply:GetModel()
end)

