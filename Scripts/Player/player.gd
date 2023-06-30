extends CharacterBody3D
class_name Player

@export var HP = 10

func _ready():
	update_ui()
	check_spawn_pos()
	
	#Events.connect('player_take_damage', _on_take_damage)

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func check_spawn_pos():
	var start_y = global_position.y
	if GlobalVariables.player_spawn_data == null: return
	if get_path().get_name(1) != GlobalVariables.player_spawn_data.location_name:
		return
	var point = GlobalVariables.player_spawn_data.point as Transform3D
	global_transform = point
	global_position.y = start_y

func update_ui():
	pass
	#Events.emit_signal("player_hp_ui", HP)

func _on_take_damage(damage: float):
	HP = max(0, HP - damage)
	update_ui()
