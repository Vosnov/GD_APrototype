extends Node
class_name PlayerMovements

@export var PLAYER: Player
@export var SPEED = 1.0
@export var SMOOTH_SPEED = 6.0
@export var ROTATE_SPEED = 10
@export var AIM_ROTATE_SPEED = 6
@export var AIM_SPEED = 0.5
@export var SPRINT_SPEED = 2.0
@export var HIT_ANIM_NAME = 'Hit'

@onready var camera: Camera3D = get_tree().root.get_camera_3d()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var aiming = false
var sprinting = false
var input_dir = Vector2()
var is_stunned = false

func _ready():
	Events.connect('player_take_damage', func(_damage): is_stunned = true)

func get_speed():
	if sprinting and not aiming:
		return SPRINT_SPEED
	if aiming:
		return AIM_SPEED
	return SPEED

func movement(delta: float):
	aiming = GlobalVariables.player_is_aim
	sprinting = GlobalVariables.player_is_runing
	
	input_dir = Input.get_vector("left", "right", "top", "bottom")
	
	var basis = camera.global_transform.basis
	var direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		PLAYER.velocity = PLAYER.velocity.lerp(
			direction * get_speed(), 
			delta * SMOOTH_SPEED
		)
	else:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, 0, SPEED)
		PLAYER.velocity.z = move_toward(PLAYER.velocity.z, 0, SPEED)
	
	if aiming:
		var y = lerp_angle(PLAYER.global_rotation.y, camera.global_rotation.y, delta * AIM_ROTATE_SPEED)
		PLAYER.rotation.y = y
		
	if direction and not aiming:
		var rotate_quat = Quaternion(Vector3.UP, atan2(-direction.x, -direction.z))
		PLAYER.quaternion = PLAYER.quaternion.slerp(rotate_quat, delta * ROTATE_SPEED)
	
	if is_stunned:
		PLAYER.velocity = Vector3()
	
	if not PLAYER.is_on_floor():
		PLAYER.velocity.y -= gravity * delta
	PLAYER.move_and_slide()

func _physics_process(delta):
	movement(delta)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == HIT_ANIM_NAME:
		is_stunned = false
