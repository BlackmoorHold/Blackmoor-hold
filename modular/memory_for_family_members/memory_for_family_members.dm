// Check comments with "family_changes" for all related code.

/mob/living/carbon/human
	var/spouse_ckey = null // Ckey второго члена семьи (жены или мужа)
	var/family_surname = null // Фамилия семьи
	var/list/family_genitals = list("Male", "Female", "Futa", "Cuntboy") // Допустимые гениталии у партнёра
	var/allow_latejoin_family = TRUE // Разрешается ли формирование семьи после начала раунда
	var/old_real_name = null // Имя, которое присвоилось до выставления имени семьи



/datum/controller/subsystem/family/proc/SetupFamilies_Short(mob/living/carbon/human/newcomer)
	// Check if this is a royal family member
	var/datum/job/newcomer_job = SSjob.GetJob(newcomer.job)
	if(newcomer_job?.ruler_family)
		// Case 1: Lord late-joining - gather existing royal family members
		if(istype(newcomer_job, /datum/job/roguetown/lord))
			var/list/existing_royal_family = list()
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(!H.client || H == newcomer)
					continue
				var/datum/job/J = SSjob.GetJob(H.job)
				if(J?.ruler_family)
					existing_royal_family += H
			
			if(length(existing_royal_family))
				// Create lord's family and add existing royal members
				var/duke_surname = newcomer.family_surname
				if(!duke_surname)
					// If duke has no surname, create "of [duke's firstname]"
					var/list/duke_name_parts = splittext(newcomer.real_name, " ")
					duke_surname = "of [duke_name_parts[1]]"
				var/datum/family/lord_family = SSfamily.makeFamily(newcomer, duke_surname)
				for(var/mob/living/carbon/human/royal_member in existing_royal_family)
					// Don't change existing players' names mid-round - just add them to family
					lord_family.addMember(royal_member)
					var/datum/job/J = SSjob.GetJob(royal_member.job)
					var/rel_type = J.lord_rel_type
					// Fix: newcomer is the Duke, royal_member is the family member
					lord_family.addRel(royal_member, newcomer, rel_type, TRUE)  // Family member -> Duke
					lord_family.addRel(newcomer, royal_member, getMatchingRel(rel_type), TRUE)  // Duke -> Family member
				
				// Set up relationships between family members using shared function
				SSfamily.setupRoyalFamilyRelationships(lord_family, newcomer)
				return
		
		// Case 2: Other royal family member joining existing lord's family
		else
			for(var/mob/living/carbon/human/H in GLOB.mob_list)
				if(!H.client || !H.family)
					continue
				var/datum/job/J = SSjob.GetJob(H.job)
				if(istype(J, /datum/job/roguetown/lord))
					// Handle surname like regular family members
					var/duke_surname = H.family_surname
					if(!duke_surname)
						// If duke has no surname, create "of [duke's firstname]"
						var/list/duke_name_parts = splittext(H.real_name, " ")
						duke_surname = "of [duke_name_parts[1]]"
					
					if(duke_surname)
						for(var/datum/mind/MF in get_minds()) // Remove from memory since they were known by different name at round start
							newcomer.mind.become_unknown_to(MF)
						
						var/list/name_parts = splittext(newcomer.old_real_name, " ")
						newcomer.real_name = "[name_parts[1]] [duke_surname]" // Change name to first name + duke's surname
						newcomer.name = newcomer.real_name
						for(var/X in J.peopleknowme) // Add new name to lists
							for(var/datum/mind/MF in get_minds(X))
								newcomer.mind.person_knows_me(MF)
					
					H.family.addMember(newcomer)
					var/rel_type = newcomer_job.lord_rel_type
					H.family.addRel(newcomer, H, rel_type, TRUE)
					H.family.addRel(H, newcomer, getMatchingRel(rel_type), TRUE)
					
					// Set up relationships between family members using shared function
					SSfamily.setupRoyalFamilyRelationships(H.family, H)
					return
	
	var/add_to_potentials_poll = TRUE
	var/datum/family/F = new() // Виртуальная семья, нужная только для сравнения кандидатов на совместимость
	for(var/mob/living/carbon/human/candidate in family_candidates)
		if(lowertext(newcomer.client.prefs.spouse_ckey))
			if(lowertext(newcomer.client.prefs.spouse_ckey) == candidate.ckey) // у newcomer должен стоять ckey, который прописан у candidate
				if(lowertext(candidate.client?.prefs.spouse_ckey) == newcomer.ckey) // у кандидата должен стоять ckey, который прописан у newcomer
					// Если фамилии не одинаковые, дропаем семью
					if(candidate.family_surname != newcomer.family_surname)
						to_chat(newcomer, span_danger("Вы чувствуете, что только что была попытка создать семью... Но ваши фамилии оказались разными."))
						to_chat(candidate, span_danger("Вы чувствуете, что только что была попытка создать семью... Но ваши фамилии оказались разными."))
						add_to_potentials_poll = FALSE
						break
			else
				continue
		// Чтобы бандит или заключенный не имели семью кроме случаев, когда это предусмотрено наличием spouse_ckey
		if(!candidate.allow_latejoin_family)
			continue
		if(newcomer_job?.family_blacklisted)
			break
		if(newcomer_job?.ruler_family)
			break 
		var/datum/job/candidate_job = SSjob.GetJob(candidate.job)
		if(candidate_job?.family_blacklisted)
			continue 
		if(candidate_job?.ruler_family)
			continue 
		// Такая же проверка, как при создании семьи. На всякий случай, чтобы избежать знать в браке с простолюдинами и другие проблемы
		if(F.checkFamilyCompat(candidate,newcomer,REL_TYPE_SPOUSE) && F.checkFamilyCompat(newcomer,candidate,REL_TYPE_SPOUSE))
			var/mob/family_head = candidate
			var/mob/family_member = newcomer
			if(candidate.family_surname)
				for(var/datum/mind/MF in get_minds()) // Т.к. со старта раунд известны под другим именем, удаляем его
					newcomer.mind.become_unknown_to(MF)
				
				newcomer.real_name = "[newcomer.old_real_name] [candidate.family_surname]" // Меняем имя на имя + фамилия у главы семьи
				for(var/X in newcomer_job.peopleknowme) // добавляем новое имя в списки
					for(var/datum/mind/MF in get_minds(X))
						newcomer.mind.person_knows_me(MF)
			else
				family_head = newcomer
				family_member = candidate
			var/datum/family/real_family = makeFamily(family_head)
			real_family.addMember(family_member)
			real_family.addRel(newcomer,candidate,getMatchingRel(REL_TYPE_SPOUSE),TRUE)
			real_family.addRel(candidate,newcomer,REL_TYPE_SPOUSE,TRUE)

			family_candidates -= candidate
			add_to_potentials_poll = FALSE
			break
	qdel(F)
	// Если не удалось найти пару, добавляем в пулл ждунов
	if(add_to_potentials_poll)
		family_candidates += newcomer

// Начисление триумфов супругам за соитие
/datum/sex_controller/after_intimate_climax()
	. = ..()
	if(user.isFamily(target))
		if(!target.mob_timers["cumfamily"])
			target.mob_timers["cumfamily"] = world.time
			to_chat(target, "I have been with my spouse!")
			target.adjust_triumphs(3)
		if(!user.mob_timers["cumfamily"])
			user.mob_timers["cumfamily"] = world.time
			to_chat(user, "I have been with my spouse!")
			user.adjust_triumphs(3)

