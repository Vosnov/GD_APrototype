extends Node

@export var INVENTORY_DATA: InventoryData

var slots: Array[SlotData] = []
var max_size = 0

func _ready():
	Inventory.slots = INVENTORY_DATA.SLOTS
	Inventory.max_size = INVENTORY_DATA.MAX_SIZE
	
	Events.emit_signal('inventory_update', INVENTORY_DATA.SLOTS)
	Events.connect('item_pick_up', _on_item_pick_up)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('inventory_update', _on_inventory_update)

func _on_item_pick_up(item: SlotData, body: Node3D):
	var success = item.add_to_inventory()
	if success:
		body.queue_free()
		GlobalVariables.no_spawn_items.push_back(body.get_path().get_concatenated_names())
	Events.emit_signal('inventory_update', INVENTORY_DATA.SLOTS)

func _on_player_reload(amount_drop: int):
	var amount = amount_drop
	for slot_data in INVENTORY_DATA.SLOTS:
		if slot_data.ITEM_DATA is AmmoData:
			slot_data.AMOUNT -= amount
			if slot_data.AMOUNT <= 0:
				amount = abs(slot_data.AMOUNT)
			else:
				amount = 0
			if slot_data.AMOUNT <= 0: INVENTORY_DATA.SLOTS.erase(slot_data)
	Events.emit_signal('inventory_update', INVENTORY_DATA.SLOTS)

func _on_inventory_update(_slots: Array[SlotData]):
	slots = _slots
