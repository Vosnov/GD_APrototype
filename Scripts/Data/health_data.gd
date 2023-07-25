extends ItemData
class_name HealthData

@export var HP_RECOVERY = 2

func use():
	for slot in Inventory.SLOTS:
		if slot.ITEM_DATA != self: continue
		if slot is StackableSlotData:
			slot.AMOUNT -= 1
			if slot.AMOUNT <= 0:
				Inventory.SLOTS.erase(slot)
			
			Events.inventory_update.emit()
			Events.player_take_health.emit(HP_RECOVERY)
			return
