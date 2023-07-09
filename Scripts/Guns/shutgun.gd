extends BaseGun

@export var FRACTION_COUNT = 6
@export var V_RANGE = 0.2
@export var H_RANGE = 0.4
@export var RAY_DISTANCE = 8.0
@export_flags_3d_physics var RAY_COLLISION
@export var HIT_PARTICLE: PackedScene

@onready var space_state = get_world_3d().direct_space_state
@onready var look_at_enemy_node = $LookAtEnemyNode

func _init():
	randomize()

func _override_shot():
	var damage = GUN_SLOT_DATA.DAMAGE
	if GlobalVariables.player_target_is_full: damage = GUN_SLOT_DATA.FULL_DAMAGE
	var enemys: Array[Enemy] = []
	
	for i in range(FRACTION_COUNT):
		var dir = Vector3(randf_range(-H_RANGE, H_RANGE), randf_range(-V_RANGE, V_RANGE), -1) * RAY_DISTANCE
		var to = (look_at_enemy_node.global_transform.basis * dir) + global_position
		
		var ray = PhysicsRayQueryParameters3D.new()
		ray.from = global_position
		ray.to = to
		ray.collision_mask = RAY_COLLISION
		var hit = space_state.intersect_ray(ray)
		var collider = hit.get('collider')
		if collider:
			if !enemys.has(collider): enemys.push_back(collider)
			Events.enemy_take_damage.emit(collider, damage)
	
	for enemy in enemys:
		var hit_particle = HIT_PARTICLE.instantiate() as Node3D
		enemy.add_child(hit_particle)
		hit_particle.global_position = enemy.get_aim_target().global_position
		hit_particle.look_at(global_position, hit_particle.basis.y)

func _physics_process(_delta):
	if target != null: look_at_enemy_node.look_at(
		target.global_position,
		look_at_enemy_node.global_transform.basis.y
	)
