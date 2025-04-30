/obj/item/skillraiser
	var/skillToRaise = 0
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "hburger"
	name = "Skill Raiser"

/obj/item/xpgiver
	var/XpToGive = 0 
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "hburger"
	name = "XP Giver"

/obj/item/skillraiser/Initialize(mapload)
	..()
	skillToRaise = pick(ALL_STATS_FOR_LEVEL_UP)
	desc = "Using this will raise your [skillToRaise] by 1"

/obj/item/xpgiver/Initialize(mapload)
	..()
	XpToGive = rand(1, 100)
	desc = "Using this will give you " + XpToGive + "xp"

/obj/item/xpgiver/attack_self(mob/user)
	user.stats.add_xp(XpToGive)
	to_chat(user, span_bold("The Giver fizzles into nothiness as you clutch it in your hands... and gives you: [XpToGive]xp"))
	qdel(src)

/obj/item/skillraiser/attack_self(mob/user)
	user.stats.changeStat(skillToRaise, 1)
	to_chat(user, span_bold("The Giver fizzles into nothiness as you clutch it in your hands... and gives you: 1 point in [skillToRaise]"))
	qdel(src)
