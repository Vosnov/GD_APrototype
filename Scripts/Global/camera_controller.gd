extends Node

var active_camera: Camera3D
var main_camera: Camera3D

signal set_scene_camera(camera: Camera3D)
signal remove_scene_camera(camera: Camera3D)
signal set_active_camera(camera: Camera3D)

func _ready():
	connect('set_scene_camera', _on_set_camera)
	connect('remove_scene_camera', _on_remove_camera)
	
func _on_set_camera(_camera: Camera3D):
	active_camera = _camera
	emit_signal('set_active_camera', active_camera)

func _on_remove_camera(_camera: Camera3D):
	if active_camera == _camera:
		active_camera = main_camera
		emit_signal('set_active_camera', active_camera)

func get_active_camera_basis() -> Basis:
	var active_camera = CameraController.active_camera
	var quat = Quaternion(active_camera.global_transform.basis)
	quat.x = 0
	quat.z = 0
	return Basis(quat)
