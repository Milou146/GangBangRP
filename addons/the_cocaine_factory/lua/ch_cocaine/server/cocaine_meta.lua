local PMETA = FindMetaTable( "Player" )

function PMETA:TCF_RewardXP( amount )
	-- Give XP (Vronkadis DarkRP Level System)
	if TCF.Config.DarkRPLevelSystemEnabled then
		self:addXP( amount, true )
	end
	
	-- Give XP (Sublime Levels)
	if TCF.Config.SublimeLevelSystemEnabled then
		self:SL_AddExperience( amount, "XP rewarded")
	end
	
	-- Give XP (Elite XP system)
	if TCF.Config.EXP2SystemEnabled then
		EliteXP.CheckXP( self, amount )
	end
	
	-- Give XP (DarkRP essentials & Brick's Essentials)
	if TCF.Config.EssentialsXPSystemEnabled then
		self:AddExperience( amount, "XP rewarded" )
	end

	-- Give XP (GlorifiedLeveling)
	if TCF.Config.GlorifiedLevelingXPSystemEnabled then
		GlorifiedLeveling.AddPlayerXP( self, amount )
	end
end