/datum/ritual/communion
	name = "Qabbalistic Communion"
	tutorial = "Stand in the centre of the sigil."
	incantation = "Zizo! Carry my words!"
	ingredient_map = list(
		"C" = /mob/living/carbon/human,
	)

/datum/ritual/communion/ritual_effects(var/list/ingredients)
	. = ..()
	var/mob/living/carbon/human/cultist = ingredients["C"]
	var/speech = input(cultist, "What will you share with the Qabbal?", "ZIZO") as text|null
	if(!speech)
		return
	
	for(var/mob/living/carbon/human/C in world)
		if(HAS_TRAIT(C, TRAIT_CABAL))
			to_chat(C, span_danger("[cultist] speaks: [speech]"))

	log_game("[key_name(cultist)] used a ritual to say: [speech]")
