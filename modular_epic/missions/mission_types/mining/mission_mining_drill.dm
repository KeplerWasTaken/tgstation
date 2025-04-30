/obj/item/mechdriller
	name = "Drill"
	desc = "Put this on the ore!"
	tool_behaviour = TOOL_OREDRILLER
	var/drill_timer = 1.5 SECONDS
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver_map"

/obj/item/mechdriller/play_tool_sound(target, volume)
	return
