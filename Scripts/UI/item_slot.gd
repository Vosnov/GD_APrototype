extends MarginContainer
class_name SlotUI

@export var SLOT: SlotData

@onready var label = $Panel/VBoxContainer/Label
@onready var amount_label = $Panel/VBoxContainer/Content/AmountLabel
@onready var texture_rect = $Panel/VBoxContainer/Content/TextureRect

func _ready():
	amount_label.visible = false
	
	label.text = SLOT.ITEM_DATA.NAME
	texture_rect.texture = SLOT.ITEM_DATA.TEXTURE
	
	if SLOT is StackableSlotData:
		amount_label.visible = true
		amount_label.text = str(SLOT.AMOUNT)
