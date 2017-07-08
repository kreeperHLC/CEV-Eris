/obj/item/weapon/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	var/activation_emote = "sigh"
	var/obj/item/scanned = null
	is_legal = FALSE
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=4, TECH_BLUESPACE=5, TECH_ILLEGAL=4)

/obj/item/weapon/implant/compressed/trigger(emote, mob/living/source)
	if(!scanned)
		return

	if(emote == activation_emote)
		source << "The air glows as \the [scanned.name] uncompresses."
		activate()

/obj/item/weapon/implant/compressed/activate()
	if(wearer)
		wearer.put_in_hands(scanned)
	else
		scanned.forceMove(get_turf(src))
	qdel(src)

/obj/item/weapon/implant/compressed/on_install(mob/living/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if(source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	source << "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate."


/obj/item/weapon/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	implant = /obj/item/weapon/implant/compressed

/obj/item/weapon/implanter/compressed/update_icon()
	if(implant)
		var/obj/item/weapon/implant/compressed/c = implant
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/weapon/implanter/compressed/attack(mob/living/M, mob/living/user)
	var/obj/item/weapon/implant/compressed/c = implant
	if (!c)	return
	if (c.scanned == null)
		user << "Please scan an object with the implanter first."
		return
	..()

/obj/item/weapon/implanter/compressed/afterattack(obj/item/A, mob/user, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && implant)
		var/obj/item/weapon/implant/compressed/c = implant
		if (c.scanned)
			user << "<span class='warning'>Something is already scanned inside the implant!</span>"
			return
		if(ismob(A.loc))
			var/mob/M = A.loc
			if(!M.unEquip(A))
				return
		else if(istype(A.loc,/obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = A.loc
			S.remove_from_storage(A)

		A.forceMove(c)
		c.scanned = A
		update_icon()