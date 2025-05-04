/obj/item
	// List of attachments the tool can take
	var/list/modular_slots_available = list()
	// List of /obj/item/modular_attachment types that come preinstalled to the item
	var/list/modular_initial_slots = list()
	// List of actively /obj/item/modular_attachment of installed attachments
	var/list/modular_attachments = list()
	// List of ATTACHMENT_x Defines that are required to be able to use the tool
	var/list/modular_required_to_operate = list()
	var/list/modular_slots_in_use = list()

/obj/item/proc/InitializeModularAttachments()
	for (var/attachment_type in modular_initial_slots)
		var/obj/attachment = new attachment_type
		attachment.attack_no_hit_atom(src)

/obj/item/proc/RefreshUpgrades()
	ResetModularVariables()
	SendModularSignals()

/obj/item/proc/ResetModularVariables()
	toolspeed = initial(toolspeed)
	force = initial(force)

/obj/item/proc/SendModularSignals()
	SEND_SIGNAL(src, COMSIG_UPGRADE_APPVAL, src)
	SEND_SIGNAL(src, COMSIG_UPGRADE_ADDVAL, src)

/obj/item/proc/GetAttachmentsBySlot(var/slot)
	var/list/attachments = GetComponents(/datum/component/modular_attachment)
	var/list/to_return = list()
	for(var/datum/component/modular_attachment/attachment in attachments)
		if (slot == attachment.slot_used)
			to_return += attachment.get_attachment()
	return to_return

/proc/list2keys(list/mylist)
	var/list/allVariables = splittext(list2params(mylist), "&")
	var/list/myKeys = list()
	for(var/variable in allVariables)
		myKeys.Add(splittext(variable, "=")[1])
	return myKeys

/obj/item/proc/HasModularSlotsToOperate()
	var/list/keys = list2keys(modular_required_to_operate)
	for(var/required_slot in keys)
		if (!modular_slots_in_use[required_slot] || modular_slots_in_use[required_slot] < modular_required_to_operate[required_slot])
			return FALSE
	return TRUE
