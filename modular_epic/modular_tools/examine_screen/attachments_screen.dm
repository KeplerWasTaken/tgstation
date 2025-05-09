/atom/movable/screen/attachments
	name = "view attachments"
	icon = 'icons/hud/screen_midnight.dmi'
	icon_state = "navigate"
	screen_loc = ui_attachments_menu
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/attachments/Click()
	if(!isliving(usr))
		return TRUE
	var/mob/living/player = usr
	var/obj/item/active_item = player.get_active_held_item()
	if (!active_item)
		to_chat(usr, span_notice("You must have an attachment-compatible object in your hand"))
		return TRUE
	if(LAZYLEN(active_item.modular_slots_available) == 0 && LAZYLEN(active_item.modular_slot_used) == 0)
		to_chat(usr, span_notice("The object in your hand does not seem to have any slots for attachments."))
		return TRUE
	SEND_SIGNAL(active_item, ATTACHMENTS_OPEN_UI, player)

