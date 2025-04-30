/datum/map_template/dungeons/outlays/bunker
    name = "Bunker outlay"
    customPath = "modular_epic/_missionmaps/abandoned_bunker/65x65base.dmm"
    width = 65
    height = 65

/datum/map_template/dungeons/generatable/bunker
    name = "Abandoned bunker room"

/datum/map_template/dungeons/generatable/bunker/type_small/smallone
    customPath = "modular_epic/_missionmaps/abandoned_bunker/8x8_small_room_1.dmm"
    height = 8
    width = 8

/datum/map_template/dungeons/generatable/bunker/type_small/smalltwo
    customPath = "modular_epic/_missionmaps/abandoned_bunker/8x8_small_room_2.dmm"
    height = 8
    width = 8
    
/datum/map_template/dungeons/generatable/bunker/type_small/smallthree
    customPath = "modular_epic/_missionmaps/abandoned_bunker/8x8_small_room_3.dmm"
    height = 8
    width = 8
    
/datum/map_template/dungeons/generatable/bunker/type_small/mediumone
    customPath = "modular_epic/_missionmaps/abandoned_bunker/12x12_medium_room_1.dmm"
    height = 12
    width = 12
    
/datum/map_template/dungeons/generatable/bunker/type_small/mediumtwo
    customPath = "modular_epic/_missionmaps/abandoned_bunker/12x12_medium_room_2.dmm"
    height = 12
    width = 12
    
/datum/map_template/dungeons/unique/bunker/arrivals
    name = DUNGEONGEN_ROOM_STARTING
    customPath = "modular_epic/_missionmaps/abandoned_bunker/8x8_arrivals.dmm"
    height = 8
    width = 8
    returns_created_atoms = TRUE

/datum/map_template/dungeons/unique/bunker/core/large
    customPath = "modular_epic/_missionmaps/abandoned_bunker/20x20_main_room_1.dmm"
    height = 20
    width = 20
