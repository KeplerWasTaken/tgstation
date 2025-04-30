GLOBAL_LIST_INIT(base_markers_list, typecacheof(list(/obj/missionmarker)))

/obj/missionmarker
    name = "Missions marker"
    desc = "You shouldn't be seeing that. Bleehhhhhhhhh :3"
    // The map this marker is in
    var/datum/mission/map
    // Am I in the base?
    var/isBaseMarker
    var/id
    var/available = TRUE

/obj/missionmarker/mission
    isBaseMarker =  MISSIONS_MARKER_AT_MISSION

/obj/missionmarker/base
    isBaseMarker =  MISSIONS_MARKER_AT_BASE

/obj/missionmarker/Initialize(mapload)
    . = ..()
    if (isBaseMarker == MISSIONS_MARKER_AT_BASE)
        var/obj/vehicle/sealed/car/missiondriver/mycar = new /obj/vehicle/sealed/car/missiondriver(src.loc)
        mycar.vehicle_location = MISSIONS_MARKER_AT_BASE
        GLOB.base_markers_list.Add(src)

