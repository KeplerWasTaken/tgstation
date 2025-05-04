/datum/mission/proc/CleanUpAndAbandonMission()
	hostCkey = null
	playerCkeys = list()
	invitedCkeys = list()
	map.Destroy(TRUE)
	missionvehicle = null

/datum/mission/proc/GetListOfPlayers()
	var/list/players = list()

	// If there is no host, you got no players
	if (hostCkey)
		players.Add(hostCkey)
		players.Add(playerCkeys)

	return players


/datum/mission/proc/IsEveryPlayerInVehicle()
	var/list/playerStatuses = GetListOFReadyPlayers()

	// Are any of them not ready?
	for(var/datum/playerMissionStatus/playerStatus in playerStatuses)
		if (playerStatus.isReady == MISSIONS_PLAYER_NOTREADY_STRING)
			return FALSE
	return TRUE
/datum/mission/proc/MoveEveryPlayerToCar()
	for(var/playerCkey in GetListOfPlayers())
		var/mob/living/playerMob = GetMobByCkey(playerCkey)
		playerMob.loc = missionvehicle.loc
/datum/mission/proc/MissionStart(starterCkey, forced = FALSE)
	// If variable is null, or they are not the host, return
	if (!starterCkey || starterCkey != hostCkey)
		return FALSE
	// Do we even have a car
	if (!missionvehicle)
		return FALSE

	if (!forced &&!IsEveryPlayerInVehicle())
		return FALSE

	if (!CoupleEveryPlayerMobToMission())
		return FALSE

	missionvehicle.loc = markers[1].loc
	missionvehicle.KickEveryoneOut()
	MoveEveryPlayerToCar()
	started = TRUE
	return TRUE

/datum/mission/proc/CoupleEveryPlayerMobToMission()
	var/list/playerMobs = list()
	for(var/ckey in GetListOfPlayers())
		var/mob/playerMob = GetMobByCkey(ckey)
		if (!playerMob)
			return FALSE
		playerMob.missions_mission = src
		playerMobs.Add(playerMob)
	associatedEntries.Add(playerMobs)
	return TRUE

/datum/mission/proc/DecoupleEveryPlayerMobFromMission()
	for(var/mob/myMob in associatedEntries)
		if (myMob.ckey)
			associatedEntries -= myMob


/datum/mission/proc/GetListOFReadyPlayers()
	var/list/listOfReadyPlayers = list()
	for(var/playerCkey in GetListOfPlayers())
		var/datum/playerMissionStatus/myPMS = new /datum/playerMissionStatus
		myPMS.ckey = playerCkey
		myPMS.isReady = MISSIONS_PLAYER_NOTREADY_STRING
		myPMS.name = ""
		var/mob/living/playerMob = GetMobByCkey(playerCkey)
		if (playerMob)
			myPMS.name = playerMob.real_name
			if(missionvehicle)
				if(playerMob in missionvehicle.occupants)
					myPMS.isReady = MISSIONS_PLAYER_READY_STRING
		listOfReadyPlayers.Add(myPMS)
	return listOfReadyPlayers
/datum/mission/proc/IsMissionAvailable()
	if (completed)
		return FALSE
	return TRUE

/datum/mission/proc/IsMissionClaimed()
	if (!hostCkey)
		return TRUE
	return FALSE
/datum/mission/proc/GetFreeBaseMarker()
	for(var/obj/missionmarker/myMarker in GLOB.base_markers_list)
		if (myMarker.available == TRUE)
			return myMarker



/datum/playerMissionStatus
	var/ckey
	var/name
	var/isReady

/datum/mission/proc/on_mission_loaded(datum/lazy_template/source, loaded_atom_movables, loaded_turfs, loaded_areas)
	GenerateTerrain(loaded_areas)
	PopulateTerrain(loaded_areas)
	FindMarkers(loaded_atom_movables)
	EndOfMissonLoadingCycle()

/datum/mission/proc/GenerateTerrain(var/loaded_areas)
	for(var/area/A in loaded_areas)
		A.RunTerrainGeneration()

/datum/mission/proc/PopulateTerrain(var/loaded_areas)
	for(var/area/A in loaded_areas)
		A.RunTerrainPopulation()

/datum/mission/proc/FindMarkers(var/loaded_atom_movables)
	for(var/obj/missionmarker/marker in loaded_atom_movables)
		marker.name = "Marker [markerId]"
		markerId++
		markers.Add(marker)

/datum/mission/proc/hasMarkersAvailable()
	return TRUE

/datum/mission/proc/getAvailableMarker(mob/living/user)
	return pick(tgui_input_list(user, "Available Landing Spots:", "Landing Selection", markers))

/datum/mission/proc/GetMarkerByName(markername)
	for(var/obj/missionmarker/marker in markers)
		if (marker.name == markername)
			return marker
	return null

/datum/mission/proc/ObjectivesUpdated()
	var/all_objectives_complete = Check_All_Objectives_Status()
	if(all_objectives_complete && !completed)
		Mission_Complete()
	else if (!all_objectives_complete && completed)
		message_admins("Players can still return home but this might result in a fail.")

/datum/mission/proc/Check_All_Objectives_Status()
	for(var/obj/objective in objectives)
		var/datum/component/mission_objective/myObjective = objective.GetComponent(/datum/component/mission_objective)
		if(!myObjective)
			CRASH("Objective had no objective component!")
		if (myObjective.objective_complete == MISSION_OBJECTIVE_STATUS_NOTREADY)
			return FALSE
	return TRUE

/datum/mission/proc/Mission_Complete()
	// If this variable is populated, mission was complete and do not run this again
	if (missionEndReport == "")
		completed = TRUE
		missionEndReport += "<h2>Contract Report of [name]</h2><br/><hr/>"
		missionEndReport += "<p>Objective: [missionType]</p>"
		missionEndReport +="<p>List of contractors: </p> <br/> <ul>"
		for(var/ckey in GetListOfPlayers())
			var/mob/living/player = GetMobByCkey(ckey)
			missionEndReport += "<li>[player.real_name]</li>"
			player.balloon_alert(player, "Mission complete, time to go home")
			var/datum/action/ShowMissionReport/R = new
			R.myMission = src
			var/client/C = player.client
			C.persistent_client.player_actions += R
			R.Grant(C.mob)
			to_chat(C,"<span class='infoplain'><a href='?src=[REF(R)];report=1'>Show mission report again</a></span>")
		missionEndReport += "</ul>"

/datum/mission/proc/show_mission_report(client/C, report_type = null)
	var/datum/browser/roundend_report = new(C, "Mission Report")
	roundend_report.width = 800
	roundend_report.height = 600
	var/content = missionEndReport

	roundend_report.set_content(content)
	roundend_report.stylesheets = list()
	roundend_report.add_stylesheet("roundend", 'html/browser/roundend.css')
	roundend_report.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css')
	roundend_report.open(FALSE)

/datum/mission/proc/does_user_have_vehicle(var/ckey)

/datum/mission/proc/grant_user_vehicle_permit(var/ckey)

/datum/mission/proc/EndOfMissonLoadingCycle()
	SSmission.on_mission_generation_complete(src)

/datum/mission/proc/does_user_have_money(var/ckey, var/amount)
	return ""

/datum/mission/proc/take_money_from_user(var/ckey, var/amount)
	return ""
