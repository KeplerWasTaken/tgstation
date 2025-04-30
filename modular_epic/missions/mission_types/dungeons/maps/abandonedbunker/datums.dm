/datum/dungeon_maptemplateslist
    var/list/datum/map_template/dungeons/mandatory = list()
    var/datum/map_template/dungeons/arrivals_room
    var/list/optional = list()

/datum/dungeon_maptemplateslist/abandoned_bunker/New()
    ..()
    mandatory += new /datum/map_template/dungeons/unique/bunker/core/large
    optional = subtypesof(/datum/map_template/dungeons/generatable/bunker/type_small)
    arrivals_room = new /datum/map_template/dungeons/unique/bunker/arrivals
