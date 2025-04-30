// Special thank you to ERIS code, Lyroy, for being a good coder and giving a great example on how to work with components properly

/obj/item
	// List of ATTACHMENT_x Defines 
	var/list/modular_slots_available = list()
	// List of /obj/item/modular_attachment types that come preinstalled to the item
	var/list/modular_initial_slots = list()
	// List of /obj/item/modular_attachment of installed attachments
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
