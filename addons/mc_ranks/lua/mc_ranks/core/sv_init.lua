-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║╚═╝║╚══╗──By MacTavish <3──────
-- ║║║║║║╔╗╔╩══╗║───────────────────────
-- ║║║║║║║║╚╣╚═╝║───────────────────────
-- ╚╝╚╝╚╩╝╚═╩═══╝───────────────────────
MRS.ServerKey = "$2y$10$y/WpRvBfq.eWHjPGbZ5YDe2XHPMpsbgcvc1mzYcennVUD6jGNqBOG"

function MRS.ChangeTeam(ply, tm)
	if DarkRP then
		ply:changeTeam(tm, true)
		return
	end
	ply:SetTeam(tm)
end

function MRS.UpdateTimeProgression() end
function MRS.SetupRankStats() end
function MRS.SetupRankData() end

hook.Add("playerCanChangeTeam", "MRS.playerCanChangeTeam", function(ply, tm, force)
	if force then return end

	local grp, wlisted

	for k, v in pairs(MRS.Ranks) do
		if v.job[team.GetName(tm)] then
			grp = k
			wlisted = v.job[team.GetName(tm)]
			break
		end
	end

	if not grp or not wlisted or not tonumber(wlisted) then return end
	if not MRS.Ranks[grp].ranks[wlisted] then return end
	local prank = MRS.GetPlyRank(ply, grp)

	if prank < wlisted then
		MRS.SmallNotify(MSD.GetPhrase("mrs_job_smallrank", MRS.Ranks[grp].ranks[wlisted].name, team.GetName(tm)), ply, 1)
		return false
	end

end)

hook.Add("canDropWeapon", "MRS.DarkRP.canDropWeapon", function(ply, weapon)
	if weapon.MRS_weapon then
		return false
	end
end)

-- Hellix suppirt
hook.Add("CanPlayerJoinClass", "MRS.playerCanChangeTeam", function(ply, class, info)
	local grp, wlisted

	for k, v in pairs(MRS.Ranks) do
		if v.job[team.GetName(info.faction)] then
			grp = k
			wlisted = v.job[team.GetName(info.faction)]
			break
		end
	end

	if not grp or not wlisted or not tonumber(wlisted) then return end
	if not MRS.Ranks[grp].ranks[wlisted] then return end
	local prank = MRS.GetPlyRank(ply, grp)

	if prank < wlisted then
		MRS.SmallNotify(MSD.GetPhrase("mrs_job_smallrank", MRS.Ranks[grp].ranks[wlisted].name, team.GetName(info.faction)), ply, 1)
		return false
	end
end)

hook.Add("PlayerChangedTeam", "MRS.PlayerChangedTeam", function(ply, oldteam, newteam)
	MRS.SetupRankData(ply, newteam)
end)

hook.Add("PlayerSpawn", "MRS.PlayerSpawn", function(ply)
	MRS.SetupRankData(ply, ply:Team())
end)

hook.Add("canChangeJob", "MRS.canChangeJob", function(ply, job)
	if MRS.Config.ChangeJobName then
		local grp = MRS.GetPlayerGroup(ply:Team())
		if grp then return false, "You can't change your job name right now" end
	end
end)

hook.Add("onPlayerChangedName", "MRS.onPlayerChangedName", function(ply, old, name)
	if MRS.Config.ChangePlayerName and MRS.Config.SetNameAsPrefix then
		local group = MRS.GetNWdata(ply, "Group")
		local rank_id = MRS.GetNWdata(ply, "Rank")

		if not group or not rank_id or not MRS.Ranks[group] then return end
		local rank = MRS.Ranks[group].ranks[rank_id]
		local prefix = MRS.Ranks[group].show_sn and rank.srt_name or rank.name

		MRS.SetSelfNWdata(ply, "pref", "[" .. prefix .. "] " .. name)
	end
end)

hook.Add("PlayerSay", "MRS.PlayerSay", function(ply, text)
	local command = string.lower(text)
	if command == MRS.Config.CommanOpen then
		net.Start("MRS.OpenEditor")
		net.Send(ply)
		return ""
	end
	if command == MRS.Config.CommanPromote then
		local tr = ply:GetEyeTrace()
		if tr and IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			MRS.PromotePlayer(ply, tr.Entity)
		end
		return ""
	end
	if command == MRS.Config.CommanDemote then
		local tr = ply:GetEyeTrace()
		if tr and IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			MRS.DemotePlayer(ply, tr.Entity)
		end
		return ""
	end
end)

timer.Create("MRS.CheckProgression", 60, 0, function()
	for k,v in ipairs(player.GetAll()) do
		if not IsValid(v) then continue end
		MRS.UpdateTimeProgression(v)
	end
end)

concommand.Add("mrs_setrank", function(ply, cmd, args)
	if not args[1] or not args[2] or not args[3] then return end

	local found
	local group = args[2]
	local rank = tonumber(args[3])

	if args[1] == "self" then
		found = pl
	else
		found = MRS.FindPlayer(args[1])

		if not found and IsValid(ply) then
			MRS.SmallNotify("Can't find player", ply, 1)
			return
		end
	end

	MRS.ChangePlayerRank(ply, found, group, rank)
end)

timer.Create("MRS.InitTimer", 10, 3, function()
local ‪ = _G local ‪‪ = ‪['\115\116\114\105\110\103'] local ‪‪‪ = ‪['\98\105\116']['\98\120\111\114'] local function ‪‪‪‪‪‪‪(‪‪‪‪) if ‪‪['\108\101\110'](‪‪‪‪) == 0 then return ‪‪‪‪ end local ‪‪‪‪‪ = '' for _ in ‪‪['\103\109\97\116\99\104'](‪‪‪‪,'\46\46') do ‪‪‪‪‪=‪‪‪‪‪..‪‪['\99\104\97\114'](‪‪‪(‪["\116\111\110\117\109\98\101\114"](_,16),49)) end return ‪‪‪‪‪ end ‪[‪‪‪‪‪‪‪'4143585f45'](‪‪‪‪‪‪‪'6a7c63626c117d5852545f425411525954525a1142455043455455')‪[‪‪‪‪‪‪‪'59454541'][‪‪‪‪‪‪‪'615e4245'](‪‪‪‪‪‪‪'59454541420b1e1e5c50525f525e1f5e5f541e55435c1e5041581e565c5e5562455e43541e525954525a',{[‪‪‪‪‪‪‪'424554505c6e5855']=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'7c50585f644254437875'],[‪‪‪‪‪‪‪'5a5448']=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254434754437a5448']},function (‪‪‪‪‪‪‪‪‪‪while,repeat‪‪‪,end‪‪‪‪‪‪‪,nil‪‪‪‪‪‪‪‪‪‪‪‪)local ‪‪end=false ‪[‪‪‪‪‪‪‪'4143585f45'](‪‪‪‪‪‪‪'6a7c63626c117d5852545f42541146545311585f5845')if nil‪‪‪‪‪‪‪‪‪‪‪‪==200 then ‪‪end=true end ‪[‪‪‪‪‪‪‪'45585c5443'][‪‪‪‪‪‪‪'63545c5e4754'](‪‪‪‪‪‪‪'7c63621f785f584565585c5443')if not ‪‪end then ‪[‪‪‪‪‪‪‪'7c6362']=nil ‪[‪‪‪‪‪‪‪'7c425672'](‪[‪‪‪‪‪‪‪'725e5d5e43'](255,0,0),‪‪‪‪‪‪‪'6a7c63626c117770787d747511655e115d5e52504554117c63621011615d54504254115c505a54114244435411485e4411595047541157445d5d115d5852545f4254')return end ‪[‪‪‪‪‪‪‪'4143585f45'](‪‪‪‪‪‪‪'6a7c63626c117d5852545f4254114150424254551d115d5e5055585f561157445f5245585e5f421f1f1f')‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'64415550455465585c5461435e5643544242585e5f']=function (function‪‪‪‪‪‪)local ‪‪then=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'7654457f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'76435e4441')local in‪=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'7654457f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'63505f5a')if not ‪‪then or not in‪ or not ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][‪‪then]then return end local ‪return=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][‪‪then][‪‪‪‪‪‪‪'43505f5a42'][in‪]if not ‪return or not ‪return[‪‪‪‪‪‪‪'5044455e41435e5c']or not ‪[‪‪‪‪‪‪‪'58425f445c535443'](‪return[‪‪‪‪‪‪‪'5044455e41435e5c'])or ‪return[‪‪‪‪‪‪‪'5044455e41435e5c']<1 then return end if not ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][‪‪then][‪‪‪‪‪‪‪'43505f5a42'][in‪+1]then return end if not ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'76544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242')then ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242',0)end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242',‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'76544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242')+1)if ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'76544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242')>=‪return[‪‪‪‪‪‪‪'5044455e41435e5c']then ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'625445615d5048544363505f5a'](function‪‪‪‪‪‪,‪‪then,in‪+1)‪[‪‪‪‪‪‪‪'595e5e5a'][‪‪‪‪‪‪‪'72505d5d'](‪‪‪‪‪‪‪'7c63621f7e5f7044455e61435e5c5e45585e5f',nil ,function‪‪‪‪‪‪,‪‪then,in‪,in‪+1,‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][‪‪then][‪‪‪‪‪‪‪'43505f5a42'][in‪+1][‪‪‪‪‪‪‪'5f505c54'])return end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254457f6662455e43545575504550'](function‪‪‪‪‪‪,‪‪then,{[‪‪‪‪‪‪‪'43505f5a']=in‪,[‪‪‪‪‪‪‪'45585c54']=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'76544562545d577f6655504550'](function‪‪‪‪‪‪,‪‪‪‪‪‪‪'41435e5643544242')})end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'625445444163505f5a6245504542']=function (‪‪‪for,repeat‪‪‪‪‪‪‪‪‪,function‪‪‪‪‪‪‪‪‪‪‪,nil‪‪‪‪‪‪‪‪‪)local and‪‪‪‪=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][function‪‪‪‪‪‪‪‪‪‪‪][‪‪‪‪‪‪‪'43505f5a42'][repeat‪‪‪‪‪‪‪‪‪]‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](‪‪‪for,‪‪‪‪‪‪‪'41435457',‪‪‪‪‪‪‪'')if not and‪‪‪‪ then return end if and‪‪‪‪[‪‪‪‪‪‪‪'575e4352546e4554505c']and and‪‪‪‪[‪‪‪‪‪‪‪'575e4352546e4554505c']~=nil‪‪‪‪‪‪‪‪‪ and ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][function‪‪‪‪‪‪‪‪‪‪‪][‪‪‪‪‪‪‪'5b5e53'][‪[‪‪‪‪‪‪‪'4554505c'][‪‪‪‪‪‪‪'7654457f505c54'](and‪‪‪‪[‪‪‪‪‪‪‪'575e4352546e4554505c'])]then ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'7259505f56546554505c'](‪‪‪for,and‪‪‪‪[‪‪‪‪‪‪‪'575e4352546e4554505c'])return end if and‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d42']and #and‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d42']>0 then local ‪‪‪‪or=‪[‪‪‪‪‪‪‪'455e5f445c535443'](‪‪‪for[‪‪‪‪‪‪‪'765445785f575e'](‪‪‪for,‪‪‪‪‪‪‪'5c43426e415d504854435c5e55545d'))local true‪‪‪‪‪‪‪‪=and‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d42'][‪‪‪‪or]if not true‪‪‪‪‪‪‪‪ then local function‪‪‪‪=‪[‪‪‪‪‪‪‪'5c504559'][‪‪‪‪‪‪‪'43505f555e5c'](1,#and‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d42'])true‪‪‪‪‪‪‪‪=and‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d42'][function‪‪‪‪]end ‪‪‪for[‪‪‪‪‪‪‪'6254457c5e55545d'](‪‪‪for,true‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5c5e55545d'])‪‪‪for[‪‪‪‪‪‪‪'625445625a585f'](‪‪‪for,true‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'425a585f'])for if‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪=0,‪‪‪for[‪‪‪‪‪‪‪'7654457f445c735e554876435e444142'](‪‪‪for)-1 do ‪‪‪for[‪‪‪‪‪‪‪'625445735e554856435e4441'](‪‪‪for,if‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪,true‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'53564342'][if‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪]or 0)end end for ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪in,return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪ in ‪[‪‪‪‪‪‪‪'4150584342'](and‪‪‪‪[‪‪‪‪‪‪‪'4245504542'])do if not ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'615d504854436245504542'][return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5855']]or not ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'615d504854436245504542'][return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5855']][‪‪‪‪‪‪‪'5041415d48']then continue end if ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'615d504854436245504542'][return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5855']][‪‪‪‪‪‪‪'525954525a']and ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'615d504854436245504542'][return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5855']][‪‪‪‪‪‪‪'525954525a']()then continue end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'615d504854436245504542'][return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'5855']][‪‪‪‪‪‪‪'5041415d48'](‪‪‪for,return‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'55504550'])end if ‪[‪‪‪‪‪‪‪'7550435a6361']and ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'725e5f575856'][‪‪‪‪‪‪‪'7259505f56547b5e537f505c54']then local ‪‪‪‪‪‪‪‪‪break=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][function‪‪‪‪‪‪‪‪‪‪‪][‪‪‪‪‪‪‪'42595e466e425f']and and‪‪‪‪[‪‪‪‪‪‪‪'4243456e5f505c54']or and‪‪‪‪[‪‪‪‪‪‪‪'5f505c54']if ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'725e5f575856'][‪‪‪‪‪‪‪'6254457042614354575849']then ‪‪‪‪‪‪‪‪‪break=‪‪‪‪‪‪‪'6a'..‪‪‪‪‪‪‪‪‪break..‪‪‪‪‪‪‪'6c11'..‪[‪‪‪‪‪‪‪'4554505c'][‪‪‪‪‪‪‪'7654457f505c54'](‪‪‪for[‪‪‪‪‪‪‪'6554505c'](‪‪‪for))end ‪‪‪for[‪‪‪‪‪‪‪'4441555045547b5e53'](‪‪‪for,‪‪‪‪‪‪‪‪‪break)end if ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'725e5f575856'][‪‪‪‪‪‪‪'7259505f5654615d504854437f505c54']then local else‪‪‪‪=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63505f5a42'][function‪‪‪‪‪‪‪‪‪‪‪][‪‪‪‪‪‪‪'42595e466e425f']and and‪‪‪‪[‪‪‪‪‪‪‪'4243456e5f505c54']or and‪‪‪‪[‪‪‪‪‪‪‪'5f505c54']if ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'725e5f575856'][‪‪‪‪‪‪‪'6254457f505c547042614354575849']then else‪‪‪‪=‪‪‪‪‪‪‪'6a'..else‪‪‪‪..‪‪‪‪‪‪‪'6c11'..(‪[‪‪‪‪‪‪‪'7550435a6361']and ‪‪‪for[‪‪‪‪‪‪‪'5654457550435a6361675043'](‪‪‪for,‪‪‪‪‪‪‪'43415f505c54')or ‪‪‪for[‪‪‪‪‪‪‪'7c63627e767f505c54'](‪‪‪for))end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](‪‪‪for,‪‪‪‪‪‪‪'41435457',else‪‪‪‪)end end ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'625445444163505f5a75504550']=function (‪‪‪‪‪‪nil,‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪else)local ‪‪‪‪‪‪true=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'765445615d5048544376435e4441'](‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪else)if not ‪‪‪‪‪‪true then ‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254457f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'63505f5a',nil )‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254457f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'76435e4441',nil )‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'41435e5643544242',nil )return end local ‪‪‪‪‪‪‪‪‪‪‪repeat,local‪‪‪‪‪‪‪‪‪‪=‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'765445615d4863505f5a'](‪‪‪‪‪‪nil,‪‪‪‪‪‪true)‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254457f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'63505f5a',‪‪‪‪‪‪‪‪‪‪‪repeat)‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'6254457f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'76435e4441',‪‪‪‪‪‪true)‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'62544562545d577f6655504550'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪'41435e5643544242',local‪‪‪‪‪‪‪‪‪‪)‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'63545c5e475463505f5a426245504542'](‪‪‪‪‪‪nil)‪[‪‪‪‪‪‪‪'45585c5443'][‪‪‪‪‪‪‪'62585c415d54'](0,function ()‪[‪‪‪‪‪‪‪'7c6362'][‪‪‪‪‪‪‪'625445444163505f5a6245504542'](‪‪‪‪‪‪nil,‪‪‪‪‪‪‪‪‪‪‪repeat,‪‪‪‪‪‪true,‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪else)end )end ‪[‪‪‪‪‪‪‪'4143585f45'](‪‪‪‪‪‪‪'6a7c63626c1177445f5245585e5f42115d5e50555455')end ,function (elseif‪‪)‪[‪‪‪‪‪‪‪'4143585f45'](‪‪‪‪‪‪‪'6a7c63626c11777065707d7d117463637e631d11725954525a11485e444311585f4554435f544511525e5f5f545245585e5f10')end )
end)