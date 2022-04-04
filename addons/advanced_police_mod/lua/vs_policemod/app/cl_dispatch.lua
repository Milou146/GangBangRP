local config = KVS.GetConfig
local font = KVS.GetFont
local CFG = VS_PoliceMod.Config

local dFrame
local dMinimapPanel

VS_PoliceMod.DispatchGroups = VS_PoliceMod.DispatchGroups or {}

net.Receive( "PoliceMod.Dispatch", function()
    VS_PoliceMod.DispatchGroups = net.ReadTable() or {}
end )

VS_PoliceMod:NetReceive( "DispatchSelected", function( tData )
    local iEmitter = tData[ 1 ]
    local pEmitter = Player( iEmitter )

    if VS_PoliceMod.CurrentPoliceCalls and VS_PoliceMod.CurrentPoliceCalls[ pEmitter ] then
        VS_PoliceMod.CurrentPoliceCalls[ pEmitter ].dispatchGroup = CFG.DispatchGroupsNames[ tData[ 2 ] ] and VS_PoliceMod.DispatchGroups[ tData[ 2 ] ] and tData[ 2 ]
        if dMinimapPanel and IsValid( dMinimapPanel ) and dMinimapPanel.RemoveMission then
            dMinimapPanel:RemoveMission( pEmitter )
            dMinimapPanel:AddMission( VS_PoliceMod.CurrentPoliceCalls[ pEmitter ] )
        end
    end

    if LocalPlayer().Dispatch and LocalPlayer().Dispatch ~= VS_PoliceMod:L("NotDispatched") and tData[ 2 ] == LocalPlayer().Dispatch then
        VS_PoliceMod:Notify( VS_PoliceMod:L("DispatchGroupAssigned") )
    end
end )

hook.Add( "HUDPaint", "HUDPaint.VS_PoliceMod.Dispatch", function()
    if LocalPlayer().Dispatch and LocalPlayer():PM_IsPolice() and LocalPlayer().Dispatch ~= VS_PoliceMod:L("NotDispatched") then
        for pEmitter, tInfos in pairs( VS_PoliceMod.CurrentPoliceCalls or {} ) do
            if tInfos.dispatchGroup ~= LocalPlayer().Dispatch then continue end

            local position = tInfos.positionEmitter
            local posScreen = position:ToScreen()

            local fDist = math.Round( position:Distance( LocalPlayer():GetPos() ) /  39.37 )
            
            if fDist < 5 then continue end
            
            local alpha = math.Clamp( 1 - ( 15 - (fDist - 5) ) / 15, 0, 1 )
        
            local color = ColorAlpha( config( "vgui.color.warning" ), 255 * alpha )
            local color_black = ColorAlpha( config( "vgui.color.black_hard" ), 255 * alpha )
            draw.SimpleText( utf8.char( 0xf70c ), font( "FAS", 30, "extended" ), posScreen.x - 14, posScreen.y - 14, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( utf8.char( 0xf70c ), font( "FAS", 30, "extended" ), posScreen.x - 15, posScreen.y - 15, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( fDist .. " m", font( "Rajdhani Bold", 18, "extended" ), posScreen.x - 14, posScreen.y + 3, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText( fDist .. " m", font( "Rajdhani Bold", 18, "extended" ), posScreen.x - 15, posScreen.y + 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        end
    end
end )

local lastDispatchNotif = 0

VS_PoliceMod:NetReceive( "ChangeDispatchClient", function( tData )
    if not tData or not tData[1] then return end

    local pPlayer = Player( tData[1] )

    if not IsValid( pPlayer ) then return end

    local newDispatchGroup = tData[2]
    local oldDispatchGroup = tData[3]

    if newDispatchGroup == VS_PoliceMod:L("NotDispatched") then newDispatchGroup = nil end
    if oldDispatchGroup == VS_PoliceMod:L("NotDispatched") then oldDispatchGroup = nil end

    if not newDispatchGroup or not CFG.DispatchGroupsNames[ newDispatchGroup ] then
        -- set as not dispatched
        if oldDispatchGroup and CFG.DispatchGroupsNames[ oldDispatchGroup ] then
            VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] or {}
            VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players or {}
            VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players[ pPlayer ] = nil
            if table.Count( VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players ) <= 0 then
                VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = nil
            end
        end
        pPlayer.Dispatch = nil

        if dFrame and IsValid( dFrame ) and dFrame.CreateRightPanel then
            dFrame:CreateRightPanel()
        end
    elseif not oldDispatchGroup or not CFG.DispatchGroupsNames[ oldDispatchGroup ] then
        -- set in a team from not dispatched
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ] = VS_PoliceMod.DispatchGroups[ newDispatchGroup ] or {}
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players or {}
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players[ pPlayer ] = true
        pPlayer.Dispatch = newDispatchGroup

        if dFrame and IsValid( dFrame ) and dFrame.CreateRightPanel then
            dFrame:CreateRightPanel()
        end
    else
        -- set in a team from another
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ] = VS_PoliceMod.DispatchGroups[ newDispatchGroup ] or {}
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players or {}
        VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] or {}
        VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players = VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players or {}
        VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players[ pPlayer ] = nil
        if table.Count( VS_PoliceMod.DispatchGroups[ oldDispatchGroup ].Players ) <= 0 then
            VS_PoliceMod.DispatchGroups[ oldDispatchGroup ] = nil
        end
        VS_PoliceMod.DispatchGroups[ newDispatchGroup ].Players[ pPlayer ] = true
        pPlayer.Dispatch = newDispatchGroup

        if dFrame and IsValid( dFrame ) and dFrame.CreateRightPanel then
            dFrame:CreateRightPanel()
        end
    end

    if lastDispatchNotif + 10 < CurTime() and LocalPlayer().Dispatch and LocalPlayer().Dispatch ~= VS_PoliceMod:L("NotDispatched") and ( newDispatchGroup == LocalPlayer().Dispatch or oldDispatchGroup == LocalPlayer().Dispatch ) then
        VS_PoliceMod:Notify( VS_PoliceMod:L("DispatchGroupModified"), 10 )
        lastDispatchNotif = CurTime()
    end
end )

hook.Add( "VS_PoliceMod:OnMissionReceived", "VS_PoliceMod:OnMissionReceived:Dispatch", function( tMissionInformations )
    if dMinimapPanel and IsValid( dMinimapPanel ) and dMinimapPanel.AddMission then
        dMinimapPanel:AddMission( tMissionInformations )
    end
end )

hook.Add( "VS_PoliceMod:OnMissionsCancelled", "VS_PoliceMod:OnMissionsCancelled:Dispatch", function( pEmitter )
    if dMinimapPanel and IsValid( dMinimapPanel ) and dMinimapPanel.RemoveMission then
        dMinimapPanel:RemoveMission( pEmitter )
    end
end )


--[[
    APP CREATION
]]

local App = {}

App.Name = VS_PoliceMod:L("Dispatch")
App.Icon = utf8.char( 0xf5a0 )

function App:Open( dParent, iSizeW, iSizeH )
	local mMap = KVS.Minimap.GetGameMapImage()

    dFrame = vgui.Create( "KVS.Frame", dParent )
    dFrame:Dock( FILL )
    dFrame:SetBorder( false )
    dFrame:SetUseAnimation( false )
    dFrame:ShowCloseButton( false )
    dFrame._Toolbar._frameTitle:SetFont(font("Rajdhani Bold", 21))
    dFrame:SetFont("Rajdhani")
    dFrame:SetTitle( VS_PoliceMod:L("DispatchAndGPS") )
    dFrame:SetSubTitle( VS_PoliceMod:L("PlaceUnitsAroundCity"))
    dFrame:SetFrameIcon( font("FAS", 15, "extended"), 0xf5a0, color_white )

    local currentSize = iSizeW

    local maxZoom
    local maxUnzoom

    local move_x = 0
    local move_y = 0

    local currentFocus

    dMinimapPanel = vgui.Create( "KVS.Panel", dFrame )
    dMinimapPanel:Dock( FILL )
    dMinimapPanel.Missions = {}
    function dMinimapPanel:RemoveMission( pEmitter )
        if not self.Missions[ pEmitter ] or not IsValid( self.Missions[ pEmitter ] ) then return end
        if self.Missions[ pEmitter ].InfoDetails and IsValid( self.Missions[ pEmitter ].InfoDetails ) then
            self.Missions[ pEmitter ].InfoDetails:Remove()
        end

        self.Missions[ pEmitter ]:Remove()
        self.Missions[ pEmitter ] = nil
    end
    function dMinimapPanel:AddMission( tMissionInfos )
        local this = self

        local dMission = vgui.Create( "DButton", self )
        dMinimapPanel.Missions[ tMissionInfos.emitter ] = dMission
        dMission:SetSize( 30, 30 )
        dMission:SetText( "" )
        function dMission:Paint( w, h )
            draw.SimpleText( utf8.char( 0xf06a ), font( "FAS", 30, "extended" ), w / 2 + 1, h / 2 + 1, config( "vgui.color.black_hard" ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( utf8.char( 0xf06a ), font( "FAS", 30, "extended" ), w / 2, h / 2, config( "vgui.color.warning" ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        function dMission:Think()
            local x, y  = KVS.Minimap.VectorToPos( self.Infos.positionEmitter, currentSize, currentSize )
            x = x + move_x
            y = y + move_y
           
            self:SetPos( x, y )
        end
        function dMission:DoClick()
            if not this or not IsValid( this ) then return end
            if self.InfoDetails and IsValid( self.InfoDetails ) then self.InfoDetails:Remove() end

            local infos = self.Infos

            if not infos or not IsValid( infos.emitter ) then
                self:Remove()
                return
            end

            self.InfoDetails = vgui.Create( "KVS.ScrollPanel", this )
            local infoDetails = dMission.InfoDetails
            infoDetails:SetSize( 200, 145 )
            currentFocus = infoDetails

            function infoDetails.Paint( infoDetails, w, h )
                draw.RoundedBox( 3, 0, 0, w, h, config( "vgui.color.black" ) )
            end
            function infoDetails.Think( infoDetails )
                local pos_x, pos_y = self:GetPos()
                local x = math.Clamp( pos_x - infoDetails:GetWide() / 2 + self:GetWide() / 2, 0, this:GetWide() - infoDetails:GetWide() )
                local y = math.Clamp( pos_y + self:GetTall(), 0, this:GetTall() - infoDetails:GetTall() )
                infoDetails:SetPos( x, y )
                if currentFocus ~= infoDetails then
                    infoDetails:Remove()
                end
            end

            local titleLabel = vgui.Create( "DLabel", infoDetails )
            titleLabel:Dock( TOP )
            titleLabel:DockMargin( 0, 2, 0, 5 )
            titleLabel:SetFont( font( "Rajdhani Bold", 20 ) )
            titleLabel:SetText( VS_PoliceMod:L("HelpRequest") .. " : " )
            titleLabel:SetContentAlignment( 5 )

            local separationPanel = vgui.Create( "DPanel", infoDetails )
            separationPanel:Dock( TOP )
            separationPanel:SetTall( 2 )
            function separationPanel:Paint( w, h )
                draw.RoundedBox( 0, 0, 0, w, h, config( "vgui.color.black_hard" ) )
            end

            local textEmitter = vgui.Create( "DLabel", infoDetails )
            textEmitter:Dock( TOP )
            textEmitter:DockMargin( 5, 2, 5, 0 )
            textEmitter:SetFont( font( "Rajdhani", 18 ) )
            textEmitter:SetText( VS_PoliceMod:L("By") .. " : " .. infos.emitter:Name() )
            textEmitter:SetContentAlignment( 4 )

            local textReason = vgui.Create( "DLabel", infoDetails )
            textReason:Dock( TOP )
            textReason:DockMargin( 5, 0, 5, 0 )
            textReason:SetFont( font( "Rajdhani", 18 ) )
            textReason:SetText( VS_PoliceMod:L("Reason") .. " : " .. infos.missionType )
            textReason:SetContentAlignment( 4 )

            local textDate = vgui.Create( "DLabel", infoDetails )
            textDate:Dock( TOP )
            textDate:DockMargin( 5, 0, 5, 0 )
            textDate:SetFont( font( "Rajdhani", 18 ) )
            textDate:SetText( VS_PoliceMod:L("At") .. " : " .. os.date( "%H:%M:%S", infos.timeStart ) )
            textDate:SetContentAlignment( 4 )

            local textDescription = vgui.Create( "DLabel", infoDetails )
            textDescription:Dock( TOP )
            textDescription:DockMargin( 5, 0, 5, 0 )
            textDescription:SetFont( font( "Rajdhani", 18 ) )
            textDescription:SetText( VS_PoliceMod:L("Description") .. " : " .. ( ( not infos.missionDesc or infos.missionDesc == "" ) and VS_PoliceMod:L("NoDescriptionSpecified") or infos.missionDesc ) )
            textDescription:SetContentAlignment( 4 )
            textDescription:SetAutoStretchVertical( true )
            textDescription:SetWrap( true )

            if LocalPlayer():PM_IsChief() then
                local dispatchGroup = vgui.Create( "KVS.ComboBox", infoDetails )
                dispatchGroup:Dock( TOP )
                dispatchGroup:DockMargin( 5, 5, 5, 0 )
                dispatchGroup:SetTall( 20 )
                dispatchGroup:SetValue( infos.dispatchGroup or VS_PoliceMod:L("NoOneAssigned") )
                dispatchGroup:AddChoice( " " .. VS_PoliceMod:L("NoOneAssigned") )
                for sGroupName, info in pairs( VS_PoliceMod.DispatchGroups ) do
                    dispatchGroup:AddChoice( sGroupName )
                end
                function dispatchGroup:OnSelect( iIndex, sValue )
                    VS_PoliceMod:NetStart( "SelectDispatch", { infos.emitter:UserID(), sValue } )
                    VS_PoliceMod:Notify( string.format( VS_PoliceMod:L("MissionAssignedTo"), sValue ) )
                end
            end

            local stopMission = vgui.Create( "KVS.Button", infoDetails )
            stopMission:Dock( TOP )
            stopMission:DockMargin( 5, 5, 5, 0 )
            stopMission:SetTall( 25 )
            stopMission:SetText( VS_PoliceMod:L("Solved") )
            stopMission:SetFont( font( 'Rajdhani Bold', 20 ) )
            stopMission:SetColor( config( "vgui.color.accept_green" ) )
            stopMission:WithIcon( font( 'FAS', 20, 'extended' ), 0xf00c )
            function stopMission:DoClick()
                if this and IsValid( this ) then
                    this:RemoveMission( infos.emitter )
                end
                VS_PoliceMod:NetStart( "MissionSolved", { infos.emitter:UserID() } )
                VS_PoliceMod:Notify( VS_PoliceMod:L("HelpRequestMarkedSolved"))
            end
        end
        dMission.Infos = tMissionInfos
    end

    function dMinimapPanel:DrawMap( w, h )
        surface.SetDrawColor( color_white )
        surface.SetMaterial( mMap )
        surface.DrawTexturedRect( move_x, move_y, currentSize, currentSize )
    end
    function dMinimapPanel:DrawPolice( w, h )
        for _, pPlayer in pairs( player.GetAll() ) do
            if not pPlayer:PM_HasGPS() then continue end

            local x, y  = KVS.Minimap.VectorToPos( pPlayer:GetPos(), currentSize, currentSize )
            x = x + move_x
            y = y + move_y

            draw.SimpleText( pPlayer:Name(), font( "Rajdhani Bold", 18 ), x + 1, y + 1, config( "vgui.color.black_hard" ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
            draw.SimpleText( pPlayer:Name(), font( "Rajdhani Bold", 18 ), x, y, Color( 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
            draw.SimpleText( "⬤", font( "Rajdhani Bold", 15 ), x + 1, y + 1, config( "vgui.color.black_hard" ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "⬤", font( "Rajdhani Bold", 15 ), x, y, Color( 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        end
    end
    function dMinimapPanel:Paint( w, h )
        if self:IsHovered() then
            self:SetCursor( 'hand' )
        end

        maxZoom = h * 10
        maxUnzoom = math.min( w, h )

        move_x = math.Clamp( move_x, w - currentSize, 0 )
        move_y = math.Clamp( move_y, h - currentSize, 0 )

    	self:DrawMap( w, h )
        self:DrawPolice( w, h )
	end
    function dMinimapPanel:Zoom( mouseWheel )
        if currentFocus ~= self then return end

        local oldSize = currentSize
        currentSize = math.Clamp( currentSize * ( 1 + mouseWheel / 10 ) , maxUnzoom, maxZoom)
        move_x = move_x - ( currentSize - oldSize ) / 2
        move_y = move_y - ( currentSize - oldSize ) / 2
    end
    function dMinimapPanel:Think()
        if not self.IsMoving then
            return
        end

        local x, y = input.GetCursorPos()
        -- print( self:CursorPos() )
        local oldx, oldy = self.IsMoving[1], self.IsMoving[2]
        move_x = move_x - ( oldx - x )
        move_y = move_y - ( oldy - y )

        self.IsMoving[ 1 ] = x
        self.IsMoving[ 2 ] = y

    end
    function dMinimapPanel:OnMousePressed( iMouseCode )
        currentFocus = self
        if iMouseCode ~= MOUSE_LEFT then return end

        if not self.IsMoving then
            self.IsMoving = { input.GetCursorPos() }
            self:MouseCapture( true )
            return
        end
    end
    function dMinimapPanel:OnMouseReleased( iMouseCode )
        if not dMinimapPanel.Clics[ iMouseCode ] then return end

        self.IsMoving = nil
        self:MouseCapture( false )

        if ( self.LastClicCode or 0 ) == iMouseCode and CurTime() - ( self.LastClicTime or 0 ) < 0.2 then
            dMinimapPanel.Clics[ iMouseCode ]()

            self.LastClicTime = nil
            self.LastClicCode = nil 
            return
        end

        self.LastClicTime = CurTime()
        self.LastClicCode = iMouseCode 
    end
    function dMinimapPanel:OnMouseWheeled( dData )
        self:Zoom( dData )
    end

    dMinimapPanel.Clics = {
        [ MOUSE_LEFT ] = function()
            -- dMinimapPanel:Zoom()
        end,
        [ MOUSE_RIGHT ] = function()
            -- dMinimapPanel:Unzoom()
        end,
    }


    local policeCalls = VS_PoliceMod.CurrentPoliceCalls or {}

    for _, tData in pairs( policeCalls ) do
        dMinimapPanel:AddMission( tData )
    end


    --[[
        
        RIGHT PANEL

    ]]
    function dFrame:CreateRightPanel()
        if self.RightPanel and IsValid( self.RightPanel ) then self.RightPanel:Remove() end

        local dRight = vgui.Create( "KVS.ScrollPanel", self )
        self.RightPanel = dRight
        dRight:Dock( RIGHT )
        dRight:SetWide( iSizeW * 0.3)
        function dRight:Paint() end

        local tCops = VS_PoliceMod:GetCops()

        local listPoliceGroups = VS_PoliceMod.DispatchGroups or {}

        local tGroupsCategory = {}
        local function CreateCategory( groupName, listCops )
            local tall = 20
            listCops = listCops or {}
            
            local dCollapsible = vgui.Create( "DCollapsibleCategory", dRight )
            dCollapsible:DockMargin( 10, 0, 10, 10 )
            dCollapsible:Dock( TOP )
            dCollapsible:SetLabel( groupName )
            dCollapsible.Group = groupName
            if LocalPlayer():PM_IsChief() then
                dCollapsible:Receiver( "PlayerPanels", function( dCollapsible, tPanels, isDropped )
                    if isDropped then
                        if not dCollapsible.Group then return end
                        for _, dPlayerPanel in pairs( tPanels ) do
                            if not dPlayerPanel.Player or not IsValid( dPlayerPanel.Player ) then continue end
                            local dParent = dPlayerPanel:GetParent()
                            if not IsValid( dParent ) then return end
                            local dMainParent = dParent:GetParent()
                            if not IsValid( dMainParent ) then return end

                            local oldGroup = dCollapsible.Group
                            local newGroup = dMainParent.Group or dParent.Group

                            if newGroup == oldGroup then return end

                            dParent:SetTall( math.max( dParent:GetTall() - 50, 0 ) )
                            dMainParent:SetTall( dParent:GetTall() + 20 )
                            dPlayerPanel:SetParent( dCollapsible )
                            dPlayerPanel:Dock( TOP )
                            dCollapsible:SetTall( dCollapsible:GetTall() + 50 )

                            VS_PoliceMod:NetStart( "ChangeDispatch", { dPlayerPanel.Player:UserID(), dCollapsible.Group, dMainParent.Group or dParent.Group } )
                        end
                    end
                end )
            end

            local dContentPanel = vgui.Create( "DPanel", dRight )
            dContentPanel:Dock( TOP )

            for pPlayer, isPlaced in pairs( listCops ) do
                if not tCops[ pPlayer ] then continue end
                tCops[ pPlayer ] = false

                local dPlayerPanel = vgui.Create( "DButton", dContentPanel )
                dPlayerPanel:Dock( TOP )
                dPlayerPanel:SetText( "" )
                dPlayerPanel:SetTall( 50 )
                dPlayerPanel.Player = pPlayer
                function dPlayerPanel:Paint( w, h )
                    if not IsValid( pPlayer ) then 
                        dPlayerPanel:Remove()
                        if IsValid( dCollapsible ) and tall then
                            dCollapsible:SetTall( tall - 50  )
                        end
                        return
                    end

                    draw.RoundedBox( 0, 0, 0, w, h, config( "vgui.color.light_black" ) )
          
                    local name = pPlayer:Name()
                    surface.SetFont( font( "Rajdhani Bold", 20 ) )
                    local text_size = surface.GetTextSize( name )

                    if text_size <= w - 50 then
                        draw.SimpleText( name, font("Rajdhani Bold", 20), 50, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
                    else
                        draw.SimpleText( name, font("Rajdhani Bold", 14), 50, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
                    end

                    draw.SimpleText( team.GetName( pPlayer:Team() ), font("Rajdhani", 20, "italic"), 50, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

                    draw.RoundedBox( 0, 0, h - 1, w, 1, config( "vgui.color.black_hard" ) )
                end

                if LocalPlayer():PM_IsChief() then
                    dPlayerPanel:Droppable( "PlayerPanels" )
                end

                local dPlayerAvatar = vgui.Create( "KVS.AvatarImage", dPlayerPanel )
                dPlayerAvatar:SetType( "circle" )
                dPlayerAvatar:SetSize( 40, 40 )
                dPlayerAvatar:SetPos( 5, 5 )
                dPlayerAvatar:SetPlayer( pPlayer )

                dPlayerPanel.oldOnMousePressed = dPlayerPanel.OnMousePressed
                if LocalPlayer():PM_IsChief() then
                    function dPlayerPanel:OnMousePressed( iMouseCode )
                        self:oldOnMousePressed( iMouseCode )

                        if iMouseCode ~= MOUSE_RIGHT then return end

                        local menu = DermaMenu()
                        menu:AddOption( VS_PoliceMod:L("Fire"), function()
                            if pPlayer == LocalPlayer() then 
                                VS_PoliceMod:Notify( VS_PoliceMod:L("CantFireYourself"), 10 )
                                return
                            end
                            dPlayerPanel:Remove()
                            dContentPanel:SetTall( dContentPanel:GetTall() - 50 )
                            dCollapsible:SetTall( dContentPanel:GetTall() + 20 )
                            VS_PoliceMod:NetStart( "FireCop", { pPlayer:UserID() } )
                        end )
                        menu:Open()
                    end
                end
                tall = tall + 50
            end

            dCollapsible:SetTall( tall )
            dCollapsible:SetContents( dContentPanel )
        end

        for groupName, groupInfos in pairs( listPoliceGroups or {} ) do
            CreateCategory( groupName, groupInfos.Players )
        end

        --[[

            Not dispatched

        ]]
        CreateCategory( VS_PoliceMod:L("NotDispatched"), tCops )

        local function CreateNewGroupButton()
            local dNewGroup = vgui.Create( "KVS.Button", dRight )
            dNewGroup:Dock( TOP )
            dNewGroup:DockMargin( 10, 0, 10, 10 )
            dNewGroup:SetTall( 25 )
            dNewGroup:SetText( VS_PoliceMod:L("AddNewGroup") )
            dNewGroup:SetFont( font( 'Rajdhani Bold', 20 ) )
            dNewGroup:WithIcon( font( 'FAS', 20, 'extended' ), 0xf067 )
            function dNewGroup:DoClick()
                local newGroup
                local isEmpty = false

                for sGroupName, bBool in pairs( CFG.DispatchGroupsNames ) do
                    if listPoliceGroups[ sGroupName ] then
                        if table.IsEmpty( listPoliceGroups[ sGroupName ] ) then
                            isEmpty = true
                            newGroup = nil
                            break
                        else
                            continue
                        end
                    end
                    
                    newGroup = sGroupName
                end

                if newGroup then
                    listPoliceGroups[ newGroup ] = {}
                    CreateCategory( newGroup, listPoliceGroups[ newGroup ] )
                    CreateNewGroupButton()
                    self:Remove()
                elseif isEmpty then
                    VS_PoliceMod:Notify( VS_PoliceMod:L("AlreadyEmptyGroup"))
                else
                    VS_PoliceMod:Notify( VS_PoliceMod:L("MaximumGroupsReached"))
                end
            end
        end

        if LocalPlayer():PM_IsChief() then
            CreateNewGroupButton()
        end
    end

    dFrame:CreateRightPanel()
end

VS_PoliceMod:RegisterApp( App )
