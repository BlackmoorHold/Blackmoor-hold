/mob/living/carbon/human
    var/list/curses = list()

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
    trait = TRAIT_EORA_CURSE

/datum/curse/abyssor
    name = "Abyssor's Curse"
    description = "I can no longer distinguish reality from delusion."
    trait = TRAIT_ABYSSOR_CURSE

/datum/curse/malum
    name = "Malum's Curse"
    description = "Dark thoughts consume me. I see evil everywhere."
    trait = TRAIT_MALUM_CURSE
