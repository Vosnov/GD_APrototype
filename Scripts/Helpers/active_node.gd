extends Node3D
class_name ActiveNode

signal action_pressed

@export var SPRITE: PackedScene
@export var AREA: Area3D

var player_in_zone = false
var sprite: Node

func _ready():
	AREA.connect('body_entered', _on_area_3d_body_entered)
	AREA.connect('body_exited', _on_area_3d_body_exited)

func _on_area_3d_body_entered(_body):
	player_in_zone = true
	if SPRITE:
		sprite = SPRITE.instantiate()
		add_child(sprite)

func _on_area_3d_body_exited(_body):
	player_in_zone = false
	if sprite: sprite.queue_free()

func _input(_event):
	if !player_in_zone: return
	if Input.is_action_just_pressed("action"):
		action_pressed.emit()
