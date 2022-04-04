include('shared.lua')


surface.CreateFont( "CFont", { font = "Arial", size = 21, weight = 1000, antialias = true, } )

surface.CreateFont( "CFont2", { font = "Arial", size = 16, antialias = true, } )

surface.CreateFont( "CFont3", { font = "Arial", size = 22, weight = 1000, antialias = true, } )

surface.CreateFont( "CFont4", { font = "Arial", size = 16, weight = 1000, antialias = true, } )

surface.CreateFont( "weapondealertitle", { font = "Arial", size = 70, weight = 1000, antialias = true } )


local blur = Material 'pp/blurscreen' function drawBlur( pan, amt ) local x, y = pan:LocalToScreen( 0, 0 ) surface.SetDrawColor( 255, 255, 255 ) surface.SetMaterial( blur ) for i = 1, 3 do blur:SetFloat( '$blur', ( i / 3 ) * ( amt or 6 ) ) blur:Recompute(  ) render.UpdateScreenEffectTexture(  ) surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() ) end end

local surface = surface;
local Color = Color;
local LocalPlayer = LocalPlayer
local draw = draw;
local vgui = vgui;
local gui = gui;
local white = Color(255,255,255)
local white2 = Color(255,255,255)
local la = Color(0,0,12,150)
local bunt = ( HSVToColor(  ( CurTime() * 120 ) % 360, 1, 1 ) )

local blure = Material("pp/blurscreen")

net.Receive("DermaDesign", function(len, ply)

	function blurPanel(p, a, h)
		local x, y = p:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(blure)
		for i = 1, (h or 12) do
			blure:SetFloat("$blure", (i/3)*(a or 6))
			blure:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x*-1,y*-1,scrW,scrH)
		end
end
	local money = DarkRP.formatMoney((LocalPlayer():getDarkRPVar("money") || 0)) //
	local frame = vgui.Create( "DFrame")
	frame:SetSize(1300,1000)
	frame:MakePopup()
	frame:Center()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function(self, w, h)
	frame:SetDraggable( false )
	

    frame.startTime = SysTime()
	Derma_DrawBackgroundBlur(frame, frame.startTime)
	

	

		if NpcShop_Config.Config_Blur then --		if NpcShop_Config.Config_Blur == true then
			drawBlur(self , 5)
		else
			draw.RoundedBox(12,0,0,w , h * 1, NpcShop_Config.Config_ColorTwo )
			draw.RoundedBox(0,0,0,w * 0.2 , h * 1, NpcShop_Config.Config_ColorThree )
			draw.RoundedBox(0,w * 0,0,w * 0.19 , h * 0.9, NpcShop_Config.Config_ColorOne )
			draw.RoundedBox(0,w * 0.0,h * 0.98,w * 1 , h * 0.02, NpcShop_Config.Config_ColorThree )
			draw.RoundedBox(0,w * 0.0,h * 0.06,w * 1 , h * 0.02, NpcShop_Config.Config_ColorThree )			--hier
			//draw.RoundedBox(0,0,0,w * 0.01 , h * 1, NpcShop_Config.Config_ColorThree ) -- THIS SUCKS
			draw.SimpleText(money, "CFont3", w * 0.1, h * 0.925, Color(30, 255, 30), TEXT_ALIGN_CENTER )
			draw.SimpleText(NpcShop_Config.Lang_SomeText, "CFont4", w * 0.6, h * 0.935, Color(255, 255, 255), TEXT_ALIGN_CENTER )
		end

		draw.RoundedBox(0,0,0,w , h / 15, NpcShop_Config.Config_ColorOne )
	end

	local closeButton = vgui.Create("DButton" , frame)
	closeButton:SetPos(1246.375,0) --1,625
	closeButton:SetSize(55,66)
	closeButton:SetText("X")
	closeButton:SetFont("CFont")
	closeButton:SetTextColor(white)
	closeButton.DoClick = function()
		frame:Close()
			surface.PlaySound("buttons/button14.wav")
	end
	closeButton.Paint = function(s , w , h)
		if closeButton:IsHovered() then
			draw.RoundedBox(0,0,0,w , h, Color(255, 30, 30) )
			
		else
			draw.RoundedBox(0,0,0,w , h, NpcShop_Config.Config_ColorOne )
		end
	end
	closeButton.OnCursorEntered = function()
		surface.PlaySound("UI/buttonrollover.wav")
	end

	local Scroll = vgui.Create( "DScrollPanel", frame )
	Scroll:SetSize(1250,800)
	Scroll:Center()

	local sbar = Scroll:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, la )
	end
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, NpcShop_Config.Config_ColorOne )
	end
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, NpcShop_Config.Config_ColorOne )
	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, NpcShop_Config.Config_ColorOne )
	end


	Scroll.Button = {}
	Scroll.Text = {}
	Scroll.Desc = {}
	Scroll.Prix = {}
	Scroll.Model = {}

	local espace = 100
	local nothing = 0

	for k,v in pairs(ItemShop) do

		local Pos = 0

		Scroll.Button[k] = vgui.Create( "DButton", Scroll )
		Scroll.Button[k]:SetPos( 1100,45 + espace * nothing)
		Scroll.Button[k]:SetText(NpcShop_Config.Lang_Buy)
		Scroll.Button[k]:SizeToContents()
		Scroll.Button[k]:SetSize( 100, 25 )
		Scroll.Button[k]:SetFont("CFont3")
		Scroll.Button[k].Paint = function(s , w , h)
		

			if Scroll.Button[k]:IsHovered() then
			if NpcShop_Config.Config_NeedGunlicense == true and LocalPlayer():getDarkRPVar("HasGunlicense") then 
				draw.RoundedBox(8,0,0, w , h , Color(30, 255, 30) )
				else
				draw.RoundedBox(8,0,0, w , h , Color(255, 30, 30) )
			end
				
				Scroll.Button[k]:SetTextColor(white)
			else
				draw.RoundedBox(8,0,0, w , h , NpcShop_Config.Config_ColorThree )
				Scroll.Button[k]:SetTextColor(white2)
			end

		end
		Scroll.Button[k].OnCursorEntered = function()
		if NpcShop_Config.Config_NeedGunlicense == true and LocalPlayer():getDarkRPVar("HasGunlicense") then 
			surface.PlaySound("UI/buttonrollover.wav") -- buttons/button15.wav
			else
			surface.PlaySound("UI/buttonrollover.wav") -- buttons/button15.wav
			end
		end



		if LocalPlayer().DarkRPVars.money < ItemShop[k].Price then --hier2 
			Scroll.Button[k]:SetText(NpcShop_Config.Lang_NoMoney)
			Scroll.Button[k]:SetFont("CFont2")
			Scroll.Button[k]:SetTextColor(white)
			Scroll.Button[k]:SetDisabled(true)
			Scroll.Button[k].Paint = function(s , w , h)
				draw.RoundedBox(8,0,0, w , h ,Color(255, 30 , 30) )
			end
		end

		Scroll.Button[k].DoClick = function()
			
			
		if NpcShop_Config.Config_NeedGunlicense == false or (NpcShop_Config.Config_NeedGunlicense == true and LocalPlayer():getDarkRPVar("HasGunlicense")) then

			local kkstr = tostring(k)
			surface.PlaySound("button_sound/tg_purchase_button.wav")
				
			net.Start("buy")
				net.WriteString(kkstr)
							--if ( Entity( 1 ):HasWeapon( ?????????? ) ) then return end -- check if player has allreday a weapon
				net.SendToServer()
					frame:Close()
						chat.AddText( NpcShop_Config.Config_ColorOne, "[INFO] ", Color( 255, 255, 255 ), NpcShop_Config.Lang_madeABuy, Color(255, 255, 255), ""..ItemShop[k].Name ) --hier
				else
					surface.PlaySound("buttons/button10.wav")
						--for i, ply in ipairs( player.GetAll() ) do --ERROR
					chat.AddText( NpcShop_Config.Config_ColorOne, "[INFO] ", Color( 255, 255, 255 ), NpcShop_Config.Lang_YouNeedLicense )
				--end --ERROR
					
			end
		end
		
		Scroll.Text[k] = vgui.Create("DLabel" , Scroll)
		Scroll.Text[k]:SetPos(150,25 + espace * nothing)
		Scroll.Text[k]:SetText(NpcShop_Config.Lang_Name..ItemShop[k].Name)
		Scroll.Text[k]:SetFont("CFont")
		Scroll.Text[k]:SizeToContents()

		Scroll.Desc[k] = vgui.Create("DLabel" , Scroll)
		Scroll.Desc[k]:SetPos(150,65 + espace * nothing)
		Scroll.Desc[k]:SetTextColor( Color( 155, 155, 155) )
		Scroll.Desc[k]:SetText(NpcShop_Config.Lang_YouNeedTyp..ItemShop[k].Desc)
		Scroll.Desc[k]:SetFont("CFont4")
		Scroll.Desc[k]:SizeToContents()

		Scroll.Prix[k] = vgui.Create("DLabel" , Scroll)
		Scroll.Prix[k]:SetPos(150,45 + espace * nothing)
		Scroll.Prix[k]:SetTextColor( Color( 30, 255, 30) )
		Scroll.Prix[k]:SetText(NpcShop_Config.Lang_Price..ItemShop[k].Price.."$")
		Scroll.Prix[k]:SetFont("CFont")
		Scroll.Prix[k]:SizeToContents()

		Scroll.Model[k] = vgui.Create("SpawnIcon" , Scroll) --Label:SizeToContents()
		Scroll.Model[k]:SetPos(-35,-70 + espace * nothing) 
		Scroll.Model[k]:SetSize(250, 250)
		Scroll.Model[k]:SetModel(ItemShop[k].Model)
		Scroll.Model[k].PaintOver = function(self) end


		Pos = Pos +1
		nothing = nothing +1

	end

end)



