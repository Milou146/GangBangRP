local App = {}

App.Name = VS_PoliceMod:L("CriminalRecords")
App.Icon = utf8.char( 0xf1c0 )

local font = KVS.GetFont
local config = KVS.GetConfig

local updateStats
local fetchContent

local formatContent = {
    ["wanted"] = function(t)
        return VS_PoliceMod:L("LogWantedFor"):format(t.Emitter, t.Target, t.Reason)
    end,
    ["unwanted"] = function(t)
        return VS_PoliceMod:L("LogUnwanted"):format(t.Emitter, t.Target)
    end,
    ["arrests"] = function(t)
        return VS_PoliceMod:L("LogArrested"):format(t.Emitter, t.Target)
    end,
    ["unarrests"] = function(t)
        return VS_PoliceMod:L("LogUnarrested"):format(t.Emitter, t.Target)
    end,
    ["warrants"] = function(t)
        return VS_PoliceMod:L("LogWarrantedFor"):format(t.Emitter, t.Target, t.Reason)
    end,
    ["unwarrants"] = function(t)
        return VS_PoliceMod:L("LogUnwarranted"):format(t.Emitter, t.Target)
    end,
    ["fines"] = function(t)
        if t.HasPaid then
            return VS_PoliceMod:L("LogPaidFine"):format(t.Target, DarkRP.formatMoney(t.Price), t.Emitter, t.Reasons)
        else
            return VS_PoliceMod:L("LogRefusedPayFine"):format(t.Target, DarkRP.formatMoney(t.Price), t.Emitter, t.Reasons)
        end
    end,
    ["complaints"] = function(t)
        return VS_PoliceMod:L("LogFiledComplaint"):format(t.Target, t.Reason)
    end,
}

local function addBox(parent, tooltip, text)
    local dBox = parent:Add("DPanel")
    dBox:SetSize(75, 35)
    dBox:AddTooltip(tooltip)
    dBox.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
    dBox.iVal = "0"
    function dBox:Paint(w, h)
        draw.SimpleText(text, font("FAS", 18, "extended"), 10, h * 0.5, color_white, 0, 1)
        draw.SimpleText(self.iVal, font("Rajdhani Bold", 20), 40, h * 0.5, color_white, 0, 1)
    end

    return dBox
end

function App:Open(pnl, w, h)
    local dLoading

    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("CriminalRecords") )
    dFrame:SetSubTitle( VS_PoliceMod:L("JudicialBackground") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf1c0, color_white )

    local dIcon
    local dLeft
    local dRight

    local dSearch = vgui.Create("KVS.ComboBox", dFrame)
    dSearch:Dock(TOP)
    dSearch:DockMargin(10, 10, 10, 10)
    dSearch:SetText(VS_PoliceMod:L("SelectCitizen"))
    for k, v in pairs(player.GetAll()) do
        dSearch:AddChoice(v:Nick(), v:UserID())
    end
    local iLastPSelected
    function dSearch:OnSelect(_, _, d)
        if not IsValid(Player(d)) then 
            dSearch:Clear()
            for k, v in pairs(player.GetAll()) do
                dSearch:AddChoice(v:Nick(), v:UserID())
            end
            return
        end

        if iLastPSelected == d then return end
        
        iLastPSelected = d

        dLeft:SetVisible(true)
        dRight:SetVisible(true)
        dIcon:SetModel(Player(d):GetModel())
        dIcon:SetTooltip()
        VS_PoliceMod:NetStart("OnGetCRStats", {pid = d})
    end

    dLeft = vgui.Create("DPanel", dFrame)
    dLeft:Dock(LEFT)
    dLeft:DockMargin(10, 0, 10, 10)
    dLeft:SetWide(150)
    dLeft:SetVisible(false)
    function dLeft:Paint(w, h)
        surface.SetDrawColor(config("vgui.color.black"))
        surface.DrawRect(0, 0, w, h)
    end

    dIcon = vgui.Create("SpawnIcon", dLeft)
    dIcon:Dock(TOP)
    dIcon:DockMargin(43, 10, 43, 10)
    dIcon:SetTall(64)
    dIcon:SetTooltip()
    function dIcon:PaintOver()end
    function dIcon:OnMousePressed()end
    

    local pnlContent = vgui.Create("DIconLayout", dLeft)
    pnlContent:Dock(TOP)

    local tBoxes = {}

    tBoxes["arrests"] = addBox(pnlContent, VS_PoliceMod:L("Arrests"), utf8.char(0xf023))
    tBoxes["wanted"] = addBox(pnlContent, VS_PoliceMod:L("WantedNotices"), utf8.char(0xf071))
    tBoxes["warrants"] = addBox(pnlContent, VS_PoliceMod:L("SearchWarrants"), utf8.char(0xf52b))
    tBoxes["fines"] = addBox(pnlContent, VS_PoliceMod:L("Fines"), utf8.char(0xf4c0))
    tBoxes["complaints"] = addBox(pnlContent, VS_PoliceMod:L("Complaints"), utf8.char(0xf0c5))

    updateStats = function(data)
        if not IsValid(dFrame) then return end
        if data.pid != select(2, dSearch:GetSelected()) then return end

        data.pid = nil

        tBoxes["arrests"].iVal = "0"
        tBoxes["wanted"].iVal = "0"
        tBoxes["warrants"].iVal = "0"
        tBoxes["fines"].iVal = "0"
        tBoxes["complaints"].iVal = "0"

        for k, v in pairs(data) do
            if tBoxes[v.category] and IsValid(tBoxes[v.category]) then tBoxes[v.category].iVal = v.count end
        end
    end

    pnlContent:SizeToContentsY()

    dRight = vgui.Create("DPanel", dFrame)
    dRight:Dock(FILL)
    dRight:DockMargin(0, 0, 10, 10)
    dRight:SetVisible(false)
    function dRight:Paint(w, h)
        surface.SetDrawColor(config("vgui.color.black"))
        surface.DrawRect(0, 0, w, h)
    end

    local dCasesType = vgui.Create("KVS.ComboBox", dRight)
    dCasesType:Dock(TOP)
    dCasesType:DockMargin(10, 10, 10, 10)
    dCasesType:AddChoice(VS_PoliceMod:L("Arrests"), "arrests")
    dCasesType:AddChoice(VS_PoliceMod:L("Unarrests"), "unarrests")
    dCasesType:AddChoice(VS_PoliceMod:L("StartWantedNotices"), "wanted")
    dCasesType:AddChoice(VS_PoliceMod:L("EndWantedNotices"), "unwanted")
    dCasesType:AddChoice(VS_PoliceMod:L("StartSearchWarrants"), "warrants")
    dCasesType:AddChoice(VS_PoliceMod:L("EndSearchWarrants"), "unwarrants")
    dCasesType:AddChoice(VS_PoliceMod:L("Fines"), "fines")
    dCasesType:AddChoice(VS_PoliceMod:L("Complaints"), "complaints")
    dCasesType:SetSortItems(false)

    local dList = vgui.Create("KVS.ScrollPanel", dRight)
    dList:Dock(FILL)
    dList:DockMargin(10, 0, 10, 10)
    function dList:Fetch(data)
        dLoading:SetVisible(false)
        for k, v in pairs(data) do
            v.content = util.JSONToTable(v.content)
            local pnl = vgui.Create("DPanel", dList)
            pnl:Dock(TOP)
            pnl:DockMargin(0, 0, 0, 10)
            pnl:SetTall(20)
            pnl:DockPadding(10, 10, 10, 10)
            function pnl:Paint(iw, ih)
                surface.SetDrawColor(config("vgui.color.black_rhard"))
                surface.DrawRect(0, 0, iw, ih)
            end

            local sFont = font("Rajdhani", 20)
            local sDate = os.date("%d/%m/%y %H:%M", v.date)
            local sContent = sDate .. " " .. formatContent[v.category](v.content)
            local tblLines = string.Explode("\n", DarkRP.textWrap(sContent, sFont, w - 230))

            for k, v in pairs(tblLines) do
                local lbl = Label(v, pnl)
                lbl:SetTall(22)
                lbl:Dock(TOP)
                lbl:SetFont(sFont)
                lbl:SetContentAlignment(4)

                pnl:SetTall(pnl:GetTall() + 22)
            end
        end
    end

    function dCasesType:OnSelect(_ , _, d)
        dLoading:SetVisible(true)
        dList:Clear()
        
        VS_PoliceMod:NetStart("OnGetCRContent", {cat = d, pid = iLastPSelected})
    end

    dLoading = vgui.Create("DPanel", dRight)
    dLoading:SetSize(40, 32)
    dLoading:SetPos((w - 220) / 2, (h - 100) / 2)
    dLoading:SetVisible(false)
    function dLoading:Paint(w, h)
        for i = 0, 2 do
            draw.RoundedBox(4, i * 16, h - 8 - math.Clamp(math.sin((CurTime() - 0.3 * i) * 4), 0, 1) * 20, 8, 8, color_white)
        end
    end

    fetchContent = function(data)
        if not IsValid(dFrame) then return end
        if data.pid != select(2, dSearch:GetSelected()) then return end

        data.pid = nil

        dList:Fetch(data)
    end
end

VS_PoliceMod:RegisterApp(App)

VS_PoliceMod:NetReceive("OnSendCRStats", function(tbl)
    if updateStats then
        updateStats(tbl)
    end
end)

VS_PoliceMod:NetReceive("OnSendCRContent", function(tbl)
    if fetchContent then
        fetchContent(tbl)
    end
end)