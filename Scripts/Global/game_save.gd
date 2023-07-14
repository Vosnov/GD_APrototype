extends Node

@export var PATH = 'user://'
@export var SAVE_FILE_NAME = "save"
@export var EXTENSION = '.dat'

func save(index: int):
	var file = FileAccess.open(get_file_name(index), FileAccess.WRITE)
	if file == null:
		printerr("Save file error")
		return
		
	var data = {
		'slots': Inventory.SLOTS.map(func(slot): return slot.get_data()),
		'global': GlobalVariables.get_data(),
	}
	file.store_string(var_to_str(data))

func load_save(index: int):
	var file = load_file(index)
	if file == null: return
	
	var data = str_to_var(file.get_as_text())

	Inventory.SLOTS = parse_slots(data.slots)
	GlobalVariables.set_data(data.global)
	
	Events.inventory_update.emit()

func load_file(index: int) -> FileAccess:
	if not FileAccess.file_exists(get_file_name(index)): 
		printerr('Save file not found')
		return null
		
	var file = FileAccess.open(get_file_name(index), FileAccess.READ)
	if file == null:
		printerr("Cant read save file")
		return null
	return file

func get_save_data(index: int):
	var file = load_file(index)
	if file == null: return null
	var data = str_to_var(file.get_as_text())
	return data.global.save_data

func get_file_name(index: int) -> String:
	return str(PATH, SAVE_FILE_NAME, '_', index, EXTENSION)

func parse_slots(slots_dict: Array) -> Array[SlotData]:
	var new_slots: Array[SlotData] = []
	for slot_dict in slots_dict:
		var slot_script = load(slot_dict.script_path)
		var slot = slot_script.new()
		slot.set_data(slot_dict)
		new_slots.push_back(slot)
	return new_slots
