/datum/ritual/initiation
	name = "The Initiation"
	tutorial = "Place the prospective in the centre. Candles should be at their east and west."
	incantation = "Zizo, a bounty of souls! Zaos Dei!"
	ingredient_map = list(
		"W" = /obj/item/candle,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/candle,
	)
	consumption = TRUE

/datum/ritual/initiation/ritual_effects(var/list/ingredients)
	. = ..()
	var/mob/living/carbon/human/convert = ingredients["C"]
	if(convert.patron != /datum/patron/inhumen/zizo && convert.mind) //Conversion can be forced unto an unwilling captive!
		convert.set_patron(/datum/patron/inhumen/zizo)
		convert.say(incantation, forced = "ritual")
		var/list/shouts = list(
		'sound/vo/cult/cultist1.ogg',
		'sound/vo/cult/cultist2.ogg',
		'sound/vo/cult/cultist3.ogg',
		'sound/vo/cult/cultist4.ogg',
		'sound/vo/cult/cultist5.ogg',
		)
		playsound(convert.loc, pick(shouts), 100)
		ADD_TRAIT(convert, TRAIT_CABAL, TRAIT_GENERIC)
		convert.verbs |= /mob/living/carbon/human/proc/praise_zizo //They don't get the rest of them because they're neophytes.
		convert.verbs -= /mob/living/carbon/human/proc/zizo_sigil
		convert.verbs -= /mob/living/carbon/human/proc/begin_zizo_ritual
	return

