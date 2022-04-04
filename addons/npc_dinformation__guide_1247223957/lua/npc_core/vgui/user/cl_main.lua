
-- Blur Function
local blur = Material("pp/blurscreen")

local function blurPanel(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 6 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end


/*
    URL FRAME

    Type:  "Web" or any
    Title: String
    Content: String
*/
local function DrawPopUp( type, title, content )

    local base = vgui.Create("DFrame")
        base:SetSize( ScrW() / 1.5, ScrH() / 1.5 )
        base:ShowCloseButton( false )
        base:AlphaTo( 255, 0.25 )
        base:SetTitle( "" )
        base:SetAlpha( 0 )
        base:MakePopup()
        base:Center()

        function base:Paint( w, h )
            surface.SetDrawColor( 0, 0, 0 )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( OsGuide.popUp.backgroundTitleColor )
            surface.DrawRect( 0, 0, w, 30 )
        
            draw.DrawText( title, "guide_CCBI", w / 2, 4, OsGuide.popUp.titleColor, TEXT_ALIGN_CENTER )

            if ( type == "web" ) then
                draw.DrawText( OsGuide.Lang.nlfbotl26, "guide_CCBI", w / 2, w / 2, OsGuide.popUp.titleColor, TEXT_ALIGN_CENTER )
            end
 
        end
    
    local but = vgui.Create( "DButton", base )
    but:Dock( BOTTOM )
    but:SetSize( 0, 37 )
    but:SetText( OsGuide.popUp.exitTitle )
    but:SetFont( "guide_CCBI" )
    but:SetTextColor( OsGuide.popUp.exitTextColor )

    function but:Paint( w, h)
        surface.SetDrawColor( self.Hovered && OsGuide.popUp.exitHover or OsGuide.popUp.exitColor )
        surface.DrawRect( 0, 0, w, h )
    end

    but.DoClick = function()
        base:Close()            
    end

    if ( type == "web" ) then
        print(content)
        local html = vgui.Create( "DHTML", base )
        html:Dock( FILL )
        html:OpenURL( content )
        html:SetAllowLua( true )

    else
        local dl = vgui.Create( "RichText", base )
        dl:Dock( FILL )
        dl:InsertColorChange( 255, 255, 255, 255 )
        dl:AppendText( content )
        dl:SetFontInternal( "guide_CCBI" )
        dl:SetVerticalScrollbarEnabled( true )
            
        function dl:PerformLayout()
            self:SetFontInternal( "guide_CCBI" )
         end
    end
        
end

/*
    OsGuide:OpenDerma
*/
function OsGuide:OpenDerma()
    local localAudio = false
    local method = false

    if ( OsGuide.useSound ) then 
        method = sound.PlayFile
    elseif OsGuide.useWebSound then
        method = sound.PlayURL 
    end 

    if ( method ) then
        method( OsGuide.soundPath, "", function( station )
            if ( IsValid( station ) ) then 
                localAudio = station 
                station:Play() 
            end
        end )
    end

    local baseWide = 960

    local base = vgui.Create( "DFrame" )
    base:ShowCloseButton( false )
    base:SetDraggable( true )
    base:SetSize( 960, 560 )
    base:SetVisible( true )
    base:SetTitle( "" )
    base:MakePopup()
    base:Center()

    function base:Paint( w, h )
        blurPanel( self, 5 )

        draw.RoundedBox( 10, 0, 0, w, h, OsGuide.backgroundContourColor )

        draw.SimpleText( OsGuide.title , "guide_CCN_24", baseWide - 550, 15, OsGuide.titleColor )

        surface.SetDrawColor( 242, 242, 242, 255 )
        surface.DrawLine(0, 43, baseWide, 43)

    end

    local close = vgui.Create( "DButton", base )
    close:SetSize( 50, 20 )
    close:SetPos( baseWide - 50, 0 )
    close:SetText( "X" )
    close:SetFont( "guide_CCN_12" )
    close:SetTextColor( Color(255, 255, 255) )

    function close:Paint( w, h )
        draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150 ), false, false, true, true )
        draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color(255, 150, 150) or Color(175, 100, 100), false, false, true, true )
    end

    close.DoClick = function()
        if ( ( OsGuide.useSound or OsGuide.useWebSound) and localAudio ) then 
            localAudio:Stop()
        end
        surface.PlaySound( OsGuide.onClickSound )

        base:Close()
    end

    close.OnCursorEntered = function(self)
        surface.PlaySound( OsGuide.onHoveredSound )
    end


    local secondBase = vgui.Create( "DPanel", base )
    secondBase:SetSize( baseWide, 468 )
    secondBase:SetPos( 0, 44 )

    local iconPath = Material( OsGuide.pathLogo )
    function secondBase:Paint( w, h )

        surface.SetDrawColor( OsGuide.backgroundColor )
        surface.DrawRect( 0, 0, w, h )
        
        if ( OsGuide.useLogo ) then

            surface.SetDrawColor( 242, 242, 242, 255 )
            surface.SetMaterial( iconPath )

            if ( OsGuide.rotationLogo ) then
                local Rotating = math.sin( CurTime() * 3 )

                if ( Rotating < 0 ) then
                    Rotating = 1 - (1 + Rotating)
                end

                surface.DrawTexturedRectRotated( w / 2, 30, Rotating * 65, 65, 0 )
     
            else
                surface.DrawTexturedRect( w / 2, 16, 65, 65 )
            end
        end
    end

    local baseButton = vgui.Create( "DPanel", base )
    baseButton:SetSize( baseWide, 225 )
    baseButton:SetPos( 0, 330 )
    function baseButton:Paint( w , h )
        surface.SetDrawColor( OsGuide.backgroundColor )
        surface.DrawRect( 0, 0, w, h )
    end 

    local scrollButton = vgui.Create( "DScrollPanel", baseButton )
    scrollButton:SetSize(811, 464)    
    scrollButton:Dock(FILL)

    local scrollButtonBar = scrollButton:GetVBar()     
    function scrollButtonBar:Paint( w, h )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, w, h )
    end
       
    function scrollButtonBar.btnGrip:Paint( w, h )
        surface.SetDrawColor( OsGuide.navbarColor )
        surface.DrawRect( 4, 0, w, h )
     end
       
    function scrollButtonBar.btnUp:Paint( w, h )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, w, h )
    end
       
    function scrollButtonBar.btnDown:Paint( w, h )
        surface.DrawRect( 0, 0, w, h )
    end

    local iconModel = vgui.Create( "DModelPanel", secondBase )
    iconModel:SetModel( OsGuide.modelNPC )
    iconModel:SetSize( 200, 200 )
    iconModel:SetPos( 50, 70 )

    local headPos = iconModel.Entity:GetBonePosition( iconModel.Entity:LookupBone("ValveBiped.Bip01_Head1") )
    iconModel:SetLookAt( headPos )
    iconModel:SetCamPos( headPos - Vector(-15, 0, 0) )
    iconModel.Entity:SetEyeTarget( headPos - Vector(-15, 0, 0) )

    function iconModel:LayoutEntity()
        return
    end

    if ( OsGuide.adminGroup[ LocalPlayer():GetUserGroup() ] ) then 
        local buttonAdmin = vgui.Create( "DButton", base )
        buttonAdmin:SetSize( 50, 20 )
        buttonAdmin:SetPos( 0, 0 )
        buttonAdmin:SetText( OsGuide.Lang.nlfbotl78 )
        buttonAdmin:SetTextColor( Color(255, 255, 255, 255) )
        buttonAdmin:SetFont( "guide_CCN_12" )

        function buttonAdmin:Paint( w, h )
            draw.RoundedBoxEx( 0, 0, 0, w, h, Color(255, 150, 150, 255), false, false, true, true )
            draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color(255, 150, 150, 255) or Color(175, 100, 100), false, false, true, true )
        end

        buttonAdmin.DoClick = function()
            surface.PlaySound( OsGuide.onClickSound )

            OsGuide:OpenAdminDerma()   
        end

        buttonAdmin.OnCursorEntered = function()
            surface.PlaySound( OsGuide.onHoveredSound )
        end

    end

    local textPanel = vgui.Create( "DLabel", secondBase )
    textPanel:SetSize( baseWide - 275, 200 )
    textPanel:SetPos( 275, 70 )
    textPanel:SetText( OsGuide.mainText )
    textPanel:SetTextColor( OsGuide.mainTextColor )
    textPanel:SetFont( "guide_CCBI" )
    textPanel:SetWrap(true)

    for index, content in ipairs( OsGuide.Action ) do

        local buttonAction = vgui.Create( "DButton", scrollButton )
        buttonAction:Dock( TOP )
        buttonAction:SetSize( 0, 30 )
        buttonAction:SetText( content.name or "Error: Name not found" )
        buttonAction:SetTextColor( OsGuide.buttonTextColor )
        buttonAction:SetFont( "guide_CCN_24" )

        function buttonAction:Paint( w, h )
            draw.RoundedBox(4, 2, 2, w - 4, h - 4, self:IsHovered() && OsGuide.buttonHoveredColor or OsGuide.buttonColor )
        end

        buttonAction.DoClick = function()
            surface.PlaySound( OsGuide.onClickSound )
            print( content.action )
            if ( content.action == "text" ) then
                DrawPopUp( "text", content.name, content.text )
            elseif ( content.action == "webURL" ) then
                gui.OpenURL(content.text)
            elseif ( content.action == "ingameURL" ) then
                DrawPopUp( "web", content.name, content.text )
            elseif ( content.action == "giveMoneyOneTime" ) then
                net.Start( "Guide_Server" )
                    net.WriteInt( -8, 4 )
                    net.WriteUInt( index, 16 )
                net.SendToServer()
            elseif ( content.action == "playSoundFile" ) then
                sound.PlayFile( content.text, "", function( station )
                    if ( IsValid( station ) ) then 
                        station:Play() 
                    end
                end ) 
            elseif ( content.action == "leave" ) then
                base:Close()
                if ( localAudio ) then 
                    localAudio:Stop()
                end 
            end
        end

        buttonAction.OnCursorEntered = function()
            surface.PlaySound( OsGuide.onHoveredSound )
        end

    end

end