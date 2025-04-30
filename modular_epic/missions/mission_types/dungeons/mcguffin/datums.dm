/datum/mission/dungeon/mcguffin/CreateObjectives()
    var/list/datum/template_location/myrooms = generator.GetThreeFarthestRoomsFromSpawn()
    var/datum/template_location/myroom = pick(myrooms)
    var/turf/placetospawn = pick(myroom.objective_spawn_points).loc
    var/spawned = FALSE
    var/obj/myitem
    for(var/obj/thing in placetospawn.contents)
        if(istype(thing, /obj/structure/closet))
            myitem = new /obj/item/food/burger(thing)
            spawned = TRUE
            break
    if (!spawned)
        myitem = new /obj/item/food/burger(placetospawn)
    myitem.AddComponent(/datum/component/mission_objective/mcguffin, src)
    objectives += myitem	
    message_admins("Mcguffing objective spawned at: [ADMIN_COORDJMP(myitem.loc)]")

/datum/mission/dungeon/mcguffin/New(name, difficulty, maptemplate, missiontype, description)
    . = ..("SCV-[rand(0,1000)]", 0, null, "Scavenge", "This remote installation is emitting signals of a decrepit but salvageable power source. Explore and retrieve it.")

/datum/mission/dungeon/mcguffin
