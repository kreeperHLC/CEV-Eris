var/list/cruciform_rituals = (typesof(/datum/ritual/cruciform)-/datum/ritual/cruciform)+\
	(typesof(/datum/ritual/targeted/cruciform)-/datum/ritual/targeted/cruciform)

/datum/ritual/cruciform
	name = "cruciform"
	phrase = null
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform
	success_message = "On the verge of audibility you hear pleasant music, your mind clears up and the spirit grows stronger. Your prayer was heard."
	fail_message = "Cruciform on your chest is getting cold and pricks your skin."
	var/priest = FALSE

/datum/ritual/cruciform/is_allowed(var/obj/item/weapon/implant/external/core_implant/cruciform/C)
	return !priest || istype(C, /obj/item/weapon/implant/external/core_implant/cruciform/priest)

/datum/ritual/cruciform/get_grabbed(var/mob/living/carbon/human/user)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI

	if(G)
		CI = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in G.affecting

	return CI


/datum/ritual/targeted/cruciform
	name = "cruciform targeted"
	phrase = null
	implant_type = /obj/item/weapon/implant/external/core_implant/cruciform
	var/priest = FALSE

/datum/ritual/targeted/cruciform/is_allowed(var/obj/item/weapon/implant/external/core_implant/cruciform/C)
	return !priest || istype(C, /obj/item/weapon/implant/external/core_implant/cruciform/priest)

/datum/ritual/targeted/cruciform/get_grabbed(var/mob/living/carbon/human/user)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI

	if(G)
		CI = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in G.affecting

	return CI

/datum/ritual/cruciform/relief
	name = "relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	desc = "Short litany to relieve a pain of afflicted."
	power = 50
	chance = 33

/datum/ritual/cruciform/relief/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.add_chemical_effect(CE_PAINKILLER, 10)
	return TRUE


/datum/ritual/cruciform/soul_hunger
	name = "soul hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	desc = "Litany of piligrims, helps better withstand hunger."
	power = 50
	chance = 33

/datum/ritual/cruciform/soul_hunger/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	H.nutrition += 100
	H.adjustToxLoss(5)
	return TRUE


/datum/ritual/cruciform/entreaty
	name = "entreaty"
	phrase = "Deus meus ut quid dereliquisti me"
	desc = "Call for help, that other cruciform bearers can hear."
	power = 50
	chance = 60

/datum/ritual/cruciform/entreaty/perform(mob/living/carbon/human/H, obj/item/weapon/implant/external/core_implant/C)
	for(var/mob/living/carbon/human/target in christians)
		if(target == H)
			continue
		if(locate(/obj/item/weapon/implant/external/core_implant/cruciform/priest, target) || prob(20))
			target << "<span class='danger'>[H], faithful cruciform follower, cries for salvation!</span>"
	return TRUE


/datum/ritual/cruciform/epiphany
	name = "epiphany"
	phrase = "In nomine Patris et Filii et Spiritus sancti"
	desc = "Cyberchristianity's principal sacrament is a ritual of baptism and merging with cruciform. A body, relieved of clothes should be placed on NeoTheology corporation's  special altar."
	priest = TRUE

/datum/ritual/cruciform/epiphany/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("Cruciform not found.", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	if(CI.activated || CI.active)
		fail("This cruciform already has a soul inside.", user, C)
		return FALSE

	CI.activate()

	CI.wearer << "<span class='info'>Your cruciform vibrates and warms up.</span>"

	return TRUE

/* - This will be used later, when new cult arrive.
/datum/ritual/cruciform/banish
	name = "banish"
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"
*/

/datum/ritual/cruciform/resurrection
	name = "resurrection"
	phrase = "Qui fuit, et crediderunt in me non morietur in aeternum"
	desc = "A ritual of formation of a new body in a speclially designed machine.  Deceased person's cruciform has to be placed on the scanner then a prayer is to be uttered over the apparatus."
	priest = TRUE

/datum/ritual/cruciform/resurrection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/list/OBJS = get_front(user)

	var/obj/machinery/neotheology/cloner/pod = locate(/obj/machinery/neotheology/cloner) in OBJS

	if(!pod)
		fail("Cloner not found.", user, C)
		return FALSE

	if(pod.cloning)
		fail("Cloner is already cloning.", user, C)
		return FALSE

	if(pod.stat & NOPOWER)
		fail("Cloner is off.", user, C)
		return FALSE

	pod.start()
	return TRUE

/datum/ritual/cruciform/reincarnation
	name = "reincarnation"
	phrase = "Vetus moritur et onus hoc levaverit"
	desc = "A reunion of a spirit with it's new body, ritual of activation of a crucifrom, lying on the body. The process requires NeoTheology's special altar on which a body stripped of clothes is to be placed."
	priest = TRUE

/datum/ritual/cruciform/reincarnation/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("Cruciform not found.", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	if(!CI.activated)
		fail("This cruciform doesn't have soul inside.", user, C)
		return FALSE

	if(CI.active)
		fail("This cruciform already activated.", user, C)
		return FALSE

	if(CI.wearer.stat == DEAD)
		fail("Soul cannot move to dead body.", user, C)
		return FALSE

	var/datum/mind/MN = CI.data.mind
	if(!istype(MN, /datum/mind))
		fail("Soul is lost.", user, C)
		return FALSE
	if(MN.active)
		if(CI.data.ckey != ckey(MN.key))
			fail("Soul is lost.", user, C)
			return FALSE
	if(MN.current && MN.current.stat != DEAD)
		fail("Soul is lost.", user, C)
		return FALSE

	var/succ = CI.transfer_soul()

	if(!succ)
		fail("Soul transfer failed.", user, C)
		return FALSE

	return TRUE


/datum/ritual/cruciform/install
	name = "Commitment"
	phrase = "Unde ipse Dominus dabit vobis signum"
	desc = "This litany will command cruciform attach to person, so you can perform Reincarnation or Epiphany. Cruciform must lay near them."
	priest = TRUE

/datum/ritual/cruciform/install/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI

	if(G && G.affecting && ishuman(G.affecting))
		CI = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in G.affecting
	else
		fail("You must hold patient's hand.", user, C)
		return FALSE

	var/mob/living/H = G.affecting

	if(CI)
		fail("[H] already have a cruciform installed.", user, C)
		return FALSE

	var/list/L = get_front(user)

	CI = locate(/obj/item/weapon/implant/external/core_implant/cruciform) in L

	if(!CI)
		fail("Cruciform not found.", user, C)
		return FALSE

	if(!(H in L))
		fail("Cruciform is too far from [H].", user, C)
		return FALSE

	if(CI.active)
		fail("Cruciform already active.", user, C)
		return FALSE

	if(!H.lying || !locate(/obj/machinery/optable/altar) in L)
		fail("[H] must lie on the altar.", user, C)
		return FALSE

	for(var/obj/item/clothing/CL in H)
		if(H.l_hand == CL || H.r_hand == CL)
			continue
		fail("[H] must be undressed.", user, C)
		return FALSE

	CI.install(H)

	if(CI.wearer != H)
		fail("Install failed.", user, C)
		return FALSE

	if(ishuman(H))
		var/mob/living/carbon/human/M = H
		var/obj/item/organ/external/E = M.organs_by_name[BP_CHEST]
		E.take_damage(25)
		M.custom_pain("You feel cruciform rips into your chest!",1)
		M.update_implants()

	return TRUE


/datum/ritual/cruciform/ejection
	name = "Deprivation"
	phrase = "Et revertatur pulvis in terram suam unde erat et spiritus redeat ad Deum qui dedit illum"
	desc = "This litany will command cruciform to detach from bearer if one bearing it is dead. You will be able to attach this cruciform later, or use it in scaner for Resurrection."
	priest = TRUE

/datum/ritual/cruciform/ejection/perform(mob/living/carbon/human/user, obj/item/weapon/implant/external/core_implant/C)
	var/obj/item/weapon/implant/external/core_implant/cruciform/CI = get_grabbed(user)

	if(!CI)
		fail("Cruciform not found.", user, C)
		return FALSE

	if(!CI.wearer)
		fail("Cruciform is not installed.", user, C)
		return FALSE

	var/mob/M = CI.wearer

	if(CI.active && M.stat != DEAD)
		fail("You cannot eject active cruciform from alive christian.", user, C)
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/E = H.organs_by_name[BP_CHEST]
		E.take_damage(15)
		H.custom_pain("You feel cruciform rips out of your chest!",1)

	CI.uninstall()
	return TRUE

