/datum/ritual/black_judgement
	name = "Black Judgement"
	tutorial = "A doubloon shall take its throne in the centre and find itself rounded by candles. Whisper the unworthy's name over the Product of your efforts."
	incantation = "Zizo! May a fool be cast into darkness today!"
	ingredient_map = list(
		"NW" = /obj/item/candle,
		"N" = /obj/item/candle,
		"NE" = /obj/item/candle,
		"W" = /obj/item/candle,
		"C" = /obj/item/roguecoin/gold,
		"E" = /obj/item/candle,
		"SW" = /obj/item/candle,
		"S" = /obj/item/candle,
		"SE" = /obj/item/candle,
	)
	consumption = TRUE


/datum/ritual/black_judgement/ritual_effects(var/list/ingredients)
	. = ..()
	var/turf/T =  ingredients["C"]
	new /obj/item/roguecoin/gold/judgement(T)
	return

/obj/item/roguecoin/gold/judgement
	var/mob/living/carbon/human/victim = null

/obj/item/roguecoin/gold/judgement/attack_self(mob/living/user)
	. = ..()
	if(!victim)
		return
	var/list/goresound = list(
		'sound/combat/dismemberment/dismem (1).ogg',
		'sound/combat/dismemberment/dismem (2).ogg',
		'sound/combat/dismemberment/dismem (3).ogg',
		'sound/combat/dismemberment/dismem (5).ogg',
		'sound/combat/dismemberment/dismem (6).ogg',
	)
	var/turf/location
	var/obj/item/bodypart/head/VH

	if(heads_tails)
		//Heads!
		playsound(victim, pick(goresound), 50, FALSE, -1)
		victim.visible_message(span_danger("<B>[victim]'s head bursts into gore!</B>"))
		victim.spawn_gibs()
		victim.spawn_gibs()
		victim.spawn_gibs()
		VH = victim.get_bodypart(BODY_ZONE_HEAD)
		VH.drop_limb()
		qdel(VH)
		location = get_turf(victim)
		if(istype(location))
			victim.add_splatter_floor(location)
		qdel(src)
	else //You lose!
		playsound(user, pick(goresound), 50, FALSE, -1)
		user.visible_message(span_danger("<B>[user]'s head bursts into gore!</B>"))
		user.spawn_gibs()
		user.spawn_gibs()
		user.spawn_gibs()
		VH = user.get_bodypart(BODY_ZONE_HEAD)
		VH.drop_limb()
		qdel(VH)
		location = get_turf(user)
		if(istype(location))
			user.add_splatter_floor(location)
		qdel(src)

/obj/item/roguecoin/gold/judgement/attack_right(mob/user)
	. = ..()
	if(!victim)
		var/victim_name = input(user, "Who will suffer the death penalty?", "JUDGEMENT") as text|null
		for(var/mob/living/P in GLOB.player_list)
			if(P.real_name == victim_name)
				victim = P
				return
