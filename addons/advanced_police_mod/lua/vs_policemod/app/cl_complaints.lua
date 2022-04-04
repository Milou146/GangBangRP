local App = {}

App.Name = VS_PoliceMod:L("Complaints")
App.Icon = utf8.char( 0xf0c5 )

local font = KVS.GetFont
local config = KVS.GetConfig

local addComplaint = function() end
local removeComplaint = function() end

function App:Open(pnl, w, h)
    local dLoading

    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("Complaints") )
    dFrame:SetSubTitle( VS_PoliceMod:L("ManageAllComplaints") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf0c5, color_white )

    local dNav = vgui.Create("DPanel", dFrame)
    dNav:Dock(TOP)
    dNav:DockMargin(10, 10, 10, 10)
    dNav:SetTall(40)
    dNav.Paint = nil

    local dOpenedCases = vgui.Create("KVS.Button", dNav)
    dOpenedCases:Dock(LEFT)
    dOpenedCases:SetWide(w * 0.5 - 15)
    dOpenedCases:SetText(VS_PoliceMod:L("OpenedCases"))
    dOpenedCases:SetFont(font("Rajdhani Bold", 23))
    dOpenedCases:SetColor(config("vgui.color.black"))

    local dClosedCases = vgui.Create("KVS.Button", dNav)
    dClosedCases:Dock(RIGHT)
    dClosedCases:SetWide(w * 0.5 - 15)
    dClosedCases:SetText(VS_PoliceMod:L("ClosedCases"))
    dClosedCases:SetFont(font("Rajdhani Bold", 23))
    dClosedCases:SetColor(config("vgui.color.black"))
    
    local dList = vgui.Create("KVS.ScrollPanel", dFrame)
    dList:Dock(FILL)
    dList:DockMargin(10, 0, 10, 10)
    dList:InvalidateParent(true)
    dList:InvalidateLayout(true)

    local iNextClick = 0

    function dOpenedCases:DoClick()
        if iNextClick > CurTime() then
            VS_PoliceMod:Notify(VS_PoliceMod:L("WaitBeforeThat"), 5)
            return
        end

        VS_PoliceMod:NetStart("OnAskForComplaints", {state = false})
        dOpenedCases:SetText("- " .. VS_PoliceMod:L("OpenedCases") .. " -")
        dClosedCases:SetText(VS_PoliceMod:L("ClosedCases"))
        
        dLoading:SetVisible(true)
        dList:SetVisible(false)

        iNextClick = CurTime() + 2
    end

    function dClosedCases:DoClick()
        if iNextClick > CurTime() then
            VS_PoliceMod:Notify(VS_PoliceMod:L("WaitBeforeThat"), 5)
            return
        end

        VS_PoliceMod:NetStart("OnAskForComplaints", {state = true})
        dOpenedCases:SetText( VS_PoliceMod:L("OpenedCases") )
        dClosedCases:SetText("- " .. VS_PoliceMod:L("ClosedCases") .. " -")

        dLoading:SetVisible(true)
        dList:SetVisible(false)

        iNextClick = CurTime() + 2
    end

    addComplaint = function(t)
        if not IsValid(dFrame) then return end

        dLoading:SetVisible(false)
        dList:SetVisible(true)
        dList:Clear()

        dList.VBar:AnimateTo(0, 0.25)
        for k, data in pairs(t or {}) do
            data.state = tonumber(data.state)
            local dCase = vgui.Create("KVS.Panel", dList)
            dCase:Dock(TOP)
            dCase:DockMargin(0, 0, 0, 10)
            dCase:SetTall(40)
            dCase.complaintID = data.id
            function dCase:Paint(iW, iH)
                surface.SetDrawColor(config("vgui.color.black"))
                surface.DrawRect(0, 0, iW, iH)
            end

            local dContent = vgui.Create("DPanel", dCase)
            dContent:Dock(TOP)
            dContent:DockMargin(0, 0, 0, 10)
            dContent:SetTall(40)
            function dContent:Paint(iW, iH)
                draw.SimpleText(utf8.char(0xf15b), font("FAS", 18, "extended"), 15, iH * 0.5, color_white, 0, 1)
                draw.SimpleText(data.citizen .. " - " .. data.category, font("Rajdhani", 20), 40, iH * 0.5, color_white, 0, 1)
            end

            local dLockToggle = vgui.Create("KVS.ButtonIcon", dContent)
            dLockToggle:Dock(RIGHT)
            dLockToggle:SetWide(40)
            dLockToggle:SetIcon( font("FAS", 18, "extended"), data.state == 1 and 0xf09c or 0xf023, data.state == 1 and config("vgui.color.accept_green") or config("vgui.color.danger") )
            dLockToggle:SetAlignement(5)
            dLockToggle:AddTooltip(data.state == 1 and VS_PoliceMod:L("Open") or VS_PoliceMod:L("Close"))
            dLockToggle.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
            function dLockToggle:DoClick()
                VS_PoliceMod:NetStart("OnUpdateComplaintState", {id = data.id, state = tonumber(data.state)})
            end

            local dViewMore = vgui.Create("KVS.ButtonIcon", dContent)
            dViewMore:Dock(RIGHT)
            dViewMore:SetWide(40)
            dViewMore:SetIcon( font("FAS", 18, "extended"), 0xf129, config("vgui.color.primary") )
            dViewMore:SetAlignement(5)
            dViewMore:AddTooltip(VS_PoliceMod:L("ViewMore"))
            dViewMore.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
            function dViewMore:DoClick()
                if dCase.IsOpening then return end
                dCase.IsOpening = true
                dCase:SizeTo(dList:GetWide(), dCase:GetTall() == 180 and 40 or 180, 0.25, 0, -1, function()
                    dCase.IsOpening = false
                end)
            end

            local dContent = vgui.Create("DLabel", dCase)
            dContent:Dock(TOP)
            dContent:SetTall(180 - 40)
            dContent:SetText(data.content)
            dContent:SetContentAlignment(7)
            dContent:DockMargin(10, 0, 10, 10)
            dContent:SetWrap(true)
            dContent:SetFont(font("Rajdhani", 16))
        end
    end

    removeComplaint = function(id)
        for k, v in pairs(dList:GetChildren()[1]:GetChildren()) do
            if v.complaintID and v.complaintID == id then
                v:SizeTo(dList:GetWide(), 0, 0.25, 0, -1, function()
                    if IsValid(v) then v:Remove() end
                end)
            end
        end
    end

    dLoading = vgui.Create("DPanel", dFrame)
    dLoading:SetSize(40, 32)
    dLoading:SetPos(w * 0.5 - 16, h * 0.5 - 16)
    dLoading:SetVisible(false)
    function dLoading:Paint(w, h)
        for i = 0, 2 do
            draw.RoundedBox(4, i * 16, h - 8 - math.Clamp(math.sin((CurTime() - 0.3 * i) * 4), 0, 1) * 20, 8, 8, color_white)
        end
    end

    dOpenedCases:DoClick()
end

VS_PoliceMod:RegisterApp(App)

function VS_PoliceMod:DisplayComplaintMenu(npc)
    local dFrame = vgui.Create( "KVS.Frame", dParent )
    dFrame:SetSize(500, 300)
    dFrame:Center()
    dFrame:SetBorder( false )
    dFrame:MakePopup()
    dFrame:SetUseAnimation( false )
    dFrame:SetTitle( VS_PoliceMod:L("Complaint") )
    dFrame:SetSubTitle( VS_PoliceMod:L("MakeComplaint") )
	function dFrame:Paint(w, h)
		Derma_DrawBackgroundBlur( dFrame, self.startTime )
		draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard"))
	end

	local dCat = vgui.Create("KVS.ComboBox", dFrame)
	dCat:Dock(TOP)
	dCat:DockMargin(15, 15, 15, 0)
	dCat:SetSortItems(false)
	for k, v in pairs(VS_PoliceMod.Config.ComplaintsReasons) do
		dCat:AddChoice(v, k)
	end

	local dDescription = vgui.Create("KVS.Input", dFrame)
	dDescription:Dock(TOP)
	dDescription:DockMargin(15, 15, 15, 0)
	dDescription:SetPlaceholderText(VS_PoliceMod:L("Description"))
	dDescription.Input:SetMultiline(true)
	dDescription:SetTall(115)
    dDescription.OnTextChanged = function(self)
        local txt = self.Input:GetValue()
        local amt = string.len(txt)
        if amt > 600 then
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
		VS_PoliceMod:NetStart("OnComplaintSent", {cat = tonumber(dCat:GetOptionData(dCat:GetSelectedID())), desc = tostring(dDescription:GetText()), npc = npc})

		dFrame:AlphaTo(0, 0.2, 0, function()
			if IsValid(dFrame) then dFrame:Remove() end
		end)
		dFrame:MoveTo(ScrW() * 0.5 - dFrame:GetWide() * 0.5, ScrH() * 0.5 - dFrame:GetTall() * 0.5 + 40, 0.2)
	end
end

VS_PoliceMod:NetReceive("OnSendComplaints", function(t)
    addComplaint(t)
end)

VS_PoliceMod:NetReceive("OnComplaintStateUpdated", function(t)
    removeComplaint(t.id)
end)