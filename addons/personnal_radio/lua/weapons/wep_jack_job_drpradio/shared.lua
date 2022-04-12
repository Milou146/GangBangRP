if (SERVER) then
    AddCSLuaFile()
    --// File generated by F0x's Resources Generator 3.0.0 \\--
    resource.AddFile("materials/radio/button.vtf")
    resource.AddFile("materials/radio/buttons00.vmt")
    resource.AddFile("materials/radio/buttons1.vmt")
    resource.AddFile("materials/radio/buttons2.vmt")
    resource.AddFile("materials/radio/buttons2.vtf")
    resource.AddFile("materials/radio/buttons3.vtf")
    resource.AddFile("materials/radio/buttons4.vmt")
    resource.AddFile("materials/radio/digital.vtf")
    resource.AddFile("materials/radio/glass.vmt")
    resource.AddFile("materials/radio/holes.vmt")
    resource.AddFile("materials/radio/illum.vtf")
    resource.AddFile("materials/radio/illum_screen.vmt")
    resource.AddFile("materials/radio/plastic2_base_color.vtf")
    resource.AddFile("materials/radio/plastic_2.vmt")
    resource.AddFile("materials/radio/plastic_ambient_occlusion.vtf")
    resource.AddFile("materials/radio/plastic_base_color.vtf")
    resource.AddFile("materials/radio/plastic_height.vtf")
    resource.AddFile("materials/radio/plastic_normal.vtf")
    resource.AddFile("materials/radio/plastic_shiny.vmt")
    resource.AddFile("materials/radio/qwe.vtf")
    resource.AddFile("materials/radio/radio_plastic.vmt")
    resource.AddFile("materials/radio/rip.vtf")
    resource.AddFile("materials/radio/trans.vtf")
    resource.AddFile("materials/radio/wart.vmt")
    resource.AddFile("models/radio/c_radio.mdl")
    resource.AddFile("models/radio/w_radio.mdl")
    resource.AddFile("sound/snd_jack_job_radioswitch.wav")
    resource.AddFile("sound/snd_jack_job_radiotone.wav")
elseif (CLIENT) then
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 65
    SWEP.ViewModelFlip = true
    SWEP.Slot = 5
    SWEP.SlotPos = 3
    killicon.AddFont("wep_jack_job_drpradio", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

    function SWEP:Initialize()
        --wat
    end

    function SWEP:DrawViewModel()
        return false
    end

    function SWEP:DrawHUD()
        local W, H = ScrW(), ScrH()
        if not (self:GetActive()) then return end
        local ChanTxt = tostring(90 + self:GetChannel() / 10)
        draw.SimpleTextOutlined("Fréquence : " .. ChanTxt, "Trebuchet24", W * .76, H * .87, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
    end
end

SWEP.Base = "weapon_base"
SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/radio/w_radio.mdl"
SWEP.PrintName = "Talkie-walkie"
SWEP.Instructions = ""
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.BobScale = 3
SWEP.SwayScale = 3
SWEP.Weight = 3
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.Delay = 0.5
SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 120
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.04
SWEP.Primary.ClipSize = -1
SWEP.Primary.Force = 900
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DownAmt = 0
SWEP.VPos = Vector(5.025, -17, 0)
SWEP.VAng = Angle(-20, -70, 10)
SWEP.ShowViewModel = true

SWEP.ViewModelBoneMods = {
    ["v_weapon.Flashbang_Parent"] = {
        scale = Vector(0.009, 0.009, 0.009),
        pos = Vector(0, 0, 0),
        angle = Angle(0, 0, 0)
    }
}

SWEP.VElements = {
    ["radio"] = {
        type = "Model",
        model = "models/radio/c_radio.mdl",
        bone = "v_weapon.Flashbang_Parent",
        rel = "",
        pos = Vector(-11.7, 1.557, -3.6),
        angle = Angle(40.909, 3.506, 90),
        size = Vector(0.8, 0.8, 0.8),
        color = Color(255, 255, 255, 255),
        surpresslightning = false,
        material = "",
        skin = 0,
        bodygroup = {}
    },
    ["light"] = {
        type = "Sprite",
        sprite = "sprites/blueflare1",
        bone = "v_weapon.Flashbang_Parent",
        rel = "",
        pos = Vector(0, -.2, -.85),
        size = {
            x = 2,
            y = 2
        },
        color = Color(0, 255, 0, 0),
        nocull = true,
        additive = true,
        vertexalpha = true,
        vertexcolor = true,
        ignorez = false
    }
}

function SWEP:Initialize()
    self:SetHoldType("normal")
    self.DownAmt = 20
    self:SetActive(false)
    self:SetEarpiece(self.HasEarpiece or false)
    self:SetChannel(1)
    self:SCKInitialize()

    if (SERVER) then
        self:PhysicsInitBox(Vector(-5, -5, -5), Vector(5, 5, 5))
        self:SetCollisionBounds(Vector(-5, -5, -5), Vector(5, 5, 5))
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local Phys = self:GetPhysicsObject()
        Phys:Wake()
        Phys:SetMass(10)
    end
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Active")
    self:NetworkVar("Bool", 1, "Earpiece")
    self:NetworkVar("Int", 0, "Channel")
end

function SWEP:PrimaryAttack()
    self:SetActive(not self:GetActive())
    self:EmitSound("snd_jack_job_radioswitch.wav", 60, 110)

    if (self:GetActive()) then
        self.VElements.light.color.a = 255
    else
        self.VElements.light.color.a = 0
    end

    self:SetNextPrimaryFire(CurTime() + .5)
end

function SWEP:Deploy()
    self:SetNextPrimaryFire(CurTime() + 1)
    self.DownAmt = 20

    return true
end

function SWEP:Holster()
    self:SCKHolster()

    return true
end

-- this is messy, don't care. Ain't paid enough to be doing derma menus honestly
if (SERVER) then
    util.AddNetworkString("jackjob_drp_radiochannelmenu")
end

function SWEP:SecondaryAttack()
    if not (self:GetActive()) then return end

    if (SERVER) then
        net.Start("jackjob_drp_radiochannelmenu")
        net.WriteEntity(self)
        net.Send(self:GetOwner())
    end

    --[[
	local NewChannel=self:GetChannel()+1
	if(NewChannel>100)then NewChannel=1 end
	self:SetChannel(NewChannel)
	self:EmitSound("snd_jack_job_radioswitch.wav",40,90)
	--]]
    self:SetNextSecondaryFire(CurTime() + .1)
end

if (CLIENT) then
    net.Receive("jackjob_drp_radiochannelmenu", function(len, ply)
        local Wep = net.ReadEntity()
        local DermaPanel = vgui.Create("DFrame")
        DermaPanel:SetPos(40, 80)
        DermaPanel:SetSize(500, 100)
        DermaPanel:SetTitle("Sélectionner la fréquence")
        DermaPanel:SetVisible(true)
        DermaPanel:SetDraggable(true)
        DermaPanel:ShowCloseButton(true)
        DermaPanel:MakePopup()
        DermaPanel:Center()
        local DermaNumSlider = vgui.Create("DNumSlider", DermaPanel)
        DermaNumSlider:SetPos(10, 25)
        DermaNumSlider:SetSize(490, 50)
        DermaNumSlider:SetText("Fréquence")
        DermaNumSlider:SetMin(90.1)
        DermaNumSlider:SetMax(100.1)
        DermaNumSlider:SetDecimals(1)
        DermaNumSlider:SetValue(Wep:GetChannel() / 10 + 90)

        DermaNumSlider.OnValueChanged = function(panel, val)
            RunConsoleCommand("jackjob_drpradio_setchannel", tostring(math.Round(val, 1)))
        end
    end)
end

if (SERVER) then
    concommand.Add("jackjob_drpradio_setchannel", function(ply, txt, args)
        if (ply:HasWeapon("wep_jack_job_drpradio")) then
            local Wep = ply:GetWeapon("wep_jack_job_drpradio")

            if (Wep:GetActive()) then
                local Chan = tonumber(args[1])

                if ((Chan >= 90.1) and (Chan <= 100.1)) then
                    Wep:EmitSound("snd_jack_job_radioswitch.wav", 30, 90)
                    local Rounded = math.Round((Chan - 90) * 10)
                    Wep:SetChannel(math.Clamp(Rounded, 1, 100))
                end
            end
        end
    end)
end

function SWEP:Think()
    --
end

function SWEP:Reload()
    if (self:GetEarpiece()) then
        self:SetEarpiece(false)
        if (CLIENT) then return end
        local Ea = ents.Create("ent_jack_job_drpearpiece")
        Ea:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 20)
        Ea:Spawn()
        Ea:Activate()
    end
end

function SWEP:OnRemove()
    self:SCKOnRemove()
end

function SWEP:OnDrop()
    self.HasEarpiece = self:GetEarpiece()
end

if (CLIENT) then
    function SWEP:ViewModelDrawn()
        self:SCKViewModelDrawn()
    end

    function SWEP:PreDrawViewModel(vm, ply, wep)
        --
    end

    function SWEP:GetViewModelPosition(pos, ang)
        if not self.DownAmt then
            self.DownAmt = 0
        end

        if self:GetOwner():KeyDown(IN_SPEED) then
            self.DownAmt = math.Clamp(self.DownAmt + .2, 0, 20)
        else
            self.DownAmt = math.Clamp(self.DownAmt - .2, 0, 20)
        end

        --pos=pos-ang:Up()*(self.DownAmt+47)
        pos = pos + ang:Forward() * self.VPos.x + ang:Right() * self.VPos.y + ang:Up() * self.VPos.z
        ang:RotateAroundAxis(ang:Up(), self.VAng.y)
        ang:RotateAroundAxis(ang:Right(), self.VAng.r)
        ang:RotateAroundAxis(ang:Forward(), self.VAng.p)

        return pos, ang
    end

    function SWEP:DrawWorldModel()
        if not (self:GetOwner():IsPlayer()) then
            self:DrawModel()

            return
        end

        local DatBone = self:GetOwner():LookupBone("ValveBiped.Bip01_L_Hand")

        if (DatBone) then
            local Pos, Ang = self:GetOwner():GetBonePosition(DatBone)

            if (self.DatWorldModel) then
                if Pos and Ang then
                    self.DatWorldModel:SetRenderOrigin(Pos - Ang:Up() * -6 - Ang:Right() * -15 + Ang:Forward() * 5)
                    Ang:RotateAroundAxis(Ang:Forward(), -20)
                    Ang:RotateAroundAxis(Ang:Up(), 120)
                    Ang:RotateAroundAxis(Ang:Right(), 0)
                    self.DatWorldModel:SetRenderAngles(Ang)
                    self.DatWorldModel:DrawModel()
                end
            else
                self.DatWorldModel = ClientsideModel("models/radio/c_radio.mdl")
                self.DatWorldModel:SetPos(self:GetPos())
                self.DatWorldModel:SetParent(self)
                self.DatWorldModel:SetNoDraw(true)
                self.DatWorldModel:SetModelScale(.9, 0)
            end
        end
    end
end

--[[-------------------------------------------------------------------------
--                              Global Stuff                               --
---------------------------------------------------------------------------]]
local function Radioed(ply)
    if ply:IsPlayer() and ply:Alive() and ply.HasWeapon and ply:HasWeapon("wep_jack_job_drpradio") then
        local Wep = ply:GetWeapon("wep_jack_job_drpradio")

        return true, Wep:GetActive(), ply:GetActiveWeapon() == Wep, Wep:GetChannel(), Wep:GetEarpiece()
    end

    return false, false, false, 0, false
end

local NextChat, LastPly = 0, nil -- there's some double-bullshit that goes on created by the DRP manual hook-calling, what a bunch of assholes

hook.Add("PlayerSay", "JackaJobRadioChatSayHook", function(ply, txt)
    local Time = CurTime()

    if not ((NextChat > Time) and (LastPly == ply)) then
        LastPly = ply
        NextChat = Time + .01
        local SRadio, SActive, SHeld, SChannel, SEarpiece = Radioed(ply)

        if (SRadio and SActive and (SHeld or SEarpiece)) then
            local Col, Col2 = team.GetColor(ply:Team()), color_white
            ply:EmitSound("snd_jack_job_radiotone.wav", 60, 110)

            for _, listener in pairs(player.GetAll()) do
                if listener ~= ply then
                    local LRadio, LActive, _, LChannel, _ = Radioed(listener)

                    if (LRadio and LActive and (SChannel == LChannel)) then
                        listener:EmitSound("snd_jack_job_radiotone.wav", 60, 90)
                        DarkRP.talkToPerson(listener, Col, "Radio: " .. ply:Name(), Col2, txt, ply)
                    else
                        for _, playah in pairs(ents.FindInSphere(listener:GetPos(), 100)) do
                            local PRadio, PActive, _, PChannel, PEarpiece = Radioed(playah)

                            if PRadio and PActive and PChannel == SChannel and not PEarpiece then
                                DarkRP.talkToPerson(listener, Col, "Radio: " .. ply:Name(), Col2, txt, ply)
                            end
                        end
                    end
                end
            end
        end
    end
end)

hook.Add("PlayerCanHearPlayersVoice", "JackaDRPRadioVoice", function(listener, speaker)
    local Result = nil
    local SRadio, SActive, SHeld, SChannel, SEarpiece = Radioed(speaker)

    if (SRadio and SActive and (SHeld or SEarpiece)) then
        local LRadio, LActive, _, LChannel, _ = Radioed(listener)

        if (LRadio and LActive and (SChannel == LChannel)) then
            Result = true
        else
            for _, playah in pairs(ents.FindInSphere(listener:GetPos(), 100)) do
                local PRadio, PActive, _, PChannel, PEarpiece = Radioed(playah)

                if (PRadio and PActive and (PChannel == SChannel) and not PEarpiece) then
                    Result = true
                    break
                end
            end
        end
    end

    if (Result) then return Result end
end)

--[[--------------------------------------------------------------------------
--                              SCK Code                                    --
----------------------------------------------------------------------------]]
function SWEP:SCKInitialize()
    if CLIENT then
        -- Create a new table for every weapon instance
        self.VElements = table.FullCopy(self.VElements)
        self.WElements = table.FullCopy(self.WElements)
        self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
        self:CreateModels(self.VElements) -- create viewmodels
        self:CreateModels(self.WElements) -- create worldmodels

        -- init view model bone build function
        if IsValid(self:GetOwner()) then
            local vm = self:GetOwner():GetViewModel()

            if IsValid(vm) then
                self:ResetBonePositions(vm)

                -- Init viewmodel visibility
                if (self.ShowViewModel == nil or self.ShowViewModel) then
                    vm:SetColor(Color(255, 255, 255, 255))
                else
                    -- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
                    vm:SetColor(Color(255, 255, 255, 1))
                    -- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
                    -- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
                    vm:SetMaterial("Debug/hsv")
                end
            end
        end
    end
end

function SWEP:SCKHolster()
    if CLIENT and IsValid(self:GetOwner()) then
        local vm = self:GetOwner():GetViewModel()

        if IsValid(vm) then
            self:ResetBonePositions(vm)
        end
    end

    return true
end

function SWEP:SCKOnRemove()
    self:Holster()
end

if CLIENT then
    SWEP.vRenderOrder = nil

    function SWEP:SCKViewModelDrawn()
        local vm = self:GetOwner():GetViewModel()
        if not IsValid(vm) then return end
        if (not self.VElements) then return end
        self:UpdateBonePositions(vm)

        if (not self.vRenderOrder) then
            -- we build a render order because sprites need to be drawn after models
            self.vRenderOrder = {}

            for k, v in pairs(self.VElements) do
                if (v.type == "Model") then
                    table.insert(self.vRenderOrder, 1, k)
                elseif (v.type == "Sprite" or v.type == "Quad") then
                    table.insert(self.vRenderOrder, k)
                end
            end
        end

        for k, name in ipairs(self.vRenderOrder) do
            local v = self.VElements[name]

            if (not v) then
                self.vRenderOrder = nil
                break
            end

            if (v.hide) then continue end
            local model = v.modelEnt
            local sprite = v.spriteMaterial
            if (not v.bone) then continue end
            local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
            if (not pos) then continue end

            if (v.type == "Model" and IsValid(model)) then
                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                model:SetAngles(ang)
                --model:SetModelScale(v.size)
                local matrix = Matrix()
                matrix:Scale(v.size)
                model:EnableMatrix("RenderMultiply", matrix)

                if (v.material == "") then
                    model:SetMaterial("")
                elseif (model:GetMaterial() ~= v.material) then
                    model:SetMaterial(v.material)
                end

                if (v.skin and v.skin ~= model:GetSkin()) then
                    model:SetSkin(v.skin)
                end

                if (v.bodygroup) then
                    for k, v in pairs(v.bodygroup) do
                        if (model:GetBodygroup(k) ~= v) then
                            model:SetBodygroup(k, v)
                        end
                    end
                end

                if (v.surpresslightning) then
                    render.SuppressEngineLighting(true)
                end

                render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
                render.SetBlend(v.color.a / 255)
                model:DrawModel()
                render.SetBlend(1)
                render.SetColorModulation(1, 1, 1)

                if (v.surpresslightning) then
                    render.SuppressEngineLighting(false)
                end
            elseif (v.type == "Sprite" and sprite) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                render.SetMaterial(sprite)
                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
            elseif (v.type == "Quad" and v.draw_func) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                cam.Start3D2D(drawpos, ang, v.size)
                v.draw_func(self)
                cam.End3D2D()
            end
        end
    end

    function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
        local bone, pos, ang

        if (tab.rel and tab.rel ~= "") then
            local v = basetab[tab.rel]
            if (not v) then return end
            -- Technically, if there exists an element with the same name as a bone
            -- you can get in an infinite loop. Let's just hope nobody's that stupid.
            pos, ang = self:GetBoneOrientation(basetab, v, ent)
            if (not pos) then return end
            pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)
        else
            bone = ent:LookupBone(bone_override or tab.bone)
            if (not bone) then return end
            pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
            local m = ent:GetBoneMatrix(bone)

            if (m) then
                pos, ang = m:GetTranslation(), m:GetAngles()
            end

            if (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip) then
                ang.r = -ang.r -- Fixes mirrored models
            end
        end

        return pos, ang
    end

    function SWEP:CreateModels(tab)
        if (not tab) then return end

        -- Create the clientside models here because Garry says we can't do it in the render hook
        for k, v in pairs(tab) do
            if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME")) then
                v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)

                if (IsValid(v.modelEnt)) then
                    v.modelEnt:SetPos(self:GetPos())
                    v.modelEnt:SetAngles(self:GetAngles())
                    v.modelEnt:SetParent(self)
                    v.modelEnt:SetNoDraw(true)
                    v.createdModel = v.model
                else
                    v.modelEnt = nil
                end
            elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME")) then
                local name = v.sprite .. "-"

                local params = {
                    ["$basetexture"] = v.sprite
                }

                -- make sure we create a unique name based on the selected options
                local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}

                for i, j in pairs(tocheck) do
                    if (v[j]) then
                        params["$" .. j] = 1
                        name = name .. "1"
                    else
                        name = name .. "0"
                    end
                end

                v.createdSprite = v.sprite
                v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
            end
        end
    end

    local allbones
    local hasGarryFixedBoneScalingYet = false

    function SWEP:UpdateBonePositions(vm)
        if self.ViewModelBoneMods then
            if (not vm:GetBoneCount()) then return end
            -- !! WORKAROUND !! //
            -- We need to check all model names :/
            local loopthrough = self.ViewModelBoneMods

            if (not hasGarryFixedBoneScalingYet) then
                allbones = {}

                for i = 0, vm:GetBoneCount() do
                    local bonename = vm:GetBoneName(i)

                    if (self.ViewModelBoneMods[bonename]) then
                        allbones[bonename] = self.ViewModelBoneMods[bonename]
                    else
                        allbones[bonename] = {
                            scale = Vector(1, 1, 1),
                            pos = Vector(0, 0, 0),
                            angle = Angle(0, 0, 0)
                        }
                    end
                end

                loopthrough = allbones
            end

            -- !! ----------- !! //
            for k, v in pairs(loopthrough) do
                local bone = vm:LookupBone(k)
                if (not bone) then continue end
                -- !! WORKAROUND !! //
                local s = Vector(v.scale.x, v.scale.y, v.scale.z)
                local p = Vector(v.pos.x, v.pos.y, v.pos.z)
                local ms = Vector(1, 1, 1)

                if (not hasGarryFixedBoneScalingYet) then
                    local cur = vm:GetBoneParent(bone)

                    while (cur >= 0) do
                        local pscale = loopthrough[vm:GetBoneName(cur)].scale
                        ms = ms * pscale
                        cur = vm:GetBoneParent(cur)
                    end
                end

                s = s * ms

                -- !! ----------- !! //
                if vm:GetManipulateBoneScale(bone) ~= s then
                    vm:ManipulateBoneScale(bone, s)
                end

                if vm:GetManipulateBoneAngles(bone) ~= v.angle then
                    vm:ManipulateBoneAngles(bone, v.angle)
                end

                if vm:GetManipulateBonePosition(bone) ~= p then
                    vm:ManipulateBonePosition(bone, p)
                end
            end
        else
            self:ResetBonePositions(vm)
        end
    end

    function SWEP:ResetBonePositions(vm)
        if (not vm:GetBoneCount()) then return end

        for i = 0, vm:GetBoneCount() do
            vm:ManipulateBoneScale(i, Vector(1, 1, 1))
            vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
            vm:ManipulateBonePosition(i, Vector(0, 0, 0))
        end
    end

    --[[*************************
		Global utility code
	*************************]]
    -- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
    -- Does not copy entities of course, only copies their reference.
    -- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
    function table.FullCopy(tab)
        if (not tab) then return nil end
        local res = {}

        for k, v in pairs(tab) do
            if (type(v) == "table") then
                res[k] = table.FullCopy(v) -- recursion ho!
            elseif (type(v) == "Vector") then
                res[k] = Vector(v.x, v.y, v.z)
            elseif (type(v) == "Angle") then
                res[k] = Angle(v.p, v.y, v.r)
            else
                res[k] = v
            end
        end

        return res
    end
end