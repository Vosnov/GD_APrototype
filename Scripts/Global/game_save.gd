extends Node

@export var SAVE_FILE_NAME = "user://save.dat"

func save():
	var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	if file == null:
		printerr("Save file error")
		return
		
	var data = {
		'slots': Inventory.SLOTS.map(func(slot): return slot.get_data()),
		'global': GlobalVariables.get_data()
	}
	file.store_string(var_to_str(data))

func load_save():
	if not FileAccess.file_exists(SAVE_FILE_NAME): 
		printerr('Load file not found')
		return
		
	var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	if file == null:
		printerr("Load file error")
		return
	
	var data = str_to_var(file.get_as_text())

	Inventory.SLOTS = parse_slots(data.slots)
	GlobalVariables.set_data(data.global)
	
	Events.inventory_update.emit()

func parse_slots(slots_dict: Array) -> Array[SlotData]:
	var new_slots: Array[SlotData] = []
	for slot_dict in slots_dict:
		var slot_script = load(slot_dict.script_path)
		var slot = slot_script.new()
		slot.set_data(slot_dict)
		new_slots.push_back(slot)
	return new_slots
