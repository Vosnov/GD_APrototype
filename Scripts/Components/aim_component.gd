extends Node3D

@export var TARGET_SPRITE: PackedScene
@onready var ray_cast_3d = $RayCast3D

var entered_body: Array = []
var target_sprite: Node3D
var enemy_in_ray: Enemy:
	set(value):
		if value == enemy_in_ray: return
		enemy_in_ray = value
		
		if value == null: 
			emit_remove_marker()
			return
		
		add_target_sprite(enemy_in_ray)
		Events.emit_signal("enemy_target", enemy_in_ray)

func _ready():
	Events.connect('enemy_die', _on_enemy_die)

func emit_remove_marker():
	Events.emit_signal("enemy_target_remove")
	if target_sprite != null: target_sprite.queue_free()

func remove_body(body: Node3D):
	entered_body.erase(body)
	if entered_body.size() == 0:
		enemy_in_ray = null

func _on_area_3d_body_entered(body: Node3D):
	if not entered_body.has(body):
		if body is Enemy: entered_body.push_front(body)

func _on_area_3d_body_exited(body: Node3D):
	remove_body(body)

func _on_enemy_die(enemy: Enemy):
	remove_body(enemy)

func _physics_process(_delta):
	if entered_body.size() == 0: return
	if !GlobalVariables.player_is_aim: 
		enemy_in_ray = null
		return
	
	var last_entered_body = entered_body.back()
	var aim_target = (last_entered_body as Enemy).get_aim_target()
	ray_cast_3d.look_at(aim_target.global_position, aim_target.basis.y)
	
	var collider = ray_cast_3d.get_collider()
	if collider is Enemy:
		enemy_in_ray = collider
	else: 
		enemy_in_ray = null

func add_target_sprite(enemy: Enemy):
	var aim_target = enemy.get_aim_target()
	if target_sprite != null: target_sprite.queue_free()
	target_sprite = TARGET_SPRITE.instantiate()
	aim_target.add_child(target_sprite)
