/obj/item/modular_attachment/fueltank
    var/capacity = 20

/obj/item/reagent_containers/reagent_tank
    name = "Fueltank"
    volume = "10"

/obj/item
    var/obj/item/reagent_containers/reagent_tank/fuel_tank

/obj/item/proc/CanUseFuel(amount)

