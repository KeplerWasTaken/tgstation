/datum/mission

    // Mission information variables
	var/datum/lazy_template/map
	var/name = "Mission Name"
	var/maxPlayers = 4
	var/difficulty = MISSION_DIFFICULTY_MINIMUM

	var/list/reward
	var/missionType
    
	var/missionDescription

    // System related variables
    
	var/completed = FALSE
	var/started = FALSE
	var/left = FALSE
	var/list/objectives = list()

	var/list/playerCkeys = list()
	var/list/invitedCkeys = list()
	var/hostCkey = null

        // Entity tracking
	var/list/associatedEntries = list()
	var/obj/vehicle/sealed/car/missiondriver/missionvehicle
	var/markerId = 0
	var/list/obj/missionmarker/markers = list()

/datum/mission/New(name, difficulty, maptemplate, missiontype, description)
	src.name = name
	src.difficulty = difficulty
	if (maptemplate)
		src.map = new maptemplate
	src.missionType = missiontype
	src.missionDescription = description

/datum/mission/proc/GenerateMap()
	RegisterSignal(map, COMSIG_LAZY_TEMPLATE_LOADED, PROC_REF(on_mission_loaded))
	map.lazy_load()
	
// Initializing mission related variables

/atom
	var/datum/mission/missions_mission = null
