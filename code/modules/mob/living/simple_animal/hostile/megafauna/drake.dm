#define DRAKE_SWOOP_HEIGHT 270 //how high up drakes go, in pixels
#define DRAKE_SWOOP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from

#define SWOOP_DAMAGEABLE 1
#define SWOOP_INVULNERABLE 2

///used whenever the drake generates a hotspot
#define DRAKE_FIRE_TEMP 500
///used whenever the drake generates a hotspot
#define DRAKE_FIRE_EXPOSURE 50

/*

ASH DRAKE

Ash drakes spawn randomly wherever a lavaland creature is able to spawn. They are the draconic guardians of the Necropolis.

It acts as a melee creature, chasing down and attacking its target while also using different attacks to augment its power that increase as it takes damage.

Whenever possible, the drake will breathe fire in the four cardinal directions, igniting and heavily damaging anything caught in the blast.
It also often causes fire to rain from the sky - many nearby turfs will flash red as a fireball crashes into them, dealing damage to anything on the turfs.
The drake also utilizes its wings to fly into the sky, flying after its target and attempting to slam down on them. Anything near when it slams down takes huge damage.
- Sometimes it will chain these swooping attacks over and over, making swiftness a necessity.
- Sometimes, it will spew fire while flying at its target.

When an ash drake dies, it leaves behind a chest that can contain four things:
1. A spectral blade that allows its wielder to call ghosts to it, enhancing its power
2. A lava staff that allows its wielder to create lava
3. A spellbook and wand of fireballs
4. A bottle of dragon's blood with several effects, including turning its imbiber into a drake themselves.

When butchered, they leave behind diamonds, sinew, bone, and ash drake hide. Ash drake hide can be used to create a hooded cloak that protects its wearer from ash storms.

Difficulty: Medium

*/

/mob/living/simple_animal/hostile/megafauna/dragon
	name = "ash drake"
	desc = "Guardians of the necropolis."
	health = 2500
	maxHealth = 2500
	spacewalk = TRUE
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomp"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	icon = 'icons/mob/lavaland/64x64megafauna.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("roars")
	melee_damage_lower = 50
	melee_damage_upper = 100
	speed = 1
	move_to_delay = 5
	ranged = 1
	pixel_x = -16
	crusher_loot = list(/obj/structure/closet/crate/necropolis/dragon/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/dragon)
	guaranteed_butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/bone = 30, /obj/item/stack/sheet/animalhide/ashdrake = 10)
	var/swooping = NONE
	var/swoop_cooldown = 0
	medal_type = BOSS_MEDAL_DRAKE
	score_type = DRAKE_SCORE
	deathmessage = "collapses into a pile of bones, its flesh sloughing away."
	death_sound = 'sound/magic/demon_dies.ogg'
	var/datum/action/small_sprite/smallsprite = new/datum/action/small_sprite/drake()

	footstep_type = FOOTSTEP_MOB_HEAVY

/mob/living/simple_animal/hostile/megafauna/dragon/Initialize()
	smallsprite.Grant(src)
	. = ..()
	internal = new/obj/item/gps/internal/dragon(src)

/mob/living/simple_animal/hostile/megafauna/dragon/ex_act(severity, target)
	if(severity == 3)
		return
	..()

/mob/living/simple_animal/hostile/megafauna/dragon/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!forced && (swooping & SWOOP_INVULNERABLE))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/dragon/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, mob/target, target_message, visible_message_flags = NONE)
	if(swooping & SWOOP_INVULNERABLE) //to suppress attack messages without overriding every single proc that could send a message saying we got hit
		return
	return ..()

/mob/living/simple_animal/hostile/megafauna/dragon/AttackingTarget()
	if(!swooping)
		return ..()

/mob/living/simple_animal/hostile/megafauna/dragon/DestroySurroundings()
	if(!swooping)
		..()

/mob/living/simple_animal/hostile/megafauna/dragon/Move()
	if(!swooping)
		..()

/mob/living/simple_animal/hostile/megafauna/dragon/Goto(target, delay, minimum_distance)
	if(!swooping)
		..()

/mob/living/simple_animal/hostile/megafauna/dragon/OpenFire()
	if(swooping)
		return
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + ranged_cooldown_time
	if(client)
		return
	if(prob(15 + anger_modifier))
		if(health < maxHealth/2)
			INVOKE_ASYNC(src,PROC_REF(swoop_attack), TRUE, null, 50)
		else
			fire_rain()

	else
		if(health > maxHealth/2)
			INVOKE_ASYNC(src,PROC_REF(swoop_attack))
		else
			INVOKE_ASYNC(src,PROC_REF(triple_swoop))

/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_rain()
	var/atom/my_target = get_target()
	if(!my_target)
		return
	my_target.visible_message(span_boldwarning("Fire rains from the sky!"))
	for(var/turf/turf in range(9,get_turf(my_target)))
		if(prob(11))
			new /obj/effect/temp_visual/target(turf)

/*
/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_walls()
	playsound(get_turf(src),'sound/magic/fireball.ogg', 200, 1)

	for(var/d in GLOB.cardinals)
		INVOKE_ASYNC(src,PROC_REF(fire_wall), d)

/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_wall(dir)
	var/list/hit_things = list(src)
	var/turf/E = get_edge_target_turf(src, dir)
	var/range = 10
	var/turf/previousturf = get_turf(src)
	for(var/turf/J in getline(src,E))
		if(!range || (J != previousturf && (!previousturf.atmos_adjacent_turfs || !previousturf.atmos_adjacent_turfs[J])))
			break
		range--
		new /obj/effect/hotspot(J)
		J.hotspot_expose(DRAKE_FIRE_TEMP, DRAKE_FIRE_EXPOSURE, 1)
		for(var/mob/living/L in J.contents - hit_things)
			if(istype(L, /mob/living/simple_animal/hostile/megafauna/dragon))
				continue
			L.adjustFireLoss(20)
			to_chat(L, span_userdanger("You're hit by the drake's fire breath!"))
			hit_things += L
		previousturf = J
		sleep(1)
*/

/mob/living/simple_animal/hostile/megafauna/dragon/proc/triple_swoop()
	swoop_attack(swoop_duration = 30)
	swoop_attack(swoop_duration = 30)
	swoop_attack(swoop_duration = 30)

/mob/living/simple_animal/hostile/megafauna/dragon/proc/swoop_attack(fire_rain, atom/movable/manual_target, swoop_duration = 40)
	if(stat || swooping)
		return
	if(manual_target)
		GiveTarget(manual_target)
	var/atom/my_target = get_target()
	if(!my_target)
		return
	swoop_cooldown = world.time + 200
	stop_automated_movement = TRUE
	swooping |= SWOOP_DAMAGEABLE
	density = FALSE
	icon_state = "shadow"
	visible_message(span_boldwarning("[src] swoops up high!"))

	var/negative
	var/initial_x = x
	if(my_target.x < initial_x) //if the my_target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(my_target.x > initial_x)
		negative = FALSE
	else if(my_target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)
	var/obj/effect/temp_visual/dragon_flight/F = new /obj/effect/temp_visual/dragon_flight(loc, negative)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = transform
	alpha = 255
	animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1)
		if(QDELETED(src) || stat == DEAD) //we got hit and died, rip us
			qdel(F)
			if(stat == DEAD)
				swooping &= ~SWOOP_DAMAGEABLE
				animate(src, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
	swooping |= SWOOP_INVULNERABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	sleep(7)
	var/list/flame_hit = list()
	while(swoop_duration > 0)
		if(!my_target && !FindTarget())
			break //we lost our my_target while chasing it down and couldn't get a new one
		if(swoop_duration < 7)
			fire_rain = FALSE //stop raining fire near the end of the swoop
		if(loc == get_turf(my_target))
			if(!fire_rain)
				break //we're not spewing fire at our targette, slam they
			if(isliving(my_target))
				var/mob/living/L = my_target
				if(L.stat == DEAD)
					break //my_target is dead and we're on em, slam they
		if(fire_rain)
			new /obj/effect/temp_visual/target(loc, flame_hit)
		forceMove(get_step(src, get_dir(src, my_target)))
		if(loc == get_turf(my_target))
			if(!fire_rain)
				break
			if(isliving(my_target))
				var/mob/living/L = my_target
				if(L.stat == DEAD)
					break
		var/swoop_speed = 1.5
		swoop_duration -= swoop_speed
		sleep(swoop_speed)

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(x, initial_x + 1, initial_x + DRAKE_SWOOP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(x, initial_x - DRAKE_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE
	new /obj/effect/temp_visual/dragon_flight/end(loc, negative)
	new /obj/effect/temp_visual/dragon_swoop(loc)
	animate(src, alpha = 255, transform = oldtransform, time = 5)
	sleep(5)
	swooping &= ~SWOOP_INVULNERABLE
	mouse_opacity = initial(mouse_opacity)
	icon_state = "dragon"
	playsound(loc, 'sound/effects/meteorimpact.ogg', 200, 1)
	for(var/mob/living/L in orange(1, src))
		if(L.stat)
			visible_message(span_warning("[src] slams down on [L], crushing [L.p_them()]!"))
			L.adjustBruteLoss(30)
		else
			L.adjustBruteLoss(75)
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(src, L)
				if(L.loc == loc)
					throw_dir = pick(GLOB.alldirs)
				var/throwtarget = get_edge_target_turf(src, throw_dir)
				L.throw_at(throwtarget, 3)
				visible_message(span_warning("[L] is thrown clear of [src]!"))

	for(var/mob/M in range(7, src))
		shake_camera(M, 15, 1)

	density = TRUE
	sleep(1)
	swooping &= ~SWOOP_DAMAGEABLE
	SetRecoveryTime(MEGAFAUNA_DEFAULT_RECOVERY_TIME)

/mob/living/simple_animal/hostile/megafauna/dragon/AltClickOn(atom/movable/A)
	if(!istype(A))
		AltClickNoInteract(src, A)
		return
	if(swoop_cooldown >= world.time)
		to_chat(src, span_warning("You need to wait 20 seconds between swoop attacks!"))
		return
	swoop_attack(TRUE, A, 25)

/obj/item/gps/internal/dragon
	icon_state = null
	gpstag = "Fiery Signal"
	desc = "Here there be dragons."
	invisibility = 100


/obj/effect/temp_visual/fireball
	icon = 'icons/obj/wizard.dmi'
	icon_state = "fireball"
	name = "fireball"
	desc = "Get out of the way!"
	layer = FLY_LAYER
	randomdir = FALSE
	duration = 9
	pixel_z = DRAKE_SWOOP_HEIGHT

/obj/effect/temp_visual/fireball/Initialize()
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/target
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 9

/obj/effect/temp_visual/target/ex_act()
	return

/obj/effect/temp_visual/target/Initialize(mapload, list/flame_hit)
	. = ..()
	INVOKE_ASYNC(src,PROC_REF(fall), flame_hit)

/obj/effect/temp_visual/target/proc/fall(list/flame_hit)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, 1)
	new /obj/effect/temp_visual/fireball(T)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	playsound(T, "explosion", 80, 1)
	new /obj/effect/hotspot(T)
	T.hotspot_expose(700, 50, 1)
	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/megafauna/dragon))
			continue
		if(islist(flame_hit) && !flame_hit[L])
			L.adjustFireLoss(40)
			to_chat(L, span_userdanger("You're hit by the drake's fire breath!"))
			flame_hit[L] = TRUE
		else
			L.adjustFireLoss(10) //if we've already hit them, do way less damage

/obj/effect/temp_visual/dragon_swoop
	name = "certain death"
	desc = "Don't just stand there, move!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "landing"
	plane = MOB_PLANE
	layer = BELOW_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
	color = "#FF0000"
	duration = 5

/obj/effect/temp_visual/dragon_flight
	icon = 'icons/mob/lavaland/64x64megafauna.dmi'
	icon_state = "dragon"
	plane = MOB_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -16
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/dragon_flight/Initialize(mapload, negative)
	. = ..()
	INVOKE_ASYNC(src,PROC_REF(flight), negative)

/obj/effect/temp_visual/dragon_flight/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(3)
	icon_state = "swoop"
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)

/obj/effect/temp_visual/dragon_flight/end
	pixel_x = DRAKE_SWOOP_HEIGHT
	pixel_z = DRAKE_SWOOP_HEIGHT
	duration = 5

/obj/effect/temp_visual/dragon_flight/end/flight(negative)
	if(negative)
		pixel_x = -DRAKE_SWOOP_HEIGHT
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)

/mob/living/simple_animal/hostile/megafauna/dragon/lesser
	name = "lesser ash drake"
	maxHealth = 200
	health = 200
	faction = list("neutral")
	obj_damage = 80
	melee_damage_upper = 30
	melee_damage_lower = 30
	mouse_opacity = MOUSE_OPACITY_ICON
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	loot = list()
	crusher_loot = list()
	guaranteed_butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/bone = 30)

/mob/living/simple_animal/hostile/megafauna/dragon/lesser/grant_achievement(medaltype,scoretype)
	return

//fire line keeps going even if dragon is deleted
/proc/dragon_fire_line(source, list/turfs)
	var/list/hit_list = list()
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		new /obj/effect/hotspot(T)
		T.hotspot_expose(DRAKE_FIRE_TEMP,DRAKE_FIRE_EXPOSURE,1)
		for(var/mob/living/L in T.contents)
			if(L in hit_list || L == source)
				continue
			hit_list += L
			L.adjustFireLoss(20)
			to_chat(L, span_userdanger("You're hit by [source]'s fire breath!"))

		// deals damage to mechs
		for(var/obj/mecha/M in T.contents)
			if(M in hit_list)
				continue
			hit_list += M
			M.take_damage(45, BRUTE, "melee", 1)
		sleep(1.5)
