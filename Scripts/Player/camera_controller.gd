extends Node3D

@export var SMOOT_ROTATE = 30.0
@export var TARGET: Node3D

var spring_enabled = false

func _ready():
	if !TARGET:
		return

func _physics_process(delta):
	if !TARGET:
		return
	
	rotation.y = lerp_angle(rotation.y, TARGET.rotation.y, delta * SMOOT_ROTATE)
	global_position = TARGET.global_position
