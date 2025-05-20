// ATTACHMENT LOCATIONS
#define ATTACHMENT_WRENCH_HEAD "attachment_wrench_head"
#define ATTACHMENT_WRENCH_HANDLE "attachment_wrench_handle"

#define ATTACHMENT_SCREWDRIVER_HEAD "attachment_screwdriver_head"
#define ATTACHMENT_SCREWDRIVER_HANDLE "attachment_screwdriver_handle"

#define ATTACHMENT_WELDER_BODY "attachment_welder_body"
#define ATTACHMENT_WELDER_IGNITER "attachment_welder_body"

#define ATTACHMENT_CROWBAR_BODY "attachment_crowbarbody"
#define ATTACHMENT_CROWBAR_TIP "attachment_crowbarbody"

#define ATTACHMENT_CELL_SMALL "attachment_cell_small"
#define ATTACHMENT_CELL_MEDIUM "attachment_cell_medium"
#define ATTACHMENT_CELL_LARGE "attachment_cell_large"

#define ATTACHMENT_FUELTANK "attachment_fueltank"

#define ATTACHMENT_MAGIC_PAINT "attachment_magic_paint"

#define ATTACHMENT_BARREL "attachment_barrel"
#define ATTACHMENT_STOCK "attachment_stock"
#define ATTACHMENT_SCOPE "attachment_scope"

// GUN VALUE MODIFICATIONS
#define MODIFICATION_FIRERATE "modification_firerate"
#define MODIFICATION_SPREADREDUCTION "modification_spreadreduction"

// TOOL VALUE MODIFICATIONS
#define MODIFICATION_TOOLSPEED "modification_toolspeed"
#define MODIFICATION_TOOLDAMAGE "modification_tooldamage"

// ATTACHMENT QUALITY
#define QUALITY_ABYSMAL 2
#define QUALITY_BAD 1.5
#define QUALITY_NORMAL 1
#define QUALITY_GOOD 0.9
#define QUALITY_GREAT 0.75
#define QUALITY_IMPRESSIVE 0.65
#define QUALITY_EXCEPTIONAL 0.5

// For easier generation of attachments
/obj/item
	var/quality = QUALITY_NORMAL
	// Where it can be inserted
	var/applicable_slots = list()
	// What modifications it would do
	var/modifications = list()

	// Toggle to true for easier creation of modular parts
	var/is_attachment = FALSE

	// Which slot it is using after being inserted, don't touch this
	var/modular_slot_used = null

/obj/item/modular_attachment
	is_attachment = TRUE

/obj/item/proc/GenerateAttachmentComponent()
	var/datum/component/modular_attachment/attachment = AddComponent(/datum/component/modular_attachment)
	attachment.modifications = modifications
	attachment.applicable_slots = applicable_slots

// Also works for regenerating
/obj/item/proc/ConsiderBecomingAttachment()
	if (is_attachment)
		var/datum/component/modular_attachment/current_attachment_component = GetComponent(/datum/component/modular_attachment)
		if (current_attachment_component)
			qdel(current_attachment_component)
		GenerateAttachmentComponent()

