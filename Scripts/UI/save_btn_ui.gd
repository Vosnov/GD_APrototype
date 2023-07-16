extends Button
class_name SaveBtnUI

@export var IS_EMPTY = false
@export var SAVE_INDEX = 0
@export var SAVE_NAME: String
@export var LEVEL_NAME: String
@export var DATE: String

@onready var v_box_container = $Control/VBoxContainer
@onready var slot_name = $SlotName
@onready var level_name = $Control/VBoxContainer/LevelName
@onready var date = $Control/VBoxContainer/Date
@onready var empty_label = $Control/EmptyLabel

func _ready():
	slot_name.text = tr(SAVE_NAME) % [SAVE_INDEX + 1]
	
	if IS_EMPTY:
		v_box_container.visible = false
		empty_label.visible = true
		return
	
	level_name.text = LEVEL_NAME
	date.text = DATE
