/obj/item/requisitions_remote
	name = "Requisitions remote"
	desc = "If during a mission you run into a supplies emergency, don't worry! For an amount of credits, those worries will wash away."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "generic_delivery"
	inhand_icon_state = "generic_delivery"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	var/obj/machinery/computer/order_console/requisitions_remote/builtin_order_console

/obj/item/requisitions_remote/Initialize(mapload)
	. = ..()
	builtin_order_console = new /obj/machinery/computer/order_console/requisitions_remote(src)

/obj/item/requisitions_remote/Destroy()
	QDEL_NULL(builtin_order_console)
	return ..()

/obj/item/requisitions_remote/interact(mob/user)
	. = ..()
	if(!can_use_beacon(user))
		return
	builtin_order_console.ui_interact(user)
    
/obj/item/requisitions_remote/proc/can_use_beacon(mob/living/user)
	if(user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return TRUE

	playsound(src, 'sound/machines/buzz-sigh.ogg', 40, TRUE)
	return FALSE

#define CATEGORY_REMOTE_REQUISITIONS "Remote Requisitions"

/obj/machinery/computer/order_console/requisitions_remote/ui_act(action, params)
	switch(action)
		if("express")
			if(!istype(get_area(src), /area/planet/mission))
				say("Orders can only be delievered to designated area missions.")
				return
	. = ..()
	
/obj/machinery/computer/order_console/requisitions_remote
	cooldown_time = 120 SECONDS
	forced_express = TRUE
	express_cost_multiplier = 1
	order_categories = list(CATEGORY_REMOTE_REQUISITIONS)
	use_power = NO_POWER_USE

/datum/orderable_item/remote_requisitions
	category_index = CATEGORY_REMOTE_REQUISITIONS

/datum/orderable_item/remote_requisitions/toolbox
	name = "Tool Box"
	item_path = /obj/item/storage/toolbox/mechanical
	cost_per_order = 30

/datum/orderable_item/remote_requisitions/powercell
	name = "Power Cell"
	item_path = /obj/item/stock_parts/cell
	cost_per_order = 5

/datum/orderable_item/remote_requisitions/driller
	name = "Vein Driller"
	item_path = /obj/item/mechdriller
	cost_per_order = 120

/datum/orderable_item/remote_requisitions/pickaxe
	name = "Pickaxe"
	item_path = /obj/item/pickaxe
	cost_per_order = 20
