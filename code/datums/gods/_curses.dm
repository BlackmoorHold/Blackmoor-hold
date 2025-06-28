/mob/living/carbon/human
    var/list/curses = list()
    var/last_curse_time = 0

/mob/living/carbon/human/proc/handle_curses()
    for(var/curse in curses)
        var/datum/curse/C = curse
        C.on_life(src)

/mob/living/carbon/human/proc/add_curse(datum/curse/C)
    if(is_cursed(C))
        return FALSE

    C = new C()
    curses += C
    C.on_gain(src)
    return TRUE

/mob/living/carbon/human/proc/remove_curse(datum/curse/C)
    if(!is_cursed(C))
        return FALSE

    for(var/datum/curse/curse in curses)
        if(curse.name == C.name)
            curse.on_loss(src)
            curses -= curse
            return TRUE
    return FALSE

/mob/living/carbon/human/proc/is_cursed(datum/curse/C)
    if(!C)
        return FALSE

    for(var/datum/curse/curse in curses)
        if(curse.name == C.name)
            return TRUE
    return FALSE

/datum/curse
    var/name = "Debug Curse"
    var/description = "This is a debug curse."
    var/trait

/datum/curse/proc/on_life(mob/living/carbon/human/owner)
    return

/datum/curse/proc/on_death(mob/living/carbon/human/owner)
    return

/datum/curse/proc/on_gain(mob/living/carbon/human/owner)
    ADD_TRAIT(owner, trait, TRAIT_CURSE)
    to_chat(owner, span_userdanger("Something is wrong... I feel cursed."))
    to_chat(owner, span_danger(description))
    owner.playsound_local(get_turf(owner), 'sound/misc/excomm.ogg', 80, FALSE, pressure_affected = FALSE)
    return

/datum/curse/proc/on_loss(mob/living/carbon/human/owner)
    REMOVE_TRAIT(owner, trait, TRAIT_CURSE)
    to_chat(owner, span_userdanger("Something has changed... I feel relieved."))
    owner.playsound_local(get_turf(owner), 'sound/misc/bell.ogg', 80, FALSE, pressure_affected = FALSE)
    qdel(src)
    return

/datum/curse/astrata
    name = "Astrata's Curse"
    description = "I am forsaken by the Sun. Healing miracles have no effect on me."
    trait = TRAIT_ASTRATA_CURSE

/datum/curse/noc
    name = "Noc's Curse"
    description = "Magical knowledge is now beyond my grasp."
    trait = TRAIT_NOC_CURSE

/datum/curse/ravox
    name = "Ravox's Curse"
    description = "Violence disgusts me. I cannot bring myself to wield any kind of weapon."
    trait = TRAIT_RAVOX_CURSE

/datum/curse/necra
    name = "Necra's Curse"
    description = "Necra has claimed my soul. No one will bring me back from the dead."
    trait = TRAIT_NECRA_CURSE

/datum/curse/xylix
    name = "Xylix's Curse"
    description = "Fortune is no longer on my side."
    trait = TRAIT_XYLIX_CURSE

/datum/curse/pestra
    name = "Pestra's Curse"
    description = "I feel sick to my stomach, and my skin is slowly starting to rot."
    trait = TRAIT_PESTRA_CURSE

/datum/curse/eora
    name = "Eora's Curse"
    description = "I am unable to show any kind of affection or love, whether carnal or platonic."
    trait = TRAIT_LIMPDICK

/datum/curse/abyssor
    name = "Abyssor's Curse"
    description = "I hear the ocean whisper in my mind. Fear of drowning has left me... but so has reason."
    trait = TRAIT_ABYSSOR_CURSE

/datum/curse/malum
    name = "Malum's Curse"
    description = "My thoughts race with endless designs I cannot build. The tools tremble in my hands."
    trait = TRAIT_MALUM_CURSE


//ASStrata's Curse

/datum/curse/astrata/on_life(mob/living/carbon/human/owner)
	. = ..()
	if (!owner || owner.stat == DEAD)
		return

	if (!HAS_TRAIT(owner, TRAIT_ASTRATA_CURSE))
		return

	if (world.time % 5)
		if (GLOB.tod != "night") // 
			if (isturf(owner.loc))
				var/turf/T = owner.loc
				if (T.can_see_sky())
					if (T.get_lumcount() > 0.15) // minecraft light meme
						owner.adjust_fire_stacks(5)
						owner.IgniteMob()
						owner.visible_message(
							span_warning("[owner] sizzles painfully under Astrata's holy light!"),
							span_danger("The sun burns my cursed flesh!")
						)
						owner.freak_out()
						owner.playsound_local(T, 'sound/magic/churn.ogg', 80, FALSE, pressure_affected = FALSE)



//NOC's Curse 

/datum/curse/noc/on_life(mob/living/carbon/human/owner)
	. = ..()
	if (!owner || owner.stat == DEAD)
		return

	if (!HAS_TRAIT(owner, TRAIT_NOC_CURSE))
		return

	if (isturf(owner.loc))
		var/turf/T = owner.loc
		if (T.get_lumcount() < 0.2) // too dark
			owner.adjustToxLoss(10, 0)
			owner.visible_message(
				span_warning("[owner] writhes in pain from Noc's shadowy curse!"),
				span_danger("The darkness... it's burning inside!")
			)


//Pestra's Curse

/datum/curse/pestra/on_life(mob/living/carbon/human/owner)
	. = ..()		
	if(owner.mob_timers["pestra_curse"])
		if(world.time < owner.mob_timers["pestra_curse"] + rand(30,60)SECONDS)
			return
	owner.mob_timers["pestra_curse"] = world.time
	var/effect = rand(1, 4)
	switch(effect)
		if(1)
			owner.vomit()
		if(2)
			owner.Unconscious(20)
		if(3)
			owner.blur_eyes(10)
		if(4)
			var/obj/item/bodypart/BP = pick(owner.bodyparts)
			BP.rotted = TRUE
			owner.playsound_local(get_turf(owner), 'sound/foley/butcher.ogg', 80, FALSE, pressure_affected = FALSE)
			owner.regenerate_icons()						
