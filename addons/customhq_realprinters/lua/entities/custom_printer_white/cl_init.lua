include("shared.lua")
include("realprinters_config.lua")
local cfg = hqprinter1
surface.CreateFont("DefA", {font = "Roboto", size = 40, weight = 900})
local function TrySendCommand(cmd)
	local ply = LocalPlayer()
	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})
	local ent = tr.Entity
	if not IsValid(ent) or not ent.IsCustomHQ then
		return
	end
	net.Start('customprinter_get') net.WriteEntity(ent) net.WriteString(cmd) net.SendToServer()
end
net.Receive("customprinter_send",function()
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end
	ent.Variables = net.ReadTable()
end)
ENT.textEnable = "true"
ENT.textProgress = "100%"
ENT.textMoney = "$220"
ENT.Variables = {}
ENT.Variables["name"] = cfg["PName"] 
ENT.Variables["power"] = 50
ENT.Variables["temp"] = 6
ENT.Variables["money"] = 0
ENT.Variables["enable"] = true
ENT.Variables["cooler"] = "dis"
ENT.Variables["time"] = CurTime()+1001
ENT.Variables["paper"] = 0
ENT.Variables["colors"] = 0
elements = {
	{ --on off 123
		numb = 3,
		x = 0.13,
		y = 0.2,
		w = 0.047,
		h = 0.18,
		color  = Color(2,2,2,0),
		hovercolor  = Color(25,135,35,155),
		press = function() TrySendCommand("c_off") end
	},
	{ -- Screen
		numb = 1,
		x = 0.758,
		y = 0.09,
		w = 0.15,
		h = 0.455,
		color = Color(238, 236, 221, 255),
	--	hovercolor = Color(10, 25, 25),
	},
	{ -- bios1
		numb = 1,
		x = 0.758,
		y = 0.087,
		w = 0.15,
		h = 0.07,
		color = Color(1, 1, 1, 255),
	--	hovercolor = Color(10, 25, 25),
	},
	{ -- bios1.5
		numb = 1,
		x = 0.758,
		y = 0.085,
		w = 0.15,
		h = 0.07,
		color = Color(124, 124, 124, 255),
	--	hovercolor = Color(10, 25, 25),
	},	
	{ -- bios2
		numb = 1,
		x = 0.758,
		y = 0.545,
		w = 0.15,
		h = 0.01,
		color = Color(124, 124, 124, 255),
	--	hovercolor = Color(10, 25, 25),
	},
	
	{ -- but power
		numb = 1,
		x = 0.767,
		y = 0.18,
		w = 0.13,
		h = 0.07,
		color = Color(1, 1, 1, 0),
	--	hovercolor = Color(10, 25, 25),
		render = function(self,x,y)
			draw.RoundedBox(4, x-1,y-12, 102,22,Color(25,25,25,255) )
			draw.RoundedBox(4, x,y-11, 100,20,Color(1,82,120,255) )
			draw.RoundedBox(4, x,y-11, self.Variables["power"],20,Color(34,119,193,255) )

		end
	},
	
	{ -- but temp
		numb = 1,
		x = 0.767,
		y = 0.26,
		w = 0.13,
		h = 0.07,
		color = Color(1, 1, 1, 0),
	--	hovercolor = Color(10, 25, 25),
		render = function(self,x,y)
			draw.RoundedBox(4, x-1,y-12, 102,22,Color(25,25,25,255) )
			draw.RoundedBox(4, x,y-11, 100,20,Color(96,33,33,255) )
			draw.RoundedBox(4, x,y-11, self.Variables["temp"],20,Color(211,40,40,255) )

		end
	},
	
	{	-- but windraw
		numb = 1,
		x = 0.767,
		y = 0.34,
		w = 0.13,
		h = 0.07,
		color = Color(1, 1, 1, 0),
		hovercolor = Color(10, 25, 0,0),
		render = function(self,x,y,b)
			local col =  Color(169,204,40,255)
			if b then
				col = Color(255,204,40,255)
			end
			draw.RoundedBox(4, x-1,y-12, 102,22,Color(25,25,25,255) )
			draw.RoundedBox(4, x,y-11, 100,20,col )

		end,
		press = function()
			TrySendCommand("g_money")
		end,
	},
		{--text withdraw
		numb = 1,
		x = 0.795,
		y = 0.352,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(0,1,0,255),
		font = "default",
		text = "Withdraw!"
	--	hovercolor = Color(210, 25, 25,255),

	},
	
	{ --text name
		numb = 1,
		x = 0.77,
		y = 0.1,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(255,255,255,255),
		font = "default",
		text = "%s",
		key = "name",
		--hovercolor = Color(210, 25, 25,255),
		press = function()
			print("AE")
		end,
	},
	
	{ --text time
		numb = 1,
		x = 0.88,
		y = 0.09,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(25,25,25,255),
		font = "default",
		text = "%s",
		key = "time",
		timer = true,
		--hovercolor = Color(210, 25, 25,255),
		press = function()
			print("AE")
		end,
	},


	

	{ --text power
		numb = 1,
		x = 0.79,
		y = 0.192,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(25,25,25,255),
		font = "default",
		text = "Power: %s %%",
		key = "power",  
		--hovercolor = Color(210, 25, 25,255),
		press = function()
			print("AE")
		end,
	},
		
	{ --text  temperature
		numb = 1,
		x = 0.79,
		y = 0.27,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(25,25,25,255),
		font = "default",
		text = "Temp: %s °C",
		key = "temp",
		--hovercolor = Color(210, 25, 25,255),
		press = function()
			print("AE")
		end,
	},

	
	
	{ --text  money 
		numb = 1,
		x = 0.766,
		y = 0.41,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(5,255,5,255),
		font = "default",
		text = "Money: %s $",
		key = "money"
	},
	
	

	
	{ --text  paper
		numb = 1,
		x = 0.766,
		y = 0.44,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(25,25,25,255),
		font = "default",
		text = "Paper: %s ",
		key = "paper"
	},
	
	{ --text  colorpaint
		numb = 1,
		x = 0.766,
		y = 0.47,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(25,25,25,255),
		font = "default",
		text = "ColorPaint: %s ",
		key = "colors"
	},
	
		{--text cooler
		numb = 1,
		x = 0.766,
		y = 0.5,
		w = 0.1,
		h = 0.04,
		color = Color(250, 250, 250, 0),
		textc = Color(120,185,255,255),
		font = "default",
		text = "Coolers %sconnected",
		key = "cooler"
	}, 
	

	
	 
	{ --on off
		numb = 1,
		x = 0.93,
		y = 0.1,
		w = 0.05,
		h = 0.3,
		color  = Color(2,2,2,0),
		hovercolor  = Color(25,135,35,0),
		press = function()
			TrySendCommand("onoff")
		end
	},

	{ -- but 1 
		numb = 2,
		x = 0.657,
		y = 0.12,
		w = 0.052,
		h = 0.11,
		color = Color(125,25,25,255),
		hovercolor = Color(75,175,75,255),
		press = function()
			TrySendCommand("p_up")
		end
	},
	
	{-- but 2
		numb = 2,
		x = 0.657,
		y = 0.31,
		w = 0.052,
		h = 0.11,
		color = Color(125,25,25,255),
		hovercolor = Color(75,175,75,255),
		press = function()
			TrySendCommand("p_down")
		end
		--text = "B"
	},
	{ -- Screen offf
		numb = 1,
		x = 0.757,
		y = -0.01,
		w = 0.14,
		h = 0.5,
		render = function(self,x,y)
			local a = 0
			if !self.Variables["enable"] then a = 255 end
			draw.RoundedBox(0, x-1,y-50, 120,150,Color(25,25,25,a) )
		end,
		color = Color(238, 236, 221, 0),
	--	hovercolor = Color(10, 25, 25),
	}
		
}




function ENT:Paint(w,h,x,y, numb)


	local hovered = self:GetHoveredElement()
	
	for k, element in ipairs(elements) do
		if element.numb != numb then continue end
		surface.SetDrawColor(element.color)

		local element_x = w * element.x
		local element_y = h * element.y
		local element_w = w * element.w
		local element_h = h * element.h

		if element == hovered and element.hovercolor then
			surface.SetDrawColor(element.hovercolor)
		end

		surface.DrawRect(element_x,element_y,element_w,element_h)
		local cx = element_x 
		local cy = element_y + element_h / 2

		if element.text then
		
			local text = element.text
			
			if element.key != nil then
				
				if element.timer then
					text = math.Clamp(math.floor((self.Variables[element.key] or 0) - CurTime()),0,999)
					local add = "    "
					if text > 9 and text < 100 then add = "  "
					elseif text > 99 then add ="" end
					text = add..tostring(text)
				else
					text = string.format(element.text,self.Variables[element.key])
				end
			end
			surface.SetFont(element.font or "DefA")
			local textw, texth = surface.GetTextSize(text)
			surface.SetTextColor(element.textc or Color(0,0,0,255))
			surface.SetTextPos(cx , cy - texth/2 )
			surface.DrawText(text)
		end
		
		if element.render then
			element.render(self, cx, cy,element == hovered)
		end
		
	end
end



function ENT:GetHoveredElement()
	local scale = self.Scale

	local w, h = self.Width2D, self.Height2D
	local x, y = self:CalculateCursorPos()

	for _, element in ipairs(elements) do
		if element.hovercolor == nil then continue end
		local element_x = w * element.x
		local element_y = h * element.y
		local element_w = w * element.w
		local element_h = h * element.h

		if 	element_x < x and element_x + element_w > x and
			element_y < y and element_y + element_h > y 
		then
			return element
		end
	end
	
	-- for right stone
	x, y = self:CalculateCursorPos2()

	for _, element in ipairs(elements) do
		if element.hovercolor == nil then continue end
		local element_x = w * element.x
		local element_y = h * element.y
		local element_w = w * element.w
		local element_h = h * element.h

		if 	element_x < x and element_x + element_w > x and
			element_y < y and element_y + element_h > y 
		then
			return element
		end
	end
end


function ENT:CalculateCursorPos()
	local ply = LocalPlayer()

	if not IsValid(ply) then
		return 0, 0
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 165,
		filter = ply
	})

	if tr.Entity ~= self then
		return 0, 0
	end

	local scale = self.Scale or 1

	local pos, ang = self:CalculateRenderPos(), self:CalculateRenderAng()
	local normal = self:GetForward()
	
	local intersection = util.IntersectRayWithPlane(ply:EyePos(), ply:GetAimVector(), pos, normal)
	
	if not intersection then
		return 0, 0
	end

	local diff = pos - intersection

	local x = diff:Dot(-ang:Forward()) / scale
	local y = diff:Dot(-ang:Right()) / scale

	return x, y
end


function ENT:CalculateCursorPos2()
	local ply = LocalPlayer()
 
	if not IsValid(ply) then
		return 0, 0
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	if tr.Entity ~= self then
		return 0, 0
	end

	local scale = self.Scale or 1

	local pos, ang = self:CalculateRenderPos2(), self:CalculateRenderAng2()
	local normal = self:GetRight()
	
	local intersection = util.IntersectRayWithPlane(ply:EyePos(), ply:GetAimVector(), pos, normal)
	
	if not intersection then
		return 0, 0
	end

	local diff = pos - intersection

	local x = diff:Dot(-ang:Forward()) / scale
	local y = diff:Dot(-ang:Right()) / scale

	return x, y
end

function ENT:CalculateRenderPos()
	local pos = self:GetPos()
		pos:Add(self:GetForward() * self.Maxs.x) 
		pos:Add(self:GetRight() * self.Maxs.y)
		pos:Add(self:GetUp() * self.Maxs.z) 

		pos:Add(self:GetForward() * -4.7)
		

		
	return pos
end

function ENT:CalculateRenderPos2()
	local pos = self:GetPos()
		pos:Add(self:GetForward() * self.Maxs.x) 
		pos:Add(self:GetRight() * self.Maxs.y)
		pos:Add(self:GetUp() * self.Maxs.z) 

		pos:Add(self:GetForward() * 0.7)
		pos:Add(self:GetRight() * -77.7)
		
		

		
	return pos
end

function ENT:CalculateRenderAng()
	local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -83)
		ang:RotateAroundAxis(ang:Up(), 90)	

	return ang
end

function ENT:CalculateRenderAng2()
	local ang = self:GetAngles()
	--	ang:RotateAroundAxis(ang:Right(), -83)
		ang:RotateAroundAxis(ang:Up(), -180)	
		ang:RotateAroundAxis(ang:Forward(), -270)	

	return ang
end
hook.Add("PlayerBindPress", "CustomHQPrinters", function(ply, bind, pressed)
	if not pressed then
		return
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 65,
		filter = ply
	})

	local ent = tr.Entity

	if not IsValid(ent) or not ent.IsCustomHQ then
		return
	end

	if string.find(bind, "+use", nil, true) then
		local button = ent:GetHoveredElement()

		if not button or not button.press then
			return
		end

		button.press(ent)
	end
end)
PrintersEnabledAzae = true