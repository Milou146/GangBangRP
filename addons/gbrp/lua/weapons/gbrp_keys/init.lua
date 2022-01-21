AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local target = ply:GetEyeTrace().Entity
    if gbrp.doors[target:EntIndex()] and target:GetNWString("owner") == ply:GetGang() then
        target:Fire("lock", "", 0)
        --comes from darkrp
        ply:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
        timer.Simple(0.9, function() if IsValid(ply) then ply:EmitSound("doors/door_latch3.wav") end end)

        umsg.Start("anim_keys")
            umsg.Entity(ply)
            umsg.String("usekeys")
        umsg.End()

        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
    end
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    local target = ply:GetEyeTrace().Entity
    if gbrp.doors[target:EntIndex()] and target:GetNWString("owner") == ply:GetGang() then
        target:Fire("unlock", "", 0)
        --comes from darkrp
        ply:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
        timer.Simple(0.9, function() if IsValid(ply) then ply:EmitSound("doors/door_latch3.wav") end end)

        umsg.Start("anim_keys")
            umsg.Entity(ply)
            umsg.String("usekeys")
        umsg.End()

        ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
    end
end