/datum/action/ShowMissionReport
	var/datum/mission/myMission = null
	name = "Show mission report"
	button_icon_state = "round_end"
	show_to_observers = FALSE

/datum/action/ShowMissionReport/Trigger(trigger_flags)
	if(owner && src.myMission.completed == TRUE)
		src.myMission.show_mission_report(owner.client)
