if not LL_PLATES_SYSTEM then return end

local App = {}

App.Name = VS_PoliceMod:L("LicensePlates")
App.Icon = utf8.char( 0xf1b9 )

local font = KVS.GetFont
local config = KVS.GetConfig

VS_PoliceMod.VehiclesList = VS_PoliceMod.VehiclesList or {}

function VS_PoliceMod:GetVehicleOwnerFromPlate(sPlate)
    for k, v in pairs(VS_PoliceMod.VehiclesList) do
        if not IsValid(v) then
            table.remove(VS_PoliceMod.VehiclesList, k)
            continue
        end
        if v:GetNWString("ll_plate", "") == sPlate then
            return v
        end
    end
end

hook.Add("OnEntityCreated", "VS_PoliceMod.Plates:OnEntityCreated", function(v)
    if v:IsVehicle() then
        table.insert(VS_PoliceMod.VehiclesList, v)
    end
end)

local function addVehicInfo(parent, icon, title, text)
    local lblIcon = vgui.Create("DPanel", parent)
    lblIcon:Dock(TOP)
    lblIcon:SetTall(35)
    icon = utf8.char(icon)
    function lblIcon:Paint(w, h)
        draw.SimpleText(icon, font("FAS", 18, "extended"), 8, h * 0.5, color_white, 0, 1)
        draw.SimpleText(title, font("Rajdhani Bold", 22), 32, h * 0.5, color_white, 0, 1)
    end

    local lblText = Label(text, parent)
    lblText:SetFont(font("Rajdhani", 22))
    lblText:Dock(TOP)
    lblText:SetContentAlignment(4)
    lblText:SetWrap(true)
    lblText:SetAutoStretchVertical(true)
    lblText:DockMargin(8, 0, 8, 0)

    return lblText
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
    dFrame:SetTitle( VS_PoliceMod:L("LicensePlates") )
    dFrame:SetSubTitle( VS_PoliceMod:L("FindAnyVehicle") )
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf1b9, color_white )

    local dSearch = vgui.Create("KVS.Input", dFrame)
    dSearch:Dock(TOP)
    dSearch:DockMargin(10, 10, 10, 0)
    dSearch:SetTall(40)
    dSearch:SetPlaceholderText(VS_PoliceMod:L("SearchByLicensePlate"))

    local dPnl = vgui.Create("DPanel", dFrame)
    dPnl:Dock(FILL)
    dPnl:DockMargin(10, 10, 10, 10)
    dPnl:SetVisible(false)
    dPnl.Paint = nil

    local dInfo = vgui.Create("KVS.ScrollPanel", dPnl)
    dInfo:SetSize(200, 400)
    function dInfo:Paint(w, h)
        surface.SetDrawColor(config("vgui.color.black"))
        surface.DrawRect(0, 0, w, h)
    end

    local lblOwner = addVehicInfo(dInfo, 0xf007, VS_PoliceMod:L("Owner"), "")
    local lblVehic = addVehicInfo(dInfo, 0xf1b9, VS_PoliceMod:L("Vehicle"), "")
    local lblPlate = addVehicInfo(dInfo, 0xf0ad, VS_PoliceMod:L("LicensePlate"), "")
    local lblWanted = addVehicInfo(dInfo, 0xf071, VS_PoliceMod:L("Wanted"), "")

    local dNoMatching = Label(VS_PoliceMod:L("NoVehicleMatching"), dFrame)
    dNoMatching:SetFont(font("Rajdhani Bold", 25))
    dNoMatching:SetSize(w, h - 120)
    dNoMatching:SetPos(10, 110)
    dNoMatching:SetVisible(false)
    dNoMatching:SetContentAlignment(5)

    local dModel = vgui.Create("DModelPanel", dPnl)
    dModel:SetSize(w - 20 - 200, h - 120)
    dModel:SetPos(200, 0)
    dModel:SetModel("models/tdmcars/gtav/bus.mdl")
    dModel:SetColor(Color(255, 0, 0))

    local mn, mx = dModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    dModel:SetFOV( 45 )
    dModel:SetCamPos( Vector( size, size, size ) )
    dModel:SetLookAt( (mn + mx) * 0.3 )
    function dModel:LayoutEntity()end

    local isSearching = false
    local function onSearch()
        if isSearching then return end

        isSearching = true

        local veh = VS_PoliceMod:GetVehicleOwnerFromPlate(dSearch:GetText())

        dLoading:SetVisible(true)
        dPnl:SetVisible(false)
        dNoMatching:SetVisible(false)
        timer.Simple(5, function()
            if IsValid(dFrame) then
                dLoading:SetVisible(false)

                if veh && IsValid(veh) then
                    local pOwner = IsValid(veh:CPPIGetOwner()) and veh:CPPIGetOwner() or nil

                    dModel:SetModel(veh:GetModel())
                    dModel:SetColor(veh:GetColor())
                    lblVehic:SetText(list.Get("Vehicles")[veh:GetVehicleClass()].Name or veh:GetVehicleClass())
                    lblPlate:SetText(veh:GetNWString("ll_plate"))
                    if pOwner then
                        lblOwner:SetText(pOwner:Nick())
                        lblWanted:SetText(pOwner:getDarkRPVar("wanted") && VS_PoliceMod:L("Yes") or VS_PoliceMod:L("No"))
                    end
                    dPnl:SetVisible(true)
                    surface.PlaySound("buttons/button9.wav")
                else
                    dNoMatching:SetVisible(true)
                    surface.PlaySound("buttons/button10.wav")
                end
                isSearching = false
            end
        end)
    end

    dSearch:Append( VS_PoliceMod:L("Search"), {font = font("FAS", 20, "extended"), unicode = 0xf002}, config("vgui.colors.info"), onSearch)
    dSearch.AppendItem:SetFont(font("Rajdhani Bold", 20))
    
    dLoading = vgui.Create("DPanel", dFrame)
    dLoading:SetSize(40, 32)
    dLoading:SetPos(w * 0.5 - 16, h * 0.5 + 16)
    dLoading:SetVisible(false)
    function dLoading:Paint(w, h)
        for i = 0, 2 do
            draw.RoundedBox(4, i * 16, h - 8 - math.Clamp(math.sin((CurTime() - 0.3 * i) * 4), 0, 1) * 20, 8, 8, color_white)
        end
    end
end

VS_PoliceMod:RegisterApp(App)