extends MarginContainer
class_name SlotGunUI

@onready var texture_rect = $TextureRect

func set_slot_data(data: ItemGunData):
	texture_rect.texture = data.TEXTURE
