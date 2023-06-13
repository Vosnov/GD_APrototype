extends Node3D
class_name SteeringBehaviorComponent

@export var SHOW_DEBUG_LINES = false
@export var NUM_RAYS = 12
@export var RAY_RANGE = 1.0

var rays: Array[Ray] = []
var velocity = Vector3()
var has_collision = false

@onready var space_state = get_world_3d().direct_space_state

class Ray:
	var direction = Vector3()
	var enabled = true
	var ray_range = 0
	
	func _init(_ray_range: float):
		ray_range = _ray_range
	
	func get_direction():
		return direction * ray_range

func _init():
	rays.resize(NUM_RAYS)
	for i in NUM_RAYS:
		var angle = i * 2 * PI / NUM_RAYS
		rays[i] = Ray.new(RAY_RANGE)
		rays[i].direction = Vector3.RIGHT.rotated(Vector3.UP, angle)

func check_ray_collision():
	has_collision = false
	for i in NUM_RAYS:
		var ray = PhysicsRayQueryParameters3D.new()
		ray.from = global_position
		ray.to = global_position + rays[i].get_direction()
		var hit = space_state.intersect_ray(ray)
		if hit.get('collider'):
			rays[i].enabled = false
			has_collision = true
		else:
			rays[i].enabled = true

func get_velocity():
	velocity = Vector3()
	for i in NUM_RAYS:
		if rays[i].enabled:
			velocity += rays[i].direction
	velocity = velocity.normalized()

func _on_update_timer_timeout():
	check_ray_collision()
	get_velocity()
