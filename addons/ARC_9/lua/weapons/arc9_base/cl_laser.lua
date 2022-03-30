local lasermat = Material("effects/laser1")
local flaremat = Material("effects/whiteflare")

function SWEP:DrawLaser(pos, dir, atttbl, behav)
    behav = behav or false
    local strength = atttbl.LaserStrength or 1
    local color = atttbl.LaserColor or Color(255, 0, 0)

    -- ang = self:GetShootDir()

    local tr = util.TraceLine({
        start = pos,
        endpos = pos + (dir * 30000),
        mask = MASK_SHOT,
        filter = self:GetOwner()
    })

    if tr.StartSolid then return end

    local width = math.Rand(0.1, 0.2) * strength

    if behavior then
        cam.Start3D(nil, nil, nil, 0, 0, ScrW(), ScrH(), 4, 32000)
        pos = pos - (dir * 256)
    end

    local hit = tr.Hit
    local hitpos = tr.HitPos

    if tr.HitSky then
        hit = false
        hitpos = pos + (dir * 30000)
    end

    if !behav then
        render.SetMaterial(lasermat)
        render.DrawBeam(pos, hitpos, width * 0.3, 0, 1, Color(200, 200, 200))
        render.DrawBeam(pos, hitpos, width, 0, 1, color)
    end

    if hit then
        local mul = strength
        local rad = math.Rand(4, 6) * mul

        render.SetMaterial(flaremat)
        render.DrawSprite(hitpos, rad, rad, color)

        render.DrawSprite(hitpos, rad * 0.3, rad * 0.3, Color(200, 200, 200))
    end

    if behavior then
        cam.End3D()
    end
end

function SWEP:DrawLasers(wm, behav)
    if !wm and !IsValid(self:GetOwner()) then return end
    if !wm and self:GetOwner():IsNPC() then return end

    local mdl = self.VModel

    if wm then
        mdl = self.WModel
    end

    if !mdl then
        self:SetupModel(wm)

        mdl = self.VModel

        if wm then
            mdl = self.WModel
        end
    end

    for _, model in ipairs(mdl) do
        local slottbl = model.slottbl
        local atttbl = self:GetFinalAttTable(slottbl)

        if atttbl.Laser then
            -- if behav then
            --     self:DrawLaser(EyePos() - (EyeAngles():Up() * 4), self:GetShootDir():Forward(), atttbl)
            -- else
                local pos, ang = self:GetAttPos(slottbl, wm, false)
                model:SetPos(pos)
                model:SetAngles(ang)

                local a

                if atttbl.LaserAttachment then
                    a = model:GetAttachment(atttbl.LaserAttachment)
                else
                    a = {
                        Pos = model:GetPos(),
                        Ang = model:GetAngles()
                    }

                    a.Ang:RotateAroundAxis(a.Ang:Up(), -90)
                end

                if !wm or self:GetOwner() == LocalPlayer() then
                    if behav then
                        self:DrawLaser(a.Pos, self:GetShootDir():Forward(), atttbl, behav)
                    else
                        self:DrawLaser(a.Pos, -a.Ang:Right(), atttbl, behav)
                    end
                else
                    self:DrawLaser(a.Pos, self:GetShootDir():Forward(), atttbl, behav)
                end
            -- end
        end
    end
end