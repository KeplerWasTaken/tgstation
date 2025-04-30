// Example creation
/datum/mission/dungeon/New(name, difficulty, maptemplate, missiontype, description)
    . = ..("DNG-[rand(0,1000)]", 0, null, "Dungeon", "There's a dungeon wowee :3!!!")

/datum/mission/dungeon
    var/datum/map_template/dungeonbase
    var/datum/space_level/generatedLevel
    var/datum/dungeon_generator/generator
    var/minSmallRooms = 3
    var/maxSmallRooms = 6
    var/minExtraPaths = 3
    var/maxExtraPaths = 4
    var/minExtraWidePaths = 1
    var/maxExtraWidePaths = 2
    var/IsDungeonGenerated = FALSE
    var/list/obj/effect/dungeongen/helper/dungeon_monster_spawn/list_of_all_spawnpoints = list()
    var/datum/dungeon_maptemplateslist/mapstouse

// Call manually after initializing dungeon config
/datum/mission/dungeon/proc/GenerateDungeon()
    dungeonbase = new /datum/map_template/dungeons/outlays/bunker
    generatedLevel = dungeonbase.load_new_z_bottomleft()
    var/list/datum/map_template/mapstogenerate = CreateListOfRoomsToGenerate()
    var/datum/map_template/mandatoryroom = mapstouse.arrivals_room
    var/extraPaths = rand(minExtraPaths, maxExtraPaths)
    var/extraWidePaths = rand(minExtraWidePaths, maxExtraWidePaths)
    generator = new /datum/dungeon_generator(dungeonbase.width, dungeonbase.height, generatedLevel.z_value, 2, src)
    generator.GenerateDungeon(mapstogenerate, mandatoryroom, extraPaths, extraWidePaths)
    FindMarkersInZLevel()
    CreateObjectives()
    CreateEnemies()
    IsDungeonGenerated = TRUE
    EndOfMissonLoadingCycle()

// Find all markers in the starting room specifically
// Markers include: Markers for vehicle location
/datum/mission/dungeon/proc/FindMarkersInZLevel()
    var/datum/template_location/startingRoom = generator.FindStartingRoom()
    var/turf/bottomleft = startingRoom.locationToPlace
    var/turf/topright = locate(startingRoom.locationToPlace.x + startingRoom.maptoplace.width - 1, startingRoom.locationToPlace.y + startingRoom.maptoplace.height - 1, startingRoom.locationToPlace.z)
    for (var/turf/T in block(bottomleft, topright))
        for (var/obj/O in T)
            if (istype(O, /obj/missionmarker))
                markers += O
                
// Hard coded to be bunker, always. Find a way to fix
/datum/mission/dungeon/proc/CreateListOfRoomsToGenerate()
    var/list/datum/map_template/mapstogenerate = list()

    //mandatory rooms
    mapstogenerate += mapstouse.mandatory 

    var/numSmallRooms = rand(minSmallRooms, maxSmallRooms)
    var/list/optional_rooms = mapstouse.optional
    for(var/i = 1 to numSmallRooms)
        var/chosenRandom = pick(optional_rooms)
        mapstogenerate.Add(new chosenRandom)

    return mapstogenerate

/datum/mission/dungeon/proc/CreateEnemies()
    var/list/my_subtypes = subtypesof(/mob/living/basic/spider)
    switch(difficulty)
        if (0)
            // 4 mobs
            for(var/i in 1 to 4)
                var/mob_type = pick(my_subtypes)
                var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_loc = FindMobSpawningSpot()
                var/mob/living/my_new_mob = new mob_type(spawn_loc.loc)
                var/list/applicable_elite_status = list(/datum/component/mob_elite_status/old, /datum/component/mob_elite_status/frail, /datum/component/mob_elite_status/unhealthy)
                if (prob(70))
                    var/elite_status = pick(applicable_elite_status)
                    my_new_mob.AddComponent(elite_status)

        if (1)
            // 8 mobs
            for(var/i in 1 to 4)
                var/mob_type = pick(my_subtypes)
                var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_loc = FindMobSpawningSpot()
                var/mob/living/my_new_mob = new mob_type(spawn_loc.loc)
                my_new_mob.missions_mission = src
                var/list/applicable_elite_status = list(/datum/component/mob_elite_status/old, /datum/component/mob_elite_status/frail, /datum/component/mob_elite_status/unhealthy)
                if (prob(70))
                    var/elite_status = pick(applicable_elite_status)
                    my_new_mob.AddComponent(elite_status)
        if (2)
            // 10 mobs
            for(var/i in 1 to 4)
                var/mob_type = pick(my_subtypes)
                var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_loc = FindMobSpawningSpot()
                var/mob/living/my_new_mob = new mob_type(spawn_loc.loc)
                my_new_mob.missions_mission = src
                var/list/applicable_elite_status = list(/datum/component/mob_elite_status/old, /datum/component/mob_elite_status/frail, /datum/component/mob_elite_status/unhealthy)
                if (prob(70))
                    var/elite_status = pick(applicable_elite_status)
                    my_new_mob.AddComponent(elite_status)
        if (3)
            // 13 mobs
            for(var/i in 1 to 4)
                var/mob_type = pick(my_subtypes)
                var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_loc = FindMobSpawningSpot()
                var/mob/living/my_new_mob = new mob_type(spawn_loc.loc)
                my_new_mob.missions_mission = src
                var/list/applicable_elite_status = list(/datum/component/mob_elite_status/old, /datum/component/mob_elite_status/frail, /datum/component/mob_elite_status/unhealthy)
                if (prob(70))
                    var/elite_status = pick(applicable_elite_status)
                    my_new_mob.AddComponent(elite_status)
        if (4)
            // 16 mobs
            for(var/i in 1 to 4)
                var/mob_type = pick(my_subtypes)
                var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_loc = FindMobSpawningSpot()
                var/mob/living/my_new_mob = new mob_type(spawn_loc.loc)
                my_new_mob.missions_mission = src
                var/list/applicable_elite_status = list(/datum/component/mob_elite_status/old, /datum/component/mob_elite_status/frail, /datum/component/mob_elite_status/unhealthy)
                if (prob(70))
                    var/elite_status = pick(applicable_elite_status)
                    my_new_mob.AddComponent(elite_status)
            

/datum/mission/dungeon/proc/FindMobSpawningSpot()
    if (!list_of_all_spawnpoints || list_of_all_spawnpoints.len <= 1)
        PopulateSpawnPointsList()
    
    return pick(list_of_all_spawnpoints)

/datum/mission/dungeon/proc/PopulateSpawnPointsList()
    for(var/datum/template_location/room in generator.rooms)
        for(var/obj/effect/dungeongen/helper/dungeon_monster_spawn/spawn_point in room.monster_spawn_points)
            list_of_all_spawnpoints += spawn_point

/datum/mission/dungeon/proc/CreateObjectives()
    // Needs override

/datum/mission/dungeon/GenerateTerrain(var/loaded_areas)
    // empty

/datum/mission/dungeon/PopulateTerrain(var/loaded_areas)
    // empty

/datum/mission/dungeon/GenerateMap()
    // empty
    GenerateDungeon()
    
