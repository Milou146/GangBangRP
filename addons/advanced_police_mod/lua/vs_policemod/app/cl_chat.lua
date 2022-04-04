local App = {}

App.Name = VS_PoliceMod:L("PoliceChat")
App.Icon = utf8.char( 0xf1d8 )

local font = KVS.GetFont
local config = KVS.GetConfig
local iCachedMessages = 200
local iLastMsg = 0

VS_PoliceMod.PoliceChatMessages = VS_PoliceMod.PoliceChatMessages or {}

local addMessageToChat

function App:Open(pnl, w, h)
    local dFrame = vgui.Create( "KVS.Frame", pnl )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("PoliceChat") )
    dFrame:SetSubTitle( VS_PoliceMod:L("TalkToPolice") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf1d8, color_white )

    local dPnlHistory = vgui.Create("KVS.ScrollPanel", dFrame)
    dPnlHistory:Dock(FILL)
    dPnlHistory:DockMargin(10, 10, 10, 10)
    function dPnlHistory:Paint() end

    function addMessageToChat(v, b)
        if not IsValid(dFrame) then addMessageToChat = nil return end

        local splitted = string.Explode("\n", DarkRP.textWrap(v.sText, font("Rajdhani", 20), w - 105))

        local dMsg = vgui.Create("DPanel", dPnlHistory)
        dMsg:Dock(TOP)
        dMsg:InvalidateLayout(true)
        dMsg:DockMargin(0, 10, 0, 0)
        function dMsg:Paint(w, h)
            local sTime = os.date("%H:%M:%S", v.iTime)
            if IsValid(v.pSender) then
                draw.RoundedBox(8, 40, 20, w - 55, h - 20, (v.pSender == LocalPlayer()) && config("vgui.color.info") || config("vgui.color.black"))
                draw.SimpleText(string.upper(v.pSender:Nick()) .. " - " .. sTime, font("Rajdhani Bold", 17), 40, 0, color_white)
            else
                draw.RoundedBox(8, 40, 20, w - 55, h - 20, config("vgui.color.black"))
                draw.SimpleText(VS_PoliceMod:L("EX-COP") .. " - " .. sTime, font("Rajdhani Bold", 17), 40, 0, color_white)
            end
            for k, v in pairs(splitted) do
                draw.SimpleText(v, font("Rajdhani", 20), 50, (k-1)*20 + 10 + 20, color_white)
            end
        end

        local dAvatar = vgui.Create("KVS.AvatarImage", dMsg)
        dAvatar:Dock(LEFT)
        dAvatar:SetSize(32, 32)
        dAvatar:SetPlayer(v.pSender, 32)
        dAvatar:SetType("circle")

        dMsg:SetTall(#splitted * 20 + 40)
        
        if (dPnlHistory.VBar:GetScroll() != (dPnlHistory.pnlCanvas:GetTall() - dPnlHistory:GetTall())) and b then return end
        dPnlHistory.VBar:AnimateTo(dPnlHistory.pnlCanvas:GetTall(), 0.5)
    end

    for k, v in pairs(VS_PoliceMod.PoliceChatMessages) do
        addMessageToChat(v)
    end
    
    timer.Simple(0, function()
        dPnlHistory.VBar:AnimateTo(dPnlHistory.pnlCanvas:GetTall(), 0.5)
    end)

    local dPnlSend = vgui.Create("DPanel", dFrame)
    dPnlSend:Dock(BOTTOM)
    dPnlSend:SetSize(0, 40)
    dPnlSend:DockPadding(10, 0, 10, 10)
    function dPnlSend:Paint() end

    local dMessage = vgui.Create("KVS.Input", dPnlSend)
    dMessage:Dock(LEFT)
    dMessage:SetSize(w - 20)
    dMessage.OnTextChanged = function(self)
        local txt = self.Input:GetValue()
        local amt = string.len(txt)
        if amt > 300 then
            self.Input:SetText(self.Input.OldText)
            self.Input:SetValue(self.Input.OldText)
        else
            self.Input.OldText = txt
        end
    end

    local function onSend()
        if iLastMsg > CurTime() then return end
        local iLen = string.len(dMessage:GetText())
        if iLen < 1 or iLen > 300 then return end
        VS_PoliceMod:NetStart("OnPoliceChat", {sText = dMessage:GetText()})
        dMessage:SetText("")
        iLastMsg = CurTime() + 2
    end

    function dMessage:OnKeyCodePressed(key)
        if key == KEY_ENTER then
            onSend()
        end
    end
    dMessage:Append( VS_PoliceMod:L("Send"), {font = font("FAS", 20, "extended"), unicode = 0xf1d8}, config("vgui.colors.info"), onSend)
    dMessage.AppendItem:SetFont(font("Rajdhani Bold", 20))
end

VS_PoliceMod:NetReceive("OnPoliceChat", function(t)
    t = {pSender = Player(t.pSender), sText = t.sText, iTime = t.iTime}
    table.insert(VS_PoliceMod.PoliceChatMessages, t)
    if addMessageToChat then addMessageToChat(t, true) end

    local iEntries = #VS_PoliceMod.PoliceChatMessages

    if iEntries > iCachedMessages then
        for i = 1, iEntries - iCachedMessages do
            table.remove(VS_PoliceMod.PoliceChatMessages, 1)
        end
    end
end)

VS_PoliceMod:RegisterApp(App)