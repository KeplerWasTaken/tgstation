/datum/dungeon_generator/proc/PickLocation(var/minx, var/maxx, var/miny, var/maxy, var/datum/map_template/dungeons/mapinquestion)
    return locate(rand(minx, maxx), rand(miny, maxy), z)

/datum/dungeon_generator/proc/GetBottomLeftTile(var/countBorder = TRUE)
    var x = 1
    var y = 1
    if (countBorder)
        x += bordersize
        y += bordersize
    return locate(x, y, z)

/datum/dungeon_generator/proc/GetTopRightTile(var/countBorder = TRUE)
    var x = width
    var y = height
    if (countBorder)
        x -= bordersize
        y -= bordersize
    return locate(x, y, z)

/datum/dungeon_generator/proc/IsTileOccupied(x, y)
    if (x <= 0 || x > width || y <= 0 || y > height)
        return TRUE
    if (grid[x][y] & DUNGEONGEN_FLAG_CORRIDOR || grid[x][y] & DUNGEONGEN_FLAG_ROOM)
        return TRUE
    return FALSE

/datum/dungeon_generator/proc/IsTileValidForExternalWall(x, y)
    if (x <= 0 || x > width || y <= 0 || y > height)
        return FALSE
    if (grid[x][y] & (DUNGEONGEN_FLAG_EXTERNALWALL | DUNGEONGEN_FLAG_CORRIDOR | DUNGEONGEN_FLAG_ROOM))
        return FALSE
    return TRUE

/datum/dungeon_generator/proc/FindStartingRoom()
    for (var/datum/template_location/room in rooms)
        if (room.maptoplace.name == DUNGEONGEN_ROOM_STARTING)
            return room
    return null

/datum/dungeon_generator/proc/Intersects(var/turf/potentialLocation, var/datum/map_template/dungeons/mapToPlace)
    for(var/x = potentialLocation.x to potentialLocation.x + mapToPlace.width - 1)
        for(var/y = potentialLocation.y to potentialLocation.y + mapToPlace.height - 1)
            if (grid[x][y] & DUNGEONGEN_FLAG_ROOM)
                return TRUE
    return FALSE

/datum/dungeon_generator/proc/ResetGrid()
    var/newgrid[width][height]
    grid = newgrid
    for (var/loopX = 1, loopX <= width, loopX++)
        for (var/loopY = 1, loopY <= height, loopY++)
            grid[loopX][loopY] = 0

/datum/dungeon_generator/proc/MarkTurfsAsCorridors(var/list/turf/path)
    for(var/turf/tile in path)
        grid[tile.x][tile.y] |= DUNGEONGEN_FLAG_CORRIDOR

/datum/dungeon_generator/proc/SmoothMapTurfs()
    for(var/x = 1 to width)
        for(var/y = 1 to height)
            QUEUE_SMOOTH(locate(x, y, z))

/datum/template_location/proc/GetBorders()
    if (borders.len == 0)
        // Left and Right walls
        for(var/scanY = locationToPlace.y to locationToPlace.y + maptoplace.height - 1)
            borders.Add(locate(locationToPlace.x, scanY, locationToPlace.z))
            borders.Add(locate(locationToPlace.x + maptoplace.width - 1, scanY, locationToPlace.z))
        // Bottom and top walls, excluding the already scanned corners
        for(var/scanX = locationToPlace.x + 1 to locationToPlace.x + maptoplace.width - 2)
            borders.Add(locate(scanX, locationToPlace.y, locationToPlace.z))
            borders.Add(locate(scanX, locationToPlace.y + maptoplace.height - 1, locationToPlace.z))
    return borders

/datum/template_location/proc/GetWallBorders()
    if (wall_borders.len == 0)
        var/minX = locationToPlace.x - 1
        var/maxX = locationToPlace.x + maptoplace.width
        var/minY = locationToPlace.y - 1
        var/maxY = locationToPlace.y + maptoplace.height
        var/z = locationToPlace.z

        // Left and Right walls
        for(var/scanY = minY to maxY)
            wall_borders.Add(locate(minX, scanY, z))
            wall_borders.Add(locate(maxX, scanY, z))
        // Bottom and top walls, excluding the already scanned corners
        for(var/scanX = minX + 1 to maxX - 1)
            wall_borders.Add(locate(scanX, minY, z))
            wall_borders.Add(locate(scanX, maxY, z))
    return wall_borders

/datum/template_location/proc/GetAllTurfs()
    var/list/turf/thingstoreturn = list()
    var/minX = locationToPlace.x
    var/maxX = locationToPlace.x + maptoplace.width - 1
    var/minY = locationToPlace.y
    var/maxY = locationToPlace.y + maptoplace.height - 1
    var/z = locationToPlace.z

    for(var/scanY = minY to maxY)
        for(var/scanX = minX to maxX)
            thingstoreturn.Add(locate(scanX, scanY, z))

    return thingstoreturn

/datum/template_location/proc/IsConnectedTo(var/datum/template_location/target)
    for (var/datum/template_location/room in connectedRooms)
        if (room == target)
            return TRUE
    return FALSE
