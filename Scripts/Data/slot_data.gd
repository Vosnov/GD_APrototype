extends Resource
class_name SlotData

@export var ITEM_DATA: ItemData

func add_to_inventory():
	Inventory.SLOTS.push_back(self)
