extends CharacterBody3D
class_name Player

@export var HP = 6

func _ready():
	update_ui()
	check_spawn_pos()
	Events.connect('player_take_damage', _on_take_damage)

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func check_spawn_pos():
	var start_y = global_position.y
	var key = get_path().get_name(1)
	if not GlobalVariables.player_spawn_data.has(key): return
	var point = GlobalVariables.player_spawn_data.get(key) as Transform3D
	
	global_transform = point
	global_position.y = start_y

func update_ui():
	Events.emit_signal("player_hp_ui", HP)

func die():
	Events.emit_signal('player_dead')

func _on_take_damage(damage: float):
	HP = max(0, HP - damage)
	update_ui()
	if HP <= 0: die()

func _input(_event):
	GlobalVariables.player_is_aim = Input.is_action_pressed("aim")
	GlobalVariables.player_is_runing = Input.is_action_pressed("sprint")
