/datum/dungeon_generator/proc/MuckUpCorridors()
    for(var/turf/open/path in corridor_turfs)
        TileDecalGenerator(path)

/datum/dungeon_generator/proc/TileDecalGenerator(var/turf/tile)
    if(tile.contents.len == 0)
        if(prob(corridor_grille_chance))
            if(prob(10))
                new /obj/structure/grille(tile)
            else 
                new /obj/structure/grille/broken(tile)
        else if (prob(corridor_spiderweb_chance))
            new /obj/structure/spider/stickyweb(tile)
        else if (prob(corridor_barricade_chance))
            new /obj/structure/barricade/wooden(tile) 

    if (prob(corridor_rust_chance))
        tile.TryToRust()

    if (prob(corridor_blood_splatter_chance))
        new /obj/effect/decal/cleanable/blood(tile)

    if (prob(corridor_oil_splatter_chance))
        new /obj/effect/decal/cleanable/oil(tile)

    if (prob(corridor_broken_chance))
        tile.break_tile()

    if (prob(corridor_burnt_chance))
        tile.burn_tile()
    
    if (prob(corridor_spiderwebcorner_chance))
        TryToMakeCornerSpiderWeb(tile)

    if (prob(corridor_dirt_chance))
        new /obj/effect/decal/cleanable/dirt(tile)

/datum/dungeon_generator/proc/TryToMakeCornerSpiderWeb(var/turf/open/target)
    if (grid[target.x][target.y + 1] & DUNGEONGEN_FLAG_EXTERNALWALL)
        if(grid[target.x-1][target.y] & DUNGEONGEN_FLAG_EXTERNALWALL)
            new /obj/effect/decal/cleanable/cobweb(target)
        else if (grid[target.x+1][target.y] & DUNGEONGEN_FLAG_EXTERNALWALL)
            new /obj/effect/decal/cleanable/cobweb/cobweb2(target)

/datum/dungeon_generator/proc/MuckUpRooms()
    for(var/datum/template_location/room in rooms)
        var/list/turf/allturfs = room.GetAllTurfs()
        for(var/turf/open/openturf in allturfs)
            TileDecalGenerator(openturf)
        for(var/turf/closed/closedturf in allturfs)
            WallDecalGenerator(closedturf)
        
/datum/dungeon_generator/proc/MuckUpExternalWalls()
    for(var/turf/closed/wall in external_wall_turfs)
        WallDecalGenerator(wall)

/datum/dungeon_generator/proc/WallDecalGenerator(var/turf/closed/target)
    if (prob(wall_rust_chance))
        target.TryToRust()

/datum/dungeon_generator/proc/CreateExternalWallsForAllRooms()
    for(var/datum/template_location/template in rooms)
        CreateExternalWallsForRoom(template)

/datum/dungeon_generator/proc/CreateExternalWallsForRoom(var/datum/template_location/template)
    var/list/turfs_applicable_for_wallening = template.GetWallBorders()
    for(var/turf/tile in turfs_applicable_for_wallening)
        if (TryToCreateWallOnTile(tile))
            external_wall_turfs += tile

/datum/dungeon_generator/proc/TryToCreateWallOnTile(var/turf/target)
    if(IsTileValidForExternalWall(target.x, target.y))
        grid[target.x][target.y] |= DUNGEONGEN_FLAG_EXTERNALWALL
        target = new wall_type(target)
        return TRUE
    return FALSE

/datum/dungeon_generator/proc/CreateExternalWallsForCorridors()
    for(var/turf/target in corridor_turfs)
        var/list/adjacent_turfs = GetAllAdjacentTurfs(target)
        for(var/turf/adjacent_target in adjacent_turfs)
            if (TryToCreateWallOnTile(adjacent_target))
                external_wall_turfs += adjacent_target

/datum/dungeon_generator/proc/GetAllAdjacentTurfs(var/turf/target)
    var/list/turf/thingstoreturn = list()
    for(var/turf/adjacent in range(1,target))
        thingstoreturn += adjacent
    return thingstoreturn
