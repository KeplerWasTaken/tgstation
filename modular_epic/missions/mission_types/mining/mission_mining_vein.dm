/obj/machinery/drillableOre/proc/getRandomItemFromInventory()
	if(contents.len == 0)
		return null

	var/obj/item/itemPicked
	for(var/i in 1 to contents.len)
		itemPicked = contents[i]
		// Not the last item in the que, run the chance
		if (i != contents.len)
		// Single items have a 2% chance of being picked, stack items scale. If at full stack, it's 100%.
			if(istype(itemPicked,/obj/item/stack))
				var/obj/item/stack/stackPicked = itemPicked
				var/chance = min((stackPicked.amount / stackPicked.max_amount) * 100, 100)
				if (prob(chance))
					break
			else
				if (prob(2))
					break
		else
			break
	
	if(istype(itemPicked, /obj/item/stack))
		var/obj/item/stack/stackPicked = itemPicked
		// Stack item, take 1
		var/obj/item/stack/itemDropped = stackPicked.returnamount(1)
		return itemDropped
	else
		// Solo item
		return itemPicked

/obj/machinery/drillableOre/Initialize(mapload)
	. = ..()
	PopulateContents()

/obj/machinery/drillableOre/proc/PopulateContents()
	new /obj/item/stack/ore/iron(src, 12)
	new /obj/item/bikehorn(src)
	totalItems = CountTotalItems()

/obj/machinery/drillableOre/proc/CountTotalItems()
	var/total_count = 0
	for(var/obj/item/I in contents)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/stackItem = I
			total_count += stackItem.amount
		else
			total_count++
	return total_count
	
/obj/machinery/drillableOre/proc/UpdateMissionStatus()
	var/datum/component/mission_objective/objective = GetMissionComponent()
	// We are tied to a mission
	if(objective)
		if(contents.len == 0)
			objective.MarkComplete()
/obj/machinery/drillableOre/proc/TrySpawnEnemies()
	//2% chance every item mined to spawn 1 enemy
	if (prob(2))
		SpawnEnemies(1)
		TryMissionLog("Drill quaking triggered isolated case of local fauna.")
	// At 25%, 50%, and 75% spawn a large guaranteed wave
	if (groupSpawnCheckPoints?.len > 0)
		var/nextcheckpoint = groupSpawnCheckPoints[1]
		if (minedItems / totalItems >= nextcheckpoint)
			groupSpawnCheckPoints -= nextcheckpoint
			TryMissionLog("Drill quaking agitated group of local fauna!")
			SpawnEnemies(4)

/obj/machinery/drillableOre/proc/SpawnEnemies(enemyCount)
	var/datum/component/mission_objective/objective = GetMissionComponent()
	var/distance = 5
	var/turf/center = get_turf(src)
	var/list/weighted_mob_list = list(/mob/living/basic/spider/giant)
	var/list/turf/open/floor/allOpenTurfs = RANGE_TURFS(distance, center) - RANGE_TURFS(distance-2, center) 
	var/list/turf/open/floor/acceptableSpawnPoints = list()
	for(var/turf/open/floor/singleTurn in allOpenTurfs)
		if (istype(get_area(singleTurn), /area/planet/mission))
			acceptableSpawnPoints.Add(singleTurn)
	for(var/i in 1 to enemyCount)
		var/turf/open/floor/chosenTurf = pick(acceptableSpawnPoints)
		var/mob/MobToSpawn = pick(weighted_mob_list)
		var/mob/spawnedMob = new MobToSpawn(chosenTurf)
		spawnedMob.missions_mission = objective.objective_mission
		TryMissionLog("[MobToSpawn.name] has [pick(list("entered", "rolled in to", "joined"))] the [pick(list("fray", "battle", "quarrel"))].")

/obj/machinery/drillableOre/proc/TryMissionLog(data)
	var/datum/mission/myMission = GetMission()
	if (myMission)
		myMission.LogToMission(data)

/obj/machinery/drillableOre/proc/GetMission()
	var/datum/component/mission_objective/objective = GetComponent(/datum/component/mission_objective)
	return objective.objective_mission

/obj/machinery/drillableOre/proc/GetMissionComponent()
	var/datum/component/mission_objective/objective = GetComponent(/datum/component/mission_objective)
	return objective

/obj/machinery/drillableOre
	icon_state = "titanium"
	icon = 'icons/obj/ore.dmi'
	name = "Drill me"
	anchored = TRUE
	var/obj/item/mechdriller/driller = null
	var/isDrilling = FALSE
	density = TRUE
	COOLDOWN_DECLARE(drilling_start_cooldown)
	var/list/obj/item/droplist = list()
	var/state = NO_DRILLER
	var/totalItems = 0
	var/minedItems = 0
	var/list/groupSpawnCheckPoints = list(0.1)
	var/first_time_turned_on = FALSE
	var/exhausted_for_the_first_time = FALSE

/obj/machinery/drillableOre/oredriller_act(mob/living/user, obj/item/tool)
	switch (state)
		if (NO_DRILLER)
			if(tool.use_tool(src, user, 40))
				driller = tool
				tool.forceMove(driller)
				balloon_alert(user, "Driller attached")
				user.visible_message(span_notice("[user] places the [tool] on [src]!"), span_notice("You place [tool] on the ore."))
				state = DRILLER_PLACED
				return

	balloon_alert(user, "Driller already present")

/obj/machinery/drillableOre/crowbar_act(mob/living/user, obj/item/tool)
	switch (state)
		if (DRILLER_PLACED)
			playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
			if(tool.use_tool(src, user, 40))
				balloon_alert(user, "Driller pried off")
				user.visible_message(span_notice("[user] removes the [driller] from [src]!"), span_notice("You remove the [driller] from the ore."))
				state = NO_DRILLER
				playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
				if(!user.put_in_hands(driller))
					driller.forceMove(get_turf(user))
					driller = null
				return

/obj/machinery/drillableOre/screwdriver_act(mob/living/user, obj/item/tool)
	. = TRUE
	switch(state)
		if (DRILLER_WRENCHED)
			tool.play_tool_sound(src)
			if(tool.use_tool(src, user, 40))
				balloon_alert(user, "Driller screwed in")
				user.visible_message(span_notice("[user] screws the [driller] in place!"), span_notice("You screw the [driller] in place."))
				tool.play_tool_sound(src)
				state = DRILLER_SCREWED
		if (DRILLER_SCREWED)
			tool.play_tool_sound(src)
			if(tool.use_tool(src, user, 40))
				balloon_alert(user, "Driller unscrewed")
				user.visible_message(span_notice("[user] unscrews the [driller] from its place!"), span_notice("You unscrew the [driller] from its place."))
				tool.play_tool_sound(src)
				state = DRILLER_WRENCHED

/obj/machinery/drillableOre/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE

	switch(state)
		if (DRILLER_PLACED)
			tool.play_tool_sound(src)
			if(tool.use_tool(src, user, 40))
				balloon_alert(user, "Driller wrenched")
				user.visible_message(span_notice("[user] wrenches the [driller] in place!"), span_notice("You wrench the [driller] in place."))
				tool.play_tool_sound(src)
				state = DRILLER_WRENCHED
		if (DRILLER_WRENCHED)
			tool.play_tool_sound(src)
			if(tool.use_tool(src, user, 40))
				balloon_alert(user, "Driller unwrenched")
				user.visible_message(span_notice("[user] unwrenches the [driller] from its place!"), span_notice("You unwrench the [driller] from its place."))
				tool.play_tool_sound(src)
				state = DRILLER_PLACED

/obj/machinery/drillableOre/attack_hand(mob/living/user, list/modifiers)
	. = ..()

	switch(state)
		if (DRILLER_SCREWED)
			if (isExhausted())
				balloon_alert(user, "The vein is exhausted.")
				return
			balloon_alert(user, "Turned on")
			if (!first_time_turned_on)
				first_time_turned_on = TRUE
				TryMissionLog("Drill turned on for the first time.")
			state = DRILLER_ON
			drillTick()
			return

		if (DRILLER_ON)
			balloon_alert(user, "Turned off")
			state = DRILLER_SCREWED
			COOLDOWN_START(src, drilling_start_cooldown, driller.drill_timer)
			return

		if (NO_DRILLER)
			balloon_alert(user, "This ore needs a driller placed on it first")
			return

		if (DRILLER_WRENCHED)
			balloon_alert(user, "The driller is not screwed")
			return
			
		if (DRILLER_PLACED)
			balloon_alert(user, "The driller is not wrenched")
			return

	return TRUE
	
/obj/machinery/drillableOre/examine(mob/user)
	. = ..()
	if (driller)
		. += span_notice ("There is a driller tied to it. It can be wrenched apart or turned on.")
	else 
		. += ("There is no driller on it, yummy ore awaits you")

/obj/machinery/drillableOre/proc/isExhausted()
	if (contents.len == 0)
		if (!exhausted_for_the_first_time)
			exhausted_for_the_first_time = TRUE
			TryMissionLog("Ore vein depleted of all naturally occuring resources.")
		return TRUE
	else
		return FALSE

/obj/machinery/drillableOre/proc/drillTick()
	PRIVATE_PROC(TRUE)

	// We have no driller
	if(!driller)
		state = NO_DRILLER

	// Did any of our checks knock us off of off?
	if (state != DRILLER_ON)
		return FALSE

	//Try to get an item
	var/obj/item/boulder/random_item = getRandomItemFromInventory()
	if (random_item == null)
		state = DRILLER_SCREWED
		UpdateMissionStatus()
		return FALSE

	random_item.forceMove(drop_location())
	minedItems++
	random_item.pixel_x = rand(-2, 2)
	random_item.pixel_y = rand(-2, 2)
	TryMissionLog("[random_item.name] has been extracted.")
	UpdateMissionStatus()
	TrySpawnEnemies()
	addtimer(CALLBACK(src, PROC_REF(drillTick), FALSE), driller.drill_timer)
