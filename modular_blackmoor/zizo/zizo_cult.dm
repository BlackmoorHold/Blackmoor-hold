//Call to the Overlord! Speak the profane words! 

/atom/movable/screen/alert/status_effect/overlord
	name = "ZIZO"
	desc = "ZIZO HEARS ME!"
	icon_state = "stressvg"

/mob/living/carbon/human/proc/praise_zizo()
	set name = "Call to Overlord!"
	set category = "ZIZO"
	audible_message(span_danger("[src] praises <span class='bold'>Zizo</span>!"))
	src.add_stress(/datum/stressevent/overlord_heard)
	src.apply_status_effect(/datum/status_effect/overlord)
	var/list/shouts = list(
		'sound/vo/cult/cultist1.ogg',
		'sound/vo/cult/cultist2.ogg',
		'sound/vo/cult/cultist3.ogg',
		'sound/vo/cult/cultist4.ogg',
		'sound/vo/cult/cultist5.ogg',
	)
	playsound(src.loc, pick(shouts), 100)
	if(src.has_flaw(/datum/charflaw/addiction/godfearing)) //Why yes, Zizoids enjoy shouting their praises to the Overlord
		src.sate_addiction()

/datum/status_effect/overlord //There are benefits to crying out to Zizo!
	id = "overlord"
	alert_type = /atom/movable/screen/alert/status_effect/overlord
	status_type = STATUS_EFFECT_UNIQUE
	effectedstats = list("strength" = 1)
	duration = 10 SECONDS

/datum/status_effect/overlord/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/overlord_heard)
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/status_effect/overlord/on_remove()
	. = ..()
	owner.remove_stress(/datum/stressevent/overlord_heard)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/stressevent/overlord_heard
	stressadd = -5
	desc = span_boldgreen("Zizo hears me!")
	timer = 10 SECONDS

/obj/effect/decal/cleanable/zizo_sigil
	name = "necromantic sigil"
	icon_state = "center"
	icon = 'icons/roguetown/zizo/zizo_sigil.dmi'

/obj/effect/decal/cleanable/zizo_sigil/N
	icon_state = "N"

/obj/effect/decal/cleanable/zizo_sigil/NE
	icon_state = "NE"

/obj/effect/decal/cleanable/zizo_sigil/E
	icon_state = "E"

/obj/effect/decal/cleanable/zizo_sigil/SE
	icon_state = "SE"

/obj/effect/decal/cleanable/zizo_sigil/S
	icon_state = "S"

/obj/effect/decal/cleanable/zizo_sigil/SW
	icon_state = "SW"

/obj/effect/decal/cleanable/zizo_sigil/W
	icon_state = "W"

/obj/effect/decal/cleanable/zizo_sigil/NW
	icon_state = "NW"

/mob/living/carbon/human/proc/zizo_sigil()
	set name = "Draw Zizo Sigil"
	set category = "ZIZO"
	if(!bloody_hands)
		to_chat(src, "<span class='danger'>My digits need fresh blood to paint with.</span>")
		return
	var/turf/T = get_turf(src.loc)
	for(var/obj/effect/decal/cleanable/zizo_sigil/old in range(1, src))
		to_chat(src, span_warning("There is already a sigil here!"))
		return
	for(var/obj/structure/F in range(1, src))
		to_chat(src, span_warning("There is no room for a sigil here!"))
		return
	for(var/turf/closed/W in range(1, src))
		to_chat(src, span_warning("There is no room for a sigil here!"))
		return
	var/turf/step = get_step(T, NORTHWEST)
	if(do_after(src, 1 SECONDS))
		new /obj/effect/decal/cleanable/zizo_sigil/NW(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, NORTH)
		new /obj/effect/decal/cleanable/zizo_sigil/N(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, NORTHEAST)
		new /obj/effect/decal/cleanable/zizo_sigil/NE(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, WEST)
		new /obj/effect/decal/cleanable/zizo_sigil/W(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = T
		new /obj/effect/decal/cleanable/zizo_sigil(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, EAST)
		new /obj/effect/decal/cleanable/zizo_sigil/E(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, SOUTHWEST)
		new /obj/effect/decal/cleanable/zizo_sigil/SW(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, SOUTH)
		new /obj/effect/decal/cleanable/zizo_sigil/S(step)
	else
		return
	if(do_after(src, 1 SECONDS))
		step = get_step(T, SOUTHEAST)
		new /obj/effect/decal/cleanable/zizo_sigil/SE(step)
	else
		return

//Handles actually invoking the sigils
/mob/living/carbon/human/proc/begin_zizo_ritual()
	set name = "Speak the Words"
	set category = "ZIZO"

	var/obj/effect/decal/cleanable/zizo_sigil/sigil
	var/turf/T
	for(var/obj/effect/decal/cleanable/zizo_sigil/S in range(1, src))
		if(S.icon_state == "center")
			sigil = S
			break
	if(!sigil)
		to_chat(src, span_warning("I need to stand on HIS sigil."))
		return
	else
		T = get_turf(sigil)
	
	var/list/rituals = typesof(/datum/ritual) - list(/datum/ritual) //The base ritual datum is not a valid ritual
	var/list/ritual_names = list()
	for(var/rite in rituals)
		var/datum/ritual/R = new rite()
		ritual_names[R.name] = rite
	
	var/ritual_pick = input(src, "Which ritual shall I invoke?", "RITUALS") as null|anything in ritual_names
	if(ritual_pick)
		var/chosen_ritual = ritual_names[ritual_pick]
		var/datum/ritual/invoked = new chosen_ritual()
		invoked.ritual_effects(invoked.ritual_check(T, src))
				
