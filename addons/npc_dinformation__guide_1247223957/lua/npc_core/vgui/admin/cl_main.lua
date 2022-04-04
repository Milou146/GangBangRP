
-- DELETE CHOICE DERMA
local function DeleteChoice()
	local base = vgui.Create( "DFrame" )
	base:ShowCloseButton( true )
	base:SetTitle( "" )
	base:SetSize( 500, 300 )
	base:SetAlpha( 0 )
	base:AlphaTo( 255, 0.25 )
	base:MakePopup()
	base:Center()

	function base:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( 226, 0, 0, 250 )
		surface.DrawRect( 0, 0, w, 30 )
		
		draw.DrawText( OsGuide.Lang.nlfbotl48, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER)
		draw.DrawText( OsGuide.Lang.nlfbotl49, "guide_CCN_12", w / 2, 115, color_white, TEXT_ALIGN_CENTER)
	end 

	local actionChoice = vgui.Create( "DComboBox", base )
	actionChoice:SetPos( base:GetWide() / 4, 40 )
	actionChoice:SetSize( 200, 30 )
	actionChoice:SetValue( OsGuide.Lang.nlfbotl50 ) -- ton choix
	actionChoice:AddChoice( OsGuide.Lang.nlfbotl51 ) -- 1 bot
	actionChoice:AddChoice( OsGuide.Lang.nlfbotl52 ) -- 1 Client
	actionChoice:AddChoice( OsGuide.Lang.nlfbotl53 )-- tout bots
	actionChoice:AddChoice( OsGuide.Lang.nlfbotl54 ) -- tout clients
	actionChoice:AddChoice( OsGuide.Lang.nlfbotl55 ) -- tout
									
	local inputText = vgui.Create( "DTextEntry", base ) 
	inputText:SetPos( base:GetWide()/4, 130 )
	inputText:SetSize( 300,  30)
	inputText:SetText( OsGuide.Lang.nlfbotl56 )
	inputText:SetDrawLanguageID( false )
											
	local buttonValid = vgui.Create( "DButton", base )
	buttonValid:SetSize( 300, 50 )
	buttonValid:SetPos( base:GetWide() / 4, 230 )
	buttonValid:SetText( OsGuide.Lang.nlfbotl57 )
	buttonValid:SetFont( "guide_CCN_12" )
	buttonValid:SetTextColor( Color( 0, 0, 0, 255 ) )

	function buttonValid:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 200, 200, 200, 255 ) || Color( 255, 255, 255 ), false, false, true, true )
	end
					
	buttonValid.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )

		local action = actionChoice:GetValue()
		if ( action == OsGuide.Lang.nlfbotl51 ) then -- 1 bot
			net.Start( "Guide_Server" )
				net.WriteInt( -7, 4 )
				net.WriteString( inputText:GetValue() )
			net.SendToServer()
		elseif ( action == OsGuide.Lang.nlfbotl52 ) then -- 1 client
			net.Start( "Guide_Server" )
				net.WriteInt( -6, 4 )
				net.WriteString( inputText:GetValue() )
			net.SendToServer()
		elseif ( action == OsGuide.Lang.nlfbotl53 ) then -- tout bot
			net.Start( "Guide_Server" )
				net.WriteInt( -5, 4 )
			net.SendToServer()
		elseif ( action == OsGuide.Lang.nlfbotl54 ) then -- tout clients
			net.Start( "Guide_Server" )
				net.WriteInt( -4, 4 )
			net.SendToServer()
		elseif ( action == OsGuide.Lang.nlfbotl55 ) then -- tout
			net.Start( "Guide_Server" )
				net.WriteInt( -3, 4 )
			net.SendToServer()
		end 
						
		base:Close()
	end

	buttonValid.OnCursorEntered = function( self )
		surface.PlaySound( OsGuide.onHoveredSound )
	end
									
end

-- SHOW DATA NPC DERMA
function OsGuide:ShowDataNPC( content )

	local base = vgui.Create( "DFrame" )
	base:ShowCloseButton( true )
    base:SetTitle( "" )
    base:SetSize( 400, 300 )
    base:SetAlpha( 0 )
    base:AlphaTo( 255, 0.25 )
    base:Center()
    base:MakePopup()

    function base:Paint( w, h )
    	surface.SetDrawColor( 0, 0, 0, 255 )
    	surface.DrawRect( 0, 0, w, h )

    	surface.SetDrawColor( 226, 0, 0, 250 )
    	surface.DrawRect( 0, 0, w, 30 )

        draw.DrawText( OsGuide.Lang.nlfbotl79, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER )
    end

	local listNPC = vgui.Create( "DListView", base )
    listNPC:Dock( FILL)
    listNPC:DockMargin( 5, 5, 5, 5 )
    listNPC:SetMultiSelect( false )
    listNPC:AddColumn("Nom du bot")

	for _, entity in ipairs( content ) do
        listNPC:AddLine( tostring( entity ) )
    end

	listNPC.OnRowRightClick = function(self, line)
        local DropDown = DermaMenu()

        local target = string.Split( string.Split( self:GetLine(line):GetValue(1), "_" )[2], "." )[1]
        DropDown:AddOption( OsGuide.Lang.nlfbotl51, function()
            net.Start("Guide_Server")
            	net.WriteInt( -7, 4 )
            	net.WriteString( target )
            net.SendToServer()
            listNPC:Clear()
        end)

        DropDown:AddSpacer()
        DropDown:Open()
    end
	
end

function OsGuide:ShowData( content )
    local base = vgui.Create( "DFrame" )
    base:ShowCloseButton( true )
    base:SetTitle( "" )
    base:SetSize( 900, 600 )
    base:SetAlpha( 0 )
    base:AlphaTo( 255, 0.25 )
    base:Center()
    base:MakePopup()

    local iconSearch = Material( OsGuide.iconSearch )
    function base:Paint( w, h )
    	surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 0, 0, 226, 255 )
        surface.DrawRect( 0, 0, w, 30 )

        draw.DrawText( OsGuide.Lang.nlfbotl58, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER )
		
		surface.SetDrawColor( Color( 242, 242, 242, 255) )
		surface.SetMaterial( iconSearch )
		surface.DrawTexturedRect( 210, 55, 25, 25 )	
    end

    local dataList = vgui.Create( "DListView", base )
    dataList:Dock( FILL )
    dataList:DockMargin( 250, 5, 5, 5 )
    dataList:SetWidth( 565 )
    dataList:SetMultiSelect( false )
    dataList:AddColumn( OsGuide.Lang.nlfbotl59 ):SetFixedWidth(200)
    dataList:AddColumn( OsGuide.Lang.nlfbotl60 )
    dataList:AddColumn( OsGuide.Lang.nlfbotl61):SetFixedWidth(120)
	dataList.OnRowRightClick = function(self, line)
        local DropDown = DermaMenu()

        DropDown:AddOption( OsGuide.Lang.nlfbotl62, function()
            net.Start( "Guide_Server" )
            	net.WriteInt( -6, 4 )
            	net.WriteString( tostring( self:GetLine(line):GetValue(1) ) )
            net.SendToServer()
            dataList:Clear()
        end)

        DropDown:AddSpacer()
        DropDown:Open()
    end

    if ( content ) then
    	dataList:Clear()
        dataList:AddLine( content[1], content[2], content[3])
    end

    local inputOffline = vgui.Create( "DTextEntry", base )
    inputOffline:SetPos( 235, 50 )
    inputOffline:SetSize( 200, 30 )
    inputOffline:SetPlaceholderText( OsGuide.Lang.nlfbotl63 )
    inputOffline:SetDrawLanguageID( false )
	
    local validSearch = vgui.Create("DButton", base)
    validSearch:SetSize( 200, 30 )
    validSearch:SetPos( 235, 90 )
    validSearch:SetText(  OsGuide.Lang.nlfbotl57 )
    validSearch:SetTextColor( Color( 255, 255, 255, 255 ) )
    validSearch:SetFont( "guide_CCN_12" )
  
    function validSearch:Paint( w, h )
        draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
        draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 255, 150, 150, 255 ) or Color( 175, 100, 100 ), false, false, true, true )
    end

    validSearch.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )

        dataList:Clear()
		net.Start( "Guide_Server" )
			net.WriteInt( -2, 4 )
    		net.WriteString( inputOffline:GetText() )
    	net.SendToServer()

    	base:Remove()
    end
    		
    validSearch.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
    end

	local buttonNPCData = vgui.Create( "DButton", base )
    buttonNPCData:SetSize( 200, 30 )
    buttonNPCData:SetPos( 235, 150 )
    buttonNPCData:SetText( OsGuide.Lang.nlfbotl80 )
    buttonNPCData:SetTextColor( Color( 255, 255, 255, 255 ) )
    buttonNPCData:SetFont("guide_CCN_12")

    buttonNPCData.Paint = function(self, w, h)
       draw.RoundedBoxEx( 0, 0, 0, w, h, Color(255, 150, 150, 255), false, false, true, true )
        draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 255, 150, 150, 255 ) or Color( 175, 100, 100 ), false, false, true, true )
    end

    buttonNPCData.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
     	net.Start("Guide_Server")
     		net.WriteInt( -1, 4 )
   	 	net.SendToServer()
    end
		
    buttonNPCData.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
    end
	
    local playerList = vgui.Create( "DListView", base )
    playerList:Dock( LEFT )
    playerList:DockMargin( 5, 5, 5, 5 )
    playerList:SetWidth( 200 )
    playerList:SetMultiSelect( false )
    playerList:AddColumn( OsGuide.Lang.nlfbotl64 )

    playerList.OnRowSelected = function(self, line)
        dataList:Clear()
        net.Start( "Guide_Server" )
        	net.WriteInt( 0, 4 )
        	net.WriteString( tostring(self:GetLine(line):GetValue(1)) )
        net.SendToServer()

        base:Remove()
    end

    for _, player in ipairs( player.GetAll() ) do
        playerList:AddLine( player:Nick() )
    end
end

-- CREDIT DERMA
local function ShowCredit()

	local base = vgui.Create( "DFrame" )
	base:ShowCloseButton( false )
    base:SetTitle( "" )
    base:SetSize( 400, 400 )
    base:SetAlpha( 0 )
    base:AlphaTo( 255, 0.25 )
    base:Center()
    base:MakePopup()

    local iconCreator = Material( OsGuide.iconCreator )
    function base:Paint( w, h )
    	surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( 0, 0, w, h )
      	
      	surface.SetDrawColor( 226, 0, 0, 250 )
        surface.DrawRect( 0, 0, w, 30 )
		
        draw.DrawText( OsGuide.Lang.nlfbotl65, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER)
		
		draw.DrawText( OsGuide.Lang.nlfbotl66 .. OsGuide.Version, "guide_CCBI", w / 2, 50, color_white, TEXT_ALIGN_CENTER)
		
		draw.DrawText( OsGuide.Lang.nlfbotl67 .." Osmos Kesko", "guide_CCBI", w / 2, 100, color_white, TEXT_ALIGN_CENTER)
		
		draw.DrawText("Néo-Life Community", "guide_CCBI", w / 2, 120, color_white, TEXT_ALIGN_CENTER)
		
		draw.DrawText( OsGuide.Lang.nlfbotl68.. " Osmos Kesko", "guide_CCBI", w / 2, 170, color_white, TEXT_ALIGN_CENTER)
		
		draw.DrawText( OsGuide.Lang.nlfbotl69.. " Osmos Kesko", "guide_CCBI", w / 2, 190, color_white, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor( Color( 242, 242, 242, 255) )
		surface.SetMaterial( iconCreator )
		surface.DrawTexturedRect( w / 3, 250, 150, 150 )
    end

	local close = vgui.Create( "DButton", base )
	close:SetSize( 50, 20 )
	close:SetPos( base:GetWide() - 50, 0 )
	close:SetText( "X" )
	close:SetTextColor( Color( 255, 255, 255, 255 ) )
	close:SetFont( "guide_CCN_12" )

	function close:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 255, 150, 150, 255 ) or Color( 175, 100, 100 ), false, false, true, true )
	end

	close.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
		base:Close()
	end

	close.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end
end 

-- ADD NEW BOT DERMA
local function newBot()

	local base = vgui.Create( "DFrame" )
	base:ShowCloseButton( true )
	base:SetTitle( "" )
	base:SetSize( 500, 300 )
	base:SetAlpha( 0 )
	base:AlphaTo( 255, 0.25 )
	base:Center()
	base:MakePopup()

	function base:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0, 255)
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( 226, 0, 0, 250 )
		surface.DrawRect( 0, 0, w, 30 )
		
		draw.DrawText( OsGuide.Lang.nlfbotl70, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER)
		draw.DrawText( OsGuide.Lang.nlfbotl71, "guide_CCN_12", w / 2, 115, color_white, TEXT_ALIGN_CENTER)
	end 
						
									
	local inputName = vgui.Create( "DTextEntry", base ) 
	inputName:SetPos( base:GetWide() / 4, 130 )
	inputName:SetSize( 300,  30)
	inputName:SetText( OsGuide.Lang.nlfbotl72 )
	inputName:SetDrawLanguageID( false )
									
	local valid = vgui.Create( "DButton", base )
	valid:SetSize( 300, 50 )
	valid:SetPos( base:GetWide()/4, 230 )
	valid:SetText( OsGuide.Lang.nlfbotl57 )
	valid:SetTextColor( Color( 0, 0, 0, 255 ) )
	valid:SetFont( "guide_CCN_12" )

	function valid:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 200, 200, 200, 255 ) or Color( 255, 255, 255 ), false, false, true, true )		
	end

	valid.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )

		base:Close()

		net.Start( "Guide_Server" )
			net.WriteInt( 1, 4 )
			net.WriteString( inputName:GetText() )
		net.SendToServer()
	end

	valid.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end
									
end 

-- ADMIN DERMA
function OsGuide:OpenAdminDerma()

	local base = vgui.Create( "DFrame" )
	base:ShowCloseButton( false )
	base:SetTitle( "" )
	base:SetSize( 500, 450 )
	base:SetAlpha( 0 )
	base:AlphaTo( 255, 0.25 )
	base:Center()
	base:MakePopup()

	local iconCreate = Material( OsGuide.iconCreate )
	local iconDelete = Material( OsGuide.iconDelete )
	local iconShowData = Material( OsGuide.iconShowData )
	function base:Paint( w, h )
		surface.SetDrawColor( 0, 0, 0, 230  )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( 226, 0, 0, 230 )
		surface.DrawRect( 0, 0, w, 30 )
		
		draw.DrawText( OsGuide.Lang.nlfbotl73, "guide_CCBI", w / 2, 4, color_white, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( Color( 242, 242, 242, 255 ) )

		surface.SetMaterial( iconCreate ) 
		surface.DrawTexturedRect( w / 9, 105, 65, 65 )	
			
		surface.SetMaterial( iconDelete )
		surface.DrawTexturedRect( w / 9, 325, 65, 65 )	
		
		surface.SetMaterial( iconShowData )
		surface.DrawTexturedRect(  w / 9, 215, 65, 65 )	
	end 
		
	local close = vgui.Create( "DButton", base )
	close:SetSize( 50, 20 )
	close:SetPos( base:GetWide() - 50, 0 )
	close:SetText( "X" )
	close:SetFont( "guide_CCN_12" )
	close:SetTextColor( Color( 255, 255, 255, 255 ) )

	function close:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 255, 150, 150, 255 ) or Color( 175, 100, 100 ), false, false, true, true )
	end

	close.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
		base:Close()
	end
					
	close.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end
		
	local buttonCredit = vgui.Create( "DButton", base )
	buttonCredit:SetSize( 50, 20 )
	buttonCredit:SetPos( 0, 0 )
	buttonCredit:SetText( OsGuide.Lang.nlfbotl74 ) 
	buttonCredit:SetTextColor( Color( 255, 255, 255, 255 ) )
	buttonCredit:SetFont( "guide_CCN_12" )

	function buttonCredit:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 255, 150, 150, 255 ) or Color( 175, 100, 100 ), false, false, true, true )
	end

	buttonCredit.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )

		ShowCredit()
	end
	
	buttonCredit.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end
					
	local buttonAdd = vgui.Create( "DButton", base )
	buttonAdd:SetSize( 300, 100 )
	buttonAdd:SetPos( base:GetWide() / 4, 80 )
	buttonAdd:SetText( OsGuide.Lang.nlfbotl75 )
	buttonAdd:SetTextColor( Color( 0, 0, 0, 255 ) )
	buttonAdd:SetFont( "guide_CCN_12" )

	function buttonAdd:Paint( w, h )
			draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
			draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 200, 200, 200, 255 ) or Color( 255, 255, 255 ), false, false, true, true )	
	end

	buttonAdd.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
		newBot()
	end

	buttonAdd.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end	
					

	local buttonShowData = vgui.Create( "DButton", base )
	buttonShowData:SetSize( 300, 100 )
	buttonShowData:SetPos( base:GetWide() / 4, 190 )
	buttonShowData:SetText( OsGuide.Lang.nlfbotl76 )
	buttonShowData:SetTextColor( Color( 0, 0, 0, 255 ) )
	buttonShowData:SetFont( "guide_CCN_12" )

	buttonShowData.Paint = function( self, w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 200, 200, 200, 255 ) or Color( 255, 255, 255 ), false, false, true, true )
	end

	buttonShowData.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
		OsGuide:ShowData()
	end

	buttonShowData.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end	
		
	local buttonDelete = vgui.Create( "DButton", base )
	buttonDelete:SetSize( 300, 100 )
	buttonDelete:SetPos( base:GetWide() / 4, 300 )
	buttonDelete:SetText( OsGuide.Lang.nlfbotl77 )
	buttonDelete:SetTextColor( Color( 0, 0, 0, 255 ) )
	buttonDelete:SetFont( "guide_CCN_12" )

	function buttonDelete:Paint( w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, Color( 255, 150, 150, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 1, 0, w - 2, h - 1, self:IsHovered() && Color( 200, 200, 200, 255 ) or Color( 255, 255, 255 ), false, false, true, true )
	end

	buttonDelete.DoClick = function()
		surface.PlaySound( OsGuide.onClickSound )
		DeleteChoice()
	end

	buttonDelete.OnCursorEntered = function()
		surface.PlaySound( OsGuide.onHoveredSound )
	end
end