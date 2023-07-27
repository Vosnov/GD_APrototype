extends Node

@export var SLOTS: Array[SlotData] = []

@onready var pick_up_stream = $PickUpStream

func _ready():
	Events.emit_signal('inventory_update')
	Events.connect('item_pick_up', _on_item_pick_up)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('inventory_remove_item', _on_inventory_remove_item)

func _on_item_pick_up(_item: SlotData, _body: Node3D):
	pick_up_stream.play()

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
	Events.emit_signal('inventory_update')

func _on_inventory_remove_item(item: ItemData):
	for slot in SLOTS:
		if slot.ITEM_DATA == item:
			SLOTS.erase(slot)
			Events.emit_signal('inventory_update')
			return

func get_slots_without_guns():
	var slots: Array[SlotData] = []
	for slot in SLOTS:
		if slot.ITEM_DATA is ItemGunData: continue
		slots.push_back(slot)
	return slots
