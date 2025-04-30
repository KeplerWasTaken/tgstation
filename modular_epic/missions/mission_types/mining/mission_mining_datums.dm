/datum/mission/mining/New(name, difficulty, maptemplate, missiontype, description)
	if (!name || !maptemplate || !missiontype || !description)
		CRASH("Cooked, real cooked. One of the mission parameters was null.")
	. = ..(name, difficulty, maptemplate, missiontype, description)
    
/datum/mission/mining/on_mission_loaded(datum/lazy_template/source, loaded_atom_movables, loaded_turfs, loaded_areas)
	. = ..()
	for(var/area/planet/mission/surface/mission/rocky/objective/missionArea in loaded_areas)
		var/list/turfs = list()
		for(var/turf/open/floor/planetary/underground/myArea in missionArea.contents)
			turfs += myArea
		var/turf/open/floor/planetary/underground/chosenArea = turfs[rand(1, turfs.len)]
		var/obj/machinery/drillableOre/newOre = new /obj/machinery/drillableOre
		newOre.x = chosenArea.x
		newOre.y = chosenArea.y
		newOre.z = chosenArea.z
		newOre.AddComponent(/datum/component/mission_objective, src)
		objectives += newOre
		message_admins("Mining objective spawned at: [ADMIN_COORDJMP(newOre.loc)]")
