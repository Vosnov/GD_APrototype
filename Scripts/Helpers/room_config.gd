extends Node
class_name RoomConfig

@onready var center = $Center

func _ready():
	if not GlobalVariables.visited_rooms.has(owner.scene_file_path):
		GlobalVariables.visited_rooms.push_back(owner.scene_file_path)

func get_doors() -> Array[Door]:
	var doors: Array[Door] = []
	
	for child in get_children():
		if child is Door:
			doors.push_back(child)
	return doors

func get_scene_path():
	return owner.scene_file_path

func get_center_pos() -> Vector3:
	return center.global_position
