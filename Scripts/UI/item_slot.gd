extends Button
class_name ItemSlot

@onready var texture_rect = $MarginContainer/TextureRect
@onready var label = $Label
@onready var amount_label = $AmountLabel

func _ready():
	amount_label.visible = false

func set_item_data(data: ItemData):
	label.text = data.NAME
	texture_rect.texture = data.TEXTURE
	
	if data is AmmoData:
		amount_label.visible = true
		amount_label.text = str(data.AMMO_AMOUNT)
