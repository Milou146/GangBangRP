player_manager.AddValidModel( "Guard", "models/bratplat/cuadrado/cuadrado.mdl" )
player_manager.AddValidHands( "Guard", "models/bratplat/cuadrado/c_arms/cuadrado.mdl", 0, "00000000" )

player_manager.AddValidModel( "Guard (Colorized)", "models/bratplat/cuadrado/cuadrado_colorized.mdl" )
player_manager.AddValidHands( "Guard (Colorized)", "models/bratplat/cuadrado/c_arms/cuadrado_colorized.mdl", 0, "00000000" )

local NPC = 
{
    	Name = "Guard (Friendly)",
    	Class = "npc_citizen",
	Model = "models/bratplat/cuadrado/cuadrado_npc.mdl",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Category = Category
}
list.Set( "NPC", "Guard_friendly", NPC )

local NPC = 
{
    	Name = "Guard (Enemy)",
	Class = "npc_combine_s",
	Model = "models/bratplat/cuadrado/cuadrado_npc.mdl",
	Health = "100",
	Weapons = { "weapon_pistol" },
	Category = Category
}
list.Set( "NPC", "Guard_enemy", NPC )