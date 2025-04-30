/datum/dungeon_generator/proc/FindPlaceForMap(var/datum/map_template/dungeons/room_to_generate)
    var/turf/bottomleft = GetBottomLeftTile()
    var/turf/topright = GetTopRightTile()

    var/minx = bottomleft.x
    var/miny = bottomleft.y
    var/maxx = topright.x
    var/maxy = topright.y

    var/failedIterations = 0
    var/maxFailedIterations = 1000

    var/turf/potentialLocation

    while (failedIterations < maxFailedIterations)
        potentialLocation = PickLocation(minx, maxx - room_to_generate.width + 1, miny, maxy - room_to_generate.height + 1)
        if (!Intersects(potentialLocation, room_to_generate))
            // ReserveSpotsForMap(potentialLocation, room_to_generate)
            return potentialLocation
        else
            failedIterations++
    message_admins("Failed iterations have met maximum possible iterations for [room_to_generate.name]")
    return null

/datum/dungeon_generator/proc/ReserveSpotForMap(var/turf/potentialLocation, var/datum/map_template/dungeons/mapToPlace)
    for(var/x = potentialLocation.x to potentialLocation.x + mapToPlace.width - 1)
        for(var/y = potentialLocation.y to potentialLocation.y + mapToPlace.height - 1)
            grid[x][y] |= DUNGEONGEN_FLAG_ROOM
    var/datum/template_location/chosenLocation = new /datum/template_location(src)
    chosenLocation.locationToPlace = potentialLocation
    chosenLocation.maptoplace = mapToPlace
    rooms += chosenLocation
    return chosenLocation

/datum/dungeon_generator/proc/FindPath(var/turf/tileA, var/turf/tileB)
    if (tileB.z != tileA.z)
        CRASH("Path From A to B function must be on same z level")

    var/list/turf/path = list()
    var/diffInX = tileB.x - tileA.x 
    var/diffInY = tileB.y - tileA.y 

    var/list/steps = list()
    for (var/i = 1 to abs(diffInX))
        steps += "X"
    for (var/i = 1 to abs(diffInY))
        steps += "Y"
    steps = shuffle(steps)

    var/turf/currentTile = tileA
    path += currentTile
    for(var/step in steps)
        switch (step)
            if ("X")
                currentTile = locate(currentTile.x + SIGN(diffInX), currentTile.y, z)
            if ("Y")
                currentTile = locate(currentTile.x, currentTile.y + SIGN(diffInY), z)
        if (!IsTileOccupied(currentTile.x, currentTile.y))
            path += currentTile
    return path

// Make sure path is actually succesful
/datum/dungeon_generator/proc/WidenPath(var/list/turf/path)
    var/list/turf/widenedpath = path.Copy()
    for (var/turf/tile in path)
        // Try right
        if (!IsTileOccupied(tile.x + 1, tile.y))
            widenedpath += locate(tile.x + 1, tile.y, tile.z)
            grid[tile.x + 1][tile.y] |= DUNGEONGEN_FLAG_CORRIDOR
        // Try left
        else if (!IsTileOccupied(tile.x - 1, tile.y))
            widenedpath += locate(tile.x - 1, tile.y, tile.z)
            grid[tile.x - 1][tile.y] |= DUNGEONGEN_FLAG_CORRIDOR
        // Try up
        else if (!IsTileOccupied(tile.x, tile.y + 1))
            widenedpath += locate(tile.x, tile.y + 1, tile.z)
            grid[tile.x][tile.y + 1] |= DUNGEONGEN_FLAG_CORRIDOR
        // Try below
        else if (!IsTileOccupied(tile.x, tile.y - 1))
            widenedpath += locate(tile.x, tile.y - 1, tile.z)
            grid[tile.x][tile.y - 1] |= DUNGEONGEN_FLAG_CORRIDOR
    return widenedpath

/datum/dungeon_generator/proc/MakePathAndFinalize(var/datum/template_location/room1, var/datum/template_location/room2, var/widenPath = FALSE)
    var/list/turf/corridor_path = FindPath(pick(room1.GetBorders()), pick(room2.GetBorders()))
    MarkTurfsAsCorridors(corridor_path)
    if (widenPath)
        corridor_path = WidenPath(corridor_path)
    MakePath(corridor_path)
    corridor_turfs += corridor_path
    return corridor_path

/datum/dungeon_generator/proc/MakePath(var/list/turf/path)
    for(var/turf/tile in path)
        if (!(grid[tile.x][tile.y] & DUNGEONGEN_FLAG_ROOM))
            tile = new floor_type(tile)

/datum/dungeon_generator/proc/ConnectAllDungeonRooms()
    var/list/datum/template_location/availableRooms = rooms.Copy()

    var/datum/template_location/arrivalsRooms = FindStartingRoom()
    if (arrivalsRooms)
        availableRooms -= arrivalsRooms

    var/datum/template_location/roomA = pick(availableRooms)
    availableRooms -= roomA

    while (availableRooms.len > 1)
        var/list/datum/tree_sort/options = GetDistanceToOtherRoomsOrderedList(roomA, availableRooms)
        var/datum/template_location/roomB = options[1].NodeKey
        MakePathAndFinalize(roomA, roomB, FALSE)
        roomA.connectedRooms += roomB
        roomB.connectedRooms += roomA
        roomA = roomB
        availableRooms -= roomA

/datum/dungeon_generator/proc/RandomlyConnectTwoRooms(var/widen_path = FALSE)
    var/current_iterations = 1
    var/max_iterations = 1000
    while (current_iterations < max_iterations)
        current_iterations++
        
        var/datum/template_location/startingRoom = pick(rooms)

        var/list/datum/tree_sort/options = GetDistanceToOtherRoomsOrderedList(startingRoom, rooms)

        var/datum/template_location/targetRoom = pick(options).NodeKey

        if (!startingRoom.IsConnectedTo(targetRoom))
            MakePathAndFinalize(startingRoom, targetRoom, widen_path)
            targetRoom.connectedRooms += startingRoom
            startingRoom.connectedRooms += targetRoom
            return TRUE
    message_admins("Generating extra path failed, too many iterations")
