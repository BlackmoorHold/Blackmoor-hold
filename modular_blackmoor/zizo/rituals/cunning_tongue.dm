/datum/ritual/cunning_tongue
	name = "Cunning Licker"
	tutorial = "A tongue will be placed in the middle. Cigarette butts at its 9 and 3. Be sure to leave your six and twelve alit to see!"
	incantation = "ZIZO!! Let them whisper my TRUTHS!!"
	ingredient_map = list(
		"N" = /obj/item/candle,
		"W" = /obj/item/cigbutt,
		"C" = /obj/item/organ/tongue,
		"E" = /obj/item/cigbutt,
		"S" = /obj/item/candle,
	)
	consumption = TRUE


/datum/ritual/cunning_tongue/ritual_effects(var/list/ingredients)
	. = ..()
	var/turf/T = ingredients["C"]
	new /obj/item/organ/tongue/trickster(T)
	return

/obj/item/organ/tongue/trickster
	desc = "There is something strange about this tongue."
	var/mob/living/carbon/human/victim = null

/obj/item/organ/tongue/trickster/attack_self(mob/user)
	if(!victim)
		var/victim_name = input(user, "Who will be the victim of your triquery?", "CONNIVING TONGUE") as text|null
		for(var/mob/living/P in GLOB.player_list)
			if(P.real_name == victim_name)
				victim = P
				return
	else
		var/speech = input(user, "What will you make the fool [victim.real_name] say?", "TWISTED TONGUE")
		if(!speech)
			return
		victim.say(speech, forced = "curse")

