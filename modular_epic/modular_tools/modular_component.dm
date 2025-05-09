#define COMSIG_UPGRADE_APPVAL "comsig_upgrade_appval"
#define COMSIG_UPGRADE_ADDVAL "comsig_upgrade_addval"
#define COMSIG_UPGRADE_REMOVE "comsig_upgrade_remove"

/datum/component/modular_attachment
	var/slot_used = null
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = TRUE

	//Actual effects of upgrades
	var/list/tool_upgrades = list() //variable name(string) -> num

	//Weapon upgrades
	var/list/applicable_slots
	var/list/modifications = list() //variable name(string) -> num

/datum/component/modular_attachment/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_OBJ_NOHIT, PROC_REF(AttachmentTryInstall))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/modular_attachment/proc/AttachmentTryInstall(datum/source, obj/item/target, mob/living/user)
	if (AttachmentCanInstall(target))
		AttachmentInstall(target, user)

/datum/component/modular_attachment/proc/AttachmentCanInstall(obj/item/target)
	if (!GetApplicableSlot(target))
		return FALSE
	return TRUE

/datum/component/modular_attachment/proc/TryUninstall(obj/item/source, mob/living/user, obj/item/target)
	if (AttachmentCanUninstall())
		AttachmentUninstall(source, target, user)

/datum/component/modular_attachment/proc/AttachmentUninstall(obj/item/attachment, obj/item/modular_tool, mob/living/user)
	if(user)
		user.visible_message(span_notice("[user] starts removing [parent] from [modular_tool]"), span_notice("You start removoing \the [attachment] from \the [modular_tool]"))
		if(!modular_tool.use_tool(user = user, target = modular_tool, delay = 1 SECONDS))
			return FALSE
		to_chat(user, span_notice("You have successfully uninstalled \the [parent] from  \the [modular_tool]"))
	//If we get here, we succeeded in the uninstalling
	user.put_in_hands(attachment)
	modular_tool.modular_attachments.Remove(attachment)
	UnregisterSignal(modular_tool, COMSIG_UPGRADE_APPVAL, PROC_REF(apply_values))
	UnregisterSignal(modular_tool, COMSIG_UPGRADE_ADDVAL, PROC_REF(add_values))
	UnregisterSignal(parent, COMSIG_UPGRADE_REMOVE, PROC_REF(TryUninstall))
	if (slot_used == ATTACHMENT_CELL_SMALL || slot_used == ATTACHMENT_CELL_MEDIUM || slot_used == ATTACHMENT_CELL_LARGE)
		modular_tool.cells -= parent
	attachment.modular_slot_used = null
	modular_tool.modular_slots_available[slot_used]++
	slot_used = null
	modular_tool.RefreshUpgrades()
	return TRUE

/datum/component/modular_attachment/proc/AttachmentCanUninstall()
	return TRUE

/datum/component/modular_attachment/proc/GetApplicableSlot(obj/item/target)
	for(var/applicable_slot in applicable_slots)
		if (target.modular_slots_available[applicable_slot] && target.modular_slots_available[applicable_slot] > 0)
			return applicable_slot
	return null

/datum/component/modular_attachment/proc/AttachmentInstall(obj/item/target, mob/user)
	if(user)
		user.visible_message(span_notice("[user] starts applying [parent] to [target]"), span_notice("You start applying \the [parent] to \the [target]"))
		var/obj/item/I = parent
		if(!I.use_tool(user = user, target =  target, delay = 1 SECONDS))
			return FALSE
		to_chat(user, span_notice("You have successfully installed \the [parent] in \the [target]"))
		user.dropItemToGround(parent)
	//If we get here, we succeeded in the applying
	var/obj/item/modular_attachment/attachment = parent
	attachment.forceMove(target)
	target.modular_attachments.Add(attachment)
	RegisterSignal(target, COMSIG_UPGRADE_APPVAL, PROC_REF(apply_values))
	RegisterSignal(target, COMSIG_UPGRADE_ADDVAL, PROC_REF(add_values))
	RegisterSignal(parent, COMSIG_UPGRADE_REMOVE, PROC_REF(TryUninstall))
	slot_used = GetApplicableSlot(target)
	if (slot_used == ATTACHMENT_CELL_SMALL || slot_used == ATTACHMENT_CELL_MEDIUM || slot_used == ATTACHMENT_CELL_LARGE)
		target.cells += parent
	attachment.modular_slot_used = slot_used
	target.modular_slots_available[slot_used]--
	target.RefreshUpgrades()
	return TRUE

/datum/component/modular_attachment/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if (modifications[MODIFICATION_TOOLSPEED])
		examine_list += span_notice("Increases tool speed by [modifications[MODIFICATION_TOOLSPEED] * 100]%")
	if (modifications[MODIFICATION_TOOLDAMAGE])
		examine_list += span_notice("Swinging force increased by [modifications[MODIFICATION_TOOLDAMAGE]]")

/datum/component/modular_attachment/proc/apply_values(obj/item/target)
	SIGNAL_HANDLER
	apply_item_values(target)

/datum/component/modular_attachment/proc/apply_item_values(obj/item/target)

/datum/component/modular_attachment/proc/add_item_values(obj/item/target)
	if (modifications[MODIFICATION_TOOLSPEED])
		target.toolspeed -= modifications[MODIFICATION_TOOLSPEED]
	if (modifications[MODIFICATION_TOOLDAMAGE])
		target.force += modifications[MODIFICATION_TOOLDAMAGE]

/datum/component/modular_attachment/proc/add_values(obj/item/target)
	add_item_values(target)
/datum/component/modular_attachment/proc/get_attachment()
	var/obj/item/attachment = parent
	return attachment
