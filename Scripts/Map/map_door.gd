@tool
extends Node2D
class_name MapDoor

@export var NAME: String = ''
@export var STATE: DoorActiveNode.AcceptState = DoorActiveNode.AcceptState.NONE:
	set(value):
		STATE = value
		if is_node_ready():
			visible_sprite(value)

@onready var open = $Open
@onready var need_key = $NeedKey
@onready var close = $Close
@onready var none = $None

func _ready():
	visible_sprite(STATE)

func visible_sprite(state: DoorActiveNode.AcceptState):
	open.visible = false
	need_key.visible = false
	close.visible = false
	none.visible = false
	
	if state == DoorActiveNode.AcceptState.ACCEPT:
		open.visible = true
	if state == DoorActiveNode.AcceptState.NEED_ACCEPT:
		need_key.visible = true
	if state == DoorActiveNode.AcceptState.CLOSE:
		close.visible = true
	if state == DoorActiveNode.AcceptState.NONE:
		none.visible = true
