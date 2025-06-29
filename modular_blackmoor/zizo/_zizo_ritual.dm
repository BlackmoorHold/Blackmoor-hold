//List of Zizoic Rituals

/datum/ritual
	// Name of the ritual
	var/name
	//Tutorial that pops up when the ritual fails
	var/tutorial = "Place a heart in the centre of the sigil. There are such sights to show you."
	//What you shout when you perform the ritual
	var/incantation = "As above, so below!"
	//Ingredients required for the ritual on each tile
	// The keys are obviously "NW", "N", "NE", "W", "C", "E", "SW", "S", "SE"
	//Example: Ingredient_map = list("NW" = /obj/item/reagent_container/food/heart, "C" = /obj/item/reagent_container/food/heart)
	var/list/ingredient_map = list()
	//Does the ritual consume ingredients?
	var/consumption = FALSE

//This checks that the ritual can be performed, and then performs it if so.
/datum/ritual/proc/ritual_check(turf/T, mob/living/cultist)
	//Mapping directions to our ritual iIngredient map
	var/list/sigil_map = list(
		"NW" = NORTHWEST,
		"N" = NORTH,
		"NE" = NORTHEAST,
		"W" = WEST,
		"E" = EAST,
		"SW" = SOUTHWEST,
		"S" = SOUTH,
		"SE" = SOUTHEAST
	)

	//Storing any iIngredients we find in a map so we can obliterate them later if consumption == TRUE
	var/list/found_ingredients = list()

	if(!cultist.can_speak_vocal() || !cultist.getorganslot(ORGAN_SLOT_TONGUE)) //You have to be able to speak them.
		to_chat(cultist, span_warning("I can't Speak the Words!"))
		return FALSE

	if(!validate_sigil(T))
		to_chat(cultist, span_warning("The Sigil is incomplete!")) 
		return FALSE

	for(var/dir in ingredient_map)
		var/expected = ingredient_map[dir]
		var/turf/sigil_tile = (dir == "C") ? T : get_step(T, sigil_map[dir])
		for(var/atom/movable/A in sigil_tile.contents)
			if(istype(A, expected))
				found_ingredients[dir] = A
				break
	//Final validation check

	for (var/dir in ingredient_map)
		var/expected = ingredient_map[dir]
		var/found = found_ingredients[dir]
		if (!found || !istype(found, expected))
			to_chat(cultist, span_warning(tutorial)) ///Send tutorial to cultist
			return FALSE  // Missing or incorrect item

	for(var/C in ingredient_map)// Only lit candles should work
		if(istype(C, /obj/item/candle))
			var/obj/item/candle/L
			if(L.lit != TRUE )
				to_chat(cultist, span_warning("The candles must be lit!"))
				return FALSE

	var/list/completion_sounds = list(
		'sound/villain/rite_chants/rite_chant1.ogg',
		'sound/villain/rite_chants/rite_chant2.ogg',
		'sound/villain/rite_chants/rite_chant3.ogg',
		'sound/villain/rite_chants/rite_chant4.ogg',
		'sound/villain/rite_chants/rite_chant5.ogg',
		'sound/villain/rite_chants/rite_chant6.ogg',
		'sound/villain/rite_chants/rite_chant7.ogg',
		'sound/villain/rite_chants/rite_chant8.ogg',
		'sound/villain/rite_chants/rite_chant9.ogg',
		'sound/villain/rite_chants/rite_chant10.ogg',
		'sound/villain/rite_chants/rite_chant11.ogg',
		'sound/villain/rite_chants/rite_chant12.ogg',
		'sound/villain/rite_chants/rite_chant13.ogg',
		'sound/villain/rite_chants/rite_chant14.ogg',
		'sound/villain/rite_chants/rite_chant15.ogg',
		'sound/villain/rite_chants/rite_chant16.ogg',
		'sound/villain/rite_chants/rite_chant17.ogg',
		'sound/villain/rite_chants/rite_chant18.ogg',
	)
	
	playsound(cultist, pick(completion_sounds), 100, ignore_walls = FALSE)
	cultist.say(incantation, forced = "ritual")
	if (consumption)
		var/list/center_loc = list("C" = T)
		for (var/dir in found_ingredients)
			var/atom/movable/A = found_ingredients[dir]
			if(!istype(A, /mob/living) && !(istype(A, /obj/item/candle)))//If the rite targets a human directly on the sigil it shouldn't consume them. 
				do_sparks(2, FALSE, A)
				qdel(A)
			if(istype(A, /obj/item/candle)) //Candles get special treatment for visual flair.
				var/obj/item/candle/C = A
				C.wax = 0
				C.update_icon()
		return center_loc //Return the central turf in hopes of doing something with it (spawning things there and whatnot)

	//Returns the list of ingredients found so that the actual ritual proc can use them
	return found_ingredients

/datum/ritual/proc/ritual_effects(var/list/ingredients)
	//Allows for shenanigans with invoking a ritual onto whatever may be on a sigil tile
	//Fill this with whatever you want to happen to ingredients on NW, N, NE, W, C, E, SW, S, SE

	return

//Check if there's actually a full sigil around the centre sigil tile.
/datum/ritual/proc/validate_sigil(turf/T)
	var/list/sigil_states = list(NORTHWEST, NORTH, NORTHEAST, WEST, EAST, SOUTHWEST, SOUTH, SOUTHEAST)
	var/pieces = 0
	for(var/atom/movable/A in T.contents)
		if(istype(A, /obj/effect/decal/cleanable/zizo_sigil))
			pieces++
			break
	for(var/dir in sigil_states)
		var/turf/sigil_tile = get_step(T, dir)
		for(var/atom/movable/A in sigil_tile.contents)
			if(istype(A, /obj/effect/decal/cleanable/zizo_sigil))
				pieces++
				break
	if(pieces < 9)
		return FALSE  // Not enough sigil pieces
	return TRUE  // Full sigil found
	
