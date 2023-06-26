extends Node
class_name PlayerMovements

@export var PLAYER: Player
@export var SPEED = 1.0
@export var SMOOTH_SPEED = 6.0
@export var ROTATE_SPEED = 10
@export var AIM_ROTATE_SPEED = 0.1
@export var AIM_SPEED = 0.5
@export var SPRINT_SPEED = 2.0

var camera: Camera3D
var active_camera: Camera3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var aiming = false
var sprinting = false

func get_speed():
	if sprinting and not aiming:
		return SPRINT_SPEED
	if aiming:
		return AIM_SPEED
	return SPEED

func get_active_camera_basis() -> Basis:
	var quat = Quaternion(active_camera.global_transform.basis)
	quat.x = 0
	quat.z = 0
	return Basis(quat)

func movement(delta: float):
	sprinting = false
	aiming = false
	
	if Input.is_action_pressed('sprint'): sprinting = true
	if Input.is_action_pressed("aim"): aiming = true
	
	if not PLAYER.is_on_floor():
		PLAYER.velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("left", "right", "top", "bottom")
	
	var basis = get_active_camera_basis()
	var direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		PLAYER.velocity = PLAYER.velocity.lerp(
			direction * get_speed(), 
			delta * SMOOTH_SPEED
		)
	else:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, 0, SPEED)
		PLAYER.velocity.z = move_toward(PLAYER.velocity.z, 0, SPEED)
	
	if not active_camera.is_in_group('scene_camera') and aiming:
		PLAYER.rotation.y = active_camera.global_rotation.y
		#PLAYER.global_transform.basis.y = active_camera.global_transform.basis.y
	
	if direction and not aiming:
		var rotate_quat = Quaternion(Vector3.UP, atan2(-direction.x, -direction.z))
		PLAYER.quaternion = PLAYER.quaternion.slerp(rotate_quat, delta * ROTATE_SPEED)
	PLAYER.move_and_slide()

func _ready():
	camera = get_tree().root.get_camera_3d()
	active_camera = camera
	
	Events.connect('player_set_scene_camera', _on_set_camera)
	Events.connect('player_remove_scene_camera', _on_remove_camera)
	#Events.connect('player_take_damage', _on_take_damage)

func _physics_process(delta):
	movement(delta)


func _input(event):
	#aim rotate when scene camera active
	if not active_camera.is_in_group('scene_camera'): return 
	if not aiming: return
	if event is InputEventMouseMotion:
		PLAYER.quaternion *= Quaternion(Vector3.UP, -deg_to_rad(event.relative.x) * AIM_ROTATE_SPEED)
		
func _on_set_camera(_camera: Camera3D):
	active_camera = _camera

func _on_remove_camera(_camera: Camera3D):
	if active_camera == _camera:
		active_camera = null 
