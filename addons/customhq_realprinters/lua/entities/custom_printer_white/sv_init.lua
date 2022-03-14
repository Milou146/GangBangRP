include("realprinters_config.lua")
local cfg = hqprinter1
function ENT:AddMorePaper()
self.PPaper = self.PPaper + cfg["PapersPerBlock"]
if self.PPaper > cfg["MaxPapers"] then self.PPaper = cfg["MaxPapers"] end
end

function ENT:AddMoreColors()
	self.PColors = self.PColors + cfg["ColorsPerBlock"] 
	if self.PColors > cfg["MaxColors"] then self.PColors = cfg["MaxColors"] end
end

function ENT:OpenBitch(ent)
	local id = self:LookupSequence("open")
	self:SetSequence(id)
	timer.Simple(1.2,function()
		if IsValid(self) then
			local id = self:LookupSequence("close")
			self:SetSequence(id)
			self.EatMore = true
		end
	end)
	timer.Simple(0.6,function()
		if IsValid(ent) and IsValid(self) then
			if ent.Paper then
				self:AddMorePaper()
			elseif ent.Colors then
				self:AddMoreColors()
			end
			self:UpdateVars()
			ent:Remove()
		end
	end)
end

function ENT:Touch(ent)
	if not IsValid(ent) then return end
		if ent.ItsUpgrade then
			if (ent.upgrade == "paper" and self.PPaper == cfg["MaxPapers"]) or (ent.upgrade == "ink" and self.PColors == cfg["MaxColors"]) then return end
			if ent.Cooler then
				// do nothing because white coolers are basic bitches and need a man
			elseif self.EatMore then
				self.EatMore = false
				self:OpenBitch(ent)
			end	
			self:UpdateVars()
		end
end

function ENT:CreateMoneybag()
	if not IsValid(self) then return end
	local MoneyPos = self:GetPos() + self:GetForward()*18
	local amount = self.PMoney
	
	if amount <= 0 then return end
	local id = self:LookupSequence("withdraw")
	self:ResetSequence(id)
	timer.Simple(0.1,function()
		local moneybag = DarkRP.createMoneyBag(Vector(MoneyPos.x , MoneyPos.y, MoneyPos.z -5), amount)
	end)
	self.PMoney = 0
	self:UpdateVars()
end


function ENT:Think()

	if not self.sparking then self:NextThink(CurTime());  return true end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
	self:NextThink(CurTime());  return true;
end

function ENT:HeatDie()
	local vPoint = self:GetPos()
	self:Remove()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
end

function ENT:OnTakeDamage(dmg)
	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:HeatDie()
	end
end

function ENT:HeatMore()
	local x = cfg["HeatPower"] * self.PPower * 0.02
	if self.PCooler then x = x / 2 end
	if !self.PEnable then
		self:EditTemp(-40)
	end
	
	if (self.PCooler == nil and self.PPower > 55) or (IsValid(self.PCooler) and self.PPower > 75) then
		self:EditTemp(x)
	else
		if self.PTemp < 70 or IsValid(self.PCooler) and self.PTemp < 57 then
			self:EditTemp(x)
		else 
			self:EditTemp(x*-1)			
		end
	end
	
	if self.PTemp >= 100 then
		return
	end
	
	timer.Simple(cfg["HeatSpeed"],function() if IsValid(self) then self:HeatMore() end end)
end
 
function ENT:ResetTimer()
	local tm = math.random(cfg["PrintTimeMin"], cfg["PrintTimeMax"])
	local x  = tm / 2
	local h  = x * self.PPower * 0.02 - x
	tm = tm - h
	if tm <= 0 then tm = 1 end
	timer.Remove(tostring(self:EntIndex()).."printingae")
	timer.Simple(0.2,function()
	timer.Create(tostring(self:EntIndex()).."printingae",tm,1, function() if IsValid(self) then self:PrintMore() end end)
	end)
	self.PTime = CurTime() + tm
	self:UpdateVars()
end


function ENT:PrintMore()
	self:MoreMoney()
	self:ResetTimer()
end

function ENT:UpdateVars()
	local Table = {}
	Table["name"] = cfg["PName"]
	Table["power"] = self.PPower
	Table["temp"] = math.floor(self.PTemp)
	Table["money"] = self.PMoney
	Table["enable"] = self.PEnable
	Table["cooler"] = self.PCoolerState
	Table["time"] = self.PTime
	Table["paper"] = self.PPaper.." / "..cfg["MaxPapers"]
	Table["colors"] = self.PColors.." / "..cfg["MaxColors"]
	net.Start("customprinter_send") net.WriteEntity(self) net.WriteTable(Table) net.Broadcast()
end

ENT.LastOff = CurTime()
function ENT:OnOff()
	if self.LastOff + 1 > CurTime() then return end
	self.LastOff = CurTime()
	self.PEnable = !self.PEnable
		
	self:EmitSound(Sound("Weapon_Pistol.Empty"))	
	if self.PEnable then
		self:ResetTimer()
		if self.PCooler then    
			self:StartCoolerAnim()
		end
		
		self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
		self.sound:SetSoundLevel(52)
		self.sound:PlayEx(1, 100)
		local id = self:LookupSequence("poweron")
		self:ResetSequence(id)
	else
		self.sparking = false
		self.sound:Stop()
		
		local id = self:LookupSequence("poweroff")
		self:ResetSequence(id)
		if self.PCooler then
		self.PCooler:Fire('setanimation','stop',0)
		if self.PCooler.sound then
			self.PCooler.sound:Stop()
		end
		end
	end	
	
	self:UpdateVars()
end

function ENT:Power(int,str)
	if not self.PEnable then return end
	self:EmitSound(Sound("Weapon_Pistol.Empty"))
	local id = self:LookupSequence(str)
	self:ResetSequence(id)
	self.PPower = self.PPower + int
	if self.PPower < 1 then self.PPower = 1 end
	if self.PPower > 100 then self.PPower = 100 end
	self:UpdateVars()
end

function ENT:EditTemp(int)

	if IsValid(self.PCooler) then
		if int > 0 then
			int = int / 2 * (self.PCooler.int or 1)
		else 
			int = int * 2
		end
	end
	
	self.PTemp = self.PTemp + int
	if self.PTemp < 0 then self.PTemp = 0 end
	if self.PTemp < 80 and self.sparking then self.sparking = false end
	if self.PTemp > 85 then self.sparking = true end
	if self.PTemp >= 100 then self:HeatDie() end
	self:UpdateVars()
end

function ENT:MoreMoney()
	if not self.PEnable then return end
	if self.PPaper < cfg["PaperEating"] then return end
	if self.PColors < cfg["ColorEating"] then return end
	
	self.PPaper = self.PPaper - cfg["PaperEating"]
	self.PColors = self.PColors - cfg["ColorEating"]
	
	
	self.PMoney = self.PMoney + cfg["PrintMoney"]
	if self.PMoney >  cfg["MaxMoney"] then self.PMoney = cfg["MaxMoney"] end
 	self:UpdateVars()
end
