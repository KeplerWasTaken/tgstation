/obj/effect/mob_trap
    var/mob_to_spawn
    var/list/mob_to_spawn_flags = list()
    density = 0
    anchored = 1
    icon = 'modular_sojourn/icons/mob/64x64.dmi'

/obj/effect/mob_trap/trap_spider
    mob_to_spawn = /mob/living/basic/spider
    mob_to_spawn_flags = list(FACTION_SPIDER)
    name = "odd shadow"
    desc = "You see an odd shadow, cast by something above you hiding in a crevice. A quick glance and you see eight red eyes filled with hatred glaring at you from the dark..."
    icon_state = "spider_emperor_shadow"

/obj/effect/mob_trap/attack_hand(mob/living/user, list/modifiers)
    . = ..()
    trap_triggered(TRUE)

/obj/effect/mob_trap/attackby(mob/living/user, list/modifiers)
    . = ..()
    trap_triggered(TRUE)

/obj/effect/mob_trap/Initialize(mapload)
    . = ..()

    var/static/list/loc_connections = list(
        COMSIG_ATOM_ENTERED = PROC_REF(on_enter)
    )
    AddElement(/datum/element/connect_loc, loc_connections)
    
    pixel_x = -16
    pixel_y = -12

    
/obj/effect/mob_trap/proc/has_non_faction_aligned_entity_on_top()
    for(var/mob/living/mob_on_top_of_trap in loc.contents)
        if (!faction_check(mob_on_top_of_trap.faction, mob_to_spawn_flags, FALSE))
            return TRUE
    return FALSE

/obj/effect/mob_trap/proc/on_enter(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
    trap_triggered()

/obj/effect/mob_trap/proc/trap_triggered(var/force_trigger = FALSE)

    if (!force_trigger)
        if(!has_non_faction_aligned_entity_on_top())
            return FALSE
        
    for(var/mob/living/mob_on_top_of_trap in loc.contents)
        if (!faction_check(mob_on_top_of_trap.faction, mob_to_spawn_flags, FALSE))
            mob_on_top_of_trap.Paralyze(10)
    
    var/mob/living/spawned_mob = new mob_to_spawn(loc)    
    visible_message(span_warning("[src] reveals its self to have a [spawned_mob] hidden underneath!"),
        span_hear("You hear a snap!"))
    playsound(src, 'sound/effects/snap.ogg', 50, TRUE)

    qdel(src)
