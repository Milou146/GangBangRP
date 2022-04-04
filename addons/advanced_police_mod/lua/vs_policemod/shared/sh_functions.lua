local CFG = VS_PoliceMod.Config

function VS_PoliceMod:Compress( tTable )
	local sJson = util.TableToJSON( tTable or {} )
	local dCompressed = util.Compress( sJson or "" )
	return dCompressed, dCompressed:len()
end

function VS_PoliceMod:Decompress( dData )
	local sJson = util.Decompress( dData )
	local tTable = util.JSONToTable( sJson or "" )
	return tTable
end

local metaPlayer = FindMetaTable( "Player" )

function metaPlayer:PM_IsPolice()
	return (CFG.IsCPPoliceJobs and self:isCP()) or CFG.PoliceJobs[ team.GetName( self:Team() ) ]	
end

function metaPlayer:PM_HasGPS()
	return self:PM_IsPolice() and IsValid( self:GetWeapon( "vs_policemod_gps" ) ) and self:GetWeapon( "vs_policemod_gps" ):GetPower()
end

function metaPlayer:PM_IsChief()
	return self:PM_IsPolice() and RPExtraTeams[ self:Team() ].chief
end
