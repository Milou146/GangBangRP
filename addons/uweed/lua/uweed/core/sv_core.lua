hook.Add("PlayerSpawn", "uWeed_Respawn", function(ply)
	if !UWeed.Config.KeepWeed then
		if (ply:GetNWInt("uWeed_Gram_Counter") or 0) >= 1 then 
			ply:SetNWInt("uWeed_Gram_Counter", 0)
			net.Start("uweed_msg")
				net.WriteString(UWeed.Translation.Chat.LoseBlunt)
			net.Send(ply)
		end
	end

	if UWeed.Config.SpawnJoints then
		if (ply:GetNWInt("uWeed_Gram_Counter") or 0) >= 1 then
			ply:Give("uweed_joint")
			net.Start("uweed_msg")
				net.WriteString(UWeed.Translation.Chat.Spawn)
			net.Send(ply)
		end
	end
end)

hook.Add("PlayerDeath", "uWeed_ResetHigh", function(ply)
	if UWeed.Config.ResetHighDeath then
		net.Start("uweed_die")
		net.Send(ply)
	end
end)