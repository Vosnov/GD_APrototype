extends MarginContainer
class_name MessageUI

@export var MESSAGE: String
@export var DESTORY_TIME = 2.5
@export var CAN_DESTORY_TIME = 0.2

@onready var label = $VBoxContainer/PanelContainer/MarginContainer/Label

var can_destory = false
var remove_message_ui_inputs = ["action", "ui_cancel", "ui_menu", "shot", "aim"]

func _ready():
	label.text = MESSAGE
	start_can_destroy_timer()
	destroy_timer()

func _exit_tree():
	Events.emit_signal("message_close_ui", MESSAGE)

func destroy_timer():
	await get_tree().create_timer(DESTORY_TIME).timeout
	queue_free()

func start_can_destroy_timer():
	can_destory = false
	await get_tree().create_timer(CAN_DESTORY_TIME).timeout
	can_destory = true

func _input(_event):
	if not can_destory: return
	for action_name in remove_message_ui_inputs:
		var is_pressed = Input.is_action_just_pressed(action_name)
		if is_pressed:
			queue_free()
