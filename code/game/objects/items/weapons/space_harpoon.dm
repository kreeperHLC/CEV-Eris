#define MODE_RECEIVE 0
#define MODE_TRANSMIT 1

/obj/item/weapon/bluespace_harpoon
	name = "bluespace harpoon"
	desc = "For climbing on bluespace mountains!"
	icon_state = "harpoon-1"
	icon = 'icons/obj/items.dmi'
	w_class = 3.0
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH_BLUESPACE = 5)
	var/mode = MODE_TRANSMIT
	var/last_fire = 0			// time of last shot
	var/transforming = FALSE	// mode changing takes some time
	var/firing_delay = 200
	var/offset_chance = 5		//chance to teleport things in wrong place
	var/teleport_offset = 8		//radius of wrong place


/obj/item/weapon/bluespace_harpoon/afterattack(atom/A, mob/user as mob)
	if(!user || !A || user.machine)
		return
	if(transforming)
		user << "<span class = 'warning'>You can't fire while [src] transforming!</span>"
		return
	if(!(world.time - last_fire >= firing_delay))
		user << "<span class = 'warning'>[src] is recharging</span>"
		return

	last_fire = world.time

	playsound(user, 'sound/weapons/wave.ogg', 60, 1)

	for(var/mob/O in oviewers(src))
		if ((O.client && !( O.blinded )))
			O << "<span class = 'warning'>[user] fire from [src]</span>"
	user << "<span class = 'warning'>You fire from [src]</span>"

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()

	var/turf/AtomTurf = get_turf(A)
	var/turf/UserTurf = get_turf(user)

	if(mode)
		teleport(UserTurf, AtomTurf)
	else
		teleport(AtomTurf, UserTurf)

/obj/item/weapon/bluespace_harpoon/proc/teleport(var/turf/source, var/turf/target)
	for(var/atom/movable/AM in source)
		if(istype(AM, /mob/shadow))
			continue
		if(!AM.anchored)
			if(prob(offset_chance))
				AM.forceMove(get_turf(pick(orange(teleport_offset,source))))
			else
				AM.forceMove(target)

/obj/item/weapon/bluespace_harpoon/attack_self(mob/living/user as mob)
	return change_fire_mode(user)

/obj/item/weapon/bluespace_harpoon/verb/change_fire_mode(mob/user as mob)
	set name = "Change fire mode"
	set category = "Object"
	set src in oview(1)
	if(transforming)
		return
	mode = !mode
	transforming = TRUE
	user << "<span class = 'notice'>You change [src] mode to [mode ? "transmiting" : "receiving"].</span>"
	update_icon()
	flick("harpoon-[mode]-change", src)
	spawn(13)	//Average length of transforming animation
		transforming = FALSE

/obj/item/weapon/bluespace_harpoon/update_icon()
	icon_state = "harpoon-[mode]"

/obj/item/weapon/bluespace_harpoon/examine(var/mob/user, var/dist = -1)
	..(user, dist)
	user << "<span class='notice'>Mode set to [mode ? "transmiting" : "receiving"].</span>"