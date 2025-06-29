/mob/living/carbon/human/species/abomination
	race = /datum/species/abomination
	footstep_type = FOOTSTEP_MOB_MOIST

/datum/species/abomination
	name = "???"
	id = "abomination"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_ZJUMP,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_NOROGSTAM,
		TRAIT_BASHDOORS,
		TRAIT_SHOCKIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY,
		TRAIT_TOXIMMUNE,
		TRAIT_ORGAN_EATER,
		TRAIT_NASTY_EATER,
		TRAIT_NOSTINK,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NODISMEMBER, //If you've seen this thing it's simply not possible
		TRAIT_IGNORESLOWDOWN,
		TRAIT_LONGSTRIDER,
		TRAIT_NOPAINSTUN,
		TRAIT_CHUNKYFINGERS
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE, SLOT_HANDS)
	nojumpsuit = 1
	sexes = 1
	soundpack_m = /datum/voicepack/abomination
	soundpack_f = /datum/voicepack/abomination
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/werewolf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/knotted/big,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	languages = list(
		/datum/language/common,
	)

/datum/intent/unarmed/abomination
	name = "stab"
	icon_state = "instrike"
	blade_class = BCLASS_STAB
	attack_verb = list("eviscerates")
	animname = "stab"
	hitsound = list('sound/combat/hits/abom_attack.ogg')
	penfactor = 90 //They don't deal too much damage even with 20 strength, and can't use weapons at all
	candodge = TRUE
	canparry = TRUE
	miss_text = "probes at the air!"
	item_d_type = "stab"

/mob/living/carbon/human/proc/abomination_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	to_chat(src, span_cultitalic("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/datum/species/abomination/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/abomination.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/abomination)
	if(H.gender == MALE)
		H.icon_state = "abom_m"
	else
		H.icon_state = "abom_m"
	return TRUE

/datum/species/abomination/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/abomination/abom_speech1.ogg','sound/vo/mobs/abomination/abom_speech2.ogg',
	'sound/vo/mobs/abomination/abom_speech3.ogg', 'sound/vo/mobs/abomination/abom_speech4.ogg', 'sound/vo/mobs/abomination/abom_speech5.ogg', 'sound/vo/mobs/abomination/abom_speech6.ogg'), 100, TRUE, -1)

/datum/species/abomination/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/abomination/random_name(gender,unique,lastname)
	return "???"
