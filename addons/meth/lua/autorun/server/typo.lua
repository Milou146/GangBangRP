concommand.Add("eml_redp_spawn", function(player, command, args)
	if player:IsAdmin() then
		if (args[1] != 0) then
			local lookPos = player:GetEyeTrace().HitPos;
		
			local redP = ents.Create("eml_redp");
			redP:SetPos(lookPos:GetPos()+Vector(0, 0, 12));
			redP:SetAngles(player:GetAngles());
			redP:Spawn();
			redP:GetPhysicsObject():SetVelocity(redP:GetUp()*2);
			redP:SetNWInt("amount", args[1]);
			redP:SetNWInt("maxAmount", args[1]);	
		end;
	end;
end);

concommand.Add("eml_ci_spawn", function(player, command, args)
	if player:IsAdmin() then
		if (args[1] != 0) then
			local lookPos = player:GetEyeTrace().HitPos;
		
			local ciO = ents.Create("eml_ciodine");
			ciO:SetPos(lookPos:GetPos()+Vector(0, 0, 12));
			ciO:SetAngles(player:GetAngles());
			ciO:Spawn();
			ciO:GetPhysicsObject():SetVelocity(ciO:GetUp()*2);
			ciO:SetNWInt("amount", args[1]);
			ciO:SetNWInt("maxAmount", args[1]);	
		end;
	end;
end);