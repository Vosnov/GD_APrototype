extends BaseGun

@onready var ray_cast_3d = $RayCast3D as RayCast3D

func _override_shot():
	var damage = GUN_SLOT_DATA.DAMAGE
	if GlobalVariables.player_target_is_full: damage = GUN_SLOT_DATA.FULL_DAMAGE
	
	var colider = ray_cast_3d.get_collider()
	if colider:
		Events.enemy_take_damage.emit(colider, damage)

func _physics_process(_delta):
	if target: ray_cast_3d.look_at(target.global_position, target.global_transform.basis.y)
