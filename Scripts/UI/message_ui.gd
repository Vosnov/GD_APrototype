extends MarginContainer
class_name MessageUI

@onready var label = $VBoxContainer/PanelContainer/MarginContainer/Label

func set_message(message: String):
	label.text = message
