#define ATTACHMENTS_OPEN_UI "attachments_open_ui"

/datum/component/attachments_description

/datum/component/attachments_description/Initialize()
	..()
	var/obj/item/target = parent
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(warning_label))
	RegisterSignal(target, COMSIG_TOPIC, PROC_REF(topic_handler))
	RegisterSignal(target, ATTACHMENTS_OPEN_UI, PROC_REF(open_ui))

/datum/component/attachments_description/proc/warning_label(obj/item/item, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	if (LAZYLEN(item.modular_slots_available) > 0 ||LAZYLEN(item.modular_slot_used) > 0)
		examine_texts += span_notice("<a href='byond://?src=[REF(item)];examine_attachments=1'>See/remove attachments.</a>")

// /datum/component/attachments_description/ui_state(mob/user)
// 	return GLOB.on_or_near

// Risky shit, like, jeez. Buuuuuuuuut, this sounds logical? We're running on dreams here, yo.
/datum/component/attachments_description/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/related_item = parent
	data["name"] = related_item.name
	data["description"] = related_item.desc
	data["durability"] = 500
	data["maxdurability"] = 600
	data["icon"] = related_item.icon
	data["icon_state"] = related_item.icon_state
	data["uid"] = related_item.uid

	data["attachments"] = list()
	data["cells"] = list()

	for(var/obj/item/modular_thing in related_item.modular_attachments)
		if(istype(modular_thing, /obj/item/stock_parts/power_store))
			var/obj/item/stock_parts/power_store/my_cell = modular_thing
			data["cells"] += list(list("name" = modular_thing.name, "desc" = modular_thing.desc, "icon" = modular_thing.icon, "icon_state" = modular_thing.icon, "charge" = my_cell.charge, "maxcharge" = my_cell.maxcharge, "uid" = my_cell.uid))
		else
			data["attachments"] += list(list("name" = modular_thing.name, "desc" = modular_thing.desc, "icon" = modular_thing.icon, "icon_state" = modular_thing.icon, "uid" = modular_thing.uid))
	return data

/datum/component/attachments_description/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("ATC_REMOVE")
			var/attachment_id = params["attachment_id"]
			var/obj/item/target = parent
			var/obj/item/attachment = target.GetAttachmentByUID(attachment_id)
			SEND_SIGNAL(attachment, COMSIG_UPGRADE_REMOVE, usr, target)

	return .


/datum/component/attachments_description/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AttachmentsScreen")
		ui.open()

/datum/component/attachments_description/proc/topic_handler(atom/source, user, href_list)
	SIGNAL_HANDLER
	if(href_list["examine_attachments"])
		open_ui(source, user)

/datum/component/attachments_description/proc/open_ui(atom/source, mob/user)
	ui_interact(user)
