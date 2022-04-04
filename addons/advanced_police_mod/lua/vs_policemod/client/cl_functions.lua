--[[
	GUI
]]

local tablet_material
local CFG = VS_PoliceMod.Config
local font = KVS.GetFont
local config = KVS.GetConfig

VS_PoliceMod.NotifList = {}

local MATERIALS = {
    [ "background" ] = Material( "materials/police_mod/background.jpg" ),
    [ "wifi" ] = Material( "materials/police_mod/wireless-signal.png" ),
    [ "blueetooth" ] = Material( "materials/police_mod/blueetooth-logo.png" ),
    [ "battery" ] = Material( "materials/police_mod/battery.png" )
}
local matFBI = Material("materials/police_mod/fbi.png")
local iconSizeBlackBar = 16
local blackBarBorders = 20
local blackBarSize = 25
local cBlue45 = ColorAlpha(KVS.GetConfig("vgui.color.info"), 45)
local iBlueBack = Color(1, 55, 99, 255)

VS_PoliceMod.Apps = VS_PoliceMod.Apps or {}

function VS_PoliceMod:RegisterApp(App)
	VS_PoliceMod.Apps[App.Name] = {Icon = App.Icon, Open = App.Open}
end

function VS_PoliceMod:OpenTablet(eTablet, topleft, bottomright )

	local selected_categories = {}
	local CenterMenu
	
	if ( topleft and not topleft.visible ) or ( bottomright and not bottomright.visible ) then
		topleft, bottomright = nil, nil
	end
	
	local tablet_sizex, tablet_sizey = 840, 530
	local tablet_posx, tablet_posy = ScrW() / 2 - tablet_sizex / 2, ScrH() / 2 - tablet_sizey / 2
	if topleft then
		tablet_sizex, tablet_sizey = bottomright.x - topleft.x, bottomright.y - topleft.y
		tablet_posx, tablet_posy = topleft.x, topleft.y
		
		if tablet_sizex < 100 or tablet_sizey <  100 then
			topleft, bottomright = nil, nil
			tablet_sizex, tablet_sizey = 840, 530
			tablet_posx, tablet_posy = ScrW() / 2 - tablet_sizex / 2, ScrH() / 2 - tablet_sizey / 2
		end
	end
	local animationTime = 0.5

	tablet_posx = tablet_posx - ScrW() * 0.0015

	local LeftMenu_LeaveButton

	local MainFrame = vgui.Create( "EditablePanel" )
	if topleft then
		MainFrame:SetPos( topleft.x, topleft.y )
	else
		tablet_material = tablet_material or Material( "materials/cardealer/background_tablet.png" )
		MainFrame:SetPos( ScrW() / 2, ScrH() / 2 )
	end
	MainFrame:SetPos( tablet_posx, tablet_posy, animationTime )
	MainFrame:SetSize( tablet_sizex, tablet_sizey, animationTime )
	MainFrame:SetAlpha(0)
	MainFrame:AlphaTo( 255, animationTime )
	MainFrame:MakePopup()
	MainFrame.intNextEscape = 0
	function MainFrame:Paint( w, h )
		if not topleft then
			surface.SetDrawColor( color_white )
			surface.SetMaterial( tablet_material )
			surface.DrawTexturedRect( 0, 0, w, h )
		end

		if self.intNextEscape > CurTime() then return end
		if input.IsKeyDown(KEY_ESCAPE) then
			LeftMenu_LeaveButton:DoClick()
			gui.HideGameUI()
			self.intNextEscape = CurTime() + 0.2
		end
	end

	local ContentPanel = vgui.Create( "DPanel", MainFrame )
	if topleft then
		ContentPanel:SetPos( 0, 0 )
		ContentPanel:SetSize( tablet_sizex, tablet_sizey )
	else
		ContentPanel:SetPos( 77 / 2, 78 / 2 )
		ContentPanel:SetSize( tablet_sizex - 77, tablet_sizey - 78 )
	end
	function ContentPanel:Paint(w, h)
		surface.SetDrawColor( iBlueBack )
		surface.DrawRect(0, 0, w, h)

		-- surface.SetDrawColor( 255, 255, 255, 20 )
        -- surface.SetMaterial( MATERIALS[ "background" ]    )
        -- surface.DrawTexturedRect( 0, 0, w, h )

		if self.bDrawFBI then
			surface.SetDrawColor( color_white )
			surface.SetMaterial( matFBI )
			surface.DrawTexturedRect( w * 0.5 - 90, (h - 25) * 0.5 + 25 - 90, 180, 180 )
		end

        draw.RoundedBox( 0, 0, 0, w, blackBarSize, Color( 20, 20, 20, 255 ) )
        
        surface.SetDrawColor( color_white )
        surface.SetMaterial( MATERIALS[ "battery" ] )
        surface.DrawTexturedRect( w - blackBarBorders - iconSizeBlackBar, ( blackBarSize - iconSizeBlackBar ) / 2, iconSizeBlackBar, iconSizeBlackBar )
        
        surface.SetDrawColor( color_white )
        surface.SetMaterial( MATERIALS[ "blueetooth" ] )
        surface.DrawTexturedRect( w - blackBarBorders - iconSizeBlackBar * 2 - 4, ( blackBarSize - iconSizeBlackBar ) / 2, iconSizeBlackBar, iconSizeBlackBar )
        
        surface.SetDrawColor( color_white )
        surface.SetMaterial( MATERIALS[ "wifi" ] )
        surface.DrawTexturedRect( w - blackBarBorders - iconSizeBlackBar * 3 - 4 * 2, ( blackBarSize - iconSizeBlackBar ) / 2, iconSizeBlackBar, iconSizeBlackBar )

        local TimeString = os.date( "%H:%M - %m/%d/%Y" , Timestamp )

        draw.SimpleText( VS_PoliceMod:L("GovernmentNetwork"), font("Rajdhani", 17), blackBarBorders + 30, blackBarSize / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( TimeString, font("Rajdhani", 17), w - blackBarBorders - iconSizeBlackBar * 4 - 4 * 3, ( blackBarSize - iconSizeBlackBar ) / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
	end

	local IconLayout = vgui.Create("DIconLayout", ContentPanel)
	IconLayout:SetSize(ContentPanel:GetWide() - 20, ContentPanel:GetTall() - 20 - 25)
	IconLayout:SetPos(10, 25 + 10)
	IconLayout:SetSpaceX(5)
	IconLayout:SetSpaceY(5)

	local appFont = font("R", MainFrame:GetTall() * 0.0375)
	local iconFont = font("FAS", MainFrame:GetTall() * 0.06, "extended")
	local iconFontHover = font("FAS", MainFrame:GetTall() * 0.07, "extended")

	for k, v in pairs(VS_PoliceMod.Apps) do
		local pnlApp = IconLayout:Add("DButton")
		pnlApp:SetSize(IconLayout:GetWide() * 0.16, IconLayout:GetTall() * 0.18)
		pnlApp:SetText("")
		local tblAppName = string.Explode("\n", DarkRP.textWrap(v.Name or k, appFont, pnlApp:GetWide()))
		function pnlApp:Paint(intW, intH)
			draw.SimpleText(v.Icon, self:IsHovered() and iconFontHover or iconFont, intW * 0.5, intH * 0.25, color_white, 1, 1)

			for k, v in pairs(tblAppName) do
				draw.SimpleText(v, appFont, intW * 0.5, intH * 0.65 + (k-1) * (intH * 0.18), color_white, 1, 1)
			end
		end
		function pnlApp:DoClick()
			if IsValid(ContentPanel.PanelApp) then return end

			surface.PlaySound("buttons/button15.wav")

			local pnlApp = vgui.Create("DPanel", ContentPanel)
			function pnlApp:Paint()end
			v:Open(pnlApp, ContentPanel:GetWide(), ContentPanel:GetTall() - 25)
			pnlApp.CameFromX, pnlApp.CameFromY = ContentPanel:ScreenToLocal(gui.MousePos())
			pnlApp:SetPos(pnlApp.CameFromX, pnlApp.CameFromY)
			pnlApp:SetSize(0, 0)
			pnlApp:SizeTo(ContentPanel:GetWide(), ContentPanel:GetTall() - 25, 0.3)
			pnlApp:MoveTo(0, 25, 0.3)
			pnlApp:SetAlpha(0)
			pnlApp:AlphaTo(255, 0.3)
			ContentPanel.PanelApp = pnlApp
		end
	end

	LeftMenu_LeaveButton = vgui.Create( "DButton", ContentPanel )
	LeftMenu_LeaveButton:SetText( "" )
	LeftMenu_LeaveButton:SetSize(25, 25)
	LeftMenu_LeaveButton:SetPos(blackBarBorders, 0)
	function LeftMenu_LeaveButton:Paint( w, h )
		draw.SimpleText( IsValid(ContentPanel.PanelApp) && utf8.char( 0xf0e2 ) || utf8.char( 0xf011 ), font("FAS", 15, "extended"), w / 2, h / 2,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	function LeftMenu_LeaveButton:DoClick()
		if IsValid( MainFrame ) then
			if IsValid(ContentPanel.PanelApp) then
				local pnlApp = ContentPanel.PanelApp
				pnlApp:SizeTo(0, 0, 0.3, 0, -1, function()
					if IsValid(pnlApp) then pnlApp:Remove() end
				end)
				pnlApp:MoveTo(pnlApp.CameFromX, pnlApp.CameFromY, 0.3)
				pnlApp:AlphaTo(0, 0.3)
			else
				MainFrame:AlphaTo( 0, 0.9, 0, function()
					if IsValid( eTablet ) and eTablet:IsWeapon() and IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon() == eTablet then eTablet:Unfocus() end
					if IsValid(MainFrame) then
						MainFrame:Remove()
					end
				end )
			end
		end
	end

	IconLayout:SetVisible(false)

	local dLock = vgui.Create("DPanel", ContentPanel)
	dLock:SetSize(200, 117)
	dLock:SetPos(ContentPanel:GetWide() * 0.5 - dLock:GetWide() * 0.5, (ContentPanel:GetTall() - 25) * 0.5 + 25 - dLock:GetTall() * 0.5)
	dLock.Paint = nil

	local dAvatar = vgui.Create("KVS.AvatarImage", dLock)
	dAvatar:SetSize(64, 64)
	dAvatar:SetPlayer(LocalPlayer(), 128)
	dAvatar:SetType("circle")
	dAvatar:SetPos(dLock:GetWide() * 0.5 - dAvatar:GetWide() * 0.5, 0)

    local dPassword = vgui.Create("KVS.Input", dLock)
    dPassword:SetSize(dLock:GetWide(), 32)
	dPassword:SetPos(0, 85)
	dPassword.Input:SetDisabled(true)
	timer.Create("PMod_" .. tostring(dPassword), 0.1, 8, function()
		if not IsValid(dPassword) then return end
		dPassword:SetText(dPassword:GetText() .. "● ")
	end)
	surface.PlaySound("ambient/machines/keyboard_fast1_1second.wav")

    dPassword:Append( utf8.char(0xf2f6), nil, nil, function()
		if LocalPlayer():PM_IsPolice() then
			IconLayout:SetVisible(true)
			IconLayout:SetAlpha(0)
			IconLayout:AlphaTo(255, 0.2)
			dLock:AlphaTo(0, 0.2)
			dLock:MoveTo(ContentPanel:GetWide() * 0.5 - dLock:GetWide() * 0.5, ContentPanel:GetTall() * 0.5 - dLock:GetTall() * 0.5 + 30, 0.2, 0, -1, function()
				if IsValid(dLock) then dLock:Remove() end
			end)
			ContentPanel.bDrawFBI = true
			surface.PlaySound("buttons/button9.wav")
		else
			surface.PlaySound("buttons/button10.wav")
		end
	end)
    dPassword.AppendItem:SetAutoSize(false)
    dPassword.AppendItem:SetFont(font("FAS", 14, "extended"))
    dPassword.AppendItem:SetSize(40, 30)
    dPassword.AppendItem:SetColor(KVS.GetConfig("vgui.color.black_hard"))
end

function VS_PoliceMod:Notify(sMessage, iLength)
	iLength = tonumber( iLength ) or 10

	surface.SetFont(font("Rajdhani", 23))
	local w = surface.GetTextSize(sMessage)

	table.insert(VS_PoliceMod.NotifList, {sMsg = sMessage, iEnd = CurTime() + iLength, iW = w, y = ScrH(), iA = w})

	if not hook.GetTable()["HUDPaint"]["VS_PoliceMod.Notif:HUDPaint"] then
		hook.Add("HUDPaint", "VS_PoliceMod.Notif:HUDPaint", function()
			for k, v in pairs(VS_PoliceMod.NotifList) do
				v.x, v.y = ScrW() / 2 - (v.iW or 0) / 2, Lerp(RealFrameTime() * 8, v.y, CurTime() > v.iEnd and ScrH() + 10 or ScrH() - 50 * k)

				v.iA = Lerp(RealFrameTime() * 5, v.iA, 40)

				if v.y > ScrH() && CurTime() > v.iEnd then
					table.remove(VS_PoliceMod.NotifList, k)
					if #VS_PoliceMod.NotifList == 0 then
						hook.Remove("HUDPaint", "VS_PoliceMod.Notif:HUDPaint")
					end
				end

				surface.SetDrawColor(KVS.GetConfig("vgui.color.black"))
				surface.DrawRect(v.x, v.y, v.iW + 70, 40)
				surface.SetDrawColor(cBlue45)
				surface.DrawRect(v.x, v.y, v.iA, 40)
				draw.SimpleText(v.sMsg, font("Rajdhani", 23), v.x + 15 + 40, v.y + 20, color_white, 0, 1)
				draw.SimpleText(utf8.char(0xf0a1), font("FAS", 16, "extended"), v.x + 12, v.y + 20, color_white, 0, 1)
			end
		end)
	end
end

function VS_PoliceMod:GetCops()
	local cops = {}

	for _, pPlayer in pairs( player.GetAll() ) do
		if pPlayer:PM_IsPolice() then
			cops[ pPlayer ] = true
		end
	end

	return cops
end

function VS_PoliceMod:DisplayHelpCallMenu()
    local dFrame = vgui.Create( "KVS.Frame", dParent )
    dFrame:SetSize(500, 225)
    dFrame:Center()
    dFrame:SetBorder( false )
    dFrame:MakePopup()
    dFrame:SetUseAnimation( false )
    dFrame:SetAlpha(0)
    dFrame:AlphaTo(255, 0.2)
    dFrame:SetTitle( VS_PoliceMod:L("CallHelp") )
    dFrame:SetSubTitle( VS_PoliceMod:L("AskHelp"))

	local dCat = vgui.Create("KVS.ComboBox", dFrame)
	dCat:Dock(TOP)
	dCat:DockMargin(15, 15, 15, 0)
	dCat:SetSortItems(false)
	for k, v in pairs(VS_PoliceMod.Config.CallsReason) do
		dCat:AddChoice(v, k, true)
	end

	local dDescription = vgui.Create("KVS.Input", dFrame)
	dDescription:Dock(TOP)
	dDescription:DockMargin(15, 15, 15, 0)
	dDescription:SetPlaceholderText(VS_PoliceMod:L("ShortDesc"))
    dDescription.OnTextChanged = function(self)
        local txt = self.Input:GetValue()
        local amt = string.len(txt)
        if amt > 150 then
            self.Input:SetText(self.Input.OldText)
            self.Input:SetValue(self.Input.OldText)
        else
            self.Input.OldText = txt
        end
    end

	local dSend = vgui.Create("KVS.Button", dFrame)
	dSend:Dock(TOP)
	dSend:DockMargin(15, 15, 15, 0)
	dSend:SetText(VS_PoliceMod:L("Send"))
	dSend:WithIcon(font("FAS", 23, "extended"), 0xf3ed)
	function dSend:DoClick()
		VS_PoliceMod:NetStart("OnMissionSent", {cat = tonumber(dCat:GetOptionData(dCat:GetSelectedID())), desc = tostring(dDescription:GetText())})

		dFrame:AlphaTo(0, 0.2, 0, function()
			if IsValid(dFrame) then dFrame:Remove() end
		end)
		dFrame:MoveTo(ScrW() * 0.5 - dFrame:GetWide() * 0.5, ScrH() * 0.5 - dFrame:GetTall() * 0.5 + 40, 0.2)
	end
end

function VS_PoliceMod:DisplayFine( tData )
	local size_x = 300
	local size_y = 30 + 10 + 25 + 30 * table.Count( tData.reasons ) + 40 + 30
	local endTime = CurTime() + CFG.FineDelay

	local fineFrame = vgui.Create( "KVS.Frame" )
	fineFrame:SetSize( size_x, size_y )
	fineFrame:SetBorder( false )
	fineFrame:SetUseAnimation( false )
	fineFrame:ShowCloseButton( true )
	fineFrame:SetTitle( VS_PoliceMod:L("Fine") )
	fineFrame:SetPos( ScrW() - size_x - 10, 50 )
	function fineFrame:Think()
		fineFrame:SetSubTitle( VS_PoliceMod:L("TimeLeft") .. " : " .. math.Round( endTime - CurTime() ) )
		if CurTime() > endTime then
			fineFrame:Close()
		end
	end
	function fineFrame:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard") )
	end

	local finePanel = vgui.Create( "KVS.ScrollPanel", fineFrame )
	finePanel:Dock( FILL )

	local fineSlide
	local fineReason = vgui.Create( "DLabel", finePanel )
	fineReason:Dock( TOP )
	fineReason:DockMargin( 10, 10, 10, 0 )
	fineReason:SetFont( font("Rajdhani Bold", 20 ) )
	fineReason:SetText( VS_PoliceMod:L("Reasons") .. " :" )
	fineReason:SetContentAlignment( 4 )

	local fineReasons = tData.reasons or {}

	for sReason, tInfos in pairs( fineReasons ) do
		local fineReason = vgui.Create( "DLabel", finePanel )
		fineReason:Dock( TOP )
		fineReason:DockMargin( 15, 5, 10, 0 )
		fineReason:SetFont( font("Rajdhani", 20) )
		fineReason:SetText( sReason )
		fineReason:SetContentAlignment( 4 )
	end

	local finePrice = vgui.Create( "DLabel", finePanel )
	finePrice:Dock( TOP )
	finePrice:DockMargin( 10, 10, 10, 0 )
	finePrice:SetFont( font("Rajdhani Bold", 20 ) )
	finePrice:SetText( VS_PoliceMod:L("Price") .. " : " .. DarkRP.formatMoney( tData.price ) )
	finePrice:SetContentAlignment( 4 )

	local panelPayFine = vgui.Create( "KVS.Panel", fineFrame )
	panelPayFine:Dock( BOTTOM )
	panelPayFine:SetTall( 30 )

	local payFine = vgui.Create( "KVS.Button", panelPayFine )
	payFine:Dock( LEFT )
	payFine:SetWide( size_x / 2 )
	payFine:SetText( VS_PoliceMod:L("PAY") )
	payFine:SetFont( font( 'Rajdhani Bold', 20 ) )
	payFine:SetColor( config( "vgui.color.accept_green" ) )
	payFine:SetBorder( false, false, true, false )
	payFine:WithIcon( font( 'FAS', 20, 'extended' ), 0xf4c0 )
	function payFine:DoClick()
		fineFrame:Remove()
		VS_PoliceMod:NetStart( "AnswerContravention", { paid = true } )
	end

	local refuseFine = vgui.Create( "KVS.Button", panelPayFine )
	refuseFine:Dock( RIGHT )
	refuseFine:SetWide( size_x / 2 )
	refuseFine:SetText( VS_PoliceMod:L("REFUSE") )
	refuseFine:SetFont( font( 'Rajdhani Bold', 20 ) )
	refuseFine:SetColor( config( "vgui.color.warning" ) )
	refuseFine:WithIcon( font( 'FAS', 20, 'extended' ), 0xf057 )
	refuseFine:SetBorder( false, false, false, true )
	function refuseFine:DoClick()
		fineFrame:Remove()
		VS_PoliceMod:NetStart( "AnswerContravention", { paid = false } )
	end
end

function VS_PoliceMod:DisplayOfficerMenu(tBails, npc)
    local dFrame = vgui.Create( "KVS.Frame" )
    dFrame:SetSize(400, 160)
    dFrame:Center()
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("Choose") )
    dFrame:MakePopup()
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf128, color_white )
	function dFrame:Paint(w, h)
		Derma_DrawBackgroundBlur( dFrame, self.startTime )
		draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard"))
	end

	local btnComplaints = vgui.Create("KVS.Button", dFrame)
	btnComplaints:Dock(TOP)
	btnComplaints:SetTall(40)
	btnComplaints:DockMargin(10, 10, 10, 0)
	btnComplaints:SetText(VS_PoliceMod:L("MakeComplaint"))
	btnComplaints:SetFont(font("Rajdhani Bold", 20))
	btnComplaints:WithIcon(font("FAS", 18, "extended"), 0xf0c5)
	function btnComplaints:DoClick()
		VS_PoliceMod:DisplayComplaintMenu(npc)
		dFrame:Remove()
	end

	local btnBails = vgui.Create("KVS.Button", dFrame)
	btnBails:Dock(TOP)
	btnBails:SetTall(40)
	btnBails:DockMargin(10, 10, 10, 0)
	btnBails:SetText(VS_PoliceMod:L("Bails"))
	btnBails:SetFont(font("Rajdhani Bold", 20))
	btnBails:WithIcon(font("FAS", 18, "extended"), 0xf155)
	function btnBails:DoClick()
		VS_PoliceMod:DisplayBailsMenu(tBails, npc)
		dFrame:Remove()
	end
end

--[[
	META PLAYER
]]

local metaPlayer = FindMetaTable( "Player" )

--[[
	I let this global so it can be used by other scripts if they want to
]]

function metaPlayer:Lock()
	self.IsLocked = true
end

function metaPlayer:UnLock()
	self.IsLocked = false
end

hook.Add( "CreateMove", "PlayerLock.CreateMove", function( oCmd )
	if LocalPlayer().IsLocked then
		oCmd:ClearButtons()
		oCmd:ClearMovement()

		oCmd:SetMouseX( 0 )
		oCmd:SetMouseY( 0 )
	end
end )

hook.Add( "InputMouseApply", "PlayerLock.InputMouseApply", function( oCmd )
	if LocalPlayer().IsLocked then
		oCmd:SetMouseX(0)
		oCmd:SetMouseY(0)
		return true
	end
end )
