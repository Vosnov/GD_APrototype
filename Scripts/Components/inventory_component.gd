extends Node
class_name InventoryComponent

@export var INVENTORY_DATA: InventoryData

func _ready():
	Inventory.items = INVENTORY_DATA.ITEMS
	Events.emit_signal('inventory_update', INVENTORY_DATA.ITEMS)
	Events.connect('item_pick_up', _on_item_pick_up)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('inventory_update', _on_inventory_update)

func _on_item_pick_up(item: ItemData):
	INVENTORY_DATA.ITEMS.push_back(item)
	Events.emit_signal('inventory_update', INVENTORY_DATA.ITEMS)

func _on_player_reload(amount_drop: int):
	for item in INVENTORY_DATA.ITEMS:
		if item is AmmoData:
			item.AMMO_AMOUNT -= amount_drop
			if item.AMMO_AMOUNT <= 0: INVENTORY_DATA.ITEMS.erase(item)
			Events.emit_signal('inventory_update', INVENTORY_DATA.ITEMS)
			return

func _on_inventory_update(items: Array[ItemData]):
	Inventory.items = items
