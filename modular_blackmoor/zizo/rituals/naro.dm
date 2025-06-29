/datum/ritual/naro
	name = "Naro Strength"
	tutorial = "Stand in the centre of the sigil. Place their righteous arm on the western side, and their sinister arm on the eastern side."
	incantation = "Zizo, grant me strength!"
	ingredient_map = list(
		"W" = /obj/item/bodypart/r_arm,
		"C" = /mob/living/carbon/human,
 		"E" = /obj/item/bodypart/l_arm,
	)
	consumption = TRUE

/datum/ritual/naro/ritual_effects(var/list/ingredients)
	. = ..()
	var/mob/living/carbon/human/cultist = ingredients["C"]
	to_chat(cultist, span_warning("You are filled with the strength of your victims!"))
	cultist.apply_status_effect(/datum/status_effect/naro_strength)
	return 

/datum/status_effect/naro_strength //There are benefits to crying out to Zizo!
	id = "naro_strength"
	alert_type = /atom/movable/screen/alert/status_effect/naro_strength
	status_type = STATUS_EFFECT_UNIQUE
	effectedstats = list("strength" = 5)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/naro_strength
	name = "Naro Strength"
	desc = "I AM EMPOWERED BY THE FALLEN!"
	icon_state = "stressvg"
