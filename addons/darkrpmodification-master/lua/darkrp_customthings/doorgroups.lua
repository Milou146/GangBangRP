--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


AddDoorGroup("Les yakuzas", TEAM_YAKUZA, TEAM_YAKUZA1, TEAM_YAKUZA2, TEAM_YAKUZA3)
AddDoorGroup("La Mafia", TEAM_MAFIA, TEAM_MAFIA1, TEAM_MAFIA2, TEAM_MAFIA3)
AddDoorGroup("Les gangsters", TEAM_GANGSTER, TEAM_GANGSTER1, TEAM_GANGSTER2, TEAM_GANGSTER3)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)
