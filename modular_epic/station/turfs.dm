/turf/open/floor/planetary
	name = "Ground"
	desc = "The ground beneath you."

	flags_1 = NO_SCREENTIPS_1
	turf_flags = IS_SOLID | NO_RUST

	icon = 'icons/turf/floors.dmi'
	base_icon_state = "floor"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

	underfloor_accessibility = UNDERFLOOR_INTERACTABLE
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN
	canSmoothWith = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR

	thermal_conductivity = 0.04
	heat_capacity = 10000
	tiled_dirt = TRUE
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/planetary

/turf/open/floor/planetary/underground
	name = "Earth"
	base_icon_state = "dirt"
	icon_state = "dirt"
	desc = "Despite being rough and coarse, it does not get everywhere."
	baseturfs = /turf/open/floor/planetary/underground

/turf/open/floor/planetary/surface
	name = "Grass"
	desc = "Touching it makes you feel at peace."
	baseturfs = /turf/open/floor/planetary/surface
	icon_state = "grass"

/turf/closed/mineral/planetary
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	baseturfs = /turf/open/floor/planetary/underground

/turf/closed/mineral/planetary/underground
	baseturfs = /turf/open/floor/planetary/underground

/area/icemoon/underground/unexplored/rivers/meadows
	name = "Caves"
	map_generator = /datum/map_generator/cave_generator/icemoon/meadows

/datum/map_generator/cave_generator/icemoon/meadows
	weighted_open_turf_types = list(/turf/open/floor/planetary/underground = 1)

	weighted_closed_turf_types = list(/turf/closed/mineral/planetary/underground = 1)

/area/icemoon/underground/unexplored/rivers/deep/meadows
	name = "Caves"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | UNIQUE_AREA
	map_generator = /datum/map_generator/cave_generator/icemoon/deep/meadows

/datum/map_generator/cave_generator/icemoon/deep/meadows
	// flora_spawn_chance = 5
	weighted_open_turf_types = list(/turf/open/floor/planetary/underground = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral/planetary/underground = 1)
	weighted_mob_spawn_list = list(
		/mob/living/basic/spider/giant = 9,
		/mob/living/basic/spider/giant/midwife = 1
	)

/area/planet
	default_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_AWAY
	name = "Planet Area"
	icon = 'icons/area/areas_away_missions.dmi'
	sound_environment = SOUND_ENVIRONMENT_PLAIN

/area/planet/mission/dangerous
	name = "Away mission - Dangerous"
	icon_state = "away3"

/area/planet/mission/safe
	name = "Away mission - Safe"
	icon_state = "away2"

/area/planet/mission/surface/mission/rocky
	name = "Away mission - Main Area"
	icon_state = "away"
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED
	map_generator = /datum/map_generator/cave_generator/planetary/mission/rocky

/area/planet/mission/surface/mission/rocky/objective
	name = "Away mission - Objective"

/area/planet/mission/surface/mission/rocky/safe
	name = "Away mission - Mining - Safe"
	icon = 'icons/area/areas_away_missions.dmi'
	icon_state = "away2"
	default_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_AWAY
	sound_environment = SOUND_ENVIRONMENT_PLAIN
	area_flags = FLORA_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/planetary/mission/rocky/safe

/datum/map_generator/cave_generator/planetary/mission/rocky
	name = "Mission Area"
	weighted_open_turf_types = list(/turf/open/floor/planetary/underground = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral = 1)
	weighted_flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 1)
	mob_spawn_chance = 0
	flora_spawn_chance = 10
	feature_spawn_chance = 0
	initial_closed_chance = 35

/datum/map_generator/cave_generator/planetary/mission/rocky/safe
	name = "Safe Area"
	weighted_open_turf_types = list(/turf/open/floor/planetary/surface = 85	, /turf/open/floor/planetary/underground = 15)
	flora_spawn_chance = 30
	weighted_flora_spawn_list = list(/obj/structure/flora/bush/style_random = 1)
	mob_spawn_chance = 0
	feature_spawn_chance = 0
	initial_closed_chance = 0

