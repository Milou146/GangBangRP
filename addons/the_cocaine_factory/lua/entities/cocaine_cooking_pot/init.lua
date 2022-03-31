AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/craphead_scripts/the_cocaine_factory/utility/pot.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHP(TCF.Config.CookingPanHealth)
    self.HasWater = false
    self.HasCarbonate = false
    self.ReadyToCook = false
    self:PhysWake()
    self:CPPISetOwner(self:Getowning_ent())
end

function ENT:OnTakeDamage(dmg)
    if (not self.m_bApplyingDamage) then
        self.m_bApplyingDamage = true
        self:SetHP((self:GetHP() or 100) - dmg:GetDamage())

        if self:GetHP() <= 0 then
            self:Destruct()
            self:Remove()
        end

        self.m_bApplyingDamage = false
    end
end

function ENT:Destruct()
    for i = 1, 3 do
        local vPoint = self:GetPos()
        local effectdata = EffectData()
        effectdata:SetStart(vPoint)
        effectdata:SetOrigin(vPoint)
        effectdata:SetScale(1)
        util.Effect("ManhackSparks", effectdata)
    end
end

function ENT:StartTouch(ent)
    if ent:IsPlayer() then return end
    if self:GetCooked() then return end
    if (ent.lastTouch or CurTime()) > CurTime() then return end
    ent.lastTouch = CurTime() + 0.5

    if ent:GetClass() == "cocaine_baking_soda" then
        if self:GetCooking() then return end

        if not self.HasCarbonate and not self.HasWater then
            SafeRemoveEntityDelayed(ent, 0)
            self.HasCarbonate = true
            self:SetBodygroup(1, 2)
        elseif not self.HasCarbonate and self.HasWater then
            SafeRemoveEntityDelayed(ent, 0)
            self.HasCarbonate = true
            self.ReadyToCook = true
            self:SetBodygroup(1, 3)
        end
    elseif ent:GetClass() == "cocaine_water" then
        if self:GetCooking() then return end

        if not self.HasCarbonate and not self.HasWater then
            SafeRemoveEntityDelayed(ent, 0)
            self.HasWater = true
            self:SetBodygroup(1, 1)
        elseif not self.HasWater and self.HasCarbonate then
            SafeRemoveEntityDelayed(ent, 0)
            self.HasWater = true
            self.ReadyToCook = true
            self:SetBodygroup(1, 3)
        end
    end
end

-- Take pots off stove with E
function ENT:AcceptInput(key, ply)
    if not TCF.Config.DetachFinishedPotsWithE then return end

    if (self.LastUsed or CurTime()) <= CurTime() then
        self.LastUsed = CurTime() + 2
        local parent = self:GetParent()

        if IsValid(parent) then
            local ei_ = parent:EntIndex()

            if self:GetCooked() then
                for i = 1, 4 do
                    if parent.PotsOnStove[i] == self then
                        if i == 1 then
                            parent:SetBodygroup(11, 0)

                            if timer.Exists("cooktimer_gas_1" .. ei_) then
                                parent:SetBodygroup(3, 1) -- Small flame if gas is on
                            end
                        elseif i == 2 then
                            parent:SetBodygroup(12, 0)

                            if timer.Exists("cooktimer_gas_2" .. ei_) then
                                parent:SetBodygroup(4, 1) -- Small flame if gas is on
                            end
                        elseif i == 3 then
                            parent:SetBodygroup(13, 0)

                            if timer.Exists("cooktimer_gas_3" .. ei_) then
                                parent:SetBodygroup(5, 1) -- Small flame if gas is on
                            end
                        elseif i == 4 then
                            parent:SetBodygroup(14, 0)

                            if timer.Exists("cooktimer_gas_4" .. ei_) then
                                parent:SetBodygroup(6, 1) -- Small flame if gas is on
                            end
                        end

                        parent.PotsOnStove[i] = nil
                        self:SetParent(nil)
                        self:SetPos(self:GetPos() + Vector(0, 0, 1))
                        break
                    end
                end
            end
        end
    end
end