    --[[ 
        Aero F4 - coded by: ted.lua (https://steamcommunity.com/id/tedlua/)
        Design Concept by: RE Lexi (https://www.gmodstore.com/users/76561198090218596)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      76561198058539108 29836

        Please do not edit anything in this file; it WILL remove support from you.
        
        Have an issue with the script? Please make a ticket and we will assist you.
    --]]

    local PANEL = {}

    function PANEL:SetText( txt )
        self.Str = txt
    end

    function PANEL:GetText()
        return self.Str or "No text set"
    end

    local mats = {
        CHECKED = Aero.Materials.CIRCLE_FILLED,
        DEFAULT = Aero.Materials.CIRCLE_OUTLINE
    }

    function PANEL:SetChecked( active )
        self.Active = active
        self.Mat = active and mats.CHECKED or mats.DEFAULT
    end

    function PANEL:SetCallback( callback )
        self.callback = function() callback( self ) end
    end

    function PANEL:Init()
        local scr_w, scr_h = ScrW(), ScrH()
        local check_box = self:Add( "DPanel" )
        check_box:SetSize( scr_w * 0.1, scr_h * 0.023 )
        check_box:SetPos( check_box:GetWide() - scr_w * 0.026, check_box:GetTall() / 2 - scr_h * 0.014 / 2 )
        check_box.Paint = function( me, w, h )
            --Aero.DrawRect( 0, 0, w, h, Aero.Colors.RED )
            Aero.DrawTexture( self.Mat, 0, 0, scr_w * 0.0084, scr_h * 0.015, self.Mat == mats.CHECKED and Aero.Colors.WHITE or Aero.Colors.GREY )
        end
        check_box.OnMousePressed = function( me )
            self:SetChecked( !self.Active )
            self.callback( me )
        end
    end

    function PANEL:Paint( w, h )
        local scr_w = ScrW()
        Aero.DrawRoundedBox( 6, 0, 0, w, h, Aero.Colors.BASE_CONTAINER )
        Aero.DrawText( self:GetText(), "Aero.Font.6", scr_w * 0.003, h / 2, Aero.Colors.GREY, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    vgui.Register( "Skeleton.Checkbox", PANEL, "DPanel" )

