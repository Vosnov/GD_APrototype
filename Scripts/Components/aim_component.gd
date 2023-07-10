extends Node3D

@export var TARGET_SPRITE: PackedScene

var entered_body: Array = []
var aiming = false
var target_sprite: Node3D

func _ready():
	Events.connect('enemy_die', _on_enemy_die)

func _input(_event):
	if GlobalVariables.player_is_aim and not aiming:
		aiming = true
		should_emit_target()
	if Input.is_action_just_released("aim"):
		emit_remove_marker()
		aiming = false

func emit_remove_marker():
	Events.emit_signal("enemy_target_remove")
	if target_sprite != null: target_sprite.queue_free()

func should_emit_target():
	if entered_body.size() > 0:
		var last_entered_body = entered_body.back()
		if aiming:
			var aim_target = (last_entered_body as Enemy).get_aim_target()
			if target_sprite != null: target_sprite.queue_free()
			target_sprite = TARGET_SPRITE.instantiate()
			aim_target.add_child(target_sprite)
			
			Events.emit_signal("enemy_target", last_entered_body)

func remove_body(body: Node3D):
	entered_body.erase(body)
	if entered_body.size() == 0 and aiming:
		emit_remove_marker()
	should_emit_target()

func _on_area_3d_body_entered(body: Node3D):
	if not entered_body.has(body):
		if body is Enemy: entered_body.push_front(body)
		should_emit_target()

func _on_area_3d_body_exited(body: Node3D):
	remove_body(body)

func _on_enemy_die(enemy: Enemy):
	remove_body(enemy)
