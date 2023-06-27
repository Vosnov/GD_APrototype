extends Node

@export var PLAYER: CharacterBody3D
@export var PLAYER_MOVEMENTS: PlayerMovements
@export var ANIMATION_TREE: AnimationTree
@export var IWR_SMOOTH = 8.0

var input_dir = Vector2()
var is_aim = false
var is_run = false

func _ready():
	Events.connect('player_shot', _on_player_shot)
	Events.connect('player_reload', _on_player_reload)

func _physics_process(delta):
	is_aim = false
	is_run = false
	input_dir = input_dir.lerp(Input.get_vector("left", "right", "top", "bottom"), delta * IWR_SMOOTH)
	
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
	
	ANIMATION_TREE.set("parameters/aim_iwr/blend_position", input_dir)

func _input(_event):
	if Input.is_action_just_released("aim"):
		ANIMATION_TREE.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func _on_player_reload(_amount_drop: int):
	ANIMATION_TREE.set("parameters/reload_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_player_shot():
	ANIMATION_TREE.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
