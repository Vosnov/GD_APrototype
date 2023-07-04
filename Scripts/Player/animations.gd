extends Node

@export var PLAYER: CharacterBody3D
@export var PLAYER_MOVEMENTS: PlayerMovements
@export var ANIMATION_TREE: AnimationTree
@export var IWR_SMOOTH = 8.0

var input_dir = Vector2()
var is_aim = false
var is_run = false
var message_is_open = false

var relative_x = 0.0
var lerp_relative_x = 0.0

func _ready():
	Events.connect("message_ui", func(_message): message_is_open = true)
	Events.connect("message_close_ui", func(): message_is_open = false)
	
	Events.connect('player_shot', _on_player_shot)
	Events.connect('player_reload', _on_player_reload)
	Events.connect('player_take_damage', _on_take_damage)

func _physics_process(delta):
	if message_is_open:
		input_dir = input_dir.lerp(Vector2(), delta * 10)
		ANIMATION_TREE.set("parameters/walk_iwr/blend_position", input_dir)
		ANIMATION_TREE.set('parameters/main_trans/transition_request', 'walk')
		return
	
	is_aim = false
	is_run = false
	input_dir = input_dir.lerp(PLAYER_MOVEMENTS.input_dir, delta * IWR_SMOOTH)
	
	if Input.is_action_pressed("aim"):
		is_aim = true
	if Input.is_action_pressed("sprint") and input_dir.y <= -0.5:
		is_run = true
	
	if is_run and not is_aim:
		ANIMATION_TREE.set('parameters/main_trans/transition_request', 'run')
		ANIMATION_TREE.set("parameters/reload_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	else:
		ANIMATION_TREE.set('parameters/main_trans/transition_request', 'walk')
	
	if is_aim:
		ANIMATION_TREE.set('parameters/aim_trans/transition_request', 'aim')
	else:
		ANIMATION_TREE.set('parameters/aim_trans/transition_request', 'not_aim')

	ANIMATION_TREE.set("parameters/walk_iwr/blend_position", input_dir.length())
	
	if input_dir.length() > 0.2:
		ANIMATION_TREE.set("parameters/aim_iwr/blend_position", input_dir)
	else:
		lerp_relative_x = lerpf(lerp_relative_x, relative_x, delta)
		relative_x = lerpf(relative_x, 0, delta * 10)
		ANIMATION_TREE.set("parameters/aim_iwr/blend_position", Vector2(lerp_relative_x, lerp_relative_x))

func _input(event):
	if event is InputEventMouseMotion:
		relative_x = clampf(event.relative.x, -1, 1)
	if Input.is_action_just_released("aim"):
		ANIMATION_TREE.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func _on_player_reload(_amount_drop: int):
	ANIMATION_TREE.set("parameters/reload_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_player_shot():
	ANIMATION_TREE.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_take_damage(_damage: float):
	ANIMATION_TREE.set("parameters/hit_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
