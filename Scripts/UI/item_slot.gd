extends PanelContainer
class_name ItemSlot

@onready var texture_rect = $MarginContainer/TextureRect
@onready var label = $Label

func set_item_data(data: ItemData):
	label.text = data.NAME
	texture_rect.texture = data.TEXTURE
