extends Node3D

@export var SKELETON: Skeleton3D
@export var BONE_NAME: String
@export var SPEED = 6.0

var target: Enemy
var amount = 0
var skelet_quat: Quaternion
var bone_index = 0

func _ready():
	bone_index = SKELETON.find_bone(BONE_NAME)
	Events.connect("enemy_target", _on_aim_component_enemy_target)
	Events.connect("enemy_target_remove", _on_aim_component_enemy_target_remove)

func _process(delta):
	if target != null and target.is_dead:
		target = null
	
	if target == null:
		amount = clamp(amount - delta * SPEED, 0, 1)
	if target != null:
		amount = clamp(amount + delta * SPEED, 0, 1)
		global_transform.basis = global_transform.looking_at(target.get_aim_target()).basis
		
	var pos = SKELETON.get_bone_global_pose_no_override(bone_index)
	var quat = quaternion
	quat.x = -quat.x + SKELETON.get_bone_pose_rotation(bone_index).x
	skelet_quat = skelet_quat.slerp(quat.normalized(), delta * SPEED)
	pos.basis *= Basis(skelet_quat)
	SKELETON.set_bone_global_pose_override(bone_index, pos, amount, true)


func _on_aim_component_enemy_target(body: Enemy):
	target = body

func _on_aim_component_enemy_target_remove():
	target = null
