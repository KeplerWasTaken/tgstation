/datum/component/mob_elite_status
    var/mob/living/basic/elite_mob
    var/name_prefix = "Debug"
    var/damage_minimum_bonus_multiplier = 1
    var/damage_maximum_bonus_multiplier = 1
    var/health_multiplier = 1
    var/speed_multiplier = 1
    var/attackspeed_multipler = 1
    // var/datum/movespeed_modifier/movespeed_bonus = null
    var/size_multiplier = 1
    var/coloration = null
    var/coloration_priority = FIXED_COLOUR_PRIORITY
    var/examine_text = "This mob has elite status"
    var/examine_span_danger = TRUE

/datum/component/mob_elite_status/Initialize()
    . = ..()
    elite_mob = parent
    RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
    ApplyEffects()

/datum/component/mob_elite_status/proc/on_examine(atom/source, mob/user, list/examine_list)
    if(examine_span_danger)
        examine_list += span_danger(examine_text)
    else
        examine_list += span_notice(examine_text)

/datum/component/mob_elite_status/proc/ApplyEffects()
    elite_mob.name = name_prefix + " " + elite_mob.name
    elite_mob.melee_damage_lower *= damage_minimum_bonus_multiplier
    elite_mob.melee_damage_upper *= damage_maximum_bonus_multiplier
    elite_mob.maxHealth = max(1, elite_mob.maxHealth * health_multiplier)
    elite_mob.health = max(1, elite_mob.health * health_multiplier)
    elite_mob.speed *= speed_multiplier
    elite_mob.melee_attack_cooldown *= attackspeed_multipler
    if (size_multiplier != 1)
        elite_mob.update_transform(size_multiplier)
    // if (movespeed_bonus)
    //     elite_mob.add_movespeed_modifier(movespeed_bonus)
    if (coloration)
        elite_mob.add_atom_colour(coloration, coloration_priority)
