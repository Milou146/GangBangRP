AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:PhysWake()
	
	self.GasCylinder = 0
	self:SetHP( TCF.Config.StoveHealth )

	self.PotsOnStove = {}
	
	-- Setup cooking plates
	self.CookerOneActive = TCF.Config.InstallPlatesDefault
	self.CookerTwoActive = TCF.Config.InstallPlatesDefault
	self.CookerThreeActive = TCF.Config.InstallPlatesDefault		
	self.CookerFourActive = TCF.Config.InstallPlatesDefault
	
	if TCF.Config.InstallPlatesDefault then
		self:SetBodygroup( 7, 1 )
		self:SetBodygroup( 8, 1 )
		self:SetBodygroup( 9, 1 )
		self:SetBodygroup( 10, 1 )
	end
	
	self:CPPISetOwner( self:Getowning_ent() )
	
	-- Start cooldown process
	self:CoolDown()
end

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
		if self:GetHP() <= 0 then
			self:Destruct()
			self:Remove()
		end
		
		self.m_bApplyingDamage = false
	end
end

function ENT:Destruct()
	local owner = self:CPPIGetOwner()
	
	if TCF.Config.StoveExplosion and not self.IsDestroyed then
		self.IsDestroyed = true
		
		local vPoint = self:GetPos()
		local effect_explode = ents.Create( "env_explosion" )
		if not IsValid( effect_explode ) then return end
		effect_explode:SetPos( vPoint )
		effect_explode:Spawn()
		effect_explode:SetKeyValue( "iMagnitude","75" )
		effect_explode:Fire( "Explode", 0, 0 )

		if TCF.Config.CreateFireOnExplode then
			local Fire = ents.Create( "fire" )
			Fire:SetPos( vPoint )
			Fire:SetAngles( Angle( 0, 0, 0 ) )
			Fire:Spawn()
			
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Your stove has exploded and caught fire due to taking an excessive amount of damage!"][TCF.Config.Language] )
		else
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Your stove has exploded due to taking an excessive amount of damage!"][TCF.Config.Language] )
		end
	end
end

function ENT:AcceptInput( key, ply )	
	local owner = self:CPPIGetOwner()
	
	if ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + TCF.Config.GasButtonDelay
		-- Check if eyetrace hit the stove.
		
		local ei_ = self:EntIndex()
		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos ) 
		
		if tr:WithinAABox( TCF.Config.StovePos.dpos1, TCF.Config.StovePos.dpos2 ) then
			if not self.CookerOneActive then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There is no cooking plate attached. Please purchase a plate for this cooker before turning it on!"][TCF.Config.Language] )
				return
			end
			
			if self:GetGasAmount() <= 0 then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There are no gas cans attached to the stove!"][TCF.Config.Language] )
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_1"..ei_ ) and self:GetPlate1() ) then
				self:SetPlate1( true )
				
				if timer.Exists( "cooktimer_pot_1"..ei_ ) then
					self:SetBodygroup( 3, 2 )
				else
					self:SetBodygroup( 3, 1 )
				end
				
				timer.Create( "cooktimer_gas_1"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 3, 0 ) -- Turn off green light
						
						self:SetPlate1( false )
						timer.Remove( "cooktimer_gas_1"..ei_ )
						return 
					end
					
					self:SetCelious1( math.Clamp( self:GetCelious1() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_1"..ei_ )
				self:SetPlate1( false )
				
				self:SetBodygroup( 3, 0 )
			end	
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos3, TCF.Config.StovePos.dpos4 ) then
			if not self.CookerTwoActive then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There is no cooking plate attached. Please purchase a plate for this cooker before turning it on!"][TCF.Config.Language] )
				return
			end
			
			if self:GetGasAmount() <= 0 then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There are no gas cans attached to the stove!"][TCF.Config.Language] )
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_2"..ei_ ) and self:GetPlate2() ) then
				self:SetPlate2( true )
				
				if timer.Exists( "cooktimer_pot_2"..ei_ ) then
					self:SetBodygroup( 4, 2 )
				else
					self:SetBodygroup( 4, 1 )
				end
				
				timer.Create( "cooktimer_gas_2"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then 
						self:SetBodygroup( 4, 0 ) -- Turn off green light 76561198139692706
						
						self:SetPlate2( false )
						timer.Remove( "cooktimer_gas_2"..ei_ ) 
						return
					end
					
					self:SetCelious2( math.Clamp( self:GetCelious2() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_2"..ei_ )
				self:SetPlate2( false )
				
				self:SetBodygroup( 4, 0 )
			end
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos5, TCF.Config.StovePos.dpos6 ) then
			if not self.CookerThreeActive then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There is no cooking plate attached. Please purchase a plate for this cooker before turning it on!"][TCF.Config.Language] )
				return
			end
			
			if self:GetGasAmount() <= 0 then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There are no gas cans attached to the stove!"][TCF.Config.Language] )
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_3"..ei_ ) and self:GetPlate3() ) then
				self:SetPlate3( true )
				
				if timer.Exists( "cooktimer_pot_3"..ei_ ) then
					self:SetBodygroup( 5, 2 )
				else
					self:SetBodygroup( 5, 1 )
				end
				
				timer.Create( "cooktimer_gas_3"..ei_, 2, 0, function()
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 5, 0 ) -- Turn off green light
						
						self:SetPlate3( false )
						timer.Remove( "cooktimer_gas_3"..ei_ )
						return
					end
					
					self:SetCelious3( math.Clamp( self:GetCelious3() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )			
				end )
			else
				timer.Remove( "cooktimer_gas_3"..ei_ )
				self:SetPlate3( false )
				
				self:SetBodygroup( 5, 0 )
			end	
		elseif tr:WithinAABox( TCF.Config.StovePos.dpos7, TCF.Config.StovePos.dpos8 ) then
			if not self.CookerFourActive then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There is no cooking plate attached. Please purchase a plate for this cooker before turning it on!"][TCF.Config.Language] )
				return
			end
			
			if self:GetGasAmount() <= 0 then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There are no gas cans attached to the stove!"][TCF.Config.Language] )
				return
			end
			
			if not ( timer.Exists( "cooktimer_gas_4"..ei_ ) and self:GetPlate4() ) then
				self:SetPlate4( true )
				
				if timer.Exists( "cooktimer_pot_4"..ei_ ) then
					self:SetBodygroup( 6, 2 )
				else
					self:SetBodygroup( 6, 1 )
				end
				
				timer.Create( "cooktimer_gas_4"..ei_, 2, 0, function() 
					if self:GetGasAmount() <= 0 then
						self:SetBodygroup( 6, 0 ) -- Turn off green light
						
						self:SetPlate4( false )
						timer.Remove( "cooktimer_gas_4"..ei_ )
						return
					end
					
					self:SetCelious4( math.Clamp( self:GetCelious4() + 2, 0, 100 ) )
					self:SetGasAmount( self:GetGasAmount() - 1 )
				end )
			else
				timer.Remove( "cooktimer_gas_4"..ei_ )
				self:SetPlate4( false )
				
				self:SetBodygroup( 6, 0 )
			end					
		end	
	end	
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	local ei_ = self:EntIndex()
	local tr = self:WorldToLocal( ent:GetPos() )
	local owner = self:CPPIGetOwner()
	
	if ent:GetClass() == "cocaine_cooking_plate" then
		if not self.CookerOneActive then
			self:SetBodygroup( 7, 1 )
			self.CookerOneActive = true
			
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The cooking plate has been successfully installed on your stove."][TCF.Config.Language] )
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			
			SafeRemoveEntityDelayed( ent, 0 )
		elseif not self.CookerTwoActive then
			self:SetBodygroup( 8, 1 )
			self.CookerTwoActive = true
			
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The cooking plate has been successfully installed on your stove."][TCF.Config.Language] )
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			
			SafeRemoveEntityDelayed( ent, 0 )
		elseif not self.CookerThreeActive then
			self:SetBodygroup( 9, 1 )
			self.CookerThreeActive = true
			
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The cooking plate has been successfully installed on your stove."][TCF.Config.Language] )
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			
			SafeRemoveEntityDelayed( ent, 0 )
		elseif not self.CookerFourActive then
			self:SetBodygroup( 10, 1 )
			self.CookerFourActive = true
			
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The cooking plate has been successfully installed on your stove."][TCF.Config.Language] )
			sound.Play( "plats/hall_elev_door.wav", self:GetPos() )
			
			SafeRemoveEntityDelayed( ent, 0 )
		else
			DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Your stove cannot fit more cooking plates."][TCF.Config.Language] )
		end
	elseif ent:GetClass() == "cocaine_cooking_pot" then
		if ent.ReadyToCook then -- Check to see if we have water and baking soda in the pot.
			for i = 1, 4, 1 do
				if ( self.PotsOnStove[i] == nil ) then
					if i == 1 then
						if not self.CookerOneActive then
							return
						end
						
						self:SetBodygroup( 11, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_1"..ei_ ) then
							self:SetBodygroup( 3, 2 ) -- Change flame to surround the pot
						end
					elseif i == 2 then
						if not self.CookerTwoActive then
							return
						end
						
						self:SetBodygroup( 12, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_2"..ei_ ) then
							self:SetBodygroup( 4, 2 ) -- Change flame to surround the pot
						end
					elseif i == 3 then
						if not self.CookerThreeActive then
							return
						end
						
						self:SetBodygroup( 13, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_3"..ei_ ) then
							self:SetBodygroup( 5, 2 ) -- Change flame to surround the pot
						end
					elseif i == 4 then
						if not self.CookerFourActive then
							return
						end
						
						self:SetBodygroup( 14, 1 ) -- Thermometer enabled
						
						if timer.Exists( "cooktimer_gas_4"..ei_ ) then
							self:SetBodygroup( 6, 2 ) -- Change flame to surround the pot
						end
					end
					
					ent:SetParent( self )
					ent:SetPos( self:WorldToLocal( self:GetAttachment( i ).Pos ) )
					ent:SetAngles( self:GetAttachment( i ).Ang )
					
					timer.Simple( TCF.Config.CookingSecondsMinimum, function()
						if IsValid( ent ) then
							ent.PotCanFinish = true
						end
					end )

					timer.Create( "cooktimer_pot_"..i..""..ei_, 5, 0, function()
						if self:GetGasAmount() > 0 then
							if i == 1 then
								-- Complete cooking process check
								if ent.PotCanFinish and self:GetCelious1() >= 100 and ( math.random( 1, TCF.Config.ChanceToFinish ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_1"..ei_ ) then
										timer.Remove( "cooktimer_pot_1"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:TCF_RewardXP( TCF.Config.FinishCookXPAmount )
									end
									
									-- Overcooking the pot timer (set on fire and decease pot)
									if TCF.Config.EnableOverCooking then
										timer.Simple( math.random( TCF.Config.OverCookingTimeMin, TCF.Config.OverCookingTimeMax ), function()
											if IsValid( ent ) and IsValid( ent:GetParent() ) then
												ent.Overcooked = true
												ent:Ignite( TCF.Config.PotOnFireTimer )
												self:TakeDamage( math.random( 15, 30 ) )
												
												self:SetBodygroup( 11, 0 ) -- Remove thermometer	
												timer.Simple( TCF.Config.PotOnFireTimer, function()
													if IsValid( self ) then
														if timer.Exists( "cooktimer_gas_1"..ei_ ) then
															self:SetBodygroup( 3, 1 ) -- Small flame if gas is on
														end
														
														self.PotsOnStove[i] = nil
													end
													if IsValid( ent ) then
														SafeRemoveEntityDelayed( ent, 0 )
													end
												end )
											end
										end )
									end
								end
							elseif i == 2 then
								if ent.PotCanFinish and self:GetCelious2() >= 100 and ( math.random( 1, TCF.Config.ChanceToFinish ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_2"..ei_ ) then
										timer.Remove( "cooktimer_pot_2"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:TCF_RewardXP( TCF.Config.FinishCookXPAmount )
									end
									
									-- Overcooking the pot timer (set on fire and decease pot)
									if TCF.Config.EnableOverCooking then
										timer.Simple( math.random( TCF.Config.OverCookingTimeMin, TCF.Config.OverCookingTimeMax ), function()
											if IsValid( ent ) and IsValid( ent:GetParent() ) then
												ent.Overcooked = true
												ent:Ignite( TCF.Config.PotOnFireTimer )
												self:TakeDamage( math.random( 15, 30 ) )
												
												self:SetBodygroup( 12, 0 ) -- Remove thermometer	
												timer.Simple( TCF.Config.PotOnFireTimer, function()
													if IsValid( self ) then
														if timer.Exists( "cooktimer_gas_1"..ei_ ) then
															self:SetBodygroup( 4, 1 ) -- Small flame if gas is on
														end
														
														self.PotsOnStove[i] = nil
													end
													if IsValid( ent ) then
														SafeRemoveEntityDelayed( ent, 0 )
													end
												end )
											end
										end )
									end
								end
							elseif i == 3 then
								if ent.PotCanFinish and self:GetCelious3() >= 100 and ( math.random( 1, TCF.Config.ChanceToFinish ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_3"..ei_ ) then
										timer.Remove( "cooktimer_pot_3"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:TCF_RewardXP( TCF.Config.FinishCookXPAmount )
									end
									
									-- Overcooking the pot timer (set on fire and decease pot)
									if TCF.Config.EnableOverCooking then
										timer.Simple( math.random( TCF.Config.OverCookingTimeMin, TCF.Config.OverCookingTimeMax ), function()
											if IsValid( ent ) and IsValid( ent:GetParent() ) then
												ent.Overcooked = true
												ent:Ignite( TCF.Config.PotOnFireTimer )
												self:TakeDamage( math.random( 15, 30 ) )
												
												self:SetBodygroup( 13, 0 ) -- Remove thermometer	
												timer.Simple( TCF.Config.PotOnFireTimer, function()
													if IsValid( self ) then
														if timer.Exists( "cooktimer_gas_1"..ei_ ) then
															self:SetBodygroup( 5, 1 ) -- Small flame if gas is on
														end
														
														self.PotsOnStove[i] = nil
													end
													if IsValid( ent ) then
														SafeRemoveEntityDelayed( ent, 0 )
													end
												end )
											end
										end )
									end
								end
							elseif i == 4 then
								if ent.PotCanFinish and self:GetCelious4() >= 100 and ( math.random( 1, TCF.Config.ChanceToFinish ) == 1 ) then
									ent:SetCooked( true )
									ent:SetBodygroup( 1, 4 ) -- Set pot bodygroup to fully cooked
									ent.ReadyToCook = false
									ent.PotCanFinish = false
									
									if timer.Exists( "cooktimer_pot_4"..ei_ ) then
										timer.Remove( "cooktimer_pot_4"..ei_ )
									end
									
									if TCF.Config.FinishCookGiveXP then
										owner:TCF_RewardXP( TCF.Config.FinishCookXPAmount )
									end
									
									-- Overcooking the pot timer (set on fire and decease pot)
									if TCF.Config.EnableOverCooking then
										timer.Simple( math.random( TCF.Config.OverCookingTimeMin, TCF.Config.OverCookingTimeMax ), function()
											if IsValid( ent ) and IsValid( ent:GetParent() ) then
												ent.Overcooked = true
												ent:Ignite( TCF.Config.PotOnFireTimer )
												self:TakeDamage( math.random( 15, 30 ) )
												
												self:SetBodygroup( 14, 0 ) -- Remove thermometer	
												timer.Simple( TCF.Config.PotOnFireTimer, function()
													if IsValid( self ) then
														if timer.Exists( "cooktimer_gas_1"..ei_ ) then
															self:SetBodygroup( 6, 1 ) -- Small flame if gas is on
														end
														
														self.PotsOnStove[i] = nil
													end
													if IsValid( ent ) then
														SafeRemoveEntityDelayed( ent, 0 )
													end
												end )
											end
										end )
									end
								end					
							end
						end
					end )

					self.PotsOnStove[i] = ent
					break
				end
			end
		end
	elseif ent:GetClass() == "cocaine_gas"then
		if self.GasCylinder == 0 then
			self:SetGasAmount( self:GetGasAmount() + 100 )
			self.GasCylinder = self.GasCylinder + 1
			
			self:SetBodygroup( 2, 1 )
			self:SetPoseParameter( "arrow", 0.5 )
			
			sound.Play( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", self:GetPos() )
			SafeRemoveEntityDelayed( ent, 0 )
		elseif self.GasCylinder == 1 then
			self:SetGasAmount( self:GetGasAmount() + 100 )
			self.GasCylinder = self.GasCylinder + 1
			
			self:SetBodygroup( 2, 2 )
			self:SetPoseParameter( "arrow", 1 )
			
			sound.Play( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", self:GetPos() )
			SafeRemoveEntityDelayed( ent, 0 )
		end
	end
end

local function TCF_PickupPots( ply, ent )
	local parent = ent:GetParent()
	
	if ent:GetClass() == "cocaine_cooking_pot" and IsValid( parent ) then
		local ei_ = parent:EntIndex()
		
		if ent:GetCooked() then
			for i = 1, 4, 1 do
				if parent.PotsOnStove[i] == ent then
					if i == 1 then
						parent:SetBodygroup( 11, 0 )
						
						if timer.Exists( "cooktimer_gas_1"..ei_ ) then
							parent:SetBodygroup( 3, 1 ) -- Small flame if gas is on
						end
					elseif i == 2 then
						parent:SetBodygroup( 12, 0 )
						
						if timer.Exists( "cooktimer_gas_2"..ei_ ) then
							parent:SetBodygroup( 4, 1 ) -- Small flame if gas is on
						end
					elseif i == 3 then
						parent:SetBodygroup( 13, 0 )
						
						if timer.Exists( "cooktimer_gas_3"..ei_ ) then
							parent:SetBodygroup( 5, 1 ) -- Small flame if gas is on
						end
					elseif i == 4 then
						parent:SetBodygroup( 14, 0 )
						
						if timer.Exists( "cooktimer_gas_4"..ei_ ) then
							parent:SetBodygroup( 6, 1 ) -- Small flame if gas is on
						end
					end
					
					parent.PotsOnStove[i] = nil
					ent:SetParent( nil )
					ent:SetPos( ent:GetPos() + Vector( 0, 0, 1 ) )
					break
				end
			end
			
			return true
		end
	end
end
hook.Add( "GravGunPickupAllowed", "TCF_PickupPots", TCF_PickupPots )
hook.Add( "PhysgunPickup", "TCF_PickupPots", TCF_PickupPots )

function ENT:CoolDown()
	local ei_ = self:EntIndex()
	local owner = self:CPPIGetOwner()
	
	timer.Create( "cooktimer_cooldown"..ei_, 3, 0, function() 
		-- Using elseif here could result in the plates bugging out as they may need to run at the same time.
		-- 76561198139692706
		
		if not self:GetPlate1() and self:GetCelious1() > 0 then
			self:SetCelious1( self:GetCelious1() - 2 )
		end
	
		if not self:GetPlate2() and self:GetCelious2() > 0 then
			self:SetCelious2( self:GetCelious2() - 2 )
		end
	
		if not self:GetPlate3() and self:GetCelious3() > 0 then
			self:SetCelious3( self:GetCelious3() - 2 )	
		end
	
		if not self:GetPlate4() and self:GetCelious4() > 0 then
			self:SetCelious4( self:GetCelious4() - 2 )
		end
		
		-- Since the timer run all the time, its more efficient to do the gas check here than in a ent:think.
		if self:GetGasAmount() > 0 and self:GetGasAmount() <= 100 then
			if self.GasCylinder == 2 then
				self.GasCylinder = self.GasCylinder - 1
				self:SetBodygroup( 2, 1 )
			end
		elseif self:GetGasAmount() <= 0 then -- OUT OF GAS
			if self.GasCylinder == 1 then
				self.GasCylinder = self.GasCylinder - 1
				self:SetBodygroup( 2, 0 )
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Your stove has ran out of gas and all cooking process has stopped."][TCF.Config.Language] )
			end
		end			
	end )
end

function ENT:OnRemove()
	local ei_ = self:EntIndex()
	
	timer.Remove( "cooktimer_gas_1"..ei_ )
	timer.Remove( "cooktimer_gas_2"..ei_ )
	timer.Remove( "cooktimer_gas_3"..ei_ )
	timer.Remove( "cooktimer_gas_4"..ei_ )
	timer.Remove( "cooktimer_cooldown"..ei_ )
	timer.Remove( "cooktimer_pot_1"..ei_ )	
	timer.Remove( "cooktimer_pot_2"..ei_ )		
	timer.Remove( "cooktimer_pot_3"..ei_ )	
	timer.Remove( "cooktimer_pot_4"..ei_ )	
end