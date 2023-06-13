extends Node3D

@export var SMOOT_ROTATE = 30.0
@export var TARGET: Node3D

var start_height = 0
var spring_enabled = false

func _ready():
	if !TARGET:
		return
	start_height = TARGET.global_position.y

func _physics_process(delta):
	if !TARGET:
		return
	
	rotation.y = lerp_angle(rotation.y, TARGET.rotation.y, delta * SMOOT_ROTATE)
	global_position = TARGET.global_position
	global_position.y -= start_height
