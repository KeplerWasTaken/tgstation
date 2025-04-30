#define INIT_ORDER_MISSIONS -70

SUBSYSTEM_DEF(mission)
	name = "Missions"
	flags = SS_BACKGROUND
	init_order = INIT_ORDER_MISSIONS

	var/list/datum/mission/all_missions = list()
	var/list/datum/mission/queue_to_generate = list()
	var/_busy = FALSE
	var/list/obj/vehicle/sealed/car/missiondriver/all_vehicles = list()

/datum/controller/subsystem/mission/Initialize()
	// On round start, create 2 dungeons and 3 mining missions
	// Difficulties 0, 1, 0, 1, 2
	
	// Make mining missions
	queue_enqueue(new /datum/mission/mining("MM-[rand(0,1000)]", 0, /datum/lazy_template/mission, "Mining", "This area analysis concluded that there are a number of concenrated ore veins, an ideal opportunity for drilling. Beware the local fauna that drilling invites."))

	queue_enqueue(new /datum/mission/mining("MM-[rand(0,1000)]", 1, /datum/lazy_template/mission, "Mining", "This area analysis concluded that there are a number of concenrated ore veins, an ideal opportunity for drilling. Beware the local fauna that drilling invites."))

	queue_enqueue(new /datum/mission/mining("MM-[rand(0,1000)]", 2, /datum/lazy_template/mission, "Mining", "This area analysis concluded that there are a number of concenrated ore veins, an ideal opportunity for drilling. Beware the local fauna that drilling invites."))

	queue_enqueue(new /datum/mission/mining("MM-[rand(0,1000)]", 3, /datum/lazy_template/mission, "Mining", "This area analysis concluded that there are a number of concenrated ore veins, an ideal opportunity for drilling. Beware the local fauna that drilling invites."))

	var/datum/mission/dungeon/dungeonone = new /datum/mission/dungeon/mcguffin("SCV-[rand(0,1000)]", 0, null, "Scavenge", "This remote installation is emitting signals of a decrepit but salvageable power source. Explore and retrieve it.")
	dungeonone.mapstouse = new /datum/dungeon_maptemplateslist/abandoned_bunker
	queue_enqueue(dungeonone)

	var/datum/mission/dungeon/dungeontwo = new /datum/mission/dungeon/mcguffin("SCV-[rand(0,1000)]", 1, null, "Scavenge", "This remote installation is emitting signals of a decrepit but salvageable power source. Explore and retrieve it.")
	dungeontwo.mapstouse = new /datum/dungeon_maptemplateslist/abandoned_bunker
	queue_enqueue(dungeontwo)

	for(var/i = 1 to 5)
		queue_enqueue(new /datum/mission/mining("MM-[rand(0,1000)]", 0, /datum/lazy_template/mission, "Mining", "This area analysis concluded that there are a number of concenrated ore veins, an ideal opportunity for drilling. Beware the local fauna that drilling invites."))

	for(var/i = 1 to 5)
		var/datum/mission/dungeon/dungeonthree = new /datum/mission/dungeon/mcguffin("SCV-[rand(0,1000)]", 1, null, "Scavenge", "This remote installation is emitting signals of a decrepit but salvageable power source. Explore and retrieve it.")
		dungeonthree.mapstouse = new /datum/dungeon_maptemplateslist/abandoned_bunker
		queue_enqueue(dungeonthree)


	return SS_INIT_SUCCESS

// /datum/controller/subsystem/mission/proc/

/*
// Create mission
/proc/generateMission()
	var/datum/mission/newmission = new /datum/mission/debug
	GLOB.missions_list.Add(newmission)

/proc/loadRandomlyGeneratedDungeon()
	var/datum/mission/dungeon/newmission = new /datum/mission/dungeon/mcguffin
	newmission.mapstouse = new /datum/dungeon_maptemplateslist/abandoned_bunker
	newmission.GenerateDungeon()
	GLOB.missions_list.Add(newmission)
	return TRUE
*/
/datum/controller/subsystem/mission/fire(resumed)
	if (!_busy && length(queue_to_generate))
		_busy = TRUE
		var/datum/mission/mission_to_generate = queue_dequeue()
		message_admins(mission_to_generate.name + " is now being generated.")
		INVOKE_ASYNC(mission_to_generate, TYPE_PROC_REF(/datum/mission/, GenerateMap))

/datum/controller/subsystem/mission/proc/queue_dequeue()
	var/datum/mission/mission_to_generate = queue_to_generate[1]
	queue_to_generate -= mission_to_generate
	return mission_to_generate

/datum/controller/subsystem/mission/proc/queue_enqueue(var/datum/mission/mission_to_generate)
	queue_to_generate += mission_to_generate

/datum/controller/subsystem/mission/proc/on_mission_generation_complete(var/datum/mission/mission_generated)
	message_admins(mission_generated.name + " is ready.")
	all_missions += mission_generated
	_busy = FALSE
