extends Node3D

@export var ROTATE_SPEED = 0.6
@export var TARGET: Node3D

@onready var camera_3d = $SpringArm3D/Camera3D

func _ready():
	CameraController.connect('remove_scene_camera', _on_remove_scene_camera)

func _physics_process(_delta):
	if !TARGET:
		return
	
	global_position = TARGET.global_position

func _input(event):
	if event is InputEventMouseMotion:
		quaternion *= Quaternion(Vector3.UP, -deg_to_rad(event.relative.x) * ROTATE_SPEED)

func _on_remove_scene_camera(_camera: Camera3D):
	if CameraController.active_camera == camera_3d:
		global_rotation.y = _camera.global_rotation.y
