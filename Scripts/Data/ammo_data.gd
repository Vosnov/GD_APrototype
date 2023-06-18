extends ItemData
class_name AmmoData

@export var AMMO_AMOUNT = 14
@export var MAX_AMMOUNT = 24

func calc_items(items: Array[ItemData], new_item: ItemData):
	if new_item is AmmoData:
		var ammo_datas = items.filter(func(f_item): return f_item is AmmoData)
		for inventory_item in ammo_datas:
			var free_amount = inventory_item.MAX_AMMOUNT - inventory_item.AMMO_AMOUNT
			var amount = min(free_amount, new_item.AMMO_AMOUNT)
			inventory_item.AMMO_AMOUNT += amount
			new_item.AMMO_AMOUNT -= free_amount
				
		if new_item.AMMO_AMOUNT > 0 and items.size() <= Inventory.max_size:
			items.push_back(new_item)
