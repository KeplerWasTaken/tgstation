/datum/dungeon_generator
    var/datum/mission/parentmission
    var/obj/effect/dungeongenerator/generator
    var/width
    var/height
    var/grid
    var/list/datum/template_location/rooms = list()
    var/bordersize = 1
    var/z
    var/list/corridor_turfs = list()
    var/list/external_wall_turfs = list()

    var/corridor_grille_chance = 5
    var/corridor_oil_splatter_chance = 3
    var/corridor_blood_splatter_chance = 3
    var/corridor_rust_chance = 40
    var/corridor_broken_chance = 6
    var/corridor_burnt_chance = 2
    var/corridor_spiderweb_chance = 2
    var/corridor_spiderwebcorner_chance = 75
    var/corridor_barricade_chance = 2
    var/corridor_dirt_chance = 96

    var/wall_rust_chance = 60

    var/wall_type = /turf/closed/wall
    var/floor_type = /turf/open/floor/iron

/turf/proc/TryToRust()
    if(turf_flags & NO_RUST)
        return
    if(HAS_TRAIT(src, TRAIT_RUSTY))
        return

    AddElement(/datum/element/rust)

/datum/dungeon_generator/New(var/widthVal, var/heightVal, var/zPos, var/bordersizeVal = 1, var/parentmissiontoset = null)
    width = widthVal
    height = heightVal
    bordersize = bordersizeVal
    z = zPos
    wall_type = /turf/closed/wall
    floor_type = /turf/open/floor/iron
    parentmission = parentmissiontoset

/datum/dungeon_controller
