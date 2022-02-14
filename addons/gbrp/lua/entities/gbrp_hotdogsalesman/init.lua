AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.hotdogpos = Vector(1985.312012,5540.983398,46.440498)

function ENT:Initialize()
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:Use(ply, caller, useType, value)
    local food = gbrp.foods["hotdog"]
    if ply:CanAfford(food.price) then

        local foodTable = {
            cmd = "buyfood",
            max = GAMEMODE.Config.maxfooditems
        }

        if ply:customEntityLimitReached(foodTable) then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", GAMEMODE.Config.chatCommandPrefix .. "buyfood"))

            return ""
        end

        ply:addCustomEntity(foodTable)

        local SpawnedFood = ents.Create("spawned_food")
        SpawnedFood.DarkRPItem = foodTable
        SpawnedFood:Setowning_ent(ply)
        SpawnedFood:SetPos(self.hotdogpos)
        SpawnedFood.onlyremover = true
        SpawnedFood.SID = ply.SID
        SpawnedFood:SetModel(food.model)

        -- for backwards compatibility
        SpawnedFood.FoodName = "hotdog"
        SpawnedFood.FoodEnergy = food.energy
        SpawnedFood.FoodPrice = food.price

        SpawnedFood.foodItem = food
        SpawnedFood:Spawn()

        ply:Pay(food.price)
        DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("you_bought", "hotdog", gbrp.formatMoney(food.price), ""))

        hook.Call("playerBoughtFood", nil, ply, food, SpawnedFood, food.price)
    else
        DarkRP.notify(ply,1,4,"Solde insuffisant.")
    end
end