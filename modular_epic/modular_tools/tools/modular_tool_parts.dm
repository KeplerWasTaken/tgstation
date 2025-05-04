// MODULAR BASE
/obj/item/modular_attachment/tool

// WRENCH BASE
/obj/item/wrench
	modular_slots_available = list(ATTACHMENT_WRENCH_HEAD = 1, ATTACHMENT_WRENCH_HANDLE = 1, ATTACHMENT_MAGIC_PAINT = 2)
	modular_initial_slots = list(/obj/item/modular_attachment/tool/wrenchhead, /obj/item/modular_attachment/tool/wrenchhandle)
	modular_required_to_operate = list(ATTACHMENT_WRENCH_HEAD = 1, ATTACHMENT_WRENCH_HANDLE = 1)

/obj/item/modular_attachment/tool/wrenchhead
	applicable_slots = list(ATTACHMENT_WRENCH_HEAD)
	modifications = list(MODIFICATION_TOOLSPEED = 0)
	name = "Wrench Head"
	desc = "A wrench head."

/obj/item/modular_attachment/tool/wrenchhandle
	applicable_slots = list(ATTACHMENT_WRENCH_HANDLE)
	modifications = list(MODIFICATION_TOOLSPEED = 0)
	name = "Wrench Handle"
	desc = "A wrench handle."

/obj/item/wrench/silver
	modular_initial_slots = list(/obj/item/modular_attachment/tool/wrenchhead/silver, /obj/item/modular_attachment/tool/wrenchhandle/silver)

// CROWBAR BASE
/obj/item/crowbar
    modular_slots_available = list(ATTACHMENT_CROWBAR_BODY = 1, ATTACHMENT_CROWBAR_TIP = 1, ATTACHMENT_MAGIC_PAINT = 2)
    modular_initial_slots = list()

// WELDER BASE

// SCREWDRIVER BASE
