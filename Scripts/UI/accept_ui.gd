extends Panel
class_name AcceptUI

signal accept()
signal cancel()

@onready var message = $PanelContainer/MarginContainer/VBoxContainer/Message
@onready var accept_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Accept
@onready var cancel_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Cancel

@export_multiline var MESSAGE: String
@export var ACCEPT_LABEL = 'OK'
@export var CANCEL_LABEL = 'CANCEL'

func _ready():
	message.text = MESSAGE
	accept_label.text = ACCEPT_LABEL
	cancel_label.text = CANCEL_LABEL

func _on_accept_button_down():
	accept.emit()
	queue_free()


func _on_cancel_button_down():
	cancel.emit()
	queue_free()
