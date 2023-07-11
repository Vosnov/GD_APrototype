extends MarginContainer
class_name SlotGunUI

@onready var texture_rect = $TextureRect

func set_slot_data(slot: GunSlotData):
	texture_rect.texture = slot.ITEM_DATA.TEXTURE
