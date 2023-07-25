extends Button
class_name SlotUI

@export var SLOT: SlotData

@onready var texture_rect = $MarginContainer/TextureRect
@onready var label = $Label
@onready var amount_label = $AmountLabel
@onready var action_menu = $ActionMenu
@onready var use = $ActionMenu/PanelContainer2/MarginContainer/VBoxContainer/Use

func _ready():
	amount_label.visible = false
	action_menu.visible = false
	
	use.visible = SLOT.ITEM_DATA.CAN_USE
	
	label.text = SLOT.ITEM_DATA.NAME
	texture_rect.texture = SLOT.ITEM_DATA.TEXTURE
	
	if SLOT is StackableSlotData:
		amount_label.visible = true
		amount_label.text = str(SLOT.AMOUNT)

func _on_button_down():
	if not SLOT.ITEM_DATA.CAN_USE: return 
	action_menu.visible = true


func _on_use_button_down():
	SLOT.ITEM_DATA.use()
	action_menu.visible = false
