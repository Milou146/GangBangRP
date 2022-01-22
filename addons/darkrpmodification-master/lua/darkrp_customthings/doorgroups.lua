--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


AddDoorGroup("yakuzas", TEAM_YAKUZA, TEAM_YAKUZA1, TEAM_YAKUZA2, TEAM_YAKUZA3)
AddDoorGroup("mafia", TEAM_MAFIA, TEAM_MAFIA1, TEAM_MAFIA2, TEAM_MAFIA3)
AddDoorGroup("gang", TEAM_GANGSTER, TEAM_GANGSTER1, TEAM_GANGSTER2, TEAM_GANGSTER3)
AddDoorGroup("NYPD", TEAM_NYPD, TEAM_NYPD1, TEAM_NYPD2, TEAM_NYPD3, TEAM_NYPD4)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)
