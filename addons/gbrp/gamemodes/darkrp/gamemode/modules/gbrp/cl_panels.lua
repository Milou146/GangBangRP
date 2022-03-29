local PANEL

PANEL = {}
function PANEL:GetMaterial()
    return Material(self:GetImage())
end
function PANEL:Paint(w,h)
    surface.SetDrawColor(255,255,255,255)
    if self:IsHovered() then
        surface.SetMaterial(self.hoveredMat)
        surface.DrawTexturedRect(0,0,w,h)
        return
    end
    surface.SetMaterial(self.mat)
    surface.DrawTexturedRect(0,0,w,h)
end
vgui.Register("GBRPButton",PANEL,"DImageButton")

PANEL = {}
function PANEL:DoClick()
    LocalPlayer():BuyShop(self:GetParent().shop)
end
vgui.Register("BuyShopButton",PANEL,"GBRPButton")

PANEL = {}
function PANEL:DoClick()
    LocalPlayer():SellShop(self:GetParent().shop)
    self:GetParent():Remove()
end
vgui.Register("SellShopButton",PANEL,"GBRPButton")

PANEL = {}
function PANEL:DoClick()
    LocalPlayer():WithdrawLaunderedMoney(self:GetParent().shop)
end
vgui.Register("WithdrawLaunderedMoneyButton",PANEL,"GBRPButton")

PANEL = {}
function PANEL:DoClick()
    LocalPlayer():DropCash(self:GetParent())
end
vgui.Register("DropCashButton",PANEL,"GBRPButton")

PANEL = {}
PANEL.mat = Material("gui/gbrp/jewelrystore/remove.png")
PANEL.hoveredMat = Material("gui/gbrp/jewelrystore/removerollover.png")
function PANEL:DoClick()
    surface.PlaySound("gui/gbrp/remove_customerarea.wav")
    self:GetParent():Remove()
end
vgui.Register("RemoveButton",PANEL,"GBRPButton")