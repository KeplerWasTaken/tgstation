#define NO_DRILLER 0
// 0->1 Place Driller
// 1->0 Crowbar
#define DRILLER_PLACED 1
// 1->2 Wrench
// 2->1 Wrench
#define DRILLER_WRENCHED 2
// 2->3 Screw
// 3->2 Screw
#define DRILLER_SCREWED 3
// 3->4 Hand
// 4->3 Hand
// 4->3 Exhausted
#define DRILLER_ON 4

/obj/item/stack/proc/returnamount(amount)
	if(!use(amount))
		return
	return new type(src, amount, FALSE, mats_per_unit)
