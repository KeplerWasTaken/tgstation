// HOSTING A MISSION

/datum/mission/proc/HostClaimVehicle(claimerCkey)

	if (!claimerCkey || claimerCkey != hostCkey)
		return FALSE

	// Do we already have one?
	if (missionvehicle)
		return FALSE
	
	for(var/obj/vehicle/sealed/car/missiondriver/myVehicle in SSmission.all_vehicles)
		if(myVehicle.missionassignedto == null)
			// You're mine now
			myVehicle.missionassignedto = src 
			missionvehicle = myVehicle
			return TRUE
	
	// None were available. Boo whomp
	return FALSE

/datum/mission/proc/HostUnclaimsVehicle(unclaimerCkey)

	// Did we get the parameter, and are they the host?
	if (!unclaimerCkey || unclaimerCkey != hostCkey)
		return FALSE

	// Do we have one to actually unclaim?
	if (!missionvehicle)
		return FALSE
	
	// Unclaim it
	missionvehicle.missionassignedto = null
	missionvehicle = null
	
	return TRUE

/datum/mission/proc/HostInvitesUser(invitedCkey, invitingCkey)

	if (!invitedCkey)
		return "ERROR: Invited contractor could not be read"
	if (!invitingCkey)
		return "ERROR: Inviting contractor could not be read"
	if (hostCkey != invitingCkey)
		return "ERROR: Inviter does not have permission to invite"
	if(invitedCkey in invitedCkeys)
		return "ERROR: Contractor has already been invited"
	if(invitedCkey in playerCkeys)
		return "ERROR: Contractor is already in the group"
	if(invitedCkey == hostCkey)
		return "ERROR: Invited contractor is already hosting this mission"
	
	invitedCkeys.Add(invitedCkey)
	return ""

/datum/mission/proc/HostUninvitesUser(invitedCkey, invitingCkey)
	// invitedCkey not null, and check its in invite list
	if (invitedCkey && invitingCkey && (invitedCkey in invitedCkeys))
		invitedCkeys.Remove(invitedCkey)
		return TRUE
	return FALSE

/datum/mission/proc/HostKicksUser(tokick, kicker)
	// tokick not null, kicker not null, kicker is host, to kick is a player
	if (tokick && kicker && kicker == hostCkey && (tokick in playerCkeys))
		playerCkeys.Remove(tokick)
		return TRUE
	return FALSE

/datum/mission/proc/HostClaimsMission(claimerCkey)

	// claimerCkey is not null, claimer not in a mission, mission is available, mission is not already hosted
	if (!claimerCkey)
		return "ERROR: Claiming contractor could not be read"
	
	var/datum/mission/MissionUserIsIn = GetMissionUserIsIn(claimerCkey)
	if (MissionUserIsIn)
		return "ERROR: Contractor is already in a group"
	
	if (hostCkey != null)
		return "ERROR: Contract already has a host"

	if (!IsMissionAvailable())
		return "ERROR: Contract is not available"

	hostCkey = claimerCkey
	return ""

// CONTRACTOR ACTIONS
// (You joined a contract)

/datum/mission/proc/UserAcceptsInvite(invitedCkey)
	// invitedCkey not null, invited ckey not host or in list of already joined users, user is in invited ckeys list, user is not already in a mission
	if (invitedCkey && (invitedCkey in invitedCkeys) && !(invitedCkey in playerCkeys) && invitedCkey != hostCkey)
		invitedCkeys.Remove(invitedCkey)
		playerCkeys.Add(invitedCkey)
		return TRUE
	return FALSE

/datum/mission/proc/UserDeniesInvite(invitedCkey)
	// invitedCkey not null, and check its in invite list
	if (invitedCkey && (invitedCkey in invitedCkeys))
		invitedCkeys.Remove(invitedCkey)
		return TRUE
	return FALSE

/datum/mission/proc/MissionLeave(leaverCkey)
	if (!leaverCkey)
		return "Person trying to leave mission not registered"
	
	if (leaverCkey != hostCkey)
		return "Contractor attempting to depart from Mission is not the host"
	
	if (completed != TRUE)
		return "Mission grounds can not be left yet as the mission is not complete"

	var/obj/missionmarker/targetMarker = GetFreeBaseMarker()

	if (!targetMarker)
		return "No parking spot is available for the vehicle"

	DecoupleEveryPlayerMobFromMission()

	missionvehicle.loc = targetMarker.loc
	missionvehicle.KickEveryoneOut()
	MoveEveryPlayerToCar()
	left = TRUE
	CleanUpAndAbandonMission()
	return TRUE

/datum/mission/proc/UserLeavesGroup(ckeyLeaving)
	if (!ckeyLeaving)
		return FALSE
	if (!(ckeyLeaving in GetListOfPlayers()))
		return FALSE
	
	// Host is leaving? Disband
	if (ckeyLeaving == hostCkey)
		hostCkey = null

		// Clean the mission
		playerCkeys = list()
		playerCkeys = list()
		invitedCkeys = list()
		if (missionvehicle)
			missionvehicle.missionassignedto = null
		missionvehicle = null
	// Just one guy
	else
		playerCkeys.Remove(ckeyLeaving)

	return TRUE
