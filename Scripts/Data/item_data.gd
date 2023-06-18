extends Resource
class_name ItemData

@export var NAME: String
@export_multiline var DESCRIPTION: String
@export var TEXTURE: Texture2D

func calc_items(items: Array[ItemData]) -> bool:
	if items.size() < Inventory.max_size:
		items.push_back(self)
		return true
	return false
