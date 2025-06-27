/datum/job/roguetown/prisonerb
	title = "Prisoner (Bog)"
	flag = PRISONERB
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	family_blacklisted = TRUE

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	tutorial = "How does it feel to be the rat in the cage? You're alone and at the mercy of your captors, kept around as a hostage. You spend your days waiting for the oft chance someone comes to pay your ransom. Might as well start praying to whatever god you find solace in."

	outfit = /datum/outfit/job/roguetown/prisonerr
	bypass_jobban = TRUE
	display_order = JDO_PRISONERB
	give_bank_account = 10
	min_pq = -14
	max_pq = null
	can_random = FALSE

	cmode_music = 'sound/music/combat_bum.ogg'

	advclass_cat_rolls = list(CTAG_PRISONER = 20)

/datum/job/roguetown/prisonerb/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

/datum/job/roguetown/prisonerb/special_check_latejoin(client/C)
	return FALSE
