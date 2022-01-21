local function AddButtonToFrame(Frame)
    Frame:SetTall(Frame:GetTall() + 110)

    local button = vgui.Create("DButton", Frame)
    button:SetPos(10, Frame:GetTall() - 110)
    button:SetSize(180, 100)

    Frame.buttonCount = (Frame.buttonCount or 0) + 1
    Frame.lastButton = button
    return button
end

DarkRP.stub{
    name = "openKeysMenu",
    description = "Open the keys/F2 menu.",
    parameters = {},
    realm = "Client",
    returns = {},
    metatable = DarkRP
}

DarkRP.hookStub{
    name = "onKeysMenuOpened",
    description = "Called when the keys menu is opened.",
    parameters = {
        {
            name = "ent",
            description = "The door entity.",
            type = "Entity"
        },
        {
            name = "Frame",
            description = "The keys menu frame.",
            type = "Panel"
        }
    },
    returns = {
    },
    realm = "Client"
}

local KeyFrameVisible = false

local function openMenu(setDoorOwnerAccess, doorSettingsAccess)
    return
end

function DarkRP.openKeysMenu(um)
    CAMI.PlayerHasAccess(LocalPlayer(), "DarkRP_SetDoorOwner", function(setDoorOwnerAccess)
        CAMI.PlayerHasAccess(LocalPlayer(), "DarkRP_ChangeDoorSettings", fp{openMenu, setDoorOwnerAccess})
    end)
end
usermessage.Hook("KeysMenu", DarkRP.openKeysMenu)
