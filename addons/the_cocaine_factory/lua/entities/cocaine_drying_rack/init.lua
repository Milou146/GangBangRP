AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:SetHP( TCF.Config.DryingRackHealth )
	
	self.IsDrying = false
	self.RackHasCocaine = false
	self.SwitchIsOn = false
	self.ConnectedBatteries = 0
	
	self:PhysWake()
	
	self:CPPISetOwner( self:Getowning_ent() )
end	

function ENT:OnTakeDamage( dmg )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		
		self:SetHP( ( self:GetHP() or 100 ) - dmg:GetDamage() )
		if self:GetHP() <= 0 then
			self:Remove()
		end
	
		self.m_bApplyingDamage = false
	end
end

function ENT:AcceptInput( key, ply )
	local owner = self:CPPIGetOwner()
	local ei_ = self:EntIndex()
	
	if ( self.lastUsed or CurTime() ) <= CurTime() then

		self.lastUsed = CurTime() + 1

		local tr = self:WorldToLocal( ply:GetEyeTrace().HitPos )

		if tr:WithinAABox( TCF.Config.DryingRackPos.posone, TCF.Config.DryingRackPos.postwo ) then
			if self.IsDrying then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The machine is currently drying the cocaine!"][TCF.Config.Language] )
				return
			end
			
			if self.ConnectedBatteries < 1 then
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["There are no batteries connected to the drying rack!"][TCF.Config.Language] )
				return
			end
			
			if not self.SwitchIsOn then
				self.SwitchIsOn = true
				self:SetBodygroup( 1, 1 ) -- Green light ON
				self:SetSkin( 1 ) -- Turn on lights
				
				sound.Play( "buttons/button14.wav", self:GetPos() )
				
				net.Start( "COCAINE_DryingSwitch" )
					net.WriteEntity( self )
					net.WriteBool( true )
				net.Send( owner )
				
				timer.Create( "battery_decrease_"..ei_, TCF.Config.BatteryDecreaseTimer, 0, function()
					if IsValid( self ) then
						self:SetBatteryCharge( math.Clamp( self:GetBatteryCharge() - TCF.Config.BatteryDecreaseAmount, 0, 100 ) )
						
						if self:GetBatteryCharge() <= 50 and self:GetBatteryCharge() > 0 then
							self:SetBodygroup( 2, 1 ) -- delete one battery
							self.ConnectedBatteries = 1
						elseif self:GetBatteryCharge() <= 0 then
							self:SetBodygroup( 2, 0 ) -- delete last battery
							self.ConnectedBatteries = 0
							
							self.SwitchIsOn = false
							self:SetBodygroup( 1, 0 ) -- Green light OFF
							self:SetSkin( 0 ) -- Turn off lights
							
							DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Batteries ran out of energy and the drying rack has been turned off!"][TCF.Config.Language] )
							
							net.Start( "COCAINE_DryingSwitch" )
								net.WriteEntity( self )
								net.WriteBool( false )
							net.Send( owner )
							
							timer.Remove( "battery_decrease_"..ei_ )
							return
						end
					end
				end )
				
				if self.RackHasCocaine then
					self.IsDrying = true
					
					-- Starting the arrow with blend sequences
					net.Start( "COCAINE_DryCocaine" )
						net.WriteEntity( self )
						net.WriteBool( true )
					net.Send( owner )
					
					timer.Simple( TCF.Config.DryingTime, function()
						if IsValid( self ) and IsValid( owner ) then
							if self.SwitchIsOn then
								self:SetBodygroup( 3, 0 )
								self.IsDrying = false
								self.RackHasCocaine = false
								
								-- Stopping the arrow with blend sequences
								net.Start( "COCAINE_DryCocaine" )
									net.WriteEntity( self )
									net.WriteBool( false )
								net.Send( owner )
								
								local finishedcocaine = ents.Create( "cocaine_pack" )
								finishedcocaine:SetPos( self:GetAttachment( 1 ).Pos )
								finishedcocaine:SetAngles( self:GetAttachment( 1 ).Ang )
								finishedcocaine:Spawn()
								
								sound.Play( "buttons/blip1.wav", self:GetPos() )
					
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The drying process has finished and is now ready."][TCF.Config.Language] )
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Put the cocaine pack in your drug holder box."][TCF.Config.Language] )
								
								-- XP Support
								if TCF.Config.DryingRackGiveXP then
									owner:TCF_RewardXP( TCF.Config.DryingRackXPAmount )
								end
							else
								self:SetBodygroup( 3, 0 )
								self.IsDrying = false
								self.RackHasCocaine = false
								
								-- Stopping the arrow with blend sequences
								net.Start( "COCAINE_DryCocaine" )
									net.WriteEntity( self )
									net.WriteBool( false )
								net.Send( owner )
								
								sound.Play( "buttons/button11.wav", self:GetPos() )
								
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The drying rack had ran out of energy and failed the process."][TCF.Config.Language] )
							end
						end
					end )
				end
			else
				self.SwitchIsOn = false
				self:SetBodygroup( 1, 0 ) -- Green light OFF
				self:SetSkin( 0 ) -- Turn off lights
				
				sound.Play( "buttons/button14.wav", self:GetPos() )

				net.Start( "COCAINE_DryingSwitch" )
					net.WriteEntity( self )
					net.WriteBool( false )
				net.Send( owner )
				
				timer.Remove( "battery_decrease_"..ei_ )
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
	
	local owner = self:CPPIGetOwner()
	--local bonus = 76561198139692706
	
	if ent:GetClass() == "cocaine_battery" then
		if self.ConnectedBatteries < 2 then
			self:SetBodygroup( 2, self.ConnectedBatteries + 1 )
			self.ConnectedBatteries = self.ConnectedBatteries + 1
			
			if self:GetBatteryCharge() < 100 then
				self:SetBatteryCharge( math.Clamp( self:GetBatteryCharge() + 50, 0, 100 ) )
			end
			
			SafeRemoveEntityDelayed( ent, 0 )
		end
	elseif ent:GetClass() == "cocaine_bucket" then
		if not self.IsDrying then
			if ent.FullBucket then
				ent.FullBucket = false
				ent:SetBodygroup( 1, 0 )
				
				self:SetBodygroup( 3, 1 )
				self.RackHasCocaine = true
				
				DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Cocaine poured out on the drying rack."][TCF.Config.Language] )
				
				if self.SwitchIsOn then
					self.IsDrying = true
					
					-- Starting the arrow with blend sequences
					net.Start( "COCAINE_DryCocaine" )
						net.WriteEntity( self )
						net.WriteBool( true )
					net.Send( owner )
					
					timer.Simple( TCF.Config.DryingTime, function()
						if IsValid( self ) and IsValid( owner ) then
							if self.SwitchIsOn then
								self:SetBodygroup( 3, 0 )
								self.IsDrying = false
								self.RackHasCocaine = false
								
								-- Stopping the arrow with blend sequences
								net.Start( "COCAINE_DryCocaine" )
									net.WriteEntity( self )
									net.WriteBool( false )
								net.Send( owner )
								
								local finishedcocaine = ents.Create( "cocaine_pack" )
								finishedcocaine:SetPos( self:GetAttachment( 1 ).Pos )
								finishedcocaine:SetAngles( self:GetAttachment( 1 ).Ang )
								finishedcocaine:Spawn()
								
								sound.Play( "buttons/blip1.wav", self:GetPos() )
					
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The drying process has finished and is now ready."][TCF.Config.Language] )
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["Put the cocaine pack in your drug holder box."][TCF.Config.Language] )
								
								if TCF.Config.DryingRackGiveXP then
									owner:addXP( TCF.Config.DryingRackXPAmount, true )
								end
							else
								self:SetBodygroup( 3, 0 )
								self.IsDrying = false
								self.RackHasCocaine = false
								
								-- Stopping the arrow with blend sequences
								net.Start( "COCAINE_DryCocaine" )
									net.WriteEntity( self )
									net.WriteBool( false )
								net.Send( owner )
								
								sound.Play( "buttons/blip1.wav", self:GetPos() )
								
								DarkRP.notify( owner, 1, 5, TCF.Config.Lang["The drying rack ran out of battery and failed the process."][TCF.Config.Language] )
							end
						end
					end )
				end
			end
		end
	end
end

function ENT:OnRemove()
	local ei_ = self:EntIndex()
	
	timer.Remove( "battery_decrease_"..ei_ )
end