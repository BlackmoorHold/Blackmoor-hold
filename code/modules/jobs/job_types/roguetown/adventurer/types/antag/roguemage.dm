/datum/advclass/roguemage //mage class - like the adventurer mage, but more evil.
	name = "Rogue Mage"
	tutorial = "Those fools at the academy laughed at you and cast you from the ivory tower of higher learning and magickal practice. No matter - you will ascend to great power one day, but first you need wealth - vast amounts of it. Show those fools in the town what REAL magic looks like."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/roguemage
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/combat_bandit_mage.ogg'

/datum/outfit/job/roguetown/bandit/roguemage/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/zizo) || istype(H.patron, /datum/patron/inhumen/matthios) || istype(H.patron, /datum/patron/inhumen/graggar) || istype(H.patron, /datum/patron/inhumen/baotha)))
		to_chat(H, span_warning("My former deity has abandoned me.. Matthios is my new master."))
		H.set_patron(/datum/patron/inhumen/matthios)	//We allow other heretics into the cool-kids club, but if you are a tennite/psydonian it sets you to matthiosan.
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/book/spellbook = 1, // Spell resetting is a key identity of good mage
					)
	neck = /obj/item/clothing/neck/roguetown/coif
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	id = /obj/item/mattcoin

	r_hand = /obj/item/rogueweapon/woodstaff/toper
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE) // Jman Polearms, for better parrying without making them bandit level 
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE) //needs climbing to get into hideout
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE) // Standards for athletics is 3, give them 2
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
		ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
		if(H.age == AGE_OLD)
			head = /obj/item/clothing/head/roguetown/wizhat/gen
			armor = /obj/item/clothing/suit/roguetown/shirt/robe
			H.mind.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.change_stat("intelligence", 1)
			H.mind.adjust_spellpoints(6)
		//5 points due spells
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 2)
		H.mind.adjust_spellpoints(21) // On par with Mage Associate
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
