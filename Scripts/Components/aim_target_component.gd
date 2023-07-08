extends Node3D

@export var ENEMY: Enemy

@onready var aim_icon = $AimIcon
@onready var anim_player = $AnimationPlayer

var is_aim_target = false
var is_full_target = false

func _ready():
	reset_target()
	Events.connect('enemy_target', _on_aim_target)
	Events.connect('enemy_target_remove', _on_aim_target_remove)
	Events.connect('player_shot', _on_player_shot)

func set_target():
	is_aim_target = true
	anim_player.play("aim_target_anim")
	aim_icon.visible = true
	is_full_target = false

func reset_target():
	is_aim_target = false
	anim_player.stop()
	aim_icon.visible = false
	is_full_target = false

func _on_aim_target(_enemy: Enemy):
	if _enemy == ENEMY and not is_aim_target:
		set_target()
	
	if _enemy != ENEMY:
		reset_target()
		
func _on_aim_target_remove():
	reset_target()

func _on_animation_player_animation_finished(_anim_name):
	is_full_target = true

func _on_player_shot(gun_slot: GunSlotData):
	if is_aim_target:
		if is_full_target:
			Events.emit_signal("enemy_take_damage", ENEMY, gun_slot.DAMAGE)
		else:
			anim_player.seek(0, true)
			Events.emit_signal("enemy_take_damage", ENEMY, gun_slot.DAMAGE / 2)
