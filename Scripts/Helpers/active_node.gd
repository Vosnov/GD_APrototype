extends Node3D
class_name ActiveNode

signal action_pressed

@export var SPRITE: Sprite3D
@export var AREA: Area3D

var player_in_zone = false

func _ready():
	AREA.connect('body_entered', _on_area_3d_body_entered)
	AREA.connect('body_exited', _on_area_3d_body_exited)
	SPRITE.visible = false

func _on_area_3d_body_entered(_body):
	player_in_zone = true
	SPRITE.visible = true

func _on_area_3d_body_exited(_body):
	player_in_zone = false
	SPRITE.visible = false

func _input(_event):
	if !player_in_zone: return
	if Input.is_action_just_pressed("action"):
		action_pressed.emit()

func change_sprite(sprite: Sprite3D):
	SPRITE = sprite
