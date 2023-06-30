class_name PlayerSpawnData

var point: Transform3D
var location_name: String = ''

func _init(_point: Transform3D, _location_name: String):
	point = _point
	location_name = _location_name
