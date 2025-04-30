/datum/dungeon_generator/proc/GetDistanceToOtherRoomsOrderedList(var/datum/template_location/firstRoom, var/list/datum/template_location/allRooms)
    var/datum/tree_sort/sortingTree = new /datum/tree_sort
    for(var/datum/template_location/room in allRooms)
        if (room == firstRoom)
            continue
        var/value = abs(firstRoom.locationToPlace.x - room.locationToPlace.x) + abs(firstRoom.locationToPlace.y - room.locationToPlace.y)
        sortingTree.Insert(value, room)
        
    return sortingTree.GetOrderedList()
    
/datum/dungeon_generator/proc/GetThreeFarthestRoomsFromSpawn()
    var/datum/template_location/firstRoom = FindStartingRoom()
    var/list/datum/tree_sort/result = GetDistanceToOtherRoomsOrderedList(firstRoom, rooms)

    if (result.len == 0)
        return list()

    var/startAt = min(1, result.len - 2)
    var/endAt = max(1, result.len)

    var/list/datum/template_location/toreturn = list()
    for(var/i in startAt to endAt)
        toreturn += result[i].NodeKey
    return toreturn
