/datum/advclass/iconoclast //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Iconoclast"
	tutorial = "Trained by an Ecclesial sect, you uphold the Ideological purity of the Matthian Creed. Take from the wealthy, give to the worthless, empower. They will look up to you, in search of the God of Robbery's guidance. Be their light in the dark."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/iconoclast
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1 // We only want one of these.
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE) //if you are gonna be a thief cleric be a proper one.
	H.mind.adjust_skillrank(/datum/skill/magic/holy, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	r_hand = /obj/item/rogueweapon/woodstaff
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	head = /obj/item/clothing/head/roguetown/roguehood
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	id = /obj/item/mattcoin
	//5 points cause we can do prayers and rituals.
	H.change_stat("strength", -1)
	H.change_stat("perception", 2)
	H.change_stat("intelligence", 3)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //nothing will go wrong totally
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)
