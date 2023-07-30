extends Node2D
class_name MapRoom

@export_file('*.tscn') var SCENE_PATH

@onready var center = $Center

var doors: Dictionary = {}

func _ready():
	for child in get_children():
		if child is MapDoor:
			var touch_door_name = str(SCENE_PATH, '_', child.NAME)
			if GlobalVariables.touched_doors.has(touch_door_name):
				child.STATE = GlobalVariables.touched_doors[touch_door_name]

func get_center_pos() -> Vector2:
	return center.global_position
