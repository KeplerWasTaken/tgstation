#define MISSION_OBJECTIVE_STATUS_READY "Complete"
#define MISSION_OBJECTIVE_STATUS_NOTREADY "Not Complete"

/datum/component/mission_objective
    var/objective_complete = MISSION_OBJECTIVE_STATUS_NOTREADY
    var/objective_name = ""
    var/datum/mission/objective_mission = null

/datum/component/mission_objective/proc/MarkComplete()
    objective_complete = MISSION_OBJECTIVE_STATUS_READY
    objective_mission.ObjectivesUpdated()

/datum/component/mission_objective/proc/MarkUncomplete()
    objective_complete = MISSION_OBJECTIVE_STATUS_NOTREADY
    objective_mission.ObjectivesUpdated()

/datum/component/mission_objective/Initialize(
    datum/mission/parentmission
)
    . = ..()
    src.objective_mission = parentmission


// MINING MISSION

/datum/component/mission_objective/mining

// RETRIEVE OBJECTIBVE

/datum/component/mission_objective/mcguffin

/datum/component/mission_objective/mcguffin/Initialize(
    datum/mission/parentmission
)
    ..(parentmission)
    RegisterSignal(src.parent, COMSIG_MOVABLE_MOVED, PROC_REF(On_Move))

/atom/proc/Is_Being_Carried_By_Player()
    var/atom/current_loc = loc
    while (current_loc && !istype(current_loc, /turf))
        if (istype(current_loc, /mob/living))
            var/mob/living/current_mob = current_loc
            return current_mob.ckey ? TRUE : FALSE
        current_loc = current_loc.loc
    return FALSE

/datum/component/mission_objective/mcguffin/proc/On_Move(atom/movable/mover, atom/oldloc)
    message_admins("Mcguffin on move")
    var/obj/item/I = parent
    if (I.Is_Being_Carried_By_Player() && objective_complete == MISSION_OBJECTIVE_STATUS_NOTREADY)
        MarkComplete()
    else if(!I.Is_Being_Carried_By_Player() && objective_complete == MISSION_OBJECTIVE_STATUS_READY)
        MarkUncomplete()
