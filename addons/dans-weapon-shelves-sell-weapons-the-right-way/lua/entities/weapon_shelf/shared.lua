ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Weapon Shelf"
ENT.Author = "Dan"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Owner = nil
ENT.Category = "Dan's Addons"
ENT.WorldModel = "models/dansgunshelf/dansgunshelf.mdl"
ENT.Hover = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AdminAccess = {

	["superadmin"] = true,
	["admin"] = true,

}

ENT.ItemBlacklist = {

	"weapon_pistol",
	"weapon_physgun",

}
ENT.MaxPrice = 1250000
ENT.PhysgunPickupEnabled = true
ENT.SelfSupply = false -- Set this to true to allow users to buy their own weapons.
 function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
end

DANS_SHELVES = DANS_SHELVES or {}
DANS_SHELVES.EntCache = DANS_SHELVES.EntCache or {}
DANS_SHELVES.BuyDelay = 0 -- ( Number of seconds between buying items ) 0 to disable.
