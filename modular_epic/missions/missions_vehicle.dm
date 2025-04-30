#define VEHICLE_TYPE_MERCENARY "VEHICLE_MERCENARY"
#define VEHICLE_TYPE_SECURITY "VEHICLE_SECURITY"
#define VEHICLE_TYPE_MEDICAL "VEHICLE_MEDICAL"

/obj/vehicle/sealed/car/missiondriver
	name = "Vroom"
	desc = "We ball"
	max_occupants = 4
	max_drivers = 1
	icon_state = "clowncar"
	max_integrity = 150
	enter_delay = 20
	movedelay = 0.6
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_range = 6
	light_power = 2
	light_on = TRUE
	occupantTraitsList = list()
	canmove = FALSE
	var/datum/mission/missionassignedto
	var/vehicletype = VEHICLE_TYPE_MERCENARY

/obj/vehicle/sealed/car/missiondriver/proc/ValidateOccupantsRightToBeInside()
	if (!missionassignedto)
		// Kick out everyone. Out!
		for(var/mob/myMob in occupants)
			remove_occupant(myMob)

	// Otherwise, go through them one by one
	for(var/mob/occupant in occupants)
		if(!occupant.ckey && !(occupant.ckey in missionassignedto.GetListOfPlayers()))
			remove_occupant(occupant)

/obj/vehicle/sealed/car/missiondriver/proc/KickEveryoneOut()
	for(var/mob/occupant in occupants)
		mob_exit(occupant)

/obj/vehicle/sealed/car/missiondriver/mob_try_enter(mob/rider)
	// If Mob has no ckey
	if(!rider.ckey)
		to_chat(rider, "What? Me? In there? NONSENSE...")
		rider.balloon_alert(rider, "What? Me? In there? NONSENSE...")
		return FALSE
	
	// If vehicle has no mission assigned to it
	if (!missionassignedto)
		to_chat(rider, "This vehicle is not booked yet")
		rider.balloon_alert(rider, "This vehicle is not booked yet")
		return FALSE

	// If the incoming ckey is not in our accepted list of players
	if (!(rider.ckey in missionassignedto.GetListOfPlayers()))
		to_chat(rider, "You are not assigned to this vehicle.")
		rider.balloon_alert(rider, "You are not assigned to this vehicle.")
		return FALSE

	if(missionassignedto.started && !missionassignedto.completed)
		to_chat(rider, "Not all objectives are complete.")
		rider.balloon_alert(rider, "Not all objectives are complete.")
		return FALSE
		
	return ..(rider)

/obj/vehicle/sealed/car/missiondriver/generate_actions()
	. = ..()
	// initialize_controller_action_type(/datum/action/vehicle/sealed/horn, VEHICLE_CONTROL_DRIVE)
	// initialize_controller_action_type(/datum/action/vehicle/sealed/gotomission, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/car/missiondriver/proc/GetReadiedUpPlayers()
	var/list/readiedPlayers = list()
	for(var/mob/occupant in occupants)
		if(occupant.ckey && (occupant.ckey in missionassignedto.GetListOfPlayers()))
			readiedPlayers.Add(occupant.ckey)
	return readiedPlayers

/datum/action/vehicle/sealed/gotomission
	name = "Go to Mission"
	desc = "We ball"
	button_icon_state = "car_horn"

/datum/action/vehicle/sealed/gotomission/Trigger(trigger_flags)
	if (vehicle_target.vehicle_location == MISSIONS_MARKER_AT_BASE)
		var/list/views = list()
		for (var/datum/mission/mission in SSmission.all_missions)
			views.Add(mission.name)
		if(views.len == 0)
			return
		var/mission_selected_string = tgui_input_list(usr, "Available missions:", "Mission Selection", views)
		if(!mission_selected_string)	
			return
		var/datum/mission/mission_selected = getMissionByName(mission_selected_string)
		var/obj/missionmarker/marker_name_selected = mission_selected.getAvailableMarker(usr)
		if(!marker_name_selected)
			return
		vehicle_target.loc = marker_name_selected.loc
		vehicle_target.vehicle_location = MISSIONS_MARKER_AT_MISSION
	else
		var/list/views = list()
		for (var/obj/missionmarker/marker in GLOB.base_markers_list)
			views.Add(marker)
		if(views.len == 0)
			return
		var/obj/missionmarker/selected_spot = tgui_input_list(usr, "Available spots:", "Spot Selection", views)
		if (!selected_spot)
			return
		vehicle_target.loc = selected_spot.loc
		vehicle_target.vehicle_location = MISSIONS_MARKER_AT_BASE

/obj/vehicle/sealed/car/missiondriver/Initialize(mapload)
	. = ..()
	name = "Vroom [rand(1,1000000)]"
	SSmission.all_vehicles.Add(src)

