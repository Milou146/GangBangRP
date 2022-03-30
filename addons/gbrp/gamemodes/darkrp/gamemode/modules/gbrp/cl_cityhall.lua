local frame
local defaultSkin = Material("gwenskin/gmoddefault.png")
net.Receive("GBRP::cityhallReception",function()
    local ply = LocalPlayer()
    local gang = ply:GetGang()
    local taxChoice
    if IsValid(frame) then return end
    frame = vgui.Create("EditablePanel",GetHUDPanel())
    frame.mat = Material("gui/gbrp/cityhall/background.jpg")
    frame:SetPos(gbrp.FormatX(376),gbrp.FormatY(143))
    frame:SetSize(gbrp.FormatX(1220),gbrp.FormatY(937))
    frame:MakePopup()
    local bottom = Material("gui/gbrp/bottombar.jpg")
    local side = Material("gui/gbrp/sidebar.png")
    local pcscreen = Material("gui/gbrp/pcscreen.png")
    local x1,y1,w1,h1 = gbrp.FormatX(30),gbrp.FormatY(54),gbrp.FormatX(1114),gbrp.FormatY(615)
    local x2,y2,w2,h2 = gbrp.FormatX(36),gbrp.FormatY(663),gbrp.FormatX(1131),gbrp.FormatY(41)
    local x3,y3,w3,h3 = gbrp.FormatX(1136),gbrp.FormatY(54),gbrp.FormatX(31),gbrp.FormatY(609)
    local x4,y4 = gbrp.FormatX(93),gbrp.FormatY(665)
    function frame:Paint(w,h)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(255,255,255,255)

        surface.SetMaterial(self.mat)
        surface.DrawTexturedRect(x1,y1,w1,h1)

        surface.SetMaterial(bottom)
        surface.DrawTexturedRect(x2,y2,w2,h2)

        surface.SetMaterial(side)
        surface.DrawTexturedRect(x3,y3,w3,h3)

        surface.SetMaterial(pcscreen)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetFont("Bank")
        surface.SetTextColor(0,0,0)
        surface.SetTextPos(x4,y4)
        surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))
    end
    local LoadPage2 = function()
        local x5,y5,w5,h5 = gbrp.FormatX(752),gbrp.FormatY(98),gbrp.FormatX(368),gbrp.FormatY(444)
        local x6,y6 = gbrp.FormatX(768),gbrp.FormatY(172)
        local y7 = gbrp.FormatY(276)
        local y8 = gbrp.FormatY(364)
        local y9 = gbrp.FormatY(450)
        local x10,y10 = gbrp.FormatX(812),gbrp.FormatY(161)
        local y11 = gbrp.FormatY(255)
        local y12 = gbrp.FormatY(359)
        local y13 = gbrp.FormatY(446)
        function frame:Paint(w,h)
            Derma_DrawBackgroundBlur(self, CurTime())
            surface.SetDrawColor(255,255,255,255)

            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(x1,y1,w1,h1)

            surface.SetMaterial(bottom)
            surface.DrawTexturedRect(x2,y2,w2,h2)

            surface.SetMaterial(side)
            surface.DrawTexturedRect(x3,y3,w3,h3)

            surface.SetMaterial(pcscreen)
            surface.DrawTexturedRect(0,0,w,h)

            surface.SetFont("Bank")
            surface.SetTextColor(0,0,0)
            surface.SetTextPos(x4,y4)
            surface.DrawText("SOLDE DU GANG: " .. gbrp.formatMoney(gang:GetBalance()))

            GWEN.CreateTextureBorder(256,128,127,127,8,8,8,8,defaultSkin)(x5,y5,w5,h5,Color(69,68,74,102))

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(x6,y6)
            surface.DrawText(gbrp.GetPropertyTax() .. " %")

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(x6,y7)
            surface.DrawText(gbrp.GetHousingTax() .. " %")

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(x6,y8)
            surface.DrawText(gbrp.GetIncomeTax() .. " %")

            surface.SetTextColor(255,0,0)
            surface.SetTextPos(x6,y9)
            surface.DrawText(gbrp.GetVAT() .. " %")

            surface.SetFont("BankMiles20")
            surface.SetTextColor(255,255,255,255)
            surface.SetTextPos(x10,y10)
            surface.DrawText("TAXE FONCIERE : Le pourcentage ci-avant")
            surface.SetTextPos(x10,y10 + 20)
            surface.DrawText("indiqué s'applique sur la valeur vénale de")
            surface.SetTextPos(x10,y10 + 40)
            surface.DrawText("chaque commerce possédé par le gang.")
            surface.SetTextPos(x10,y11)
            surface.DrawText("TAXE D'HABITATION : Le pourcentage ci-avant")
            surface.SetTextPos(x10,y11 + 20)
            surface.DrawText("indiqué s'applique sur la valeur de chaque")
            surface.SetTextPos(x10,y11 + 40)
            surface.DrawText("propriété dont le gang est propriétaire.")
            surface.SetTextPos(x10,y11 + 60)
            surface.DrawText("Sont exclus les commerces.")
            surface.SetTextPos(x10,y12)
            surface.DrawText("IMPOT SUR LES SOCIETES : Le pourcentage")
            surface.SetTextPos(x10,y12 + 20)
            surface.DrawText("s'applique sur les fonds que détient le gang.")
            surface.SetTextPos(x10,y13)
            surface.DrawText("TVA : La TVA est applicable sur les fonds")
            surface.SetTextPos(x10,y13 + 20)
            surface.DrawText("blanchis.")
        end
        local propertyTax,housingTax,incomeTax,VAT = {},{},{},{}
        local taxList = {
            ["propertyTax"] = {propertyTax,170,"TAXE FONCIERE"},
            ["housingTax"] = {housingTax,265,"TAXE D'HABITATION"},
            ["incomeTax"] = {incomeTax,355,"IMPOT SUR LES SOCIETES"},
            ["VAT"] = {VAT,448,"TVA"},
        }
        for tax,v in pairs(taxList) do
            v[1].frame = vgui.Create("Panel",frame)
            v[1].frame:SetSize(gbrp.FormatXY(207,34))
            v[1].frame:SetPos(gbrp.FormatXY(79,v[2]))
            v[1].frame.Paint = function(self,w,h)
                GWEN.CreateTextureBorder(320,0,64,63,8,8,8,8,defaultSkin)(0,0,w,h,Color(0,0,0,125))
            end
            v[1].label = vgui.Create("DLabel",v[1].frame)
            v[1].label:SetText(v[3])
            v[1].label:SetFont("BankSmall")
            v[1].label:SizeToContents()
            v[1].label:Center()
            v[1].label:SetColor(Color(255,255,255))
            v[1].button = vgui.Create("DButton",frame)
            v[1].button:SetSize(gbrp.FormatXY(172,19))
            v[1].button:SetPos(gbrp.FormatXY(96,v[2] + 32))
            v[1].button:SetColor(Color(252,255,81))
            v[1].button:SetFont("BankMiles20")
            v[1].button.mat = Material("gui/gbrp/cityhall/button.png")
            v[1].button.Paint = function(self,w,h)
                if self:IsHovered() and self:IsEnabled() then
                    surface.SetDrawColor(255,0,0)
                elseif self:IsEnabled() then
                    surface.SetDrawColor(0,0,0)
                else
                    surface.SetDrawColor(88,86,86)
                end
                surface.SetMaterial(self.mat)
                surface.DrawTexturedRect(0,0,w,h)
            end
            v[1].button.SetPrice = function(self,amount)
                self.price = amount
                self:SetText(gbrp.formatMoney(self.price))
            end
        end

        if taxChoice then
            for tax,v in pairs(taxList) do
                v[1].button:SetPrice(gbrp.tax[tax][GetGlobalInt(tax) + 1])
                v[1].button.DoClick = function(self)
                    if gang:CanAfford(self.price) then
                        net.Start("GBRP::changeTax")
                        net.WriteString(tax)
                        net.WriteBool(true)
                        net.WriteInt(self.price,32)
                        net.SendToServer()
                        SetGlobalInt(tax,GetGlobalInt(tax) + 1)
                        self:SetEnabled(GetGlobalInt(tax) < 5)
                        self:SetPrice(gbrp.tax[tax][GetGlobalInt(tax) + 1])
                    else
                        GAMEMODE:AddNotify("Votre gang n'a pas les moyens.",1,2)
                    end
                end
                v[1].button:SetEnabled(GetGlobalInt("incomeTax") < 5)
                for k = 1,5 do
                    v[1].levels = {}
                    v[1].levels[k] = vgui.Create("Panel",frame)
                    v[1].levels[k]:SetSize(gbrp.FormatXY(24,34))
                    v[1].levels[k]:SetPos(gbrp.FormatXY(303 + (k-1) * 33,v[2]))
                    v[1].levels[k].Paint = function(self,w,h)
                        if GetGlobalInt(tax) >= k then
                            GWEN.CreateTextureBorder(416,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h)
                        elseif GetGlobalInt(tax) == k-1 then
                            GWEN.CreateTextureBorder(416,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(0,0,0,150))
                        else
                            GWEN.CreateTextureBorder(416,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(0,0,0,77))
                        end
                    end
                    v[1].levels[k].text = vgui.Create("DLabel",v[1].levels[k]) v[1].levels[k].text:SetText(k) v[1].levels[k].text:SetFont("Bank") v[1].levels[k].text:SetColor(Color(255,255,255)) v[1].levels[k].text:SizeToContents() v[1].levels[k].text:Center()
                end
            end
        else
            for tax,v in pairs(taxList) do
                v[1].button:SetPrice(gbrp.defiscalize[tax][GetGlobalInt(tax) - 1])
                v[1].button.DoClick = function(self)
                    if gang:CanAfford(self.price) then
                        net.Start("GBRP::changeTax")
                        net.WriteString(tax)
                        net.WriteBool(false)
                        net.WriteInt(self.price,32)
                        net.SendToServer()
                        SetGlobalInt(tax,GetGlobalInt(tax) - 1)
                        self:SetEnabled(GetGlobalInt(tax) > 0)
                        self:SetPrice(gbrp.defiscalize[tax][GetGlobalInt(tax) - 1])
                    else
                        GAMEMODE:AddNotify("Votre gang n'a pas les moyens.",1,2)
                    end
                end
                v[1].button:SetEnabled(GetGlobalInt("incomeTax") > 0)
                for k = 1,5 do
                    v[1].levels = {}
                    v[1].levels[k] = vgui.Create("Panel",frame)
                    v[1].levels[k]:SetSize(gbrp.FormatXY(24,34))
                    v[1].levels[k]:SetPos(gbrp.FormatXY(303 + (k-1) * 33,v[2]))
                    v[1].levels[k].Paint = function(self,w,h)
                        if GetGlobalInt(tax) >= k then
                            GWEN.CreateTextureBorder(384,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,0,0,150))
                        else
                            GWEN.CreateTextureBorder(384,0,31,31,8,8,8,8,defaultSkin)(0,0,w,h,Color(0,0,0,77))
                        end
                    end
                    v[1].levels[k].text = vgui.Create("DLabel",v[1].levels[k]) v[1].levels[k].text:SetText(k) v[1].levels[k].text:SetFont("Bank") v[1].levels[k].text:SetColor(Color(255,255,255)) v[1].levels[k].text:SizeToContents() v[1].levels[k].text:Center()
                end
            end
        end
    end
    local tax = vgui.Create("DButton",frame)
    tax:SetPos(gbrp.FormatXY(83,269))
    tax:SetSize(gbrp.FormatXY(363,105))
    tax:SetText("IMPOSER")
    tax:SetFont("DermaHuge")
    tax:SetColor(Color(255,255,255))
    function tax:Paint(w,h)
        if self:IsHovered() then
            return GWEN.CreateTextureBorder(128,0,127,127,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,255,255,255))
        end
        GWEN.CreateTextureBorder(128,0,127,127,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,255,255,179))
    end
    local defiscalize = vgui.Create("DButton",frame)
    defiscalize:SetPos(gbrp.FormatXY(746,267))
    defiscalize:SetSize(gbrp.FormatXY(363,105))
    defiscalize:SetText("DEFISCALISER")
    defiscalize:SetFont("DermaHuge")
    defiscalize:SetColor(Color(255,255,255))
    function defiscalize:Paint(w,h)
        if self:IsHovered() then
            return GWEN.CreateTextureBorder(128,0,127,127,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,255,255,255))
        end
        GWEN.CreateTextureBorder(128,0,127,127,8,8,8,8,defaultSkin)(0,0,w,h,Color(255,255,255,179))
    end
    function tax:DoClick()
        self:Remove()
        defiscalize:Remove()
        taxChoice = true
        LoadPage2()
    end
    function defiscalize:DoClick()
        self:Remove()
        tax:Remove()
        LoadPage2()
    end
    local remove = vgui.Create("RemoveButton",frame)
    remove:SetPos(gbrp.FormatXY(1089,101))
    remove:SetSize(gbrp.FormatXY(29,29))
    remove.DoClick = function()
        frame:Remove()
    end
end)