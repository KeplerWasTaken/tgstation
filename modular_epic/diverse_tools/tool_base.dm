// In what way can a tool be used?
//Mechanical Qualities
#define QUALITY_BOLT_TURNING			"bolt turning"
#define QUALITY_PULSING					"pulsing"
#define QUALITY_PRYING					"prying"
#define QUALITY_WELDING					"welding"
#define QUALITY_SCREW_DRIVING			"screw driving"
#define QUALITY_WIRE_CUTTING			"wire cutting"
#define QUALITY_SHOVELING				"shoveling"
#define QUALITY_DIGGING					"digging"
#define QUALITY_EXCAVATION				"excavation"
#define QUALITY_ADHESIVE				"adhesive"
#define QUALITY_SEALING					"sealing"
#define QUALITY_HAMMERING				"hammering"

//Biological Qualities
#define QUALITY_CLAMPING				"clamping"
#define QUALITY_CAUTERIZING				"cauterizing"
#define QUALITY_RETRACTING				"retracting"
#define QUALITY_DRILLING				"drilling"
#define QUALITY_SAWING					"sawing"
#define QUALITY_BONE_SETTING			"bone setting"
#define QUALITY_CUTTING					"cutting"
#define QUALITY_LASER_CUTTING			"laser cutting"	//laser scalpels and e-swords - bloodless cutting
#define QUALITY_BONE_GRAFTING			"bone grafting"

//Other Qualities
#define QUALITY_WEAVING					"weaving"
#define QUALITY_ELECTROCUTION			"electroshock"
#define QUALITY_ARMOR					"armor"
#define QUALITY_HEATING					"heating" //Used absure crafting

/obj/item
	var/list/tool_qualities = list()

/obj/item/wrench
	tool_qualities = list(TOOL_WRENCH)

/obj/item/diverse_omni_tool
	name = "Admin test tool"
	desc = "You can be totally screwy with this."
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver_map"
	inhand_icon_state = "screwdriver"
	worn_icon_state = "screwdriver"
	inside_belt_icon_state = "screwdriver"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	tool_qualities = list(TOOL_CROWBAR = 100, TOOL_MULTITOOL = 100,TOOL_SCREWDRIVER = 100,TOOL_WIRECUTTER = 100,TOOL_WRENCH = 100, TOOL_WELDER = 100)

/obj/item/diverse_omni_tool/tool_use_check(mob/living/user, amount, heat_required)
	return TRUE
