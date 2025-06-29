/datum/ritual/sigil_walk
	name = "Walk the Runes"
	tutorial = "Stand in the centre of the sigil."
	incantation = "Portada et mortem!"
	ingredient_map = list(
		"C" = /mob/living/carbon/human,
	)

/datum/ritual/sigil_walk/ritual_effects(var/list/ingredients)
	. = ..()
	var/mob/living/carbon/human/cultist = ingredients["C"]
	var/turf/T = get_turf(cultist)
	var/obj/effect/decal/cleanable/zizo_sigil/old_sigil

	for(var/atom/movable/A in T.contents)
		if(istype(A, /obj/effect/decal/cleanable/zizo_sigil))
			old_sigil = A
			break
	
	var/world_sigils = list()
	for(var/obj/effect/decal/cleanable/zizo_sigil/Z in world)
		if(Z != old_sigil && Z.icon_state == "center")
			world_sigils += Z

	var/obj/effect/decal/cleanable/zizo_sigil/destination_sigil = pick(world_sigils)
	var/turf/TP = get_turf(destination_sigil)
	if(!TP)
		to_chat(cultist, span_warning("There are no other sigils for you to escape to!"))
		return
	
	if(do_teleport(cultist, TP, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC))
		playsound(T, 'sound/villain/sigil_walk.ogg', 100, ignore_walls = FALSE)

	return 
