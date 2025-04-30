/datum/mission
    // Logging related variables
	var/list/DamageDealtLog = list() // "Dealer", "Type", "Damage"
	var/list/DamageTakenLog = list() // "Tanker", "Type", "Damage"
	var/list/MobsKilledLog = list() // "Killer", "", "Killer"
	var/list/FriendlyFireLog = list() // "Shooter", "Shooted", ""
	var/list/MissionsLog = list() // "TimeStamp", "Action"

    // Final output, in html
	var/missionEndReport = ""

/datum/mission/proc/MissionOngoing()
	if (!started)
		return FALSE
	if (completed)
		return FALSE
	return TRUE

/datum/mission/proc/LogToMission(toLog)
	if (!MissionOngoing())
		return
	MissionsLog += list(list("TimeStamp" = ROUND_TIME(), "Action" = toLog))

/datum/mission/proc/TallyDamageDealt(dealer, type, damage)
	if (!MissionOngoing())
		return

	if(!DamageDealtLog[dealer])
		DamageDealtLog[dealer] = list()

	if (!DamageDealtLog[dealer][type])
		DamageDealtLog[dealer][type] = 0

	DamageDealtLog[dealer][type] += damage

/datum/mission/proc/TallyDamageTaken(tanker, type, damage)
	if (!MissionOngoing())
		return

	if(!DamageTakenLog[tanker])
		DamageTakenLog[tanker] = list()
	
	if (!DamageTakenLog[tanker][type])
		DamageTakenLog[tanker][type] = 0

	DamageTakenLog[tanker][type] += damage

/datum/mission/proc/TallyMobKilled(killer, mobname)
	if (!MissionOngoing())
		return

	if(!MobsKilledLog[killer])
		MobsKilledLog[killer] = list()

	if(!MobsKilledLog[killer][mobname])
		MobsKilledLog[killer][mobname] = 0
	MobsKilledLog[killer][mobname]++
	
/datum/mission/proc/TallyFriendlyFire(shooter, shooted, damagetype, damage)
	if (!MissionOngoing())
		return
		
	if(!FriendlyFireLog[shooter])
		FriendlyFireLog[shooter] = list()

	if(!FriendlyFireLog[shooter][shooted])
		FriendlyFireLog[shooter][shooted] = list()

	if(!FriendlyFireLog[shooter][shooted][damagetype])
		FriendlyFireLog[shooter][shooted][damagetype] = 0

	FriendlyFireLog[shooter][shooter][damagetype][damage] += damage

// Assumes one of them has missions_mission not null
/datum/mission/proc/ConsiderLogging(atom/firer, atom/target, damage, damagetype, waskilled)
	if (!InSameMission(firer,target) || !MissionOngoing())
		return

	var/mob/firerMob = null
	var/mob/targetMob = null
	if (ismob(firer))
		firerMob = firer
	if (ismob(target))
		targetMob = target
	
	// Shooter was a player
	if (firerMob?.ckey)
		// Target was also a player
		if (targetMob?.ckey)
			TallyFriendlyFire(firer.name, target.name, damagetype, damage)
		else
			TallyDamageDealt(firer.name, damagetype, damage)
			if (waskilled)
				TallyMobKilled(firer.name, target.name)
	else if (targetMob?.ckey)
		// Player received damage
		TallyDamageTaken(target.name, firer.name, damage)

/datum/mission/proc/InSameMission(atom/firer, atom/target)
	if (firer?.missions_mission && target?.missions_mission && firer.missions_mission.name == firer.missions_mission.name)
		return TRUE
	return FALSE
