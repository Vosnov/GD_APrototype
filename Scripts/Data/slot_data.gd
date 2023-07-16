extends Resource
class_name SlotData

@export var ITEM_DATA: ItemData

func add_to_inventory():
	Inventory.SLOTS.push_back(self)

func get_data() -> Dictionary:
	return {
		'item_data_path': ITEM_DATA.resource_path,
		'script_path': get_script().resource_path
	}

func set_data(dict: Dictionary):
	ITEM_DATA = load(dict['item_data_path'])
