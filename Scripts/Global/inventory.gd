extends Node

@export var SLOTS: Array[SlotData] = []
@export var GUN_SLOTS: Array[GunSlotData] = []

func _ready():
	Events.emit_signal('inventory_update', SLOTS)
	Events.connect('item_pick_up', _on_item_pick_up)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('inventory_remove_item', _on_inventory_remove_item)

func _on_item_pick_up(item: SlotData, body: Node3D):
	item.add_to_inventory()
	body.queue_free()
	GlobalVariables.no_spawn_items.push_back(body.get_path().get_concatenated_names())
	Events.emit_signal('inventory_update', SLOTS)

func _on_player_reload(amount_drop: int):
	var amount = amount_drop
	for slot_data in SLOTS:
		if slot_data.ITEM_DATA is AmmoData and slot_data is StackableSlotData:
			slot_data.AMOUNT -= amount
			if slot_data.AMOUNT <= 0:
				amount = abs(slot_data.AMOUNT)
			else:
				amount = 0
			if slot_data.AMOUNT <= 0: SLOTS.erase(slot_data)
	Events.emit_signal('inventory_update', SLOTS)

func _on_inventory_remove_item(item: ItemData):
	for slot in SLOTS:
		if slot.ITEM_DATA == item:
			SLOTS.erase(slot)
			Events.emit_signal('inventory_update', SLOTS)
			return
