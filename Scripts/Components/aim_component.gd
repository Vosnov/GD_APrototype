extends Node3D

var entered_body: Array = []
var aiming = false

func _input(_event):
	if Input.is_action_just_pressed("aim"):
		aiming = true
		should_emit_target()
	if Input.is_action_just_released("aim"):
		emit_remove_marker()
		aiming = false

func emit_remove_marker():
	Events.emit_signal("enemy_target_remove")

func should_emit_target():
	if entered_body.size() > 0:
		var last_entered_body = entered_body.back()
		if aiming: Events.emit_signal("enemy_target", last_entered_body)

func _on_area_3d_body_entered(body: Node3D):
	if not entered_body.has(body):
		if body is Enemy: entered_body.push_front(body)
		should_emit_target()

func _on_area_3d_body_exited(body: Node3D):
	entered_body.erase(body)
	if entered_body.size() == 0 and aiming:
		emit_remove_marker()
	should_emit_target()
