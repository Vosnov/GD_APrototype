extends Node3D

@export var TARGET: Node3D

@onready var camera_3d = $SpringArm3D/Camera3D

var screen_dpi = 96


func _ready():
	print(screen_dpi)
	global_rotation.y = TARGET.global_rotation.y

func _physics_process(_delta):
	if !TARGET:
		return
	
	global_position = TARGET.global_position

func _input(event):
	if event is InputEventMouseMotion:
		var value = event.relative.x / screen_dpi * GlobalVariables.setting_mouse
		quaternion *= Quaternion(Vector3.UP, -value)
