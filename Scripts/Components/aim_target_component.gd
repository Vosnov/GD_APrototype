extends Node3D

@export var ENEMY: Enemy

@onready var aim_icon = $AimIcon
@onready var anim_player = $AnimationPlayer

var is_aim_target = false
var is_full_target = false

func _ready():
	set_target(false)
	Events.connect('enemy_target', _on_aim_target)
	Events.connect('enemy_target_remove', _on_aim_target_remove)
	Events.connect('player_shot', _on_player_shot)

func set_target(value: bool):
	is_full_target = false
	
	aim_icon.visible = value
	is_aim_target = value
	
	if value:
		anim_player.play("aim_target_anim")
	else:
		anim_player.stop()

func _on_aim_target(_enemy: Enemy):
	set_target(false)
	if _enemy == ENEMY:
		set_target(true)
		
func _on_aim_target_remove():
	set_target(false)

func _on_animation_player_animation_finished(_anim_name):
	is_full_target = true

func _on_player_shot():
	if is_aim_target:
		if is_full_target:
			Events.emit_signal("enemy_take_damage", ENEMY, 1.0)
		else:
			anim_player.seek(0, true)
			Events.emit_signal("enemy_take_damage", ENEMY, 0.5)
