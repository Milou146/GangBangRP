local PANEL

PANEL = {}
function PANEL:GetMaterial()
    return Material(self:GetImage())
end
function PANEL:OnCursorEntered()
    self:SetImage(string.StripExtension(self:GetImage()) .. "rollover.png")
    self:SetSize(gbrp.FormatX(self:GetMaterial():Width()),gbrp.FormatY(self:GetMaterial():Height()))
end
function PANEL:OnCursorExited()
    self:SetImage(string.sub(self:GetImage(),1,#self:GetImage() - 12) .. ".png")
    self:SetSize(gbrp.FormatX(self:GetMaterial():Width()),gbrp.FormatY(self:GetMaterial():Height()))
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
    panelOpen = false
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
function PANEL:DoClick()
    surface.PlaySound("gui/gbrp/remove_customerarea.wav")
    self:GetParent():Remove()
end
vgui.Register("RemoveButton",PANEL,"GBRPButton")