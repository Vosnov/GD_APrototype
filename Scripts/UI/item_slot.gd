extends Button
class_name SlotUI

@onready var texture_rect = $MarginContainer/TextureRect
@onready var label = $Label
@onready var amount_label = $AmountLabel

func _ready():
	amount_label.visible = false

func set_slot_data(slot: SlotData):
	label.text = slot.ITEM_DATA.NAME
	texture_rect.texture = slot.ITEM_DATA.TEXTURE
	
	if slot is StackableSlotData:
		amount_label.visible = true
		amount_label.text = str(slot.AMOUNT)
