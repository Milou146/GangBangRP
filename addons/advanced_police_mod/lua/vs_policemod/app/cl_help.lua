local App = {}

App.Name = VS_PoliceMod:L("Help")
App.Icon = utf8.char( 0xf128 )

local font = KVS.GetFont
local config = KVS.GetConfig

function App:Open(pnl, w, h)
    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("Help") )
    dFrame:SetSubTitle( VS_PoliceMod:L("KnowledgeBase") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf128, color_white )

    local dPnlText = vgui.Create("KVS.ScrollPanel", dFrame)
    dPnlText:Dock(FILL)
    dPnlText:DockMargin(10, 10, 10, 10)
    -- function dPnlText:Paint() end

    for k, v in pairs(VS_PoliceMod.Config.HelpAppText) do
        local tbl = string.Explode("/]", v)
        local lbl = Label(tbl[2], dPnlText)
        lbl:Dock(TOP)
        lbl:SetWrap(true)
        lbl:SetTextColor(Color(230, 230, 230))
        lbl:DockMargin(10, 0, 0, 0)
        if tbl[1] == "[content" then
            lbl:SetFont(font("Rajdhani", 20))
        elseif tbl[1] == "[title" then
            lbl:SetFont(font("Rajdhani Bold", 25))
            lbl:SetTextColor(color_white)
            lbl:DockMargin(0, 10, 0, 10)
        elseif tbl[1] == "[br" then
            lbl:SetFont(font("Rajdhani", 20))
        elseif tbl[1] == "[italic" then
            lbl:SetFont(font("Rajdhani", 20, "italic"))
        elseif tbl[1] == "[bold" then
            lbl:SetFont(font("Rajdhani Bold", 20))
        end
        lbl:SetAutoStretchVertical(true)
    end
end

VS_PoliceMod:RegisterApp(App)