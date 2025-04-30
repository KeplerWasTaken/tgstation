#define PING_SOUND
#define VEHICLE_COST 100
#define MISSION_EASY_PAYOUT 1000
#define MISSION_MEDIUM_PAYOUT 2500
#define MISSION_HARD_PAYOUT 4000
#define MISSION_INSANE_PAYOUT 7500

/datum/computer_file/program/missionfinder
	filename = "contractlist"
	filedesc = "Contracts List"
	program_open_overlay = "generic"
	extended_desc = "Grab some fellows, enlist in a contract - and get paid today!"
	undeletable = TRUE
	size = 4
	tgui_id = "NtosMissionFinder"
	program_icon = "download"

/datum/computer_file/program/missionfinder/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("MF_hostmission")
			var/missionSelectedName = params["mission"]
			var/datum/mission/myMission = getMissionByName(missionSelectedName)
			if (myMission)
				var/operationResult = myMission.HostClaimsMission(ui.user.ckey)
				if(operationResult == "")
					PingAndNotifyUser(ui.user, "Successfully claimed contract")
				else
					PingAndNotifyUser(ui.user, operationResult)
			return TRUE

		if("MF_invite")
			var/userinvited = params["userInvited"]
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				var/operationResult = myMission.HostInvitesUser(userinvited, ui.user.ckey)
				if(operationResult == "")
					PingAndNotifyUser(ui.user, "Contractor has been invited")
				else
					PingAndNotifyUser(ui.user, operationResult)
			return TRUE

		if("MF_acceptinvite")
			var/userInvitedBy = params["mission"]
			var/datum/mission/myMission = getMissionByName(userInvitedBy)
			if (myMission)
				if(myMission.UserAcceptsInvite(ui.user.ckey))
					PingAndNotifyUser(ui.user, "Invitation accepted")
				else
					PingAndNotifyUser(ui.user, "Invitation could not be accepted")				
			return TRUE

		if("MF_declineinvite")
			var/missionInQuestion = params["mission"]
			var/datum/mission/myMission = getMissionByName(missionInQuestion)
			if (myMission)
				if(myMission.UserDeniesInvite(ui.user.ckey))
					PingAndNotifyUser(ui.user, "Invite denied")
				else
					PingAndNotifyUser(ui.user, "Invite could not be denied")
			return TRUE

		if("MF_leavegroup")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				if(myMission.UserLeavesGroup(ui.user.ckey))
					PingAndNotifyUser(ui.user, "Group has been left")
				else
					PingAndNotifyUser(ui.user, "Group could not be left at this time")
				return TRUE

		if("MF_startmission")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if(myMission)
				myMission.MissionStart(ui.user.ckey)
			return TRUE

		if("MF_revokeinvite")
			var/ckeyToRevoke = params["revokeCkey"]
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if(myMission)
				if(myMission.HostUninvitesUser(ckeyToRevoke, ui.user.ckey))
					PingAndNotifyUser(ui.user, "Contractor has been uninvited")
				else
					PingAndNotifyUser(ui.user, "Contractor could not be uninvited at this time")
				return TRUE

		if ("MF_getvehicle")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				if(myMission.HostClaimVehicle(ui.user.ckey))
					PingAndNotifyUser(ui.user, "Vehicle has been requisitioned")
				else
					PingAndNotifyUser(ui.user, "Vehicle could not be requisitioned at this time")
				return TRUE

		if("MF_kick")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				if(myMission.HostKicksUser(params["toKick"], ui.user.ckey))
					PingAndNotifyUser(ui.user, "Contractor has been unenlisted from contract")
				else
					PingAndNotifyUser(ui.user, "Contractor could not be unenlisted from contract at this time")
				return TRUE

		if("MF_abandonvehicle")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				if(myMission.HostUnclaimsVehicle(ui.user.ckey))
					PingAndNotifyUser(ui.user, "Vehicle has been relinquished")
				else
					PingAndNotifyUser(ui.user, "Vehicle could not be relinquished at this time")
				return TRUE
		if("MF_returnfrommission")
			var/datum/mission/myMission = GetMissionUserIsIn(ui.user.ckey)
			if (myMission)
				var/operationResult = myMission.MissionLeave(ui.user.ckey)
				if(operationResult == "")
					PingAndNotifyUser(ui.user, "Contract complete; your reward has been deposited into your account.")
				else
					PingAndNotifyUser(ui.user, operationResult)
	return FALSE

/datum/computer_file/program/missionfinder/ui_data(mob/user)
	var/list/data = list()

	data["currentmissionData"] = null
	data["vehicle"] = null

	// Get list of all contractors
	var/list/contractors = get_contractors_list()

	// ContractorData - name , busy, ckey
	for(var/datum/contractor/i in contractors)
		var/datum/mission/missionContractorIsIn = GetMissionUserIsIn(i.ckey)

		data["contractors"] += list(list(
			"name" = i.userMob.real_name,
			"ckey" = i.ckey,
			"busy" = missionContractorIsIn ? "Busy" : ""
		))
	
	data["contractors"] += list(list(
		"name" = "Test",
		"ckey" = "Ckey",
		"busy" = "Not implemented yet"
	))

	//user
	data["user"] = user.real_name;

	//currentMissionData

	// For each mission that exists
	for(var/datum/mission/myMission in SSmission.all_missions)

		var/mission_hoster = "N/A"
		var/list/myInvitations = list()
		// Does host exist
		if (myMission.hostCkey)
			var/mob/hoster = GetMobByCkey(myMission.hostCkey)	
			mission_hoster = hoster.real_name
			for(var/invitedPersonCkey in myMission.invitedCkeys)
				var/mob/invitedMob = GetMobByCkey(invitedPersonCkey)
				myInvitations += list(list(
					"inviterName" = hoster.real_name,
					"missionName" = myMission.name,
					"recipientName" = invitedMob.real_name,
					"recipientCkey" = invitedPersonCkey,
					"inviterCkey" = myMission.hostCkey
				))
	
		var/list/missionDataPlayers = list()
		
		for(var/datum/playerMissionStatus/player in myMission.GetListOFReadyPlayers())
			missionDataPlayers += list(list(
				"player_name" = player.name,
				"player_isready" = player.isReady,
				"player_ckey" = player.ckey
			))

		data["missions"] += list(list(
			"mission_hostername" = mission_hoster,
			"mission_difficulty" = myMission.difficulty,
			"mission_type" = myMission.missionType,
			"mission_name" = myMission.name,
			"mission_maxplayers" = myMission.maxPlayers,
			"mission_description" = myMission.missionDescription,
			"mission_list_players" = missionDataPlayers,
			"mission_list_outgoinginvitations" = myInvitations,
			"mission_completed" = myMission.completed,
			"mission_started" = myMission.started,
			"mission_left" = myMission.left
		))

		if (user.ckey in myMission.GetListOfPlayers())
			data["currentmissionData"] = list(
			"mission_hostername" = mission_hoster,
			"mission_difficulty" = myMission.difficulty,
			"mission_type" = myMission.missionType,
			"mission_name" = myMission.name,
			"mission_maxplayers" = myMission.maxPlayers,
			"mission_description" = myMission.missionDescription,
			"mission_list_players" = missionDataPlayers,
			"mission_list_outgoinginvitations" = myInvitations,
			"mission_completed" = myMission.completed,
			"mission_started" = myMission.started,
			"mission_left" = myMission.left
			)
			
			data["vehicle"] = list(
				"vehicle_name" = myMission.missionvehicle ? myMission.missionvehicle.name : null
			)

	var/list/MissionsUserIsInvitedTo = GetUserInvitedMissions(user.ckey)
	for(var/datum/mission/myMission in MissionsUserIsInvitedTo)

		var/mob/hostingMob = GetMobByCkey(myMission.hostCkey)
		data["invitations"] += list(list(
			"inviterName" = hostingMob.real_name,
			"missionName" = myMission.name,
			"recipientName" = user.real_name,
			"recipientCkey" = user.ckey,
			"inviterCkey" = myMission.hostCkey
		))

	data["invitations"] = MissionsUserIsInvitedTo
	return data

/datum/computer_file/program/missionfinder/proc/GetUserInvitedMissions(ckey)
	var/list/myMissions = list()
	for(var/datum/mission/myMission in SSmission.all_missions)
		if (ckey in myMission.invitedCkeys)
			myMissions.Add(myMission)
	return myMissions

/datum/computer_file/program/missionfinder/proc/GetMissionInvitedCkeys(missionname)
	var/datum/mission/myMission = getMissionByName(missionname)
	if(myMission)
		return myMission.invitedCkeys
	return list()

/datum/computer_file/program/missionfinder/proc/PingAndNotifyUser(mob, message)
	if (istype(mob, /mob))
		var/mob/MyMob = mob
		playsound(MyMob, 'sound/machines/ping.ogg', 30, TRUE)
		MyMob.balloon_alert(MyMob, message)
		to_chat(MyMob, message)
#undef PING_SOUND

