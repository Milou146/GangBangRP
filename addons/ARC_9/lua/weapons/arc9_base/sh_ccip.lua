function SWEP:GetCCIP(pos, ang)
    // get calculated point of impact

    local v = self:GetProcessedValue("PhysBulletMuzzleVelocity")
    local g = self:GetProcessedValue("PhysBulletGravity")
    local d = self:GetProcessedValue("PhysBulletDrag")

    pos = pos or self:GetShootPos()
    local vel = (ang or self:GetShootDir()):Forward() * v
    local maxiter = 100
    local timestep = 1 / 15

    for i = 1, maxiter do
        local dir = vel:GetNormalized()
        local spd = vel:Length() * timestep
        local drag = d * spd * spd * (1 / 150000) * GetConVar("ARC9_bullet_drag"):GetFloat()
        local gravity = timestep * g * GetConVar("ARC9_bullet_gravity"):GetFloat() * 600

        if spd <= 0.001 then return nil end

        local newpos = pos + (vel * timestep)
        local newvel = vel - (dir * drag) - Vector(0, 0, gravity)

        local tr = util.TraceLine({
            start = pos,
            endpos = newpos,
            filter = self:GetOwner(),
            mask = MASK_SHOT
        })

        if tr.HitSky then
            return nil
        elseif tr.Hit then
            return tr, i * timestep
        else
            pos = newpos
            vel = newvel
        end
    end

    return nil
end