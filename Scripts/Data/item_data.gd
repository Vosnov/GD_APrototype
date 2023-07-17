extends Resource
class_name ItemData

@export var NAME: String:
	get:
		return tr(NAME)
@export var DESCRIPTION: String:
	get:
		return tr(DESCRIPTION)
@export var TEXTURE: Texture2D
