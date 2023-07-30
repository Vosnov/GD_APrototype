extends Resource
class_name ItemData

@export var NAME: String:
	set(value):
		NAME = value
		item_name = value
	get:
		return tr(NAME)
@export var DESCRIPTION: String:
	get:
		return tr(DESCRIPTION)
@export var TEXTURE: Texture2D
@export var CAN_USE = false

var item_name = ''

func use():
	pass
