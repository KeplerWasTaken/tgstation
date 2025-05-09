GLOBAL_VAR_INIT(uid_counter, 0)

/obj/item
	var/uid

/obj/item/proc/MakeUID()
	uid = GLOB.uid_counter
	GLOB.uid_counter += 1
	return TRUE

/obj/item/proc/GetAttachmentByUID(var/uid)
	for(var/obj/item/attachment in modular_attachments)
		if (attachment.uid == uid)
			return attachment
	return null
