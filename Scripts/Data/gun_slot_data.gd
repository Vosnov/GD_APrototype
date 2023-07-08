extends SlotData
class_name GunSlotData

@export var DAMAGE = 1.0
@export var AMMO_LOADED = 9
@export var MAX_AMMO_LOADED = 9
@export var SHOT_TIMEOUT = 1.0
@export var RELOAD_TIMEOUT = 1.0
@export var DROP_AMMO = 1

func add_to_inventory():
	Inventory.GUN_SLOTS.push_back(self)
