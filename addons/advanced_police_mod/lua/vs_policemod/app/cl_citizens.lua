local config = KVS.GetConfig
local font = KVS.GetFont
local CFG = VS_PoliceMod.Config

local dFrame
local fineFrame
local varUpdate = {
  ["wanted"] = true,
  ["warrant"] = true
}
hook.Add( "DarkRPVarChanged", "DarkRPVarChanged.CitizenManagement", function( pPlayer, sVarName )
  if not varUpdate[ sVarName ] then return end

  if IsValid( dFrame ) and dFrame.pnl and dFrame.pnl[ pPlayer:UserID() ] then
    dFrame.pnl[ pPlayer:UserID() ].ShouldUpdate = true
  end
end )

local App = {}

App.Name = VS_PoliceMod:L("CitizensManagement")
App.Icon = utf8.char( 0xf0c0 )

local function OpenFineFrame( pPlayer )
  if not IsValid( dFrame ) then return end
  if not IsValid( pPlayer ) then return end

  fineFrame = vgui.Create( "KVS.Frame" )
  fineFrame:SetSize( 300, 340 )
  fineFrame:SetBorder( false )
  fineFrame:SetUseAnimation( false )
  fineFrame:ShowCloseButton( true )
  fineFrame:SetTitle( VS_PoliceMod:L("SendFine") )
  fineFrame:Center()
  fineFrame:MakePopup()
  function fineFrame:Think()
    if not IsValid( dFrame ) then self:Remove() end
  end
  function fineFrame:Paint(w, h)
    Derma_DrawBackgroundBlur( self, self.startTime )
    draw.RoundedBox(4, 0, 0, w, h, config("vgui.color.black_rhard"))
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

  local fineReasons = {}

  for sReason, tInfos in pairs( CFG.Fine or {} ) do
    local fineReasonPanel = vgui.Create( "KVS.Panel", finePanel )
    fineReasonPanel:Dock( TOP )
    fineReasonPanel:SetTall( 25 )
    fineReasonPanel:DockMargin( 10, 10, 10, 0 )

    local fineReason = vgui.Create( "DLabel", fineReasonPanel )
    fineReason:Dock( FILL )
    fineReason:SetFont( font("Rajdhani", 20) )
    fineReason:SetText( sReason )
    fineReason:SetContentAlignment( 4 )

    local fineReasonCheck = vgui.Create( "KVS.CheckBox", fineReasonPanel )
    fineReasonCheck:SetWide( 25 )
    fineReasonCheck:Dock( RIGHT )
    function fineReasonCheck:OnChange( bVal ) 
      if not IsValid( fineSlide ) then return end

      if bVal then
        fineSlide:SetMin( fineSlide:GetMin() + tInfos.minPrice or 0 )
        fineSlide:SetMax( fineSlide:GetMax() + tInfos.maxPrice or 0 )
        fineReasons[ sReason ] = true
      else
        fineSlide:SetMin( fineSlide:GetMin() - tInfos.minPrice or 0 )
        fineSlide:SetValue( fineSlide:GetMin() )
        fineSlide:SetMax( fineSlide:GetMax() - tInfos.maxPrice or 0 )
        fineReasons[ sReason ] = nil
      end
    end
    
  end

  local finePrice = vgui.Create( "DLabel", finePanel )
  finePrice:Dock( TOP )
  finePrice:DockMargin( 10, 10, 10, 0 )
  finePrice:SetFont( font("Rajdhani Bold", 20 ) )
  finePrice:SetText( VS_PoliceMod:L("Price") .. " : " .. DarkRP.formatMoney( fineSlide and fineSlide:GetValue() or 0 ) )
  finePrice:SetContentAlignment( 4 )

  fineSlide = vgui.Create( "KVS.Slider", finePanel )
  fineSlide:Dock( TOP )
  fineSlide:DockMargin( 10, 10, 10, 0 )
  fineSlide:SetDecimals( 0 )
  fineSlide:SetTall( 20 )
  fineSlide:SetMin( 0 )
  fineSlide:SetMax( 0 )
  function fineSlide:OnValueChanged()
    finePrice:SetText( VS_PoliceMod:L("Price") .. " : " .. DarkRP.formatMoney( self:GetValue() or 0 ) )
  end

  local sendFine = vgui.Create( "KVS.Button", fineFrame )
  sendFine:Dock( BOTTOM )
  sendFine:SetTall( 30 )
  sendFine:SetText( VS_PoliceMod:L("SendFine") )
  sendFine:SetFont( font( 'Rajdhani Bold', 20 ) )
  sendFine:SetColor( config( "vgui.color.primary" ) )
  sendFine:SetBorder( false, false, true, true )
  sendFine:WithIcon( font( 'FAS', 20, 'extended' ), 0xf4c0 )
  function sendFine:DoClick()
    fineFrame:Remove()

    if not IsValid( pPlayer ) then return end

    VS_PoliceMod:NetStart( "SendContravention", { pPlayer:UserID(), fineReasons, fineSlide:GetValue() } )
  end

end

function App:Open( dParent, iSizeW, iSizeH )
	  dFrame = vgui.Create( "KVS.Frame", dParent )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("CitizensManagement") )
    dFrame:SetSubTitle(VS_PoliceMod:L("BeEfficient"))
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf0c0, color_white )

    local dPlayerList

    local dSearch = vgui.Create("KVS.Input", dFrame)
    dSearch:Dock(TOP)
    dSearch:DockMargin(10, 10, 10, 0)
    dSearch:SetTall(40)
    dSearch:SetPlaceholderText(VS_PoliceMod:L("Search"))
    function dSearch:OnTextChanged()
        for k, v in pairs(dPlayerList:GetChildren()[1]:GetChildren()) do
            if string.find(string.lower(v.pName), string.lower(self.Input:GetText())) then
                v:SetTall(68)
                v:DockMargin(0, 0, 0, 10)
            else
                v:SetTall(0)
                v:DockMargin(0, 0, 0, 0)
            end
        end
    end

    dPlayerList = vgui.Create( "KVS.ScrollPanel", dFrame )
    dPlayerList:Dock( FILL )
    dPlayerList:DockMargin(10, 10, 10, 10)

    dFrame.pnl = {}
    for _, pPlayer in pairs( tPlayers or player.GetAll() ) do
      local pnl = vgui.Create("DPanel", dPlayerList)
      dFrame.pnl[ pPlayer:UserID() ] = pnl
      pnl:Dock(TOP)
      pnl:SetTall(68)
      pnl:DockMargin(0, 0, 0, 10)
      pnl.pName = pPlayer:Nick()
      pnl.CreationTime = CurTime()
      pnl.ShouldUpdate = true
      function pnl:Paint(w, h)
        if not IsValid(pPlayer) then self:Remove() return end
        surface.SetDrawColor(config("vgui.color.black"))
        surface.DrawRect(0, 0, w, h)

        for iLine, sText in pairs( self.textTable or {} ) do
          if self.fEmptySpace then
            draw.SimpleText( sText, iLine == 1 and font("Rajdhani Bold", 20) or font("Rajdhani", 20), 68, self.fEmptySpace + (iLine-1) * 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
          else
            draw.SimpleText( sText, iLine == 1 and font("Rajdhani Bold", 20) or font("Rajdhani", 20), 68, 20 * (iLine-1), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
          end
        end

        if CurTime() - pnl.CreationTime > 1 and not self.ShouldUpdate then return end
        self.ShouldUpdate = false

        local text = pPlayer:Name()

        if pPlayer:getDarkRPVar("wanted") then
          text = text .. "\n" .. VS_PoliceMod:L("WantedReason") .. " : " .. pPlayer:getDarkRPVar("wantedReason")
        end
        if pPlayer:getDarkRPVar("warrant") then
          text = text .. "\n" .. VS_PoliceMod:L("WarrantReason") .. " : " .. pPlayer:getDarkRPVar("warrantReason")
        end

        local textWrap = DarkRP.textWrap( text, font("Rajdhani Bold", 20), self:GetWide() - 40 * 3 - 68 - 20 * 2 )
        local textTable = string.Explode( "\n", textWrap )

        local totalHeight = #textTable * 20
        local tall = math.max( totalHeight, 68 )
        self:SetTall( tall )
        if IsValid( self.icon ) then
          self.icon:DockMargin( 0, ( tall - 68 ) / 2, 0, ( tall - 68 ) / 2 )
        end

        local fEmptySpace
        if tall <= 68 then
          fEmptySpace = ( 68 - totalHeight ) / 2
        end

        self.textTable = textTable
        self.fEmptySpace = fEmptySpace
      end

      local icon = vgui.Create("SpawnIcon", pnl)
      icon:Dock(LEFT)
      icon:SetWide(68)
      icon:SetModel(pPlayer:GetModel())
      icon:SetTooltip()
      function icon:PaintOver() end
      function icon:OnMousePressed() end

      pnl.icon = icon
    
      local bIsWanted = pPlayer:getDarkRPVar("wanted")

      local dContraventionB = vgui.Create("KVS.ButtonIcon", pnl)
      dContraventionB:Dock(RIGHT)
      dContraventionB:SetWide(40)
      dContraventionB:SetIcon( font("FAS", 18, "extended"), 0xf651, config("vgui.color.accept_green") )
      dContraventionB:SetAlignement(5)
      dContraventionB:AddTooltip(VS_PoliceMod:L("Fine"))
      dContraventionB.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
      function dContraventionB:DoClick()
          if not IsValid(pPlayer) then return end

          OpenFineFrame( pPlayer )
      end

      local dWarrantB = vgui.Create("KVS.Button", pnl)
      dWarrantB:Dock(RIGHT)
      dWarrantB:SetWide(40)
      dWarrantB:AddTooltip(pPlayer:getDarkRPVar("warrant") and VS_PoliceMod:L("EndWarrant") or VS_PoliceMod:L("StartWarrant") )
      dWarrantB.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
      function dWarrantB:Paint( w, h )
        if not IsValid(pPlayer) then return end

        draw.SimpleText( utf8.char( 0xf52b ), font("FAS", 18, "extended"), w / 2, h / 2, pPlayer:getDarkRPVar("warrant") and config("vgui.color.danger") or config("vgui.color.gray"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
      function dWarrantB:DoClick()
          if not IsValid(pPlayer) then return end

          if pPlayer:getDarkRPVar("warrant") then
              LocalPlayer():ConCommand("darkrp unwarrant " .. pPlayer:UserID())
          else
              KVS:DermaStringRequest(VS_PoliceMod:L("StartWarrant"), VS_PoliceMod:L("EnterReason"), "", function(sText)
                  LocalPlayer():ConCommand("darkrp warrant " .. pPlayer:UserID() .. " " .. sText)
              end, nil, VS_PoliceMod:L("Send"), VS_PoliceMod:L("Cancel"))
          end
      end

      local dWantedB = vgui.Create("KVS.Button", pnl)
      dWantedB:Dock(RIGHT)
      dWantedB:SetWide(40)
      dWantedB:AddTooltip(bIsWanted and VS_PoliceMod:L("EndWanted") or VS_PoliceMod:L("StartWanted"))
      dWantedB.TOOLTIP:SetFont(font("Rajdhani Bold", 20))
      function dWantedB:Paint( w, h )
        if not IsValid(pPlayer) then return end

        draw.SimpleText( utf8.char( 0xf071 ), font("FAS", 18, "extended"), w / 2, h / 2, pPlayer:getDarkRPVar("wanted") and config("vgui.color.danger") or config("vgui.color.gray"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end
      function dWantedB:DoClick()
          if not IsValid(pPlayer) then return end

          if pPlayer:getDarkRPVar("wanted") then
              LocalPlayer():ConCommand("darkrp unwanted " .. pPlayer:UserID())
          else
              KVS:DermaStringRequest(VS_PoliceMod:L("StartWanted"), VS_PoliceMod:L("EnterReason"), "", function(sText)
                  LocalPlayer():ConCommand("darkrp wanted " .. pPlayer:UserID() .. " " .. sText)
              end, nil, VS_PoliceMod:L("Send"), VS_PoliceMod:L("Cancel"))
          end
      end
    end
end

VS_PoliceMod:RegisterApp( App )