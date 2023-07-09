extends BaseGun

@export var HIT_PARTICLE: PackedScene

@onready var ray_cast_3d = $RayCast3D as RayCast3D

func _override_shot():
	var damage = GUN_SLOT_DATA.DAMAGE
	if GlobalVariables.player_target_is_full: damage = GUN_SLOT_DATA.FULL_DAMAGE
	
	var collider = ray_cast_3d.get_collider() as Node3D
	if collider:
		Events.enemy_take_damage.emit(collider, damage)
		
		var hit = HIT_PARTICLE.instantiate() as Node3D
		collider.add_child(hit)
		hit.global_position = collider.get_aim_target().global_position
		hit.look_at(global_position, hit.basis.y)

func _physics_process(_delta):
	if target: ray_cast_3d.look_at(target.global_position, target.global_transform.basis.y)
