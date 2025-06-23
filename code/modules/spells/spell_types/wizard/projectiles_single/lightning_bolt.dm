/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	name = "Bolt of Lightning"
	desc = "Emit a bolt of lightning that burns and stuns a target."
	clothes_req = FALSE
	overlay_state = "lightning"
	sound = 'sound/magic/lightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/lightning
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
	recharge_time = 25 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokelightning
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_MEDIUM
	spell_tier = 2
	invocation = "Fulmen!"
	invocation_type = "shout"
	cost = 6
	xp_gain = TRUE

/obj/projectile/magic/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 15
	damage_type = BURN
	accuracy = 40 // Base accuracy is lower for burn projectiles because they bypass armor
	nodamage = FALSE
	speed = 0.3
	flag = "magic"
	light_color = "#ffffff"
	light_outer_range = 7

/obj/projectile/magic/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
		if(L.STACON <= 14)
			L.electrocute_act(2, src, 2, SHOCK_NOSTUN)
			L.OffBalance(1 SECONDS)    // So they can't just say nuh-uh and use the jump/leap function to close the gap, yet not long enough to let the caster just jump into them.
			L.Slowdown(3)(2 SECONDS)   // While not out-right stopping a moving force, it heavily slows it down, allowing for easy casts and strikes from the caster or their comrades, keep in mind, the bolt damage itself keeps opponent slowed down for longer than 2 seconds.
		else
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			L.OffBalance(2 SECONDS)    // Allows the caster or their comrade to jump into the opponent to knock them down. (This'll make it feel less cheap due to requiring some effort, instead of being a fight ender in most cases)
			L.Immobilize(2 SECONDS)    // Makes the opponent a very easy target, if used on someone that is down, it keeps them down due to canceling their get up action.
			L.Slowdown(2)(3.5 SECONDS) // Gives a 1.5 second leeway to react to the opponent being able to move again, while giving the caster leeway to react.
qdel(src)
