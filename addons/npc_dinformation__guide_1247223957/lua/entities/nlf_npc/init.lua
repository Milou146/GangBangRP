AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( OsGuide.modelNPC )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)

	table.insert( OsGuide.Entity, self )
end

function ENT:OnRemove()
	table.RemoveByValue( OsGuide.Entity, self )
end

function ENT:AcceptInput(name, activator, caller)	
	if (name == "Use" and caller:IsPlayer()) then
		-- caller:SendLua("local tab={Color(255,255,255),[[".. OsGuide.Lang.nlfbotl24 .."]],Color(0,75,255),[["..caller:Nick().."]],Color(255,255,255),[[!]]}chat.AddText(unpack(tab))")
		net.Start( "Guide_Client" )
			net.WriteInt( -8, 4 )
		net.Send(caller)
	else
		self:EmitSound("vo/npc/male01/sorry0"..math.random(1, 3)..".wav", 70, 100)
		caller:SendLua("local tab={Color(255,255,255),[[" .. OsGuide.Lang.nlfbotl25 .. "]]}chat.AddText(unpack(tab))")
	end
end