/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 6
	w_class = ITEMSIZE_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'sound/items/screwdriver.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	sharp  = 1
	toolspeed = 1
	var/random_color = TRUE

/obj/item/weapon/screwdriver/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << pick("<span class='danger'>\The [user] is stabbing the [src.name] into [TU.his] temple! It looks like [TU.hes] trying to commit suicide.</span>", \
						"<span class='danger'>\The [user] is stabbing the [src.name] into [TU.his] heart! It looks like [TU.hes] trying to commit suicide.</span>")
	return(BRUTELOSS)

/obj/item/weapon/screwdriver/New()
	if(random_color)
		switch(pick("red","blue","purple","brown","green","cyan","yellow"))
			if ("red")
				icon_state = "screwdriver2"
				item_state = "screwdriver"
			if ("blue")
				icon_state = "screwdriver"
				item_state = "screwdriver_blue"
			if ("purple")
				icon_state = "screwdriver3"
				item_state = "screwdriver_purple"
			if ("brown")
				icon_state = "screwdriver4"
				item_state = "screwdriver_brown"
			if ("green")
				icon_state = "screwdriver5"
				item_state = "screwdriver_green"
			if ("cyan")
				icon_state = "screwdriver6"
				item_state = "screwdriver_cyan"
			if ("yellow")
				icon_state = "screwdriver7"
				item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	..()

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != O_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/weapon/screwdriver/is_screwdriver()
	return TRUE

/obj/item/weapon/screwdriver/alien
	name = "alien screwdriver"
	desc = "An ultrasonic screwdriver."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "screwdriver_a"
	item_state = "screwdriver_black"
	usesound = 'sound/items/pshoom.ogg'
	toolspeed = 0.1
	random_color = FALSE

/obj/item/weapon/screwdriver/cyborg
	name = "powered screwdriver"
	desc = "An electrical screwdriver, designed to be both precise and quick."
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5

/obj/item/weapon/screwdriver/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a screw bit."
	icon_state = "drill_screw"
	item_state = "drill"
	matter = list(DEFAULT_WALL_MATERIAL = 150, MAT_SILVER = 50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	slot_flags = SLOT_BELT
	force = 8
	w_class = ITEMSIZE_SMALL
	throwforce = 8
	throw_speed = 2
	throw_range = 3//it's heavier than a screw driver/wrench, so it does more damage, but can't be thrown as far
	attack_verb = list("drilled", "screwed", "jabbed", "whacked")
	hitsound = 'sound/items/drill_hit.ogg'
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.25
	random_color = FALSE
	var/obj/item/weapon/wrench/power/counterpart = null

/obj/item/weapon/screwdriver/power/New(newloc, no_counterpart = TRUE)
	..(newloc)
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/weapon/screwdriver/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		qdel(counterpart)
	return ..()

/obj/item/weapon/screwdriver/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	user.drop_item(src)
	counterpart.forceMove(get_turf(src))
	src.forceMove(counterpart)
	user.put_in_active_hand(counterpart)
	to_chat(user, "<span class='notice'>You attach the bolt driver bit to [src].</span>")
