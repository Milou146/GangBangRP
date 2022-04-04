AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/humans/gasmaskcit.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)
    self:DropToFloor()
    self:SetMaxYawSpeed(90)
    self:SetCollisionGroup(1)
    self.RandomCocainePayout = math.random(TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax)

    -- Update random payout every 5th minute.
    timer.Create("COCAINE_NPCRandomPayout_" .. self:EntIndex(), TCF.Config.RandomPayoutInterval, 0, function()
        if IsValid(self) then
            self.RandomCocainePayout = math.random(TCF.Config.PayPerPackMin, TCF.Config.PayPerPackMax)
        end
    end)
end

function ENT:AcceptInput(string, ply)
    if ply:IsPlayer() and (self.lastUsed or CurTime()) <= CurTime() then
        self.lastUsed = CurTime() + 1.5
        if not IsValid(ply) then return end

        if not table.HasValue(TCF.Config.CriminalTeams, team.GetName(ply:Team())) then
            DarkRP.notify(ply, 1, 6, TCF.Config.Lang["I don't want to speak with you in your current position, go away!"][TCF.Config.Language])
            self:EmitSound("vo/npc/male01/sorry01.wav")

            return
        end

        local boxes_counted = 0
        local total_boxes = #ents.FindByClass("cocaine_box")

        for k, box in ipairs(ents.FindByClass("cocaine_box")) do
            local boxowner = box:CPPIGetOwner()

            if not IsValid(boxowner) then
                boxowner = ply
            end

            boxes_counted = boxes_counted + 1

            if ply:GetPos():DistToSqr(box:GetPos()) <= TCF.Config.SellDistance then
                if box.IsClosed then
                    if box.BoxCocaineAmount > 0 then
                        if boxowner == ply then
                            local bonus = boxowner:GetDonatorBonus()
                            local cocaine_amount = box.BoxCocaineAmount
                            local payperpack = self.RandomCocainePayout
                            local fullpayout = math.Round((cocaine_amount * payperpack) * bonus)
                            -- Network the information to the client and save it so it cannot be abused.
                            ply.DonatorSellBonus = bonus
                            ply.SellBoxCocaineAmount = cocaine_amount
                            ply.FullPayout = fullpayout
                            ply.PayPerPack = payperpack
                            net.Start("TCF_SellDrugsMenu")
                            net.WriteDouble(ply.DonatorSellBonus)
                            net.WriteDouble(ply.SellBoxCocaineAmount)
                            net.WriteDouble(ply.FullPayout)
                            net.Send(ply)
                            self:EmitSound("vo/npc/male01/hi0" .. math.random(1, 2) .. ".wav") -- finally
                            break
                        end
                    else
                        DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Your box contains no cocaine. Are you trying to scam me?"][TCF.Config.Language])
                        self:EmitSound("vo/npc/male01/gethellout.wav")
                        break
                    end
                else
                    DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Close the box before trying to sell it, rookie."][TCF.Config.Language])
                    self:EmitSound("vo/npc/male01/uhoh.wav")
                    break
                end
            elseif boxes_counted >= total_boxes then
                DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Please bring the box closer to the druggie."][TCF.Config.Language])
                self:EmitSound("vo/npc/male01/answer25.wav")
                break
            end
        end
    end
end

net.Receive("TCF_SellCocaine", function(length, ply)
    if not table.HasValue(TCF.Config.CriminalTeams, team.GetName(ply:Team())) then
        DarkRP.notify(ply, 1, 6, TCF.Config.Lang["I don't want to speak with you in your current position, go away!"][TCF.Config.Language])
        self:EmitSound("vo/npc/male01/sorry01.wav")

        return
    end

    local boxes_counted = 0
    local total_boxes = #ents.FindByClass("cocaine_box")

    for k, box in ipairs(ents.FindByClass("cocaine_box")) do
        local boxowner = box:CPPIGetOwner()

        if not IsValid(boxowner) then
            boxowner = ply
        end

        boxes_counted = boxes_counted + 1

        if ply:GetPos():DistToSqr(box:GetPos()) <= TCF.Config.SellDistance then
            if box.IsClosed then
                if box.BoxCocaineAmount > 0 then
                    if (boxowner == ply) or (box.ItemStoreOwner == ply) then
                        local bonus = boxowner:GetDonatorBonus()
                        local cocaine_amount = box.BoxCocaineAmount
                        local payperpack = ply.PayPerPack
                        ply.FullPayout = math.Round((cocaine_amount * payperpack) * bonus)
                        ply:addMoney(ply.FullPayout)
                        DarkRP.notify(ply, 1, 6, TCF.Config.Lang["You've just sold your cocaine for"][TCF.Config.Language] .. " " .. DarkRP.formatMoney(ply.FullPayout))
                        -- XP Support
                        local xp_to_give = math.Round(cocaine_amount * TCF.Config.XPPerCocainePack)

                        if TCF.Config.OnSellGiveXP then
                            ply:TCF_RewardXP(xp_to_give)
                        end

                        -- Reset all information on the user
                        ply.DonatorSellBonus = 0
                        ply.SellBoxCocaineAmount = 0
                        ply.FullPayout = 0
                        ply.PayPerPack = 0
                        box:Remove()
                        ply:EmitSound("vo/npc/male01/finally.wav")
                        break
                    end
                else
                    DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Your box contains no cocaine. Are you trying to scam me?"][TCF.Config.Language])
                    break
                end
            else
                DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Close the box before trying to sell it, rookie."][TCF.Config.Language])
                break
            end
        elseif boxes_counted >= total_boxes then
            DarkRP.notify(ply, 1, 6, TCF.Config.Lang["Please bring the box closer to the druggie."][TCF.Config.Language])
            break
        end
    end
end)

function ENT:OnRemove()
    timer.Remove("COCAINE_NPCRandomPayout_" .. self:EntIndex())
end

function ENT:OnTakeDamage(dmg)
    return 0
end