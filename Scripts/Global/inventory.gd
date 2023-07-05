extends Node

@export var INVENTORY_DATA: InventoryData

var slots: Array[SlotData] = []
var max_size = 0

func _ready():
	slots = INVENTORY_DATA.SLOTS
	max_size = INVENTORY_DATA.MAX_SIZE
	
	Events.emit_signal('inventory_update', INVENTORY_DATA.SLOTS)
	Events.connect('item_pick_up', _on_item_pick_up)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('inventory_remove_item', _on_inventory_remove_item)

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

func _on_inventory_remove_item(item: ItemData):
	for slot in INVENTORY_DATA.SLOTS:
		if slot.ITEM_DATA == item:
			INVENTORY_DATA.SLOTS.erase(slot)
			Events.emit_signal('inventory_update', INVENTORY_DATA.SLOTS)
			return
