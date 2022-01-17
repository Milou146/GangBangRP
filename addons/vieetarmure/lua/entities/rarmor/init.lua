AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )
resource.AddFile("materials/rarmor/armor.png")
include("shared.lua") 

function ENT:Initialize() 
	self:SetModel( "models/Humans/Group03/male_02.mdl" )
	self:InitPhysics()
	if not file.Exists("rarmor.txt", "DATA") then
		file.Write("rarmor.txt", 50)
		local i = 50
	end
	timer.Simple(.1, function()
		local i = file.Read("rarmor.txt", "DATA")
		i = tonumber(i)
		self:SetNWInt( "CostPerArmor", i )
	end)
end

function ENT:InitPhysics()
	self:PhysicsInitBox( Vector(-18,-18,0), Vector(18,18,72) )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end

function ENT:OnTakeDamage( dmg )
	return 0
end 

util.AddNetworkString("rarmorMenuOpen")
util.AddNetworkString("BuyArmor")
util.AddNetworkString("SaveArmorConfigChanges")
function ENT:AcceptInput( n, a, p )	
	if n == "Use" and IsValid(p) then
		p:SetNWEntity("LastNPCUsed", self)
		timer.Simple(.1, function()
			net.Start("rArmorMenuOpen")
			net.Send(p)
		end)
	end
end

net.Receive("BuyArmor",function(len, p)
	if not IsValid(p) then return end
	local e = p:GetNWEntity( "LastNPCUsed" )
	if not IsValid(e) then return end
	if p:GetPos():Distance(e:GetPos()) > 100 then return end
	local f = net.ReadFloat()
	local IsMax = f == 1 and true or false
	local max = 100
	local h2a = max * f
	local price = math.Round((e:GetNWInt("CostPerArmor") * max) * f)
	local drp = DarkRP or false
	local money = drp and p:getDarkRPVar("money") or 0
	if p:Armor() >= max then 
		if drp then
			DarkRP.notify(p, 1, 2, "Votre protection est déjà complète!")
		end
		p:ConCommand( "play buttons/button10.wav" )
		return
	end
	if money >= price and p:Armor() < max then
		if drp then
			p:addMoney(-price)	
			DarkRP.notify(p, 2, 2, "Vous avez acheté "..h2a.."d'armure!")
		end
		p:ConCommand( "play buttons/button14.wav" )
		local ar = math.Clamp(p:Armor(), p:Armor() + h2a, max)
		p:SetArmor(ar)
	end
	if money < price then
		if drp then
			DarkRP.notify(p, 1, 2, "Solde insuffisant.")
		end
		p:ConCommand( "play buttons/button10.wav" )
	end
end)

net.Receive("SaveArmorConfigChanges", function(l, p)
	if not IsValid(p) or not p:IsSuperAdmin() then return end
	local i = net.ReadFloat()
	i = math.Round(i)
	if not type(i) == number then return end
	file.Write("rarmor.txt", i)
	local e = p:GetNWEntity( "LastNPCUsed" )
	if not IsValid(e) then return end
	for k, v in pairs(ents.FindByClass("armor_npc")) do
		v:SetNWInt( "CostPerArmor", i )
	end
end)