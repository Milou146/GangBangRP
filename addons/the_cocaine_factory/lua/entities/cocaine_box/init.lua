AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	self:SetHP( TCF.Config.CocaineBoxHealth )
	
	self.BoxCocaineAmount = 0
	self.IsClosed = false
	
	self:PhysWake()
	
	self:CPPISetOwner( self:Getowning_ent() )
	self.BoxOwner = self:Getowning_ent()
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

function ENT:Use( ply )	
	if ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5
		
		if table.HasValue( TCF.Config.PoliceTeams, team.GetName( ply:Team() ) ) then
			if self.BoxCocaineAmount > 0 then
				local police_confiscate_reward = self.BoxCocaineAmount * TCF.Config.PoliceConfiscateAmount
			
				DarkRP.notify( ply, 1, 5, TCF.Config.Lang["You have confiscated a box of cocaine. You've been rewarded"][TCF.Config.Language] .." ".. DarkRP.formatMoney( police_confiscate_reward ) )
				ply:addMoney( police_confiscate_reward )
				self:Remove()
				return
			end
		end
		
		if not self.IsClosed then
			self:SetBodygroup( 1, 1 )
			self.IsClosed = true
			DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Your box packed with cocaine has been closed and is ready for sale at the druggie."][TCF.Config.Language] )
		else
			self:SetBodygroup( 1, 0 )
			self.IsClosed = false
			DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Your box has been opened again. You can put more packed cocaine in it now."][TCF.Config.Language] )
		end
	end
end

function ENT:StartTouch( ent )
	if self.IsClosed then
		return
	end
	
	if ( ent.lastTouch or CurTime() ) > CurTime() then
		return
	end
	ent.lastTouch = CurTime() + 0.5
	
	if ent:GetClass() == "cocaine_pack" then
		if self.BoxCocaineAmount < 4 then 
			self.BoxCocaineAmount = self.BoxCocaineAmount + 1
			
			self:SetBodygroup( 2, self.BoxCocaineAmount )
			SafeRemoveEntityDelayed( ent, 0 )
		end
	end
end