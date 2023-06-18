extends Resource
class_name ItemData

@export var NAME: String
@export_multiline var DESCRIPTION: String
@export var TEXTURE: Texture2D

func calc_items(items: Array[ItemData], new_item: ItemData):
	if items.size() <= Inventory.max_size:
		items.push_back(new_item)
