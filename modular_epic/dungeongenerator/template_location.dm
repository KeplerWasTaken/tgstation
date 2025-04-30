// A datum to store information about where a template is to be placed

/datum/template_location
    var/datum/map_template/maptoplace
    var/turf/locationToPlace
    var/list/turf/borders = list()
    var/list/turf/wall_borders = list()
    var/list/datum/template_location/connectedRooms = list()
    var/list/pathsoriginatingfromhere = list()
    var/list/obj/effect/dungeongen/dungeoneffects = list()
    var/list/obj/effect/dungeongen/objective_spawn_points = list()
    var/list/obj/effect/dungeongen/helper/dungeon_monster_spawn/monster_spawn_points = list()
    var/datum/dungeon_generator/parent_dungeon_generator = null
    var/placed = FALSE

/datum/template_location/New(var/datum/dungeon_generator/generatingparent)
    parent_dungeon_generator = generatingparent

/datum/template_location/proc/Place()

    var/datum/parsed_map/parsed = load_map(
        file(maptoplace.mappath),
        locationToPlace.x,
        locationToPlace.y,
        locationToPlace.z
    )

    var/turf/bottom_left = locationToPlace
    var/turf/top_right = locate(locationToPlace.x + maptoplace.width - 1, locationToPlace.y + maptoplace.height - 1, locationToPlace.z)

    var/list/loaded_atom_movables = list()
    var/list/loaded_turfs = list()
    var/list/loaded_areas = list()
    var/list/loaded_cables = list()
    var/list/loaded_atmospherics = list()

    for(var/turf/turf as anything in block(bottom_left, top_right))
        loaded_turfs += turf
        loaded_areas |= get_area(turf)

        // atoms can actually be in the contents of two or more turfs based on its icon/bound size
        // see https://www.byond.com/docs/ref/index.html#/atom/var/contents
        for(var/thing in (turf.get_all_contents() - turf))
            if(istype(thing, /obj/structure/cable))
                loaded_cables += thing
            else if (istype(thing, /obj/effect/dungeongen))
                dungeoneffects += thing
                if (istype(thing, /obj/effect/dungeongen/helper/dungeon_main_objective))
                    objective_spawn_points += thing
                if (istype(thing,  /obj/effect/dungeongen/helper/dungeon_monster_spawn))
                    monster_spawn_points += thing
            else if(istype(thing, /obj/machinery/atmospherics))
                loaded_atmospherics += thing
            loaded_atom_movables |= thing

    SSatoms.InitializeAtoms(loaded_areas + loaded_atom_movables + loaded_turfs)
    SSmachines.setup_template_powernets(loaded_cables)
    SSair.setup_template_machinery(loaded_atmospherics)
    placed = TRUE
    return parsed
