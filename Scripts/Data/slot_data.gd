extends Resource
class_name SlotData

@export var ITEM_DATA: ItemData
@export var AMOUNT = 14

func add_to_inventory() -> bool:
	# for StackableItemData
	if ITEM_DATA is StackableItemData:
		var f_slots = Inventory.slots.filter(func(slot: SlotData): return slot.ITEM_DATA == ITEM_DATA)
		
		for slot in f_slots as Array[SlotData]:
			var free_amount = ITEM_DATA.MAX_AMOUNT - slot.AMOUNT
			var amount = min(free_amount, AMOUNT)
			slot.AMOUNT += amount
			AMOUNT -= free_amount
			AMOUNT = clamp(AMOUNT, 0, ITEM_DATA.MAX_AMOUNT)
		
		if AMOUNT <= 0:
			return true
		if AMOUNT > 0 and Inventory.slots.size() < Inventory.max_size:
			Inventory.slots.push_back(self)
			return true
	
	# for ITEM_DATA
	if Inventory.slots.size() < Inventory.max_size:
		Inventory.slots.push_back(self)
		return true
	return false
