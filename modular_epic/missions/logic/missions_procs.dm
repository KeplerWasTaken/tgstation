// CKEY -> Mission
/proc/GetMissionUserIsIn(userCkey)
	for(var/datum/mission/myMission in SSmission.all_missions)
		if (userCkey in myMission.GetListOfPlayers())
			return myMission
	return null

// Mission Name -> Mission
/proc/getMissionByName(name)
	for(var/datum/mission/mission in SSmission.all_missions)
		if (mission.name == name)
			return mission
	return null

// CKEY -> Mob
/proc/GetMobByCkey(ckey)
	if (ckey)
		for(var/client/C in GLOB.clients)
			if (C.ckey == ckey)
				if (C.mob)
					return C.mob
				else
					return null
	return null

/datum/contractor
	var/ckey
	var/mob/userMob

/proc/get_contractors_list()
	var/list/contractors = list()
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/player_mob = GLOB.player_list[i]
		if(!player_mob?.client && player_mob.job && player_mob.job == JOB_ASSISTANT)
			continue
		//We want them :3
		var/datum/contractor/myContractor = new /datum/contractor
		myContractor.ckey = player_mob.ckey
		myContractor.userMob = player_mob
		contractors.Add(myContractor)
	return contractors
