/mob
	var/datum/stat_holder/stats

/mob/Initialize(mapload)
	. = ..()
	stats = new/datum/stat_holder(src)
	
/mob/verb/view_stats()
	set category = "IC"
	set name = "View Stats"
	mind?.print_stats(src)

/datum/mind/proc/print_stats(user)
	//Stats are tied to a mob
	if (current && current.stats && length(current.stats.stat_list))
		var/msg = "[span_info("<EM>Your stats</EM>")]\n<span class='notice'>"
		to_chat(user, length(current.stats.stat_list))
		for(var/i in current.stats.stat_list)
			var/datum/stat/the_stat = current.stats.stat_list[i]
			msg += "[i] - [the_stat.getLevelOfStat()] - [the_stat.value]\n"
		msg += "<b>Level [current.stats.level]</b> - [current.stats.xp]/[current.stats.get_xp_needed_for_level_up()]"
		msg += "</span>"
		to_chat(user, examine_block(msg))
	else
		to_chat(user, span_notice("Strange, isn't it? You can't seem to recall any particular skill."))
