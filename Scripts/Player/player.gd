extends CharacterBody3D
class_name Player

@export var MAX_HP = 6
@export var HP = 6

func _ready():
	update_ui()
	check_spawn_pos()
	Events.connect('player_take_damage', _on_take_damage)
	Events.connect('player_take_health', _on_take_health)

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func check_spawn_pos():
	await get_tree().process_frame #Wait until the doors are ready
	
	var y_pos = global_position.y
	for node in get_tree().get_nodes_in_group('door'):
		if node is Door:
			if node.NEXT_SCENE == GlobalVariables.door_prev_scene:
				global_transform = node.spawn_point.global_transform
				global_position.y = y_pos
				break
	
	if GlobalVariables.should_spawn_on_player_transform:
		global_transform = GlobalVariables.save_data.player_transform
		GlobalVariables.should_spawn_on_player_transform = false

func update_ui():
	Events.emit_signal("player_hp_ui", HP)

func die():
	Events.emit_signal('player_dead')

func _on_take_damage(damage: float):
	HP = max(0, HP - damage)
	update_ui()
	if HP <= 0: die()

func _input(_event):
	var is_aim = Input.is_action_pressed("aim") and GlobalVariables.active_gun_index != -1
	GlobalVariables.player_is_aim = is_aim
	GlobalVariables.player_is_runing = Input.is_action_pressed("sprint")

func _on_take_health(hp: int):
	HP = clamp(HP + hp, 0, MAX_HP)
	update_ui()
