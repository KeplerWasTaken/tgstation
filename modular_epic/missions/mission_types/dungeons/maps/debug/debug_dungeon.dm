/datum/dungeons/proc/GetRooms()
    
/datum/dungeons/testdungeon/GetRooms()
    var/list/datum/map_template/dungeons/templates_to_generate = list()

    var/minRooms = 3
    var/maxRooms = 6
    var/numRooms = rand(minRooms, maxRooms)
    
    for(var/i = 1 to numRooms)
        var/list/allsubtypes = subtypesof(/datum/map_template/dungeons/generatable/testmap/type_big)
        var/chosenRandom = pick(allsubtypes)
        templates_to_generate.Add(new chosenRandom)
    
    templates_to_generate.Add(new/datum/map_template/dungeons/unique/testmap/arrivals)

    minRooms = 5
    maxRooms = 10
    numRooms = rand(minRooms, maxRooms)
    for(var/i = 1 to numRooms)
        var/list/allsubtypes = subtypesof(/datum/map_template/dungeons/generatable/testmap/type_small)
        var/chosenRandom = pick(allsubtypes)
        templates_to_generate.Add(new chosenRandom)

    return templates_to_generate
