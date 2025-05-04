/obj/item/stock_parts/power_store
	is_attachment = TRUE
	applicable_slots = list(ATTACHMENT_CELL_SMALL)

/obj/item/gun/energy
	modular_initial_slots = list(/obj/item/stock_parts/power_store/cell)
	modular_slots_available = list(ATTACHMENT_CELL_SMALL = 1)
	modular_required_to_operate = list(ATTACHMENT_CELL_SMALL = 1)

/obj/item
	var/list/obj/item/stock_parts/power_store/cells = list()

/obj/item/proc/has_power_cell()
	if (!cells || cells.len == 0)
		return FALSE
	return TRUE

/obj/item/proc/emp_power_cells(var/severity)
	for(var/obj/item/stock_parts/power_store/cell in cells)
		cell.emp_act(severity)

/obj/item/proc/cells_give_power(var/power)
	var/remaining_charge = power
	var/amount_charged_total = 0
	for(var/obj/item/stock_parts/power_store/cell in cells)
		var/amount_charged = cell.give(power)
		remaining_charge -= amount_charged
		amount_charged_total += amount_charged
	return amount_charged_total

/obj/item/proc/cells_get_percent()
	return (cells_get_charge() / cells_get_max_charge()) * 100

/obj/item/proc/cells_get_charge()
	var/total = 0
	for(var/obj/item/stock_parts/power_store/cell in cells)
		total += cell.charge
	return total

/obj/item/proc/cells_set_charge(var/amount)
	var/remaining_charge = amount
	for(var/obj/item/stock_parts/power_store/cell in cells)
		cell.charge = min(remaining_charge, cell.maxcharge)
		remaining_charge -= cell.charge

/obj/item/proc/cells_consume_charge(var/amount)
	var/remaining_charge = amount
	var/amount_used_total = 0
	for(var/obj/item/stock_parts/power_store/cell in cells)
		var/amount_used = cell.use(remaining_charge)
		remaining_charge -= amount_used
		amount_used_total += amount_used
	return amount_used_total

/obj/item/proc/cells_get_max_charge()
	var/total = 0
	for(var/obj/item/stock_parts/power_store/cell in cells)
		total += cell.maxcharge
	return total

/obj/item/proc/cells_get_used_charge()
	var/total = 0
	for(var/obj/item/stock_parts/power_store/cell in cells)
		total += cell.used_charge()
	return total

/obj/item/proc/cells_get_next_uncharged()
	for(var/obj/item/stock_parts/power_store/cell in cells)
		if (cell.charge != cell.maxcharge)
			return cell
	return null
