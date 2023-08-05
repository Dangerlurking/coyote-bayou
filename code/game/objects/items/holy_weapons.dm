/obj/item/claymore 
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags_1 = CONDUCT_1
	slot_flags = INV_SLOTBIT_BELT | INV_SLOTBIT_BACK
	force = 30
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 15
	max_integrity = 200
	armor = ARMOR_VALUE_GENERIC_ITEM
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON

// CHAPLAIN CUSTOM ARMORS //

/obj/item/clothing/head/helmet/chaplain
	name = "crusader helmet"
	desc = "Deus Vult."
	icon_state = "knight_templar"
	item_state = "knight_templar"
	armor = ARMOR_VALUE_HEAVY
	armor_tokens = (ARMOR_MODIFIER_DOWN_BULLET_T3)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 80
	dog_fashion = null

/obj/item/holybeacon
	name = "armaments beacon"
	desc = "Contains a set of armaments for the chaplain."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	item_state = "radio"

/obj/item/holybeacon/attack_self(mob/user)
	if(user.mind) // && (user.mind.isholy))
		beacon_armor(user)
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 40, 1)

/obj/item/holybeacon/proc/beacon_armor(mob/M)
	var/list/holy_armor_list = typesof(/obj/item/storage/box/holy)
	var/list/display_names = list()
	for(var/V in holy_armor_list)
		var/atom/A = V
		display_names += list(initial(A.name) = A)

	var/choice = input(M,"What holy armor kit would you like to order?","Holy Armor Theme") as null|anything in display_names
	if(QDELETED(src) || !choice || M.stat || !in_range(M, src) || M.restrained())
		return

//	var/index = display_names.Find(choice)
//	var/A = holy_armor_list[index]

//	SSreligion.holy_armor_type = A
//	var/holy_armor_box = new A

	SSblackbox.record_feedback("tally", "chaplain_armor", 1, "[choice]")

//	if(holy_armor_box)
//		qdel(src)
//		M.put_in_active_hand(holy_armor_box)///YOU COMPILED

// CITADEL CHANGES: More variants
/obj/item/clothing/head/helmet/chaplain/bland
	icon_state = "knight_generic"
	item_state = "knight_generic"

/obj/item/clothing/head/helmet/chaplain/bland/horned
	name = "horned crusader helmet"
	desc = "Helfen, Wehren, Heilen."
	icon_state = "knight_horned"
	item_state = "knight_horned"

/obj/item/clothing/head/helmet/chaplain/bland/winged
	name = "winged crusader helmet"
	desc = "Helfen, Wehren, Heilen."
	icon_state = "knight_winged"
	item_state = "knight_winged"
// CITADEL CHANGES ENDS HERE

/obj/item/clothing/suit/armor/heavy/riot/chaplain
	name = "crusader armour"
	desc = "God wills it!"
	icon_state = "knight_templar"
	item_state = "knight_templar"
	allowed = list(/obj/item/storage/book/bible, HOLY_WEAPONS, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

// CITADEL CHANGES: More variants
/obj/item/clothing/suit/armor/heavy/riot/chaplain/teutonic
	desc = "Help, Defend, Heal!"
	icon_state = "knight_teutonic"
	item_state = "knight_teutonic"

/obj/item/clothing/suit/armor/heavy/riot/chaplain/teutonic/alt
	icon_state = "knight_teutonic_alt"
	item_state = "knight_teutonic_alt"

/obj/item/clothing/suit/armor/heavy/riot/chaplain/hospitaller
	icon_state = "knight_hospitaller"
	item_state = "knight_hospitaller"
// CITADEL CHANGES ENDS HERE

/obj/item/choice_beacon/holy
	name = "armaments beacon"
	desc = "Contains a set of armaments for the chaplain."

/obj/item/choice_beacon/holy/canUseBeacon(mob/living/user)
	if(user.mind) // && user.mind.isholy)
		return ..()
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 40, 1)
		return FALSE

/obj/item/choice_beacon/holy/generate_display_names()
	var/static/list/holy_item_list
	if(!holy_item_list)
		holy_item_list = list()
		var/list/templist = typesof(/obj/item/storage/box/holy)
		for(var/V in templist)
			var/atom/A = V
			holy_item_list[initial(A.name)] = A
	return holy_item_list

/obj/item/choice_beacon/holy/spawn_option(obj/choice,mob/living/M)
	if(choice) //!GLOB.holy_armor_type)
		..()
		playsound(src, 'sound/effects/pray_chaplain.ogg', 40, 1)
		SSblackbox.record_feedback("tally", "chaplain_armor", 1, "[choice]")
		//GLOB.holy_armor_type = choice
	else
		to_chat(M, span_warning("A selection has already been made. Self-Destructing..."))
		return

/obj/item/storage/box/holy
	name = "Templar Kit"

/obj/item/storage/box/holy/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain(src)
	new /obj/item/clothing/suit/armor/heavy/riot/chaplain(src)

// CITADEL CHANGES: More Variants
/obj/item/storage/box/holy/teutonic
	name = "Teutonic Kit"

/obj/item/storage/box/holy/teutonic/PopulateContents() // It just works
	pick(new /obj/item/clothing/head/helmet/chaplain/bland/horned(src), new /obj/item/clothing/head/helmet/chaplain/bland/winged(src))
	pick(new /obj/item/clothing/suit/armor/heavy/riot/chaplain/teutonic(src), new /obj/item/clothing/suit/armor/heavy/riot/chaplain/teutonic/alt(src))

/obj/item/storage/box/holy/hospitaller
	name = "Hospitaller Kit"

/obj/item/storage/box/holy/hospitaller/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain/bland(src)
	new /obj/item/clothing/suit/armor/heavy/riot/chaplain/hospitaller(src)
// CITADEL CHANGES ENDS HERE

/obj/item/storage/box/holy/student
	name = "Profane Scholar Kit"

/obj/item/storage/box/holy/student/PopulateContents()
	new /obj/item/clothing/suit/armor/heavy/riot/chaplain/studentuni(src)
	new /obj/item/clothing/head/helmet/chaplain/cage(src)

/obj/item/clothing/suit/armor/heavy/riot/chaplain/studentuni
	name = "student robe"
	desc = "The uniform of a bygone institute of learning."
	icon_state = "studentuni"
	item_state = "studentuni"
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/head/helmet/chaplain/cage
	name = "cage"
	desc = "A cage that restrains the will of the self, allowing one to see the profane world for what it is."
	mob_overlay_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	icon_state = "cage"
	item_state = "cage"
	worn_x_dimension = 64
	worn_y_dimension = 64
	dynamic_hair_suffix = ""

/obj/item/storage/box/holy/sentinel
	name = "Stone Sentinel Kit"

/obj/item/storage/box/holy/sentinel/PopulateContents()
	new /obj/item/clothing/suit/armor/heavy/riot/chaplain/ancient(src)
	new /obj/item/clothing/head/helmet/chaplain/ancient(src)

/obj/item/clothing/head/helmet/chaplain/ancient
	name = "ancient helmet"
	desc = "None may pass!"
	icon_state = "knight_ancient"
	item_state = "knight_ancient"

/obj/item/clothing/suit/armor/heavy/riot/chaplain/ancient
	name = "ancient armour"
	desc = "Defend the treasure..."
	icon_state = "knight_ancient"
	item_state = "knight_ancient"

/obj/item/storage/box/holy/witchhunter
	name = "Witchhunter Kit"

/obj/item/storage/box/holy/witchhunter/PopulateContents()
	new /obj/item/clothing/suit/armor/heavy/riot/chaplain/witchhunter(src)
	new /obj/item/clothing/head/helmet/chaplain/witchunter_hat(src)

/obj/item/clothing/suit/armor/heavy/riot/chaplain/witchhunter
	name = "witchunter garb"
	desc = "This worn outfit saw much use back in the day."
	icon_state = "witchhunter"
	item_state = "witchhunter"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/head/helmet/chaplain/witchunter_hat
	name = "witchunter hat"
	desc = "This hat saw much use back in the day."
	icon_state = "witchhunterhat"
	item_state = "witchhunterhat"
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR

/obj/item/storage/box/holy/follower
	name = "Followers of the Chaplain Kit"

/obj/item/storage/box/holy/follower/PopulateContents()
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/leader(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)

/obj/item/clothing/suit/hooded/chaplain_hoodie
	name = "follower hoodie"
	desc = "Hoodie made for acolytes of the chaplain."
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/storage/book/bible, HOLY_WEAPONS, /obj/item/reagent_containers/food/drinks/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/head/hooded/chaplain_hood
	name = "follower hood"
	desc = "Hood made for acolytes of the chaplain."
	icon_state = "chaplain_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/hooded/chaplain_hoodie/leader
	name = "leader hoodie"
	desc = "Now you're ready for some 50 dollar bling water."
	icon_state = "chaplain_hoodie_leader"
	item_state = "chaplain_hoodie_leader"
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood/leader

/obj/item/clothing/head/hooded/chaplain_hood/leader
	name = "leader hood"
	desc = "I mean, you don't /have/ to seek bling water. I just think you should."
	icon_state = "chaplain_hood_leader"


// CHAPLAIN NULLROD AND CUSTOM WEAPONS //

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian; its very presence disrupts and dampens the powers of evil spirits."
	icon_state = "nullrod"
	item_state = "nullrod"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 18
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME
	wound_bonus = -10
	var/chaplain_spawnable = TRUE
	//total_mass = TOTAL_MASS_MEDIEVAL_WEAPON

/obj/item/nullrod/Initialize()
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/nullrod/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is killing [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to get closer to god!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/nullrod/attack_self(mob/user)
	if(user.mind && !reskinned)
		reskin_holy_weapon(user)

/**
 * reskin_holy_weapon: Shows a user a list of all available nullrod reskins and based on his choice replaces the nullrod with the reskinned version
 *
 * Arguments:
 * * M The mob choosing a nullrod reskin
 */
/obj/item/nullrod/proc/reskin_holy_weapon(mob/living/L)
	/* if(GLOB.holy_weapon_type)
		return */
	var/obj/item/holy_weapon
	var/list/holy_weapons_list = typecacheof(/obj/item/nullrod) + list(HOLY_WEAPONS)
	var/list/display_names = list()
	var/list/nullrod_icons = list()
	for(var/V in holy_weapons_list)
		var/obj/item/nullrod/rodtype = V
		if (initial(rodtype.chaplain_spawnable))
			display_names[initial(rodtype.name)] = rodtype
			nullrod_icons += list(initial(rodtype.name) = image(icon = initial(rodtype.icon), icon_state = initial(rodtype.icon_state)))

	nullrod_icons = sortList(nullrod_icons)

	var/choice = show_radial_menu(L, src , nullrod_icons, custom_check = CALLBACK(src, .proc/check_menu, L), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(L))
		return

	var/A = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	holy_weapon = new A

	//GLOB.holy_weapon_type = holy_weapon.type

	SSblackbox.record_feedback("tally", "chaplain_weapon", 1, "[choice]")

	if(holy_weapon)
		//holy_weapon.reskinned = TRUE
		qdel(src)
		L.put_in_active_hand(holy_weapon)

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 */
/obj/item/nullrod/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src) || reskinned)
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

/obj/item/nullrod/proc/jedi_spin(mob/living/user)
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(QDELETED(user) || user.incapacitated())
			return
		user.setDir(i)
		if(i == WEST)
			user.SpinAnimation(7, 1)
		sleep(1)

/obj/item/nullrod/godhand
	icon_state = "disintegrate"
	item_state = "disintegrate"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	name = "god hand"
	desc = "This hand of yours glows with an awesome power!"
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/sear.ogg'
	damtype = BURN
	attack_verb = list("punched", "cross countered", "pummeled")
	total_mass = TOTAL_MASS_HAND_REPLACEMENT

/obj/item/nullrod/godhand/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/nullrod/staff
	icon_state = "godstaff-red"
	item_state = "godstaff-red"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	name = "red holy staff"
	desc = "It has a mysterious, protective aura."
	w_class = WEIGHT_CLASS_HUGE
	force = 5
	slot_flags = INV_SLOTBIT_BACK
	block_chance = 50
	var/shield_icon = "shield-red"

/obj/item/nullrod/staff/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(isinhands)
		. += mutable_appearance('icons/effects/effects.dmi', shield_icon, MOB_LAYER + 0.01)

/obj/item/nullrod/staff/blue
	name = "blue holy staff"
	icon_state = "godstaff-blue"
	item_state = "godstaff-blue"
	shield_icon = "shield-old"

/obj/item/nullrod/claymore
	icon_state = "claymore"
	item_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "holy claymore"
	desc = "A weapon fit for a crusade!"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = INV_SLOTBIT_BACK|INV_SLOTBIT_BELT
	block_chance = 30
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/nullrod/claymore/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(attack_type & ATTACK_TYPE_PROJECTILE) // Don't bring a sword to a gunfight
		return NONE
	return ..()

/obj/item/nullrod/claymore/darkblade
	icon_state = "cultblade"
	item_state = "cultblade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	name = "dark blade"
	desc = "Spread the glory of the dark gods!"
	slot_flags = INV_SLOTBIT_BELT
	hitsound = 'sound/hallucinations/growl1.ogg'

/obj/item/nullrod/claymore/chainsaw_sword
	icon_state = "chainswordon"
	item_state = "chainswordon"
	name = "ripper"
	desc = "A miniature chainsaw, as amazing as it sounds."
	force = 45
	slot_flags = INV_SLOTBIT_BELT
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 1.5 //slower than a real saw

/obj/item/nullrod/claymore/glowing
	icon_state = "swordon"
	item_state = "swordon"
	name = "force weapon"
	desc = "The blade glows with the power of faith. Or possibly a battery."
	slot_flags = INV_SLOTBIT_BELT

/obj/item/nullrod/claymore/katana
	name = "\improper Hanzo steel"
	desc = "Capable of cutting clean through a holy claymore."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = INV_SLOTBIT_BELT | INV_SLOTBIT_BACK

/obj/item/nullrod/claymore/multiverse
	name = "extradimensional blade"
	desc = "Once the harbinger of an interdimensional war, its sharpness fluctuates wildly."
	icon_state = "multiverse"
	item_state = "multiverse"
	slot_flags = INV_SLOTBIT_BELT

/obj/item/nullrod/claymore/multiverse/attack(mob/living/carbon/M, mob/living/carbon/user)
	force = rand(1, 30)
	..()

/obj/item/nullrod/claymore/saber
	name = "light energy sword"
	hitsound = 'sound/weapons/blade1.ogg'
	icon_state = "swordblue"
	item_state = "swordblue"
	desc = "If you strike me down, I shall become more robust than you can possibly imagine."
	slot_flags = INV_SLOTBIT_BELT

/obj/item/nullrod/claymore/saber/red
	name = "dark energy sword"
	icon_state = "swordred"
	item_state = "swordred"
	desc = "Woefully ineffective when used on steep terrain."


/obj/item/nullrod/sord
	name = "\improper UNREAL SORD"
	desc = "This thing is so unspeakably HOLY you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	slot_flags = INV_SLOTBIT_BELT
	force = 4.13
	throwforce = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/nullrod/scythe
	icon_state = "scythe1"
	item_state = "scythe1"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	name = "reaper scythe"
	desc = "Ask not for whom the bell tolls..."
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = INV_SLOTBIT_BACK
	sharpness = SHARP_EDGED
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/nullrod/scythe/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 70, 110) //the harvest gives a high bonus chance

/obj/item/nullrod/scythe/vibro
	icon_state = "hfrequency0"
	item_state = "hfrequency1"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "high frequency blade"
	desc = "Bad references are the DNA of the soul."
	attack_verb = list("chopped", "sliced", "cut", "zandatsu'd")
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/nullrod/scythe/talking
	icon_state = "talking_sword"
	item_state = "talking_sword"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "possessed blade"
	desc = "When the station falls into chaos, it's nice to have a friend by your side."
	attack_verb = list("chopped", "sliced", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	var/possessed = FALSE
	reskinned = TRUE

/obj/item/nullrod/scythe/talking/process()
	for(var/mob/living/simple_animal/shade/S in contents)
		if(S.mind)
			return
		else
			qdel(S)
	possessed = FALSE
	visible_message(span_warning("The blade makes a short sigh. The spirit within seems to have passed on..."))
	return PROCESS_KILL

/obj/item/nullrod/scythe/talking/relaymove(mob/user)
	return //stops buckled message spam for the ghost.

/obj/item/nullrod/scythe/talking/attack_self(mob/living/user)
	if(possessed)
		return

	to_chat(user, "You attempt to wake the spirit of the blade...")

	possessed = TRUE

	var/list/mob/candidates = pollGhostCandidates("Do you want to play as the spirit of [user.real_name]'s blade?", ROLE_PAI, null, FALSE, 100, POLL_IGNORE_POSSESSED_BLADE)

	if(LAZYLEN(candidates))
		var/mob/C = pick(candidates)
		var/mob/living/simple_animal/shade/S = new(src)
		S.real_name = name
		S.name = name
		S.ckey = C.ckey
		S.status_flags |= GODMODE
		S.copy_languages(user, LANGUAGE_MASTER)	//Make sure the sword can understand and communicate with the user.
		S.update_atom_languages()
		grant_all_languages(FALSE, FALSE, TRUE)	//Grants omnitongue
		S.AddElement(/datum/element/ghost_role_eligibility,penalize_on_ghost = TRUE)
		START_PROCESSING(SSprocessing,src)
		var/input = stripped_input(S,"What are you named?", ,"", MAX_NAME_LEN)

		if(src && input)
			name = input
			S.real_name = input
			S.name = input
	else
		to_chat(user, "The blade is dormant. Maybe you can try again later.")
		possessed = FALSE

/obj/item/nullrod/scythe/talking/Destroy()
	for(var/mob/living/simple_animal/shade/S in contents)
		to_chat(S, "You were destroyed!")
		qdel(S)
	return ..()

/obj/item/nullrod/scythe/talking/chainsword
	icon_state = "chainswordon"
	item_state = "chainswordon"
	name = "possessed chainsaw sword"
	desc = "Suffer not a heretic to live."
	chaplain_spawnable = FALSE
	force = 30
	slot_flags = INV_SLOTBIT_BELT
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	tool_behaviour = TOOL_SAW
	toolspeed = 0.5

/obj/item/nullrod/hammmer
	icon_state = "hammeron"
	item_state = "hammeron"
	lefthand_file = 'icons/mob/inhands/weapons/hammers_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/hammers_righthand.dmi'
	name = "relic war hammer"
	desc = "This war hammer cost the chaplain forty thousand space dollars."
	slot_flags = INV_SLOTBIT_BELT
	w_class = WEIGHT_CLASS_HUGE
	attack_verb = list("smashed", "bashed", "hammered", "crunched")

/obj/item/nullrod/chainsaw_hand
	name = "chainsaw hand"
	desc = "Good? Bad? You're the guy with the chainsaw hand."
	icon_state = "chainsaw_on"
	item_state = "mounted_chainsaw"
	lefthand_file = 'icons/mob/inhands/weapons/chainsaw_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/chainsaw_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	sharpness = SHARP_EDGED
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = 'sound/weapons/chainsawhit.ogg'
	total_mass = TOTAL_MASS_HAND_REPLACEMENT
	tool_behaviour = TOOL_SAW
	toolspeed = 2

/obj/item/nullrod/chainsaw_hand/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, 30, 100, 0, hitsound)

/obj/item/nullrod/armblade
	name = "dark blessing"
	desc = "Particularly twisted deities grant gifts of dubious value."
	icon_state = "arm_blade"
	item_state = "arm_blade"
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = ABSTRACT
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	wound_bonus = -20
	bare_wound_bonus = 25
	total_mass = TOTAL_MASS_HAND_REPLACEMENT

/obj/item/nullrod/armblade/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, 80, 70)

/obj/item/nullrod/armblade/tentacle
	name = "unholy blessing"
	icon_state = "tentacle"
	item_state = "tentacle"

/obj/item/nullrod/carp
	name = "carp-sie plushie"
	desc = "An adorable stuffed toy that resembles the god of all carp. The teeth look pretty sharp. Activate it to receive the blessing of Carp-Sie."
	icon = 'icons/obj/plushes.dmi'
	icon_state = "carpplush"
	item_state = "carp_plushie"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	force = 15
	attack_verb = list("bitten", "eaten", "fin slapped")
	hitsound = 'sound/weapons/bite.ogg'

/obj/item/nullrod/carp/attack_self(mob/living/user)
	if(!user.faction.Find("carp"))
		to_chat(user, "You are blessed by Carp-Sie. Wild space carp will no longer attack you.")
		user.faction |= "carp"

/obj/item/nullrod/claymore/bostaff //May as well make it a "claymore" and inherit the blocking
	name = "monk's staff"
	desc = "A long, tall staff made of polished wood. Traditionally used in ancient old-Earth martial arts, it is now used to harass the clown."
	w_class = WEIGHT_CLASS_BULKY
	force = 15
	block_chance = 40
	slot_flags = INV_SLOTBIT_BACK
	sharpness = SHARP_NONE
	hitsound = "swing_hit"
	attack_verb = list("smashed", "slammed", "whacked", "thwacked")
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bostaff0"
	item_state = "bostaff0"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'

/obj/item/nullrod/claymore/bostaff/attack(mob/target, mob/living/user)
	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='warning'>You club yourself over the head with [src].</span>")
		user.DefaultCombatKnockdown(60)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		return ..()
	if(!isliving(target))
		return ..()
	var/mob/living/carbon/C = target
	if(C.stat || C.health < 0 || C.staminaloss > 130 )
		to_chat(user, span_warning("It would be dishonorable to attack a foe while they cannot retaliate."))
		return
	if(user.a_intent == INTENT_DISARM)
		if(!ishuman(target))
			return ..()
		var/mob/living/carbon/human/H = target
		var/list/fluffmessages = list("[user] clubs [H] with [src]!", \
									  "[user] smacks [H] with the butt of [src]!", \
									  "[user] broadsides [H] with [src]!", \
									  "[user] smashes [H]'s head with [src]!", \
									  "[user] beats [H] with front of [src]!", \
									  "[user] twirls and slams [H] with [src]!")
		H.visible_message(span_warning("[pick(fluffmessages)]"), \
							   span_userdanger("[pick(fluffmessages)]"))
		playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, 1, -1)
		H.adjustStaminaLoss(rand(12,18))
		if(prob(25))
			(INVOKE_ASYNC(src, .proc/jedi_spin, user))
	else
		return ..()

/obj/item/nullrod/tribal_knife
	icon_state = "crysknife"
	item_state = "crysknife"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "arrhythmic knife"
	w_class = WEIGHT_CLASS_HUGE
	desc = "They say fear is the true mind killer, but stabbing them in the head works too. Honour compels you to not sheathe it once drawn."
	sharpness = SHARP_EDGED
	slot_flags = null
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	item_flags = SLOWS_WHILE_IN_HAND

/obj/item/nullrod/tribal_knife/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/butchering, 50, 100)

/obj/item/nullrod/tribal_knife/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/nullrod/egyptian
	name = "egyptian staff"
	desc = "A tutorial in mummification is carved into the staff. You could probably craft the wraps if you had some cloth."
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "pharaoh_sceptre"
	item_state = "pharaoh_sceptre"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("bashes", "smacks", "whacks")

/obj/item/nullrod/rosary
	icon_state = "rosary"
	item_state = null
	name = "prayer beads"
	desc = "A set of prayer beads used by many of the more traditional religions in space"
	force = 4
	throwforce = 0
	attack_verb = list("whipped", "repented", "lashed", "flagellated")
	slot_flags = INV_SLOTBIT_NECK | INV_SLOTBIT_BELT // its a necklace lol
	var/praying = FALSE
	var/deity_name = "Giex" //This is the default, hopefully won't actually appear if the religion subsystem is running properly

/obj/item/nullrod/rosary/keep_as_is
	reskinned = TRUE

/obj/item/nullrod/rosary/Initialize()
	.=..()
	if(GLOB.deity)
		deity_name = GLOB.deity

/obj/item/nullrod/rosary/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/toy/crayon))
		var/my_little_deity = stripped_input(user, "Dedicate this to which deity?", "Insert deity", "Giex", 64, FALSE)
		if(my_little_deity)
			deity_name = my_little_deity
			to_chat(user, span_revennotice("You re-dedicate [src] to [deity_name], praise be their name."))
		else if(deity_name)
			to_chat(user, span_revennotice("You keep [src] dedicated to [deity_name], praise be their name."))
		else
			deity_name = "Giex"
			to_chat(user, span_phobia("Something went wrong, now [src] is dedicated to [deity_name], praise be their name."))
	else
		. = ..()

/obj/item/nullrod/rosary/attack(mob/living/M, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	/* if(!user.mind || user.mind.assigned_role != "Chaplain")
		to_chat(user, span_notice("You are not close enough with [deity_name] to use [src]."))
		return */

	if(praying)
		to_chat(user, span_notice("You are already using [src]."))
		return

	user.visible_message(span_info("[user] kneels[M == user ? null : " next to [M]"] and begins to utter a prayer to [deity_name]."), \
		span_info("You kneel[M == user ? null : " next to [M]"] and begin a prayer to [deity_name]."))

	praying = TRUE
	if(do_after(user, 20, target = M))
		M.reagents?.add_reagent(/datum/reagent/water/holywater, 5)
		to_chat(M, span_notice("[user]'s prayer to [deity_name] has eased your pain!"))
		M.adjustToxLoss(-5, TRUE, TRUE)
		M.adjustOxyLoss(-5)
		M.adjustBruteLoss(-5)
		M.adjustFireLoss(-5)
		praying = FALSE
	else
		to_chat(user, span_notice("Your prayer to [deity_name] was interrupted."))
		praying = FALSE
