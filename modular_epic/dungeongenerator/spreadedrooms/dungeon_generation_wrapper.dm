/datum/dungeon_generator/proc/GenerateDungeon(var/list/datum/map_template/rooms_to_place, var/datum/map_template/arrivals_rooms, var/extra_paths, var/wide_extra_paths)

    // 0. Reset the grid
    ResetGrid()

    // 1. Find spots for all basic rooms
    // This fills up the rooms array, but does not place them
    ReserveSpotsForRooms(rooms_to_place)

    // 2. Place them
    // This goes through the rooms array, and physically places them
    PlaceAllMaps()

    // 3. Make connections for them
    ConnectAllRooms()
    CreateExtraPaths(extra_paths, wide_extra_paths)

    // 4. Place and Connect Start Room()
    PlaceAndConnectStartRoom(arrivals_rooms)

    // 5. Extras
    ExtraSteps()

    // 6. Finalize
    Finalize()

/datum/dungeon_generator/proc/ReserveSpotsForRooms(var/list/datum/map_template/rooms_to_place)
    for(var/datum/map_template/room in rooms_to_place)
        var/turf/applicable_location = FindPlaceForMap(room)
        if (applicable_location)
            ReserveSpotForMap(applicable_location, room)

/datum/dungeon_generator/proc/PlaceAllMaps()
    for(var/datum/template_location/room in rooms)
        if (!room.placed)
            room.Place()

/datum/dungeon_generator/proc/ConnectAllRooms()
    ConnectAllDungeonRooms()

/datum/dungeon_generator/proc/CreateExtraPaths(var/extra_path_count, var/wide_extra_path_count)
    for(var/i = 1 to extra_path_count)
        RandomlyConnectTwoRooms(FALSE)

    for(var/i = 1 to wide_extra_path_count)
        RandomlyConnectTwoRooms(TRUE)

/datum/dungeon_generator/proc/PlaceAndConnectStartRoom(var/datum/map_template/arrivals_rooms)
    var/turf/applicable_location = FindPlaceForMap(arrivals_rooms)
    if (applicable_location)
        var/datum/template_location/chosenLocation = ReserveSpotForMap(applicable_location, arrivals_rooms)
        chosenLocation.Place()
        var/list/datum/tree_sort/sortedTree = GetDistanceToOtherRoomsOrderedList(chosenLocation, rooms)
        MakePathAndFinalize(chosenLocation, sortedTree[1].NodeKey, FALSE)

/datum/dungeon_generator/proc/ExtraSteps()
    CreateExternalWallsForAllRooms()
    CreateExternalWallsForCorridors()
    MuckUpCorridors()
    MuckUpExternalWalls()
    MuckUpRooms()

/datum/dungeon_generator/proc/Finalize()
    SmoothMapTurfs()
    var/datum/template_location/arrivalsRooms = FindStartingRoom()
    message_admins("Dungeon finished generating. Arrivals room: [ADMIN_COORDJMP(arrivalsRooms.locationToPlace)]")
