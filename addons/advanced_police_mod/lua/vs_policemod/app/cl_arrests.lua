local App = {}

App.Name = VS_PoliceMod:L("Arrests")
App.Icon = utf8.char( 0xf502 )

local font = KVS.GetFont
local config = KVS.GetConfig

local colBars = Color(150, 150, 150, 100)

function App:Open(pnl, w, h)
    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("Arrests") )
    dFrame:SetSubTitle( VS_PoliceMod:L("ManagePrisoners") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf023, color_white )

    local dScroll = vgui.Create("KVS.ScrollPanel", dFrame)
    dScroll:Dock(FILL)
    dScroll:DockMargin(10, 10, 10, 10)

    for k, v in pairs(player.GetAll()) do
        if not v:isArrested() then continue end

        local pnl = vgui.Create("DPanel", dScroll)
        pnl:Dock(TOP)
        pnl:DockMargin(0, 0, 0, 10)
        pnl:SetTall(64)
        function pnl:GoOut()
            self:SizeTo(w - 20, 0, 0.25, 0, -1, function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end
        function pnl:Paint(w, h)
            if not self.GoingOut and (not IsValid(v) or not v:isArrested()) then self.GoingOut = true self:GoOut() end

            surface.SetDrawColor(config("vgui.color.black"))
            surface.DrawRect(0, 0, w, h)
        end

        local mdl = vgui.Create("SpawnIcon", pnl)
        mdl:Dock(LEFT)
        mdl:SetWide(pnl:GetTall())
        mdl:SetModel(v:GetModel())
        mdl:SetTooltip()
        mdl:SetCursor("none")
        function mdl:PaintOver(w, h)
            for i = 1, w, 10 do
                draw.RoundedBox(0, i, 0, 2, h, colBars)
                draw.SimpleText(utf8.char(0xf023), font("FAS", 18, "extended"), 32 + 1, h * 0.5 + 1, color_black, 1, 1)
                draw.SimpleText(utf8.char(0xf023), font("FAS", 18, "extended"), 32 - 1, h * 0.5 - 1, config("vgui.color.danger"), 1, 1)
            end
        end
        function mdl:OnMousePressed()end

        local lblName = Label(v:Nick(), pnl)
        lblName:Dock(LEFT)
        lblName:SetWide(200)
        lblName:SetContentAlignment(4)
        lblName:DockMargin(10, 0, 0, 0)
        lblName:SetFont(font("Rajdhani Bold", 22))

        local btnUnarrest = vgui.Create("KVS.ButtonIcon", pnl)
        btnUnarrest:Dock(RIGHT)
        btnUnarrest:SetWide(40)
        btnUnarrest:SetIcon( font("FAS", 18, "extended"), 0xf09c, config("vgui.color.accept_green") )
        btnUnarrest:SetAlignement(5)
        btnUnarrest:AddTooltip(VS_PoliceMod:L("ReleaseFromJail"))
        btnUnarrest.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
        function btnUnarrest:DoClick()
            if not IsValid(v) then return end

            VS_PoliceMod:NetStart("ReleaseFromJail", {pid = v:UserID()})
        end

        if v:getDarkRPVar("bailAvailable") then
            local btnNoBail = vgui.Create("KVS.ButtonIcon", pnl)
            btnNoBail:Dock(RIGHT)
            btnNoBail:SetWide(40)
            btnNoBail:SetIcon( font("FAS", 18, "extended"), 0xf155, config("vgui.color.danger") )
            btnNoBail:SetAlignement(5)
            btnNoBail:AddTooltip(VS_PoliceMod:L("DisableBail"))
            btnNoBail.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
            function btnNoBail:Think()
                if not IsValid(v) then return end
                if not v:getDarkRPVar("bailAvailable") then self:Remove() end
            end
            function btnNoBail:DoClick()
                if not IsValid(v) then return end

                VS_PoliceMod:NetStart("DisableBail", {pid = v:UserID()})
            end
        end
    end
end

VS_PoliceMod:RegisterApp(App)

function VS_PoliceMod:DisplayBailsMenu(tBails, npc)
    for k, v in pairs(tBails) do
        if not IsValid(Player(k)) then table.remove(tBails, k) continue end
    end

    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:SetSize(400, 400)
    dFrame:Center()
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:MakePopup()
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("Bails") )
    dFrame:SetSubTitle( VS_PoliceMod:L("PayAnyBail") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf155, color_white )
	function dFrame:Paint(w, h)
		Derma_DrawBackgroundBlur( dFrame, self.startTime )
		draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard"))
	end

    local dScroll = vgui.Create("KVS.ScrollPanel", dFrame)
    dScroll:Dock(FILL)
    dScroll:DockMargin(10, 10, 10, 10)

    for k, v in pairs(player.GetAll()) do

        if not IsValid(v) or not v:isArrested() then continue end

        local pnl = vgui.Create("DPanel", dScroll)
        pnl:Dock(TOP)
        pnl:DockMargin(0, 0, 0, 10)
        pnl:SetTall(64)
        local iPrice = DarkRP.formatMoney(tBails[v:UserID()])
        function pnl:Paint(w, h)
            if not IsValid(v) then self:Remove() return end

            surface.SetDrawColor(config("vgui.color.black"))
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(v:Nick(), font("Rajdhani Bold", 23), h + 10, 11, color_white)
            draw.SimpleText(iPrice, font("Rajdhani", 20), h + 10, 31, color_white)
        end

        local mdl = vgui.Create("SpawnIcon", pnl)
        mdl:Dock(LEFT)
        mdl:SetWide(pnl:GetTall())
        mdl:SetModel(v:GetModel())
        mdl:SetTooltip()
        function mdl:PaintOver() end
        function mdl:OnMousePressed() end

        local dPay = vgui.Create("KVS.ButtonIcon", pnl)
        dPay:Dock(RIGHT)
        dPay:SetWide(40)
        if v:getDarkRPVar("bailAvailable") then
            dPay:SetIcon( font("FAS", 18, "extended"), 0xf155, config("vgui.color.accept_green") )
            dPay:AddTooltip(VS_PoliceMod:L("PAY"))
        else
            dPay:SetIcon( font("FAS", 18, "extended"), 0xf155, config("vgui.color.danger") )
            dPay:AddTooltip(VS_PoliceMod:L("BailDisabled"))
        end
        dPay:SetAlignement(5)
        dPay.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
        function dPay:DoClick()
            if not IsValid(v) then return end

            if v:getDarkRPVar("bailAvailable") then
                VS_PoliceMod:NetStart("PayBail", {pid = v:UserID(), npc = npc})
            else
                VS_PoliceMod:Notify(VS_PoliceMod:L("BailDisabled"), 5)
            end

            dFrame:Remove()
        end
    end
end