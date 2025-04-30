#define JOB_CONTRACTOR "Contractor"

/datum/job/contractor
	title = JOB_CONTRACTOR
	description = "Get your space legs, assist people, ask the HoP to give you a job."
	faction = FACTION_STATION
	total_positions = 5
	spawn_positions = 5
	supervisors = "absolutely everyone"
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/contractor
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_ZERO // Get a job. Job reassignment changes your paycheck now. Get over it.

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

	department_for_prefs = /datum/job_department/contractor

	family_heirlooms = list(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)

	job_flags = STATION_JOB_FLAGS
	config_tag = "ASSISTANT"

#define DEPARTMENT_BITFLAG_CONTRACTOR (1<<10)
#define DEPARTMENT_CONTRACTOR "Contractor"

/datum/job_department/contractor
	department_name = DEPARTMENT_CONTRACTOR
	department_bitflags = DEPARTMENT_BITFLAG_CONTRACTOR

/datum/outfit/job/contractor
	name = JOB_CONTRACTOR
	jobtype = /datum/job/assistant
	id_trim = /datum/id_trim/job/assistant
	belt = /obj/item/modular_computer/pda/assistant
	shoes = /obj/item/clothing/shoes/jackboots
	uniform = /obj/item/clothing/under/syndicate/tacticool 
	suit = /obj/item/clothing/suit/armor/vest/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/fingerless
	back = /obj/item/storage/backpack/satchel
	suit_store = /obj/item/gun/ballistic/automatic/pistol/m1911

/datum/outfit/job/contractor/pre_equip(mob/living/carbon/human/target)
	..()

