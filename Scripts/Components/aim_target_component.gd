extends Node3D

@onready var aim_icon = $AimIcon
@onready var anim_player = $AnimationPlayer

var is_aim_target = false
var is_full_target = false

func _ready():
	anim_player.play("aim_target_anim")
	Events.connect('player_shot', _on_player_shot)
	GlobalVariables.player_target_is_full = false

func _on_animation_player_animation_finished(_anim_name):
	is_full_target = true
	GlobalVariables.player_target_is_full = true

func _on_player_shot(_gun_slot):
	if not is_full_target:
		anim_player.seek(0, true)
