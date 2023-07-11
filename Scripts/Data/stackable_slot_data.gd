extends SlotData
class_name StackableSlotData

@export var AMOUNT = 14

func add_to_inventory():
	var inventory_slot = get_inventory_slot()
	if inventory_slot:
		inventory_slot.AMOUNT += AMOUNT
	else:
		Inventory.SLOTS.push_back(self)

func get_inventory_slot() -> StackableSlotData:
	for slot in Inventory.SLOTS:
		if slot.ITEM_DATA == ITEM_DATA:
			return slot
	return null
