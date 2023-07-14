extends Node3D

@export var ROTATE_SPEED = 0.6
@export var TARGET: Node3D

@onready var camera_3d = $SpringArm3D/Camera3D

func _ready():
	global_rotation.y = TARGET.global_rotation.y

func _physics_process(_delta):
	if !TARGET:
		return
	
	global_position = TARGET.global_position

func _input(event):
	if event is InputEventMouseMotion:
		quaternion *= Quaternion(Vector3.UP, -deg_to_rad(event.relative.x) * ROTATE_SPEED)
