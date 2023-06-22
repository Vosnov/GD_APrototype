extends CharacterBody3D
class_name Player

@export var HP = 10
@export var SPEED = 1.0
@export var SMOOTH_SPEED = 6.0
@export var ROTATE_SPEED = 0.3
@export var AIM_ROTATE_SPEED = 0.1
@export var AIM_SPEED = 0.5
@export var SPRINT_SPEED = 2.0

@onready var camera: Camera3D = get_tree().root.get_camera_3d()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var aiming = false
var sprinting = false
var mouse_rotation = 0

func get_rotate_speed():
	if aiming: return AIM_ROTATE_SPEED
	return ROTATE_SPEED

func get_speed(direction: Vector2):
	if sprinting and not aiming and direction.y <= -0.5:
		return SPRINT_SPEED
	if aiming:
		return AIM_SPEED
	return SPEED

func movement(delta: float):
	sprinting = false
	aiming = false
	
	if Input.is_action_pressed('sprint'): sprinting = true
	if Input.is_action_pressed("aim"): aiming = true
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("left", "right", "top", "bottom")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity = velocity.lerp(direction * get_speed(input_dir), delta * SMOOTH_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _ready():
	update_ui()
	check_spawn_pos()
	#Events.connect('player_take_damage', _on_take_damage)

func _physics_process(delta):
	movement(delta)

func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= deg_to_rad(event.relative.x) * get_rotate_speed()
	#if Input.is_action_just_pressed("shot") and aiming:
		#Events.emit_signal("player_shot")

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
