/datum/status_effect/buff/vigorized/on_remove()
	. = ..()
	to_chat(owner, span_warning("The surge of energy inside me fades..."))

/atom/movable/screen/alert/status_effect/buff/solar_embrace
	name = "Solar Embrace"
	desc = "Astrata's divine fire flows through me, making flames heal instead of harm."
	icon_state = "buff"

/datum/status_effect/buff/solar_embrace
	id = "solar_embrace"
	alert_type = /atom/movable/screen/alert/status_effect/buff/solar_embrace
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/solar_embrace/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_FIRE_HEALING, MAGIC_TRAIT)
	to_chat(owner, span_notice("I feel Astrata's divine fire coursing through my veins. Flames will now heal me instead of harm me."))

/datum/status_effect/buff/solar_embrace/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FIRE_HEALING, MAGIC_TRAIT)
	to_chat(owner, span_warning("Astrata's divine fire fades from my body. Flames will harm me once more."))

/datum/status_effect/buff/seelie_drugs 
