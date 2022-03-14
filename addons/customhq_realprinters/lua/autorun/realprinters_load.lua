if SERVER then 
	resource.AddWorkshop("830525177")
	util.AddNetworkString("customprinter_send")
	util.AddNetworkString("customprinter_get")
	net.Receive('customprinter_get',function()
		local ent = net.ReadEntity()
		if not IsValid(ent) then return end
		local id = net.ReadString()
		if id 		== "onoff" then
			ent:OnOff()
		elseif id 	== "p_up" then
			ent:Power(2,"buttonup")
		elseif id 	== "p_down" then
			ent:Power(-2,"buttondown")
		elseif id 	== "g_money" then
			ent:CreateMoneybag()
		elseif id 	== "c_off" then
			if ent:GetClass() == "custom_printer_white" then return end
			ent:RemoveCooler()
		end 
	end)
end
AddCSLuaFile("realprinters_config.lua")
include("realprinters_config.lua")