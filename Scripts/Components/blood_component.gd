extends Node3D
class_name BloodComponent

@export var BLOOD_MESH: PackedScene
@export var BLOOD_PARTICLE: PackedScene

@onready var ray_cast_3d = $RayCast3D
@onready var root = get_tree().root
@onready var spawn_blood_mesh_timer = $SpawnBloodMeshTimer
@onready var spawn_blood_mesh_timeout = $SpawnBloodMeshTimeout

func _on_timer_timeout():
	if ray_cast_3d.collide_with_bodies:
		var pos = ray_cast_3d.get_collision_point()
		pos.y += 0.01
		pos.x += randf_range(-0.25, 0.25)
		pos.z += randf_range(-0.25, 0.25)
		var blood = BLOOD_MESH.instantiate() as Node3D
		root.add_child(blood)
		blood.global_position = pos
		blood.rotate_y(randf_range(-PI, PI))
		var blood_scale = randf_range(0.5, 1)
		blood.global_scale(Vector3(blood_scale, blood_scale, blood_scale))
		
func take_damage():
	var blood_particle = BLOOD_PARTICLE.instantiate() as Node3D
	root.add_child(blood_particle)
	blood_particle.global_position = global_position
	blood_particle.global_rotation = global_rotation
	
	spawn_blood_mesh_timer.start(spawn_blood_mesh_timer.wait_time)
	spawn_blood_mesh_timeout.start(spawn_blood_mesh_timeout.wait_time)

func _on_spawn_b_lood_mesh_timeout_timeout():
	spawn_blood_mesh_timer.stop()
