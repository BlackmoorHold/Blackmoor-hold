/datum/ritual/dark_armaments
	name = "Dark Armaments"
	tutorial = "Stand in the middle. Candles should lie ablaze at your cardinals."
	incantation = "Zizo! Blood and souls for my Lord Zizo!"
	ingredient_map = list(
		"N" = /obj/item/candle,
		"W" = /obj/item/candle,
		"C" = /mob/living/carbon/human,
		"E" = /obj/item/candle,
		"S" = /obj/item/candle,
	)
	consumption = TRUE

/datum/ritual/dark_armaments/ritual_effects(var/list/ingredients)
	. = ..()
	var/mob/living/carbon/human/cultist = ingredients["C"] //We don't check if they're part of the cabal in case you for whatever reason want to trap someone in Zizoid armour
	var/turf/T = get_turf(cultist)
	cultist.Stun(20) //People are going to come running
	cultist.Knockdown(20)
	to_chat(cultist, span_userdanger("UNIMAGINABLE PAIN!"))
	cultist.emote("Agony")
	playsound(T, 'sound/combat/newstuck.ogg', 50)
	T.visible_message(span_cult("Great hooks come from the rune, embedding into [cultist]'s ankles, pulling them onto the rune. Then, into their wrists. An opaque membrane of blood congeals around their form."))
	spawn(20)
		playsound(T, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		cultist.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
		cultist.cmode_music = 'sound/music/combat_rogve.ogg'
		// cultist.apply_status_effect(/datum/status_effect/debuff/devitalised) This status effect is apparently giganerfed or something
		spawn(40)
			to_chat(cultist, span_purple("Truly, truly, I say to you, unless you eat the flesh of the Son of Man and drink his blood, you have no life in you."))
	return
